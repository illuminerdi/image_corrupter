= image_corrupter

* http://illuminerdi.com

== DESCRIPTION:

Takes an image and corrupts it. Glitch art FTW.

Special thanks to @robsheridan for the idea. See more at http://www.rob-sheridan.com/TSN/

== FEATURES/PROBLEMS:

* Takes images, corrupts them.
* Supports jpg currently. working on other formats (the point is corruption, not destruction).

== SYNOPSIS:

>> require 'image_corrupter'
>> corrupter = ImageCorrupter.new('./some_image.jpg')
>> corrupter.corrupt
#=> ./some_image_corrupted.jpg

== REQUIREMENTS:

* FIX (list of requirements)

== INSTALL:

* FIX (sudo gem install, anything else)

== LICENSE:

(The MIT License)

Copyright (c) 2011 FIX

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
