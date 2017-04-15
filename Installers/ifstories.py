#!/usr/bin/python
# -*- coding: utf-8 -*-

from random import shuffle
from time import sleep
from json import load, dump
from re import compile as regexcompile
from os.path import splitext
from urllib import urlopen, urlretrieve
from locale import setlocale, LC_ALL
from os.path import exists
from os import mkdir, listdir
from zipfile import ZipFile
from HTMLParser import HTMLParser
from curses import (wrapper, newpad, use_default_colors, error as CursesError,
                    KEY_DOWN, KEY_UP, KEY_LEFT, KEY_RIGHT, KEY_ENTER,
                    KEY_NPAGE, KEY_PPAGE, A_BOLD, A_NORMAL)

# Set some tweakable globals.
__story_dict_filename__ = 'ifstorylist.json'
__intfic_page_list__ = [
    'http://www.ifarchive.org/indexes/if-archiveXgamesXzcode.html',
    'http://www.ifarchive.org/indexes/if-archiveXgamesXglulx.html',
    'http://www.ifarchive.org/indexes/if-archiveXgamesXtads.html',
    'http://www.ifarchive.org/indexes/if-archiveXgamesXhugo.html',
    'http://www.ifarchive.org/indexes/if-archiveXgamesXadrift.html',
    'http://www.ifarchive.org/indexes/if-archiveXgamesXalan.html',
    'https://dist.saugus.net/IF/'
]
__story_folder__ = '/usr/share/IF'
__story_types__ = ['ADRIFT', 'Alan', 'Glulx', 'Hugo', 'TADS', 'Z-code']
__download_delay__ = .1

# Set the locale to support the display of accented characters.
setlocale(LC_ALL, '')


class IFArchiveHTMLParser(HTMLParser):
    """
    Encapsulates the Interactive Fiction Archive HTML page parser.

    The IF Archive download pages are fairly complicated structures.
    We can get at what we care about though if we only look for HTML
    anchors within HTML definition lists, and take the names from
    the definition portion.
    """

    # The IF Archive supports a ton of different IF formats. These
    # are the extensions that it uses that we support.
    legalExtensions = (
        '.z5', '.z6', '.z8', '.zblorb', '.zlb',
        '.ulx', '.gblorb', '.blb', '.blb'
        '.gam', '.t3',
        '.acd', '.a3c', '.a3r',
        '.hex', '.taf',
        '.zip'
    )

    # This regular expression helps identify technical notes.
    noteRE = regexcompile(r' (\(.+\)|\[.+\])')

    def handle_starttag(self, tag, attrs):
        """
        Perform actions needed when an HTML start tag is parsed.

        For the IF Archive site we need to separate out IF files from
        chaff by looking at the filename extension of linked files and
        looking at where in the HTML hierarchy the linked files appear.

        Args:
            tag:    The HTML tag name.
            attrs:  The HTML tag attributes.
        """
        for attr in attrs:
            if tag == 'dt':
                self.withinDefTerm = True
            if tag == 'dd':
                self.withinDef = True
            if self.withinDefTerm and tag == 'a' and attr[0] == 'href':
                fileExtension = splitext(attr[1])[1]
                if fileExtension in IFArchiveHTMLParser.legalExtensions:
                    self.activeFile = attr[1]

    def handle_endtag(self, tag):
        """
        Perform actions needed when an HTML end tag is parsed.

        We need to observe our current state and the tag being ended to
        adjust state accordingly. In particular, we use the end of an HTML
        DD tag to mark the end of a particular story listing.

        Args:
            tag:    The HTML tag name.
        """
        if tag == 'dd':
            self.activeFile = None
        self.withinDefTerm = False
        self.withinDef = False

    def handle_data(self, data):
        """
        Handle page data within an HTML tag within the IF Archive page.

        Ignore irrelevant data but build up a story dictionary from relevant
        data. The IF Archive provides very detailed information on each story,
        often too detailed for our purposes here, and story entries are kept
        in nicely formatted HTML definition lists. The definition lists make
        tracking state a little trickier as we need to ignore everything that
        isn't in the proper place, and it's helpful to strike some of the
        extraneous information before assembling our final descriptions.

        Args:
            data:   The data from within the HTML file.
        """
        if self.withinDef and not self.withinDefTerm and self.activeFile:
            # Get rid of internal CR characters.
            data = data.replace('\n', ' ')
            # The IF Archive has lots of fairly technical notes that'll confuse
            # our target audience. Get rid of these notes.
            data = IFArchiveHTMLParser.noteRE.sub('', data)
            data = data.strip()
            # This looks more complicated than it is. Strips off the relative
            # portion of the URL and attaches it to the domain part to get an
            # absolute URL.
            self.storyDict[self.activeFile[
                self.activeFile.rfind('/') + 1:]
            ] = {
                'url': self.baseUrl + self.activeFile[
                    self.activeFile.find('/') + 1:],
                'description': data,
                'type': self.storyType
            }

    def processPage(self, ifPageUrl):
        """
        Process the given IF Archive page.

        Given a page URL, perform the actual download and parsing of it and
        assemble a story dictionary containing information on all the stories
        that page contains information for. Note that with the IF Archive,
        story formats are determined by the URL of the page being parsed.

        Args:
            ifPageUrl:  The location of the page with links to stories.

        Regurns:
            The story dictionary representing just the contributions from
            the processed page.
        """
        self.baseUrl = ifPageUrl[:ifPageUrl[7:].rfind('/')]
        # We can know the type based on the page where it was found.
        if 'zcode' in ifPageUrl:
            self.storyType = 'Z-code'
        elif 'glulx' in ifPageUrl:
            self.storyType = 'Glulx'
        elif 'tads' in ifPageUrl:
            self.storyType = 'TADS'
        elif 'hugo' in ifPageUrl:
            self.storyType = 'Hugo'
        elif 'adrift' in ifPageUrl:
            self.storyType = 'ADRIFT'
        elif 'alan' in ifPageUrl:
            self.storyType = 'Alan'
        pageHandle = urlopen(ifPageUrl)
        pageData = pageHandle.read()
        self.feed(pageData)
        return self.storyDict

    def __init__(self):
        """
        Initialize the IF Archive page parser.

        Set up the instance variables for the IF Archive-focused page parser.
        Instance variables track the assembled story dictionary as well as
        current state machine information for the parser.
        """
        HTMLParser.__init__(self)
        self.withinDefTerm = False
        self.withinDef = False
        self.activeFile = None
        self.storyDict = {}
        self.baseUrl = ''
        self.storyType = 'unknown'


