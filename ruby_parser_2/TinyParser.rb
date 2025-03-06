#
# Parser Class
#
load "TinyLexer.rb"
load "TinyToken.rb"
load "AST.rb"

class Parser < Lexer
    def initialize(filename)
        super(filename)
        consume()
    end
    
    def consume()
        @lookahead = nextToken()
        while(@lookahead.type == Token::WS)
            @lookahead = nextToken()
        end
    end
    
    def match(dtype)
        if (@lookahead.type != dtype)
            puts "Expected #{dtype} found #{@lookahead.text}"
            @errors_found+=1
        end
        consume()
    end
    
    def program()
        @errors_found = 0
        p = AST.new(Token.new("program","program"))
        while( @lookahead.type != Token::EOF)
            p.addChild(statement())
        end
        puts "There were #{@errors_found} parse errors found."
        return p
    end
    
    def statement()
        curr_statement = AST.new(Token.new("statement","statement"))
        if (@lookahead.type == Token::PRINT)
            curr_statement = AST.new(@lookahead)
            match(Token::PRINT)
            curr_statement.addChild(exp())
        elsif (@lookahead.type == Token::IFOP)
            curr_statement = if_stmt()
        elsif (@lookahead.type == Token::WHILEOP)
            curr_statement = while_stmt()
        else
            curr_statement = assign()
        end
        return curr_statement
    end
    
    def if_stmt()
        # Create IF node
        if_node = AST.new(@lookahead)
        match(Token::IFOP)
        
        # Parse condition
        if_node.addChild(bool_exp())
        
        # Parse THEN
        then_block = nil
        if (@lookahead.type == Token::THENOP)
            then_block = AST.new(@lookahead)
            match(Token::THENOP)
        else
            # If THENOP is missing, create a default then node
            then_block = AST.new(Token.new(Token::THENOP, "then"))
        end
        
        # Parse statements in the IF body
        while (@lookahead.type != Token::ENDOP && @lookahead.type != Token::EOF)
            then_block.addChild(statement())
        end
        
        # Store the END token and match it
        if (@lookahead.type == Token::ENDOP)
            # Create a node for the END token
            end_token = AST.new(@lookahead)
            match(Token::ENDOP)
            then_block.addChild(end_token)
        else
            # Handle missing END
            match(Token::ENDOP)
        end
        
        # Add the then block to the if node
        if_node.addChild(then_block)
        
        return if_node
    end
    
    def while_stmt()
        # Create WHILE node
        while_node = AST.new(@lookahead)
        match(Token::WHILEOP)
        
        # Parse condition
        while_node.addChild(bool_exp())
        
        # Parse THEN
        then_block = nil
        if (@lookahead.type == Token::THENOP)
            then_block = AST.new(@lookahead)
            match(Token::THENOP)
        else
            # If THENOP is missing, create a default then node
            then_block = AST.new(Token.new(Token::THENOP, "then"))
        end
        
        # Parse statements in the loop body
        while (@lookahead.type != Token::ENDOP && @lookahead.type != Token::EOF)
            then_block.addChild(statement())
        end
        
        # Store the END token and match it
        if (@lookahead.type == Token::ENDOP)
            # Create a node for the END token
            end_token = AST.new(@lookahead)
            match(Token::ENDOP)
            then_block.addChild(end_token)
        else
            # Handle missing END
            match(Token::ENDOP)
        end
        
        # Add the then block to the while node
        while_node.addChild(then_block)
        
        return while_node
    end
    
    def bool_exp()
        # Create a boolean expression node
        bool_exp_node = AST.new(Token.new("bool_exp", "bool_exp"))
        
        # Parse left expression
        left_exp = exp()
        
        # Parse comparison operator
        if (@lookahead.type == Token::LT || @lookahead.type == Token::GT)
            # Create operator node
            op_node = AST.new(@lookahead)
            op_type = @lookahead.type
            match(op_type)
            
            # Parse right expression
            right_exp = exp()
            
            # Attach left and right to operator node
            op_node.addChild(left_exp)
            op_node.addChild(right_exp)
            
            return op_node
        else
            # If no operator, just return the expression
            return left_exp
        end
    end
    
    def exp()
        start_term = term()
        if (@lookahead.type == Token::ADDOP or @lookahead.type == Token::SUBOP)
            curr_exp = etail()
            curr_exp.addNextChild(start_term)
            curr_exp.shiftSiblingsDown()
        else
            curr_exp = start_term
        end
        return curr_exp
    end
    
    def term()
        start_factor = factor()
        if (@lookahead.type == Token::MULTOP or @lookahead.type == Token::DIVOP)
            curr_term = ttail()
            curr_term.addNextChild(start_factor)
            curr_term.shiftSiblingsDown()
        else
            curr_term = start_factor
        end
        return curr_term
    end
    
    def factor()
        fct = AST.new(Token.new("factor", "factor"))
        if (@lookahead.type == Token::LPAREN)
            match(Token::LPAREN)
            fct = exp()
            if (@lookahead.type == Token::RPAREN)
                match(Token::RPAREN)
            else
                match(Token::RPAREN)
            end
        elsif (@lookahead.type == Token::INT)
            fct = AST.new(@lookahead)
            match(Token::INT)
        elsif (@lookahead.type == Token::ID)
            fct = AST.new(@lookahead)
            match(Token::ID)
        else
            puts "Expected ( or INT or ID found #{@lookahead.text}"
            @errors_found+=1
            consume()
        end
        return fct
    end
    
    def ttail()
        ttail = AST.new(Token.new("ttail", "ttail"))
        if (@lookahead.type == Token::MULTOP)
            ttail = AST.new(@lookahead)
            match(Token::MULTOP)
            ttail.setNextSibling(factor())
            rec_ttail = ttail()
            if (rec_ttail != nil)
                rec_ttail.addNextChild(ttail)
                ttail = rec_ttail
            end
        elsif (@lookahead.type == Token::DIVOP)
            ttail = AST.new(@lookahead)
            match(Token::DIVOP)
            ttail.setNextSibling(factor())
            rec_ttail = ttail()
            if (rec_ttail != nil)
                rec_ttail.addNextChild(ttail)
                ttail = rec_ttail
            end
        else
            return nil
        end
        return ttail
    end
    
    def etail()
        etail = AST.new(Token.new("etail", "etail"))
        if (@lookahead.type == Token::ADDOP)
            etail = AST.new(@lookahead)
            match(Token::ADDOP)
            etail.setNextSibling(term())
            rec_etail = etail()
            if (rec_etail != nil)
                rec_etail.addNextChild(etail)
                etail = rec_etail
            end
        elsif (@lookahead.type == Token::SUBOP)
            etail = AST.new(@lookahead)
            match(Token::SUBOP)
            etail.setNextSibling(term())
            rec_etail = etail()
            if (rec_etail != nil)
                rec_etail.addNextChild(etail)
                etail = rec_etail
            end
        else
            return nil
        end
        return etail
    end
    
    def assign()
        curr_assign = AST.new(Token.new("assignment","assignment"))
        if (@lookahead.type == Token::ID)
            idtok = AST.new(@lookahead)
            match(Token::ID)
            if (@lookahead.type == Token::ASSGN)
                curr_assign = AST.new(@lookahead)
                curr_assign.addChild(idtok)
                match(Token::ASSGN)
                curr_assign.addChild(exp())
            else
                match(Token::ASSGN)
            end
        else
            match(Token::ID)
        end
        return curr_assign
    end
end