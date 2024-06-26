/*

Neopiler file
aka, Neo file
.neo file

*/
// todo: rename: NeopilerParser
grammar Neopiler;

// See C++ Parser: https://github.com/antlr/grammars-v4/blob/master/cpp/CPP14Parser.g4

/*
options {
    superClass = CPP14ParserBase;
    tokenVocab = CPP14Lexer;
}
*/

// workaround for quick PoC
import CString; // Import the CString grammar

compilationUnit
    : grammarDeclaration+
    ;

grammarDeclaration
    : cString // From CString.g4
    | id      // Accept an identifier
    // | xx // Placeholder for XX grammar rules
    // | yy // Placeholder for YY grammar rules
    ;

// Lexer rules for the structure of the language definition

GRAMMARS : 'grammars';

SEMI : ';';

ID : LETTER (LETTER | [0-9] | '_')* ;

// A fragment rule
fragment LETTER : [a-zA-Z_] | UNICODE_LETTER ;

fragment UNICODE_LETTER : '\u0080'..'\uFFFF';

// Skip whitespaces
WHITESPACE : [ \t\r\n]+ -> skip ;
