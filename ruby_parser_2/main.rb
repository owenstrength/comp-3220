load "TinyParser.rb"

parse = Parser.new("input3.tiny")
mytree = parse.program()
puts mytree.toStringList()
