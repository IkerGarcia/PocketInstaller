#!/usr/bin/python
# -*- coding: utf-8 -*-

"""
InstallDocs

Install additional documentation files for PocketInstaller applications onto
your PocketC.H.I.P.

Please note that this needs to be run as root: `sudo ./InstallDocs.py`
"""

from sys import exit
from os import chdir, getcwd, listdir, mkdir
from os.path import exists, splitext
from shutil import copy2, move
from re import compile, IGNORECASE


__docs_root_dir__ = '/usr/share/pocketchip-localdoc/'
__docs_dir__ = __docs_root_dir__ + 'Applications'
__index_file__ = __docs_root_dir__ + 'index.html'
__index_orig_file__ = __docs_root_dir__ + 'index.orig.html'
__license_start_flag__ = """<h1 id="license">License</h1>\n"""
__name_re__ = compile(r"""<h1 id="GameTitle">(.+)</h1>""", flags=IGNORECASE)


def makeFolders(docsRootDir=__docs_root_dir__, docsDir=__docs_dir__):
    """
    Makes / inspects the necessary documentation folders.

    We'll move around the PocketC.H.I.P. system a little to ensure it has
    what we need and expect. Save our work directory first, though, so we
    can come back.

    Args:
        docsRootDir:    The document area root; optional.
        docsDir:        The target folder to contain the documents; optional.
    """
    directoryOctalMode = 0755
    wrkDir = getcwd()
    try:
        chdir(docsRootDir)
        chdir(wrkDir)
    except OSError:
        print('No docs directory on PocketC.H.I.P. to install into.')
        exit(-1)
    try:
        # This is where we'll add our new doc files.
        mkdir(docsDir, directoryOctalMode)
    except OSError:
        # It's fine if it already exists.
        pass


def getAvailableDocs():
    """
    Gets the list of available documentation files to install.

    Reads the contents of the documents folder and figures out which
    applications have available documentation. Excludes things like
    the template and index.

    Returns:
        The list of avalable application documents.
    """
    try:
        availableDocs = listdir('.')
    except OSError:
        print('Directory read error; possible broken installation.')
        exit(-1)
    availableDocs = [docFile for docFile in availableDocs
                     if docFile.endswith('.html')]
    availableDocs.remove('template.html')
    return availableDocs


def getDesiredDocs(availableDocs, nameRE=__name_re__):
    """
    Gets the list of documentation files the user wants to install.

    Prompts the user for which application documents ought to be
    installed. Looks through the head of each relevant HTML file to
    try and get a more human-friendly name, but falls back on a name
    formed from the HTML file's name itself.

    Args:
        availableDocs:  The list of available application documents.
        nameRE:         The regular expression to use to identify
                        the application name; optional.

    Returns:
        The list of desired application documents, as dictionary
        pairs containing the application name and document link.
    """
    oneKilobyte = 1024
    desiredDocs = []
    for docFile in availableDocs:
        # Check the beginning of the file for a name to use
        with open(docFile, 'r') as docFileHandle:
            docFileContent = docFileHandle.read(oneKilobyte)
        nameSearch = nameRE.search(docFileContent)
        # If we don't have a better name, make one from the doc filename
        name = nameSearch.group(1) if nameSearch else splitext(docFile)[0]
        answer = raw_input("Would you like to install {0}? "
                           "(y/n): ".format(name))
        if answer.upper().startswith('Y'):
            desiredDocs.append({'link': docFile, 'name': name})
    return desiredDocs


def copyDocs(desiredDocs, docsDir=__docs_dir__):
    """
    Copies documentation files into the documents directory.

    Using the given list of desired application documents, install all the
    related files into the application documentation folder. Related files
    must all start with the same prefix, but can be HTML, images, PDFs, or
    whatever.

    Args:
        desiredDocs:    The list of applications for which to install
                        documentation. Each item must be a dictionary pair
                        with name and link.
        docsDir:        The target folder to contain the documents; optional.
    """
    try:
        allFiles = listdir('.')
        copy2('apps.css', docsDir)
        for docFilePair in desiredDocs:
            docFile = docFilePair['link']
            for relatedFile in allFiles:
                if relatedFile.startswith(splitext(docFile)[0]):
                    copy2(docFile, docsDir)
    except IOError as err:
        print('Problem copying doc files; do you need to use sudo?')
        exit(-1)


def processIndex(desiredDocs, indexFile=__index_file__,
                 origIndexFile=__index_orig_file__,
                 licenseStartFlag=__license_start_flag__):
    """
    Modifies the original index.html file to link into the doc system.

    Moves the original index to a backup location and then builds a copy in
    the original location containing that has our new information integrated
    in to it.

    Args:
        desiredDocs:        The list of applications for which to install
                            documentation. Each item must be a dictionary pair
                            with name and link.
        indexFile:          The location of the main documentation index file;
                            optional.
        origIndexFile:      The location of our backup of the original index
                            file; optional.
        licenseStartFlag:   The line in the original index file that marks the
                            start of the license section.
    """
    try:
        # We want to ensure that there's an untouched original left.
        if not exists(origIndexFile):
            move(indexFile, origIndexFile)
    except IOError:
        print('Could not move original doc file; do you need to use sudo?')
        exit(-1)
    with open(origIndexFile, 'r') as origIndexFileHandle:
        origIndexFileLines = origIndexFileHandle.readlines()
    startLine = "<!-- Added by PocketInstaller Documentation System -->\n"
    endLine = "<!-- End of PocketInstaller Documentation System addition -->\n"
    writeOutput = True
    with open(indexFile, 'w') as indexFileHandle:
        for line in origIndexFileLines:
            # We should be dealing with an unmodifeed file, but look for our
            # own edits just in case.
            if line.startswith(startLine):
                print("This file has been edited before. It's probably okay.")
                writeOutput = False
            elif line.startswith(endLine):
                writeOutput = True
            elif line.endswith(licenseStartFlag):
                indexFileHandle.write(startLine)
                indexFileHandle.write('<h1>Getting Started Guides for PocketInstaller Games</h1>\n')
                indexFileHandle.write('<ul>\n')
                for desiredDoc in desiredDocs:
                    indexFileHandle.write(
                        '<li><a href="Applications/{link}" title="{name}">'
                        '{name}</a></li>\n'.format(**desiredDoc)
                    )
                indexFileHandle.write('</ul>\n')
                indexFileHandle.write(endLine)
                # This shouldn't be necessary except for a former edit
                # gone wrong.
                writeOutput = True
            if writeOutput:
                indexFileHandle.write(line)


if __name__ == '__main__':
    # Basic program flow is to inspect the PocketC.H.I.P. documentation area
    # and build up the appropriate folders, get the list of application
    # documents that are available for installation, get the list of
    # application documents the user wants installed, install them, backup the
    # original index, and make a copy of it that references our new additions.
    makeFolders(__docs_root_dir__, __docs_dir__)
    availableDocs = getAvailableDocs()
    desiredDocs = getDesiredDocs(availableDocs)
    copyDocs(desiredDocs)
    processIndex(desiredDocs, __index_file__, __index_orig_file__)
