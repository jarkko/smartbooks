# -*- encoding : utf-8 -*-
#!/usr/bin/env ruby
require File.dirname(__FILE__) + '/../config/environment'
require "sexp_parser"

filename = ARGV[0] || File.dirname(__FILE__) + '/../tmp/2007.txt'
SexpParser.new(File.read(filename)).import
