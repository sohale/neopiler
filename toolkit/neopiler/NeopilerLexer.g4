
lexer grammar NeopilerLexer;

// See C++Lexer https://github.com/antlr/grammars-v4/blob/master/cpp/CPP14Lexer.g4


// StringLiteral: Encodingprefix? (Rawstring | '"' Schar* '"');


Whitespace: [ \t]+ -> skip;

Newline: ('\r' '\n'? | '\n') -> skip;

BlockComment: '/*' .*? '*/' -> skip;

LineComment: '//' ~ [\r\n]* -> skip;
