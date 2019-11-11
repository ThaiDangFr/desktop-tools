#!/usr/bin/env ruby

require 'optparse'
require 'ostruct'

$VERBOSE = nil # avoid warning: Insecure world writable dir


options = OpenStruct.new
optparse = OptionParser.new do |opts|
  opts.banner = "#{__FILE__} -d DIRECTORY -f FILE_PATTERN -p PREFIX [-a]"
  
  opts.on("-d", "--directory DIRECTORY", "Directory to scan") do |a|
    options.directory = a
  end

  opts.on("-f", "--file FILE_PATTERN", "File pattern") do |m|
    options.pattern = m
  end

  opts.on("-p", "--prefix PREFIX", "PREFIX") do |m|
    options.prefix = m
  end

  options.apply = false
  opts.on("-a", "--[no-]apply", "Apply changes") do |m|
    options.apply = true
  end

  options.verbose = false
  opts.on("-v", "--[no-]verbose", "Run verbosely") do |v|
    options.verbose = true
  end
end

begin 
  optparse.parse!
rescue OptionParser::ParseError => e
  puts e
  exit 1
end

directory = options.directory
pattern = options.pattern
prefix = options.prefix
apply = options.apply

if directory.nil? or pattern.nil? or prefix.nil?
  puts optparse.help
  exit 1
end

if apply
  puts "Changes will BE applied"
else
  puts "Changes will NOT be applied"
end


files = Dir.glob("#{directory}/#{pattern}").select{ |e| File.file? e }

files.each do |f|
  target = f.gsub(/ (\d?\d?\d?) /," #{prefix}"+'\1\2\3 ').gsub(/ /,'_').gsub(/[^a-zA-Z0-9_ .\/]/,'')
  puts "#{f} -> #{target}"

  if apply
    File.rename(f, target)
  end
end
