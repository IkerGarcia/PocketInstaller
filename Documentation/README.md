**The PocketInstaller Documentation System** 

This system is made to be fairly easy to use and extend. Usage info
is in the main documentation area above, and instructions for extending
it are here.

*Structure of Documentation Documents*

The documents are all written using standard Web technologies, primarily
HTML, CSS, and Web-friendly image formats like PNG and JPEG. Keeping things
fairly simple ensures that they display properly in the PocketC.H.I.P.
documentation viewer (really the Surf Web Browser).

If you'd like a little bit of information on HTML and CSS, you can't do
better than looking at the Mozilla Developer Network references:

*  https://developer.mozilla.org/en-US/docs/Web/HTML

*  https://developer.mozilla.org/en-US/docs/Web/CSS

*Structure of Documentation System*

The documentation system is written in Python. Probably you won't have to
change it. If you do want to mess with it, all you ever wanted to know about
Python can be found in the main Python docs at: https://docs.python.org/2/
and documentation for it itself can be built using Doxygen with doxypypy.
Messing with it though is beyond the scope of this document.

*How to Add Documentation for an Application*

To extend the system to include an application not already covered, copy
the `template.html` file and start editing your copy. You'll want to give
it a name that reflects the application for which you're adding documentation,
so if you're adding a game called "Quest for the Kibble" you'll want to give
the new file a name something like `QuestForTheKibble.html`.

Within that template, look for things like `%%whatever%%` and replace them
as appropriate. For example, every time you see `%%Name of Game%%` you
should replace it with a human-friendly version of the game name using
case appropriate for the title, like `Quest for the Kibble` in our example
here. The template tries to give you clues on how to do the formatting,
so you'll know something ought to avoid spaces or should contain upper and
lower case just by how the label is formatted. Often the label will be
long and expressive of exactly what is needed there, and will tell you
what to delete if you don't have a good match.

*Tips*

You're free to included external image files, additional HTML files, PDFs,
or anything else you'll think will help beginning users. Just be aware of
a few things:

1  All supplementary files need to start with the same short name, so for
   our example case here if you wanted to include a screenshot you'd want
   to give it a name something like `QuestForTheKibble-screenshot.png`.
   Files that don't start with that short name won't be associated with
   the documentation for that application.

2  The intent is not to duplicate information that's already widely
   available elsewhere, just to make it really easy for a beginner to get
   started. If there's lots of info elsewhere, just point the reader to
   it so she won't have trouble finding it.

3  Anything that makes using the application different on the PocketC.H.I.P.
   versus a more traditional platform ought to be pointed out.

4  Be respectful of other people's copyrights. Link to a resource rather
   than copying it if you have any doubt.

5  Remember finally that the target audience is composed of beginners.
   Be kind. Don't be too technical.

