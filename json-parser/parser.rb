# frozen_string_literal: true

# https://regex101.com/r/1UUUxr/1
# TODO: add support to check values which are arrays, objects, strings, numbers, booleans, null
# Parses the provided JSON file to check if its valid
class JsonParser
  attr_accessor :tokens, :result, :json

  OPEN_BRACE_REGEX =  /\{/.freeze
  CLOSE_BRACE_REGEX = /}/.freeze
  SEMI_COLON_REGEX = /:/.freeze
  COMMA_REGEX = /,/.freeze
  KEY_PAIR_REGEX = /["']?[\w\s_-]+["']?\s?:/.freeze
  STRING_REGEX = /"[^"]*"/.freeze
  NUMBER_REGEX = /-?\d+(?:\.\d+)?/.freeze
  BOOLEAN_REGEX = /true|false/.freeze
  NULL_REGEX = /null/.freeze
  VALUE_REGEX = /:\s?["']?[\w\s_-]+["']?/.freeze
  VALID_VALUES = /-?\d+(?:\.\d+)?|true|false|null|["']?[\w\s_-]+["']/.freeze
  INVALID_COMMAS = /,\s?\}/.freeze

  def initialize(json)
    @json = json
    @tokens = { close_braces: 0, open_braces: 0, commas: 0, semi_colons: 0, keys: [], values: [] }
    @result = json.to_s
  end

  def find_pattern
    open_braces = @result.scan(OPEN_BRACE_REGEX)
    close_braces = @result.scan(CLOSE_BRACE_REGEX)
    commas = @result.scan(COMMA_REGEX)
    semi_colons = @result.scan(SEMI_COLON_REGEX)
    keys = @result.scan(KEY_PAIR_REGEX)
    values = @result.scan(VALUE_REGEX)

    @tokens[:open_braces] = open_braces.length
    @tokens[:close_braces] = close_braces.length
    @tokens[:commas] = commas.length
    @tokens[:semi_colons] = semi_colons.length
    @tokens[:keys] = keys
    @tokens[:values] = values
  end

  def find_and_add(identifier, update_to)
    @result.split('') do |key|
      @tokens[update_to] += 1 if key == identifier
    end
  end

  def lexer
    find_pattern
    nil unless braces
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

    return if @result.scan(INVALID_COMMAS).empty?

    puts 'Invalid JSON, got extra comma'
    exit 1
  end

  def keys
    return unless @tokens[:keys].length.positive?

    @tokens[:keys].each do |key|
      unless key.match(STRING_REGEX)
        puts "Invalid key #{key}"
        exit 1
      end
    end
  end

  def values
    return unless @tokens[:values].length.positive?

    @tokens[:values].each do |value|
      unless value.match(VALID_VALUES)
        puts "Invalid value #{value}"
        exit 1
      end
    end
  end

  def parser
    braces
    commas
    keys
    values
    puts 'Valid JSON'
  end

  def check
    lexer
    parser
  end
end

JsonParser.new(File.read(ARGV[0])).check
