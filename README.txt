= framecurve

http://guerilla-di.org/framecurve

== DESCRIPTION:

framecurve provides a simple, concrete, machine-and-human readable format for transferring frame correlation curves from computer to
computer. 

=== What is a framecurve?

In the simplest terms, it's a linearly interpolated animation curve of "Use this frame of video or animation at that frame".
For example, if you want to speed up some video that goes from frame 1 to frame 432 by 200%, you will have this as your framecurve:

1 1.0
216 432.0

This assumes that you interpolate the needed frame number linearly between these frames. If you want some speedups and slowdowns that's easy:




== SYNOPSIS:

  framecurve SomeTW.F_Kronos.spark # Outputs a textfile that is a framecurve file
  framecurve -script Maya # Returns the script that can be pasted into the Maya script editor
  framecurve -script C4D # Returns the script that can be used with C4D to read the file
  framecurve -script Houdini # Returns the script that can be used with C4D to read the file

== REQUIREMENTS:

* ruby, rubygems
* any package for which a framecurve plugin exists

== INSTALL:

* sudo gem install framecurve

== LICENSE:

(The MIT License)

Copyright (c) 2011 Julik Tarkhanov, Sebastian van Hesteren, Koen Hofmeester

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
