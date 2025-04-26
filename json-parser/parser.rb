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
  VALUE_REGEX = /:(\s?.+),/.freeze
  VALID_VALUES = /-?\d+(?:\.\d+)?|true|false|null|["']?[\w\s_-]+["']|(\{\})/.freeze
  INVALID_COMMAS = /,\s?\}/.freeze

  def initialize(json)
    @json = json
    @tokens = { close_braces: 0, open_braces: 0, commas: 0, semi_colons: 0, keys: [], values: [] }
    @result = json.to_s
  end

  def check
    lexer
    parser
  end

  private

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

    puts "values: #{values}"
  end

  def lexer
    find_pattern
    nil unless check_braces
  end

  def check_braces
    unless @tokens[:open_braces].positive? && @tokens[:close_braces].positive?
      puts 'Empty File'
      exit 1
    end

    return if @tokens[:open_braces] == @tokens[:close_braces]

    puts 'Invalid JSON file'
    exit 1
  end

  def check_commas
    return unless @tokens[:commas].positive?

    return if @result.scan(INVALID_COMMAS).empty?

    puts 'Invalid JSON, got extra comma'
    exit 1
  end

  def check_keys
    return unless @tokens[:keys].length.positive?

    @tokens[:keys].each do |key|
      unless key.match(STRING_REGEX)
        puts "Invalid key #{key}"
        exit 1
      end
    end
  end

  def check_values(values)
    values.each do |value|
      if value.is_a?(Array)
        if value.length.positive?
          check_values(value)
        else
          continue
        end
      else
        result = value.to_s
        unless result.match(VALID_VALUES)
          puts "Invalid value #{value}"
          exit 1
        end
      end
    end
  end

  def parser
    check_braces
    check_commas
    check_keys
    check_values(@tokens[:values])
    puts 'Valid JSON'
  end
end

JsonParser.new(File.read(ARGV[0])).check