class SaugusNetHTMLParser(HTMLParser):
    """
    Encapsulates the Saugus.net Interactive Fiction HTML page parser.

    The Saugus.net IF download area is basically a simple file listing.
    It's easy to parse but doesn't provide a lot of extra info. We can
    extract most of what's useful just from the HTML anchors.
    """

    # These descriptions come from Saugus.net, but are unfortunately
    # spread across multiple pages. We could have gone with a design
    # that'd load these (and the story URLs) from those pages, but we
    # went with this simpler model instead. The consequence is that we
    # have to supply these descriptions manually here.
    storyDescriptions = {
        'Awakening.z8':
            "Awakening, by Pete Gardner. Awakening on the ground next to "
            "an open grave, you have no recollection of how you came to "
            "be there. Do you investigate the nearby church and graveyard, "
            "or leave well enough alone?",
        'Hauntings.z8':
            "Hauntings, by Emma Joyce. Circumstances leave you on the "
            "doorstep of a decrepit looking house to report for the only "
            "job around that doesn't require references. Can you unravel "
            "the mystery of the house and your mysterious new employer?",
        'LIASAD.zip':
            "Love Is as Powerful as Death, Jealousy Is as Cruel as the Grave, "
            "by Michael Whittington. Atmospheric and moody, here one gets "
            "to follow an American teaching in Cambodia through a ghost story "
            "with an Eastern flavor.",
        'Lighthouse.z8':
            "The Lighthouse, by Marius Müller. Lighthouses simultaneously "
            "stand at the border between land and sea and the border between "
            "old and new. They are naturally good settings for secrets. Do "
            "you dare visit this one?"
    }

    def handle_starttag(self, tag, attrs):
        """
        Perform actions needed when an HTML start tag is parsed.

        For the Saugus.net site we need to separate out IF files from
        chaff by looking at the filename extension of linked files. We can
        also immediately eliminate an old version of Hauntings from the
        listing to make life easier for our users. The page format is
        simple, so we only need to care about anchor tags and their HREF
        attributes.

        Args:
            tag:    The HTML tag name.
            attrs:  The HTML tag attributes.
        """
        for attr in attrs:
            if tag == 'a' and attr[0] == 'href':
                fileExtension = splitext(attr[1])[1]
                # Ignore anything that's not IF.
                if fileExtension in ('.z5', '.z8', '.zip'):
                    # Skip the older version of "Hauntings".
                    if attr[1] != 'Hauntings.z5':
                        # We've got a story; note its URL.
                        self.activeFile = attr[1]

    def handle_endtag(self, tag):
        """
        Perform actions needed when an HTML end tag is parsed.

        For the Saugus.net site not too much extra work needs to be done
        for HTML end tags, but we can use it to flag that no file is active
        any longer.

        Args:
            tag:    The HTML tag name.
        """
        self.activeFile = None

    def handle_data(self, data):
        """
        Handle page data within an HTML tag within the Saugus.net page.

        Ignore irrelevant data but build up a story dictionary from relevant
        data. With the Saugus.net listing this is pretty straightforward as
        there's not a lot of extra stuff there, and almost every actual
        entry is Z-code. We can tell exceptions from filename extension.

        Args:
            data:   The data from within the HTML file.
        """
        # Ignore everything that's not IF.
        if self.activeFile:
            # On Saugus.net everything is Z-Machine except 1 zipped TADS file.
            # The descriptions are on multiple different pages, but there
            # aren't many, so it's easiest to pull them in and do a dictionary
            # lookup.
            storyName = SaugusNetHTMLParser.storyDescriptions.get(
                data, splitext(data)[0])
            if self.activeFile.endswith('.zip'):
                storyType = 'TADS'
            else:
                storyType = "Z-code"
            self.storyDict[data] = {
                'url': self.pageUrl + self.activeFile,
                'description': storyName,
                'type': storyType
            }

    def processPage(self, ifPageUrl):
        """
        Process the given Saugus.net page.

        Given a page URL, perform the actual download and parsing of it and
        assemble a story dictionary containing information on all the stories
        that page contains information for.

        Args:
            ifPageUrl:  The location of the page with links to stories.

        Regurns:
            The story dictionary representing just the contributions from
            the processed page.
        """
        assert isinstance(ifPageUrl, basestring)
        self.pageUrl = ifPageUrl
        pageHandle = urlopen(ifPageUrl)
        pageData = pageHandle.read()
        self.feed(pageData)
        return self.storyDict

    def __init__(self):
        """
        Initialize the Saugus.net page parser.

        Set up the instance variables for the Saugus.net-focused page parser.
        Instance variables track the assembled story dictionary as well as
        current state machine information for the parser.
        """
        HTMLParser.__init__(self)
        self.activeFile = None
        self.storyDict = {}
        self.pageUrl = ''


