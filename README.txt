= deduper
  
https://github.com/dsisnero/deduper

== DESCRIPTION:

This gem dedupes directories

Given a set of directories, this gem scans the directories and identifies duplicates.

* It does this by first scanning the size of the files.
* Hash by object size
* Remove those files that are unique in size
* Sort the files by inode
* Hash the head of the files
* compare same size files hash values
* remove unique values
* hash the tail of the files
* compare same size files hash values
* remove unique values
* hash the rest of the file
* compare same size files hash values
* probable duplicate files

* if wanted with most likely hash values do a complete byte compare

* forward dup arrays to a dup processor that responds to call



== FEATURES/PROBLEMS:

* FIX (list of features or problems)

== SYNOPSIS:

dup = Deduper.new('~/Videos','~/movies') do
dup.exclude("**/.git")
dup.exclude("**/Videos/NeverDelete")
dup.run.each do |duplicates_collection|
duplicate_collection.save_only(:youngest)
end
  

  scanner = Deduper::Scanner.new("~/Vidoes", "~/movies")
  scanner.exclude("**/.git")
  scanner.exclude("**/Videos/NeverDelete/**/*")
  scanner.scan

== REQUIREMENTS:

* 

== INSTALL:

* gem install deduper

== DEVELOPERS:

After checking out the source, run:

  $ rake default

This task will install any missing dependencies, run the tests/specs,
and generate the RDoc.

== LICENSE:

(The MIT License)

Copyright (c) 2012 FIX

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
