# -*- ruby -*-

require 'rubygems'
require 'hoe'


#Hoe.plugin :debugging
Hoe.plugin :git
Hoe.plugin :gemspec
Hoe.plugin :bundler
#Hoe.add_include_dirs '.' # for ruby 1.9.2

Hoe.spec 'deduper' do 
  developer('Dominic Sisneros', 'dsisnero@gmail.com')

  self.clean_globs += ['**/#*.*#']

  self.extra_dev_deps += [
                          ["hoe-bundler", ">= 1.1"],
                          ["hoe-debugging", ">= 1.0.2"],
                          ["hoe-gemspec", ">= 1.0"],
                          ["hoe-git", ">= 1.4"],
                          ["rspec", ">= 2.8"],
                          
                         ]

  
end

# vim: syntax=ruby