def downloadIFPage(ifPageUrl):
    """
    Downloads an individual Web page containing links to stories.

    Downloads a Web page given the URL, and based upon its location
    routes its contents to an appropriate parsing class.

    Args:
        ifPageUrl:  The URL of the Web page to be loaded and parsed.

    Returns:
        A story dictionary representing just the contributions from
        the parsed page.
    """
    assert isinstance(ifPageUrl, basestring)
    if ifPageUrl.startswith('http://www.ifarchive.org/'):
        parser = IFArchiveHTMLParser()
    elif ifPageUrl.startswith('https://dist.saugus.net/'):
        parser = SaugusNetHTMLParser()
    else:
        print('Unknown site page to process: {0}'.format(ifPageUrl))
        exit(-1)
    pageContribs = parser.processPage(ifPageUrl)
    return pageContribs


def downloadIFPages(ifPageList=__intfic_page_list__):
    """
    Downloads components and generates a source story dictionary.

    Builds up a new story dictionary from scratch using some fixed data
    and lots of data live downloaded from various story-hosting sites
    online. Additional story-hosting sites can be supported by adding
    a support class for each and adding it to the interactive fiction
    page list parameter. A few stories are selected by default,
    including the tutorial story "Dreamhold" and well-known titles like
    "Zork", "Galatea", "Lost Pig", and the "Hitchhiker's Guide to the
    Galaxy".

    Args:
        ifPageList: The list of Web pages containing links to stories,
                    the pages to be downloaded and parsed. Each must
                    have a proper parsing class in order to be handled
                    appropriately.

    Returns:
        The generated story dictionary.
    """
    assert isinstance(ifPageList, list)
    # There are a handful of particular stories that we'll include
    # individually rather than try to fetch. Besides these being scattered
    # with just a few per location, the hosting sites don't always even
    # provide descriptions. Since they've been constant for a long time
    # there's not much risk in just handling them statically this way.
    storyDict = {
        "hhgg.z3": {
            "description": "The Hitchhiker's Guide to the Galaxy, "
            "by Douglas Adams and Steve Meretzky. Don't Panic! In this "
            "story, you will be Arthur Dent, a rather ordinary earth "
            "creature who gets swept up in a whirlwind of interstellar "
            "adventures almost beyond comprehension.",
            "type": "Z-code",
            "url": "http://www.douglasadams.com/creations/hhgg.z3"
        },
        "zork1.z5": {
            "description": "Zork I: The Great Underground Empire, "
            "by Marc Blank and Dave Lebling. "
            "Many strange tales have been told of the fabulous "
            "treasure, exotic creatures, and diabolical puzzles in "
            "the Great Underground Empire. As an aspiring adventurer, "
            "you will undoubtedly want to locate these treasures and "
            "deposit them in your trophy case.",
            "type": "Z-code",
            "url": "http://www.batmantis.com/zorks/zork1.z5"
        },
        "zork2.z5": {
            "description": "Zork II: The Wizard of Frobozz, "
            "by Dave Lebling and Marc Blank. "
            "The Wizard appears, floating nonchalantly in the air beside "
            'you. He grins sideways at you. The Wizard incants "Fantasize," '
            "but nothing happens. He shakes his wand. Nothing happens. With "
            "a slightly embarrassed glance in your direction, he vanishes.",
            "type": "Z-code",
            "url": "http://www.batmantis.com/zorks/zork2.z5"
        },
        "zork3.z5": {
            "description": "Zork III: The Dungeon Master, "
            "by Dave Lebling and Marc Blank. "
            "An old, oddly youthful man turns toward you slowly. His long, "
            'silver hair dances about him as a fresh breeze blows. "You have '
            "reached the final test, my friend! You are proved clever and "
            "powerful, but this is not yet enough! Seek me when you feel "
            'yourself worthy!"',
            "type": "Z-code",
            "url": "http://www.batmantis.com/zorks/zork3.z5"
        }
    }
    # Shuffle to (hopefully) split up server load on any one target.
    # Although right now it's a moot point as we only target two
    # servers. It'll matter more when we add more.
    shuffle(ifPageList)
    for intficPage in ifPageList:
        storyDict.update(downloadIFPage(intficPage))
        # Be polite; don't bomb a server.
        sleep(__download_delay__)
    # Preselect a few recommendations to get people started. We don't
    # want any of the IF player apps to be hit with an empty list.
    for storyName in (
        'dreamhold.z8', 'zork1.z5', 'hhgg.z3', 'curses.z5', 'LostPig.z8',
        'ChildsPlay.zblorb', 'Tangle.z5', 'Galatea.zblorb',
        'Lighthouse.z8', 'Hauntings.z8'
    ):
        storyDict[storyName]['selected'] = True
    return storyDict


