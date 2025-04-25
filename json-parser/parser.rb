# Parses the provided JSON file to check if its valid
class JsonParser
  attr_accessor :tokens, :result

  def initialize(json)
    @tokens = { close_braces: 0, open_braces: 0 }
    @result = json.to_s
  end

  def split_by(identifier, update_to)
    @result.split('') do |key|
      @tokens[update_to] += 1 if key == identifier
    end
  end

  def lexer
    split_by('{', :open_braces)
    split_by('}', :close_braces)
  end

  def parser
    unless @tokens[:open_braces].positive? && @tokens[:close_braces].positive?
      puts 'File is empty'
      exit 1
    end

    unless @tokens[:open_braces] == @tokens[:close_braces]
      puts 'Invalid JSON'
      exit 1
    end

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
