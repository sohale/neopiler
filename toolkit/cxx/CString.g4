/* An ANTLR file
 for C/C++ string literals
 Surrounded by:
    These are inside a pair of " (only)
    no character literals (using `'`)
    String prefixed are outside this context: u8"", u, U, R"",


 ANTLR line comment is //
 ANTLR block comment:
*/

// CppString or CString?
grammar CString;

// Entry point that matches a string without the surrounding quotes
string
    : STRING_CONTENT* EOF
    ;

// Match string content or escape sequences
STRING_CONTENT
    : ESCAPE_SEQUENCE
    | ~('\\'|'\r'|'\n')+
    ;

// Define C/C++ escape sequences including octal and unicode
ESCAPE_SEQUENCE
    : '\\' ('0'          // Null character
          | 'n'         // Newline
          | 'r'         // Carriage return
          | 't'         // Horizontal tab
          | '"'         // Double quote
          | '\''        // Single quote
          | '\\'        // Backslash
          | 'b'         // Backspace
          | 'f'         // Formfeed
          | 'v'         // Vertical tab
          | 'a'         // Alert (bell)
          | OCTAL_ESCAPE_SEQUENCE // Octal byte value
          | ('x' HEX_DIGIT HEX_DIGIT?) // Hexadecimal byte value
          | ('u' HEX_DIGIT HEX_DIGIT HEX_DIGIT HEX_DIGIT) // Unicode 4 digits
          | ('U' HEX_DIGIT HEX_DIGIT HEX_DIGIT HEX_DIGIT HEX_DIGIT HEX_DIGIT HEX_DIGIT HEX_DIGIT) // Unicode 8 digits
          )
    ;

OCTAL_ESCAPE_SEQUENCE
    : [0-7] [0-7]? [0-7]? // 1 to 3 octal digits
    ;

fragment HEX_DIGIT : [0-9a-fA-F] ; // Hexadecimal digit

// Skip whitespace except new lines, to prevent them from being included in STRING_CONTENT
WS : [ \t]+ -> skip ;