def loadStoryList(storyDictFilename=__story_dict_filename__):
    """
    Loads a story dictionary from disk.

    This loads a story dictionary from disk cache rather than fetching
    it component by component and regenerating it. It assumes JSON format.

    Args:
        storyDictFilename:  The location of the story dictionary file.

    Returns:
        The story dictionary.
    """
    assert isinstance(storyDictFilename, basestring)
    with open(storyDictFilename, 'r') as storyDictFileHandle:
        storyDict = load(storyDictFileHandle)
        assert storyDict
    return storyDict


def saveStoryList(storyDict, storyDictFilename=__story_dict_filename__):
    """
    Saves a story dictionary to disk.

    This caches a fetched story list to disk so it doesn't need to be
    regenerated from scratch next time. It uses JSON format for easier
    handling.

    Args:
        storyDict:          The story dictionary to be saved.
        storyDictFilename:  The location to which to save the story
                            dictionary.
    """
    assert isinstance(storyDict, dict)
    assert isinstance(storyDictFilename, basestring)
    with open(storyDictFilename, 'w') as storyDictFileHandle:
        dump(storyDict, storyDictFileHandle, ensure_ascii=False,
             separators=(',', ':'), sort_keys=True)


def addWrappedStr(win, dispStr):
    """
    Like the regular curses addstr but performs word wrap.

    Given a string to display and a Curses window-like object to display
    it in, add the string to that window performing word wrapping as
    needed.

    Args:
        win:        The Curses window-like object.
        dispStr:    The string to add to that window.
    """
    assert isinstance(dispStr, basestring)
    maxY, maxX = win.getmaxyx()
    curY, curX = win.getyx()
    if len(dispStr) + curX <= maxX:
        win.addstr(dispStr)
    else:
        for word in dispStr.encode('utf-8').split():
            if len(word) + curX < maxX:
                win.addstr(word)
            else:
                if curY < maxY - 1:
                    win.addstr(curY + 1, 0, word)
                else:
                    win.addstr(curY, maxX - 4, '...')
            curY, curX = win.getyx()
            if curX < maxX:
                try:
                    win.addstr(' ')
                    curX += 1
                except CursesError:
                    pass


