demonstrate.sh
==============

[![Made at the Recurse Center](http://img.shields.io/badge/Made_At-The_Recurse_Center-brightgreen.svg)](https://www.recurse.com)

Does live coding make you nervous?

Have you ever mistyped a command in front of a live audience, several
times in a row?

If so, then demonstrate.sh is for you! Pass in a script file,
containing the commands you want to demonstrate, and the interpreter
to feed them too. Demonstrate will show the prompt from the
interpreter.  When you hit the spacebar, the next line from the script
will be printed after the prompt. When you hit enter, that line will
be fed to the interpreter and the output from it will appear as though
you had executed it directly! Wash, rinse, repeat!

An Example
----------

There's a demonstration script included in the repository. This is how
you should run it:

    ./demonstrate.sh script bash

Now, hitting space will cause the next line of "input" to
appear. Then, hitting enter will cause that line to be sent to the
interpreter.
