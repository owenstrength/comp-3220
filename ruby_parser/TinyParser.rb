#
#  Parser Class
#
load "TinyToken.rb"
load "TinyLexer.rb"

class Parser < Lexer
  def initialize(filename)
    super(filename)
    @errorCount = 0
    consume()
  end

  def consume()
    @lookahead = nextToken()
    while (@lookahead.type == Token::WS)
      @lookahead = nextToken()
    end
  end

  def match(dtype)
    if (@lookahead.type != dtype)
      puts "Expected #{dtype} found #{@lookahead.text}"
      @errorCount += 1
    end
    consume()
  end

  def program()
    stmtseq()
    puts "There were #{@errorCount} parse errors found."
  end
  
  def stmtseq()
    puts "Entering STMTSEQ Rule"
    while @lookahead.type != Token::EOF && @lookahead.type != Token::ENDOP
      puts "Entering STMT Rule"
      statement()
    end
    puts "Exiting STMTSEQ Rule"
    if @lookahead.type == Token::ENDOP
      puts "Found ENDOP Token: end"
    end
  end

  def statement()
    case @lookahead.type
    when Token::PRINT
      puts "Found PRINT Token: #{@lookahead.text}"
      match(Token::PRINT)
      puts "Entering EXP Rule"
      exp()
    when Token::IFOP
      puts "Entering IFSTMT Rule"
      puts "Found IFOP Token: #{@lookahead.text}"
      ifstmt()
    when Token::WHILEOP
      puts "Entering LOOPSTMT Rule"
      puts "Found WHILEOP Token: #{@lookahead.text}"
      loopstmt()
    else
      puts "Entering ASSGN Rule"
      assign()
    end
    puts "Exiting STMT Rule"
  end

  def ifstmt()
    match(Token::IFOP)
    puts "Entering COMPARISON Rule"
    comparison()
    match(Token::THENOP)
    puts "Found THENOP Token: then"
    stmtseq()
    match(Token::ENDOP)
    puts "Exiting IFSTMT Rule"
  end

  def loopstmt()
    match(Token::WHILEOP)
    puts "Entering COMPARISON Rule"
    comparison()
    match(Token::THENOP)
    puts "Found THENOP Token: then"
    stmtseq()
    match(Token::ENDOP)
    puts "Exiting LOOPSTMT Rule"
  end

  def comparison()
    puts "Entering FACTOR Rule"
    factor()
    
    while true
      if @lookahead.type == Token::LT
        puts "Found LT Token: #{@lookahead.text}"
        consume()  # Match the LT operator
        puts "Entering FACTOR Rule"
        factor()
      elsif @lookahead.type == Token::GT
        puts "Found GT Token: #{@lookahead.text}"
        consume()  # Match the GT operator
        puts "Entering FACTOR Rule"
        factor()
      elsif @lookahead.type == Token::ANDOP
        puts "Found ANDOP Token: #{@lookahead.text}"
        consume()  # Match the ANDOP operator
        puts "Entering FACTOR Rule"
        factor()
      else
        break  # Exit the loop if no more comparison operators are found
      end
    end
    
    puts "Exiting COMPARISON Rule"
  end

  def assign()
    if (@lookahead.type == Token::ID)
      puts "Found ID Token: #{@lookahead.text}"
    end
    match(Token::ID)
    if (@lookahead.type == Token::ASSGN)
      puts "Found ASSGN Token: #{@lookahead.text}"
    end
    match(Token::ASSGN)
    puts "Entering EXP Rule"
    exp()
    puts "Exiting ASSGN Rule"
  end

  def exp()
    puts "Entering TERM Rule"
    term()
    puts "Entering ETAIL Rule"
    etail()
    puts "Exiting EXP Rule"
  end

  def etail()
    if (@lookahead.type == Token::ADDOP)
      puts "Found ADDOP Token: #{@lookahead.text}"
      match(Token::ADDOP)
      puts "Entering TERM Rule"
      term()
      puts "Entering ETAIL Rule"
      etail()
    elsif (@lookahead.type == Token::SUBOP)
      puts "Found SUBOP Token: #{@lookahead.text}"
      match(Token::SUBOP)
      puts "Entering TERM Rule"
      term()
      puts "Entering ETAIL Rule"
      etail()
    else
      puts "Did not find ADDOP or SUBOP Token, choosing EPSILON production"
    end
    puts "Exiting ETAIL Rule"
  end

  def term()
    puts "Entering FACTOR Rule"
    factor()
    puts "Entering TTAIL Rule"
    ttail()
    puts "Exiting TERM Rule"
  end

  def ttail()
    if (@lookahead.type == Token::MULTOP)
      puts "Found MULTOP Token: #{@lookahead.text}"
      match(Token::MULTOP)
      puts "Entering FACTOR Rule"
      factor()
      puts "Entering TTAIL Rule"
      ttail()
    elsif (@lookahead.type == Token::DIVOP)
      puts "Found DIVOP Token: #{@lookahead.text}"
      match(Token::DIVOP)
      puts "Entering FACTOR Rule"
      factor()
      puts "Entering TTAIL Rule"
      ttail()
    else
      puts "Did not find MULTOP or DIVOP Token, choosing EPSILON production"
    end
    puts "Exiting TTAIL Rule"
  end

  def factor()
    if (@lookahead.type == Token::LPAREN)
      puts "Found LPAREN Token: #{@lookahead.text}"
      match(Token::LPAREN)
      puts "Entering EXP Rule"
      exp()
      if (@lookahead.type == Token::RPAREN)
        puts "Found RPAREN Token: #{@lookahead.text}"
        match(Token::RPAREN)
      end
    elsif (@lookahead.type == Token::ID)
      puts "Found ID Token: #{@lookahead.text}"
      match(Token::ID)
    elsif (@lookahead.type == Token::INT)
      puts "Found INT Token: #{@lookahead.text}"
      match(Token::INT)
    else
      puts "Expected ( or INT or ID found #{@lookahead.type}"
      @errorCount += 1
    end
    puts "Exiting FACTOR Rule"
  end
end