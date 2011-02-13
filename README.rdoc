= image_corrupter

* http://github.com/illuminerdi/image_corrupter
* http://illuminerdi.com


== DESCRIPTION:

Takes an image and corrupts it, inserting plain text in place of bytecode. The effect is basically a recognizable image with glitches and noise added. See an example:

* Before: http://yfrog.com/h7imttbj
* After: http://yfrog.com/h3wwmujj
* Even Coolier: http://yfrog.com/h2qo6xwj

Glitch art FTW!

Special thanks to {@rob_sheridan}[http://twitter.com/rob_sheridan] for the idea. See more at http://www.rob-sheridan.com/TSN/

== FEATURES/PROBLEMS:

* Takes images, corrupts them.
* Supports jpg currently. working on other formats (the point is corruption, not destruction).
* Fairly deep customization
* TDD
* I really didn't know anything about JPEG before I started this, and I'm sure I'm screwing something up important.

== SYNOPSIS:

  >> # Simple usage
  >> require 'image_corrupter'
  >> corrupter = ImageCorrupter.new("./some_image.jpg")
  >> corrupter.corrupt
  >> corrupter.to_file
  #=> ./some_image_corrupted.jpg

  >> # Simpler usage
  >> ImageCorrupter.corrupt("./some_image.jpg")
  #=> ./some_image_corrupted.jpg

  >> # Totally fun usage
  >> corrupter = ImageCorrupter.new("./some_image.jpg", :corruption_text => %w(FOO! BAR! BAZ!), :occurrences => 23, :random => true)

  >> # Corrupt and corrupt and corrupt again!
  >> corrupter = ImageCorrupter.new("./some_image.jpg", :occurrences => 5, :random => true)
  >> corrupter.corrupt!.corrupt!.corrupt!.to_file

  >> # Works with external files, too
  >> corruptor = ImageCorrupter.new("./some_image.jpg", :corruption_file => "./some_corruption_text", :corruption_separator => /\n/)

== REQUIREMENTS:

* ruby 1.9.2

== INSTALL:

* sudo gem install image_corrupter

== LICENSE:

(The MIT License)

Copyright (c) 2011 Joshua Clingenpeel

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
