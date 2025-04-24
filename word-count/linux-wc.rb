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

  def file_name
    @file_path
  end

  def count_bytes
    read_file.bytesize
  end

  def count_lines
    read_file.count("\n")
  end

  def count_words
    read_file.scan(/\S+/).count
  end

  def count_characters
    read_file.chars.count
  end
end

if ARGV.empty?
  puts 'Error: Please provide a file path'
  exit 1
end

if ARGV.length == 1
  wc = LinuxWc.new(ARGV[0])
  puts "    #{wc.count_lines}   #{wc.count_words}   #{wc.count_bytes}   #{wc.file_name}"
  exit 0
end

wc = LinuxWc.new(ARGV[1])
if ARGV.include?('-c')
  puts wc.count_bytes
elsif ARGV.include?('-l')
  puts wc.count_lines
elsif ARGV.include?('-w')
  puts wc.count_words
elsif ARGV.include?('-m')
  puts wc.count_characters
else
  puts 'invalid flag'
  exit 1
end
