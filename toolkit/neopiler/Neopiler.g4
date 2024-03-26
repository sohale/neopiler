/*

Neopiler file
aka, Neo file
.neo file

*/

grammar Neopiler;

// workaround for quick PoC
import CString; // Import the CString grammar

compilationUnit
    : grammarDeclaration+
    ;

grammarDeclaration
    : cString // From CString.g4
    // | xx // Placeholder for XX grammar rules
    // | yy // Placeholder for YY grammar rules
    ;

// Lexer rules for the structure of the language definition
GRAMMARS : 'grammars';
SEMI : ';';