def downloadMissingStories(desiredStories, storyFolder=__story_folder__):
    """
    Download chosen story files if they aren't already in the story folder.

    Given a list of desired stories and a folder in which to place them,
    check each to see if it has already been downloaded. If it hasn't,
    get it. If the story file is compressed via zip, unzip it.

    Args:
        desiredStories: A story dictionary where each entry contains at
                        least a URL and is referenced by filename.
        storyFolder:    The location in which to look for and store
                        stories.
    """
    assert isinstance(desiredStories, dict)
    assert isinstance(storyFolder, str)
    desiredStoriesList = desiredStories.keys()
    # Shuffle to hopefully split up server load on any one target.
    shuffle(desiredStoriesList)
    for storyName in desiredStoriesList:
        storyFilename = '{0}/{1}'.format(storyFolder, storyName)
        if exists(storyFilename):
            # If it's not there, download it
            print("Already have {0}; no need to redownload.".format(storyName))
        else:
            print("Downloading {0}...".format(storyName))
            urlretrieve(desiredStories[storyName]['url'], storyFilename)
            if storyName.endswith('.zip'):
                with ZipFile(storyFilename, 'r') as zipHandle:
                    zipHandle.extractall(storyFolder)
            # Be polite; don't bomb a server.
            sleep(__download_delay__)


