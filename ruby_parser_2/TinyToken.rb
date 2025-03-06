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
   LPAREN = "lparen"
   RPAREN = "rparen"
   ADDOP  = "addop"
   SUBOP  = "minusop"
   MULTOP = "multop"
   DIVOP  = "divop"
   INT    = "int"
   ID     = "id"
   PRINT  = "print"
   ASSGN  = "equalop"
   IFOP   = "ifop"
   WHILEOP= "whileop"
   THENOP = "thenop"
   ENDOP = "endop"
   LT     = "lt"
   GT     = "gt"
   ANDOP  = "and"
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
