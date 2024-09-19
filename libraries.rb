#!/usr/bin/ruby
#encoding: utf-8
require 'fileutils'

# Whitelist for libraries not in sniper
WHITELIST = [
  'libSDL_sound.so.2',
  'libboost_program_options.so.1.74.0',
  'libxfconf-0.so.3',
  'libsigc-2.0.so.0',
  'libphysfs.so.1',
  'libruby-2.7.so.2.7',
]

line = gets
files = []
while line
  if line =~ / => (\/.*) \(/
    if WHITELIST.any? {|library| $1.end_with? library }
      files << $1
    end
  end
  line = gets
end
FileUtils.cp(files, 'libs')
