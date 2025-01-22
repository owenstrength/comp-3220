#
#  Class Lexer - Reads a TINY program and emits tokens
#
class Lexer
# Constructor - Is passed a file to scan and outputs a token
#               each time nextToken() is invoked.
#   @c        - A one character lookahead 
	def initialize(filename)
		begin
			@f = File.open(filename,'r:utf-8')
			
			# Read first character
			if (! @f.eof?)
				@c = @f.getc()
			else
				@c = "eof"
				@f.close()
			end
		rescue Errno::ENOENT
			puts "Error: File '#{filename}' not found."
			@c = "eof"
		rescue => e
			puts "Error opening file: #{e.message}"
			@c = "eof"
		end
		
		# Open token output file
		@token_file = File.open("tokens", "w")
	end
	
	# Method nextCh() returns the next character in the file
	def nextCh()
		if (! @f.eof?)
			@c = @f.getc()
		else
			@c = "eof"
		end
		
		return @c
	end

	# Method nextToken() reads characters in the file and returns
	# the next token
	def nextToken() 
		token = nil
		
		if @c == "eof"
			token = Token.new(Token::EOF,"eof")
				
		elsif whitespace?(@c)
			str = ""
		
			while whitespace?(@c)
				str += @c
				nextCh()
			end
		
			token = Token.new(Token::WS,str)
		elsif @c == '('
			ch = @c
			nextCh()
			token = Token.new(Token::LPAREN, ch)
		elsif @c == ')'
			ch = @c
			nextCh()
			token = Token.new(Token::RPAREN, ch)
		elsif @c == '+'
			ch = @c
			nextCh()
			token = Token.new(Token::ADDOP, ch)
		elsif @c == '-'
			ch = @c
			nextCh()
			token = Token.new(Token::SUBOP, ch)
		elsif @c == '*'
			ch = @c
			nextCh()
			token = Token.new(Token::MULTOP, ch)
		elsif @c == '/'
			ch = @c
			nextCh()
			token = Token.new(Token::DIVOP, ch)
		elsif @c == '='
			ch = @c
			nextCh()
			token = Token.new(Token::ASSIGNOP, ch)
		elsif @c == '<'
			ch = @c
			nextCh()
			token = Token.new(Token::LESS, ch)
		elsif @c == '>'
			ch = @c
			nextCh()
			token = Token.new(Token::GREATER, ch)
		elsif @c == '&'
			ch = @c
			nextCh()
			token = Token.new(Token::AND, ch)
		elsif numeric?(@c)
			num = ""
			while @c != "eof" && numeric?(@c)
				num += @c
				nextCh()
			end
			token = Token.new(Token::INT, num)
		elsif letter?(@c)
			id = ""
			while @c != "eof" && (letter?(@c) || numeric?(@c))
				id += @c
				nextCh()
			end
			
			# Check for keywords
			case id
			when "if"
				token = Token.new(Token::IF, id)
			when "then"
				token = Token.new(Token::THEN, id)
			when "while"
				token = Token.new(Token::WHILE, id)
			when "print"
				token = Token.new(Token::PRINT, id)
			else
				token = Token.new(Token::ID, id)
			end
		else
			ch = @c
			nextCh()
			token = Token.new(Token::UNKWN, ch)
		end
		
		# Write token to file and print to console
		if token
			puts token
			@token_file.puts token
		end
		
		return token
	end

	def close
		@token_file.close if @token_file
		@f.close if @f && !@f.closed?
	end

#
# Helper methods for Scanner
#
def letter?(lookAhead)
	lookAhead =~ /^[a-z]|[A-Z]$/
end

def numeric?(lookAhead)
	lookAhead =~ /^(\d)+$/
end

def whitespace?(lookAhead)
	lookAhead =~ /^(\s)+$/
end
end