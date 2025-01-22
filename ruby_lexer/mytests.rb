load "./TinyLexer.rb"
load "./TinyToken.rb"

def test_lexer(filename)
    lexer = Lexer.new(filename)
    
    loop do
        token = lexer.nextToken()
        puts token
        break if token.type == Token::EOF
    end
end

# Test with valid file
test_lexer("input2.tiny")

# Test with non-existent file
test_lexer("nonexistent.txt")

# Test arithmetic operators
tok = Token.new(Token::ADDOP, "+")
puts "Add operator: #{tok}"
tok = Token.new(Token::SUBOP, "-")
puts "Subtract operator: #{tok}"

# Test comparison operators
tok = Token.new(Token::LESS, "<")
puts "Less than operator: #{tok}"
tok = Token.new(Token::AND, "&")
puts "And operator: #{tok}"

# Test keywords
tok = Token.new(Token::IF, "if")
puts "If keyword: #{tok}"
tok = Token.new(Token::WHILE, "while")
puts "While keyword: #{tok}"

# Test basic elements
tok = Token.new(Token::INT, "42")
puts "Integer: #{tok}"
tok = Token.new(Token::ID, "myVar")
puts "Identifier: #{tok}"
