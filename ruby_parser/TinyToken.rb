#
#  Class Token - Encapsulates the tokens in TINY
#
#   @type - the type of token
#   @text - the text the token represents
#
class Token
  attr_accessor :type
  attr_accessor :text
  
  EOF = "eof"
  LPAREN = "("
  RPAREN = ")"
  ADDOP  = "+"
  SUBOP  = "-"
  MULTOP = "*"
  DIVOP  = "/"
  INT    = "int"
  ID     = "id"
  PRINT  = "print"
  ASSGN  = "="
  IFOP   = "if"
  WHILEOP= "while"
  THENOP = "then"
  ENDOP = "end"
  LT     = "<"
  GT     = ">"
  ANDOP  = "&"
  WS     = "whitespace"
  UNKNWN = "unknown"
  
  def initialize(type,text)
     @type = type
     @text = text
  end
  def get_type
     return @type
  end
  def get_text
     return @text
  end
  def to_s
      return "#{@type} #{@text}"
  end
end
