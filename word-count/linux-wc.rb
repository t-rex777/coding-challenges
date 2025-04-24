#!/usr/bin/env ruby 



class LinuxWc
  def initialize(file_path)
    @file_path = file_path
  end
  
  def read_file
    if File.exist?(@file_path)
      File.read(@file_path)
    else
      puts "Error: File '#{@file_path}' does not exist"
      exit 1
    end
  end

  def count_bytes
    content = read_file
    content.bytesize
  end
end

if ARGV.include?('-c')
  if ARGV.size < 2
    puts "Error: Please provide a file path"
    exit 1
  end
  
  wc = LinuxWc.new(ARGV[1])
  puts wc.count_bytes
else
  if ARGV.size < 1
    puts "Error: Please provide a file path"
    exit 1
  end
  
  wc = LinuxWc.new(ARGV[0])
  puts wc.read_file
end