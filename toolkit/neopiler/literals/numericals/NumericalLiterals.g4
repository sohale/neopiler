grammar NumericalLiterals;
// numericals

// Entry point for parsing
numLiteral : floatingPointLiteral | integerLiteral ;

// Define floating point literals including normal, scientific, and binary with exponent
floatingPointLiteral
    : DecimalFloatingPointLiteral
    | HexadecimalFloatingPointLiteral
    | BinaryFloatingPointLiteral
    ;

DecimalFloatingPointLiteral
    : DecimalNumber '.' DecimalDigits? ExponentPart? FloatTypeSuffix?
    | '.' DecimalDigits ExponentPart? FloatTypeSuffix?
    ;

HexadecimalFloatingPointLiteral
    : '0x' HexDigits '.'? HexDigits? BinaryExponent FloatTypeSuffix?
    | '0x' '.' HexDigits BinaryExponent FloatTypeSuffix?
    ;

BinaryFloatingPointLiteral
    : BinarySign? '0b' BinaryDigits '.' BinaryDigits? BinaryExponent
    ;

// Define integer literals
integerLiteral : DecimalDigits ;

// Define components of floating point literals
DecimalDigits : [0-9] ('_'? [0-9])* ;
HexDigits : [0-9a-fA-F] ('_'? [0-9a-fA-F])* ;
BinaryDigits : [01] ('_'? [01])* ;

// Exponents for decimal and binary floating points
ExponentPart : [eE] [+\-]? DecimalDigits ;
BinaryExponent : [pP] [+\-]? DecimalDigits ;

// Optional suffixes for floating points
FloatTypeSuffix : [fF] | '_f16' | '_f32' ;

// Optional sign for numbers
BinarySign : '+' | '-' ;

// Rule for basic decimal number
DecimalNumber : [0-9]+ ;

// Define the lexer and parser rules for handling whitespace and skipping unwanted characters
WS : [ \t\r\n]+ -> skip ; // Skip spaces, tabs, newlines