def main(scr, storyDict, typeFilter=__story_types__,
         storyFolder=__story_folder__):
    """
    The Curses main loop.

    This routine provides the main loop that executes through the majority
    of time tha the program is running. It is designed to be run from within
    the Curses wrapper routine. It displays the list of selections, shows
    which are chosen and which aren't, and the description for the current
    selection. It accepts keyboard input to scroll through the list of
    selections and choose additional ones. Cursor keys scroll, alphabet
    keys jump to the first entry starting with that letter, enter accepts
    the currently chosen list, and escape exits with none selected.

    Args:
        scr:            The Curses screen object; will be automatically
                        provided by Curses wrapper.
        storyDict:      The dictionary of stories; each needs a URL, a
                        type, and a description and can optionally be
                        selected. They are referenced by filename.
        typeFilter:     A list of interactive fiction formats to display,
                        all supported ones by default.
        storyFolder:    The location in which to store story files.

    Returns:
        A new storyDict containing just chosen stories.
    """
    assert isinstance(storyDict, dict)
    assert isinstance(typeFilter, list)
    assert isinstance(storyFolder, str)
    use_default_colors()
    maxY, maxX = scr.getmaxyx()
    scr.addstr(maxY / 2 - 1, (maxX - 27) / 2, "Loading story selections...")
    scr.refresh()
    scr.clear()
    addWrappedStr(scr, "Please select some stories. Use arrow keys to move "
                  "through the list, letters to jump, space for selecting, "
                  "and enter when done.")
    storiesAlreadyDownloaded = listdir(storyFolder)
    selections = sorted(storyDict.keys(), key=lambda sel: sel.lower())
    selectionAreaWidth = maxX / 2
    selectionAreaTop = 3
    selectionAreaHeight = maxY - selectionAreaTop - 1
    checkBoxWidth = 2
    selectionPad = newpad(len(selections) + maxY, maxX)
    selectionNum = 0
    selectionPad.scrollok(True)
    colStart = 0
    for selection in selections:
        if storyDict[selection].get('type') in typeFilter:
            selectionPad.scroll()
            if storyDict[selection].get('selected', False) or \
               selection in storiesAlreadyDownloaded:
                selectionPad.addstr(len(selections) - 1, 0, '✓', A_BOLD)
            selectionPad.addnstr(len(selections) - 1, checkBoxWidth, selection,
                                 maxX - checkBoxWidth)
    descArea = scr.subwin(3, selectionAreaWidth + 2)
    scr.refresh()
    done = False
    while not done:
        selectionPad.refresh(selectionNum, colStart, selectionAreaTop, 1,
                             selectionAreaTop + selectionAreaHeight,
                             selectionAreaWidth)
        descArea.erase()
        if selectionNum < len(selections):
            addWrappedStr(descArea,
                          storyDict[selections[selectionNum]]['description'])
        descArea.refresh()
        inChr = scr.getch()
        if inChr in (KEY_ENTER, 10):
            done = True
        elif inChr == 27:
            # If the escape key is hit, return nothing.
            return {}
        elif inChr == KEY_DOWN and selectionNum < len(selections) - 1:
            selectionNum += 1
        elif inChr == KEY_UP and selectionNum > 0:
            selectionNum -= 1
        elif inChr == KEY_LEFT and colStart > 0:
            colStart -= 1
        elif inChr == KEY_RIGHT and colStart < selectionAreaWidth:
            colStart += 1
        elif inChr == ord(' '):
            if selectionPad.instr(selectionNum, 0, 1) == ' ':
                selectionPad.addstr('✓', A_BOLD)
            else:
                selectionPad.addch(' ', A_NORMAL)
            storyDict[selections[selectionNum]]['selected'] = \
                not storyDict[selections[selectionNum]].get('selected', False)
        elif inChr >= ord('a') and inChr <= ord('z'):
            # if a letter, jump to that starting point.
            for selectionNum, selection in enumerate(selections):
                if selection[0].lower() >= chr(inChr):
                    break
        elif inChr in (KEY_NPAGE, 336):
            selectionNum = min(selectionNum + selectionAreaHeight,
                               len(selections) - 1)
        elif inChr in (KEY_PPAGE, 337):
            selectionNum = max(selectionNum - selectionAreaHeight, 0)
    chosenOnes = {}
    for selection in selections:
        if storyDict[selection].get('selected', False):
            chosenOnes[selection] = storyDict[selection]
    return chosenOnes


# This is the main entry point for the interactive program. It ensures a story
# folder exists (making one if it doesn't), reads the list of available
# stories from disk (or making a new list dynamically if one doesn't yet
# exist), interacts with the user to choose some stories, and downloads any
# chosen ones that haven't already been downloaded.
if __name__ == '__main__':
    # Ensure the story folder exists.
    try:
        mkdir(__story_folder__, 0755)
    except OSError:
        pass
    try:
        # Work with a cached list if one exists.
        __story_dict__ = loadStoryList(__story_dict_filename__)
    except (IOError, AssertionError):
        # We need to recreate our list.
        print("Creating story list...")
        __story_dict__ = downloadIFPages(__intfic_page_list__)
        try:
            saveStoryList(__story_dict__, __story_dict_filename__)
        except IOError as err:
            # We can't recreate it; warn the user but continue anyway
            print("Can't save story list: {0}".format(err))
    __desired_stories__ = wrapper(main, __story_dict__, __story_types__,
                                  __story_folder__)
    downloadMissingStories(__desired_stories__, __story_folder__)
