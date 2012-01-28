# -*- ruby -*-

require 'rubygems'
require 'hoe'


Hoe.plugin :debugging
Hoe.plugin :git
Hoe.plugin :gemspec
Hoe.plugin :bundler
#Hoe.add_include_dirs '.' # for ruby 1.9.2

Hoe.spec 'deduper' do 
  developer('Dominic Sisneros', 'dsisnero@gmail.com')

  self.clean_globs += ['**/#*.*#']

  self.extra_deps += [
                      ["celluloid", ">= 0"],
                      ]

  self.extra_dev_deps += [
                          ["hoe-bundler", ">= 1.1"],
                          ["hoe-debugging", ">= 1.0.2"],
                          ["hoe-gemspec", ">= 1.0"],
                          ["hoe-git", ">= 1.4"],
                          ["rspec", ">= 2.8"],
                          ["ruby-debug", ">= 0.0"],
                          ["ZenTest", ">=0.0"],
                                                      
                         ]

  self.dependency("ruby-debug",">= 0.0",:dev)   if RUBY_VERSION =~ /1\.8/
  self.dependency("ruby-debug19",">= 0.0", :dev )   if RUBY_VERSION =~ /1\.9/
  self.dependency("require_relative",">= 0.0", :dev )   if RUBY_VERSION =~ /1\.8/
  
  
end

# vim: syntax=ruby
