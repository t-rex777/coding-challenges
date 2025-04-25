# frozen_string_literal: true

# Parses the provided JSON file to check if its valid
class JsonParser
  attr_accessor :tokens, :result, :json

  def initialize(json)
    @json = json
    @tokens = { close_braces: 0, open_braces: 0, commas: 0, semi_colons: 0, keys: [], values: [] }
    @result = json.to_s
  end

  def find_and_add(identifier, update_to)
    @result.split('') do |key|
      @tokens[update_to] += 1 if key == identifier
    end
  end

  def find_keys_values
    @result.split(',') do |word|
      word.split(':') do |key_value, index|
        index.even ? @tokens[:keys].push(key_value) : @tokens[:values].push(key_value)
      end
    end
  end

  def lexer
    find_and_add('{', :open_braces)
    find_and_add('}', :close_braces)
    find_and_add(',', :commas)
    find_and_add(':', :semi_colons)

    return unless braces

    find_keys_values
  end

  def braces
    unless @tokens[:open_braces].positive? && @tokens[:close_braces].positive?
      puts 'Empty File'
      exit 1
    end

    return if @tokens[:open_braces] == @tokens[:close_braces]

    puts 'Invalid JSON file'
    exit 1
  end

  def commas
    return unless @tokens[:commas].positive?

    return if @tokens[:semi_colons] - 1 == @tokens[:commas]

    puts 'Invalid JSON, got extra comma'
    exit 1
  end

  def keys
    return unless @tokens[:keys].length.positive?

    @tokens[:keys].each do |key|
      unless key.is_a?(String)
        puts 'key is not a string'
        exit 1
      end
    end
  end

  def parser
    braces
    commas
    keys
    puts 'Valid JSON'
  end

  def check
    lexer
    parser
  end
end

jsonFile = File.read(ARGV[0])
puts jsonFile

JsonParser.new(jsonFile).check
