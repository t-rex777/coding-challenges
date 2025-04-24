#!/usr/bin/env ruby

# Implements word count functionality similar to Unix wc command
class LinuxWc
  def initialize(content)
    @content = content
  end

  def count_bytes
    @content.bytesize
  end

  def count_lines
    @content.count("\n")
  end

  def count_words
    @content.scan(/\S+/).count
  end

  def count_characters
    @content.chars.count
  end
end

if ARGV.empty?
  puts 'Error: Please provide a file path'
  exit 1
end

# Read content from file path then do word count functionality
class LinuxWcWithFilePath < LinuxWc
  def initialize(file_path)
    unless File.exist?(file_path)
      puts "Error: File '#{file_path}' does not exist"
      exit 1
    end

    content = File.read(file_path)
    super(content)
    @file_path = file_path
  end

  def file_name
    @file_path
  end
end

def execute_wc(wc)
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
end

# file content is taken from terminal
# eg cat ./word-count/test.txt | ccwc -l
unless $stdin.tty?
  wc = LinuxWc.new($stdin.read)
  execute_wc(wc)

  exit 0
end

# no flags
# eg ccwc -m ./word-count/test.txt
if ARGV.length == 1
  wc = LinuxWcWithFilePath.new(ARGV[0])
  puts "    #{wc.count_lines}   #{wc.count_words}   #{wc.count_bytes}   #{wc.file_name}"
  exit 0
end

# with flags
# eg ccwc ./word-count/test.txt
wc = LinuxWcWithFilePath.new(ARGV[1])
execute_wc(wc)
