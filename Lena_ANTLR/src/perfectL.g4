grammar perfectL;

options {
    language = Java;
}

@header {
    import java.math.*;
    import java.util.HashMap;
    import java.util.Map;
}

program
  : (func_vars_main_block)+
  ;

WS: [ \n\t\r]+ -> skip;

func_vars_main_block
//  : FUNC name_func LBRACK (formalParameterList)? RBRACK (COLON typeIdentifier)? LCURLY block RCURLY
: GLOBAL_VARIABLES LCURLY block RCURLY
//  | START LCURLY block RCURLY FINISH
//  | name_func LBRACK (formalParameterList)? RBRACK (COLON typeIdentifier)? LCURLY block RCURLY
//  {
//    System.out.println($formalParameterList.ret);
//  }
  ;

formalParameterList returns [String ret = ""]
  : formalParameterSection {
    $ret += $formalParameterSection.text;
  }
  (COMMA formalParameterSection {
    $ret += ", ";
    $ret += $formalParameterSection.text;
  })*
  ;

typeIdentifier
  : (CHAR | BOOLEAN | INT | STRING)
  ;

name_func
  : IDENT
  ;

formalParameterSection
  : typeIdentifier IDENT
  ;

block
  : (plain_initialization
  | initialization
  | for_structure
  | if_structure
  | EXIT SEMI
  | while_structure
  | run_func)*
  ;


plain_initialization
  : formalParameterList SEMI
  | typeIdentifier IDENT (COMMA IDENT)* SEMI
  ;

initialization
  : IDENT DOT INIT LPAREN expression RPAREN SEMI
  ;

for_structure
  : FOR LPAREN IDENT DOTDOT expression RPAREN LCURLY block RCURLY
  ;

if_structure
  : IF LPAREN expression EQUAL expression RPAREN THEN LCURLY block RCURLY
  ;

while_structure
  : WHILE LPAREN ((expression (EQUAL|NOT_EQUAL|LT|LE|GE|GT)expression) | expression) RPAREN LCURLY block RCURLY
  ;

run_func
  : name_func LPAREN (expression (COMMA expression)*)? RPAREN SEMI
  ;

expression
  : IDENT | STRING_LITERAL | NUM_INT | TRUE | FALSE
  ;

  STRING
     : S T R I N G
     ;

  INT
     : I N T
     ;

  BOOLEAN
     : B O O L E A N
     ;

  CHAR
     : C H A R
     ;

  TRUE
     : T R U E
     ;

  FALSE
     : F A L S E
     ;

  STRING_LITERAL
     : '\'' ('\'\'' | ~ ('\''))* '\''
     ;

  NUM_INT
     : ('0' .. '9') +
     ;


  THEN
    : T H E N
    ;

  WHILE
    : W H I L E
    ;

  EXIT
     : E X I T
     ;

  IF
     : I F
     ;

  FOR
     : F O R
     ;

  INIT
     : S E T
     ;

  IDENT
     : ('a' .. 'z' | 'A' .. 'Z') ('a' .. 'z' | 'A' .. 'Z' | '0' .. '9' | '_')*
     ;

  FUNC
     : F U N C
     ;

  GLOBAL_VARIABLES
     : G L O B A L UNDERSCORE V A R I A B L E S
     | 'global_variables'
     ;

  START
     : S T A R T
     ;

  FINISH
     : F I N I S H
     ;

  UNDERSCORE
     : '_'
     ;

  PLUS
     : '+'
     ;


  MINUS
     : '-'
     ;


  STAR
     : '*'
     ;


  SLASH
     : '/'
     ;


  ASSIGN
     : ':='
     ;


  COMMA
     : ','
     ;


  SEMI
     : ';'
     ;


  COLON
     : ':'
     ;


  EQUAL
     : '='
     ;


  NOT_EQUAL
     : '<>'
     ;


  LT
     : '<'
     ;


  LE
     : '<='
     ;


  GE
     : '>='
     ;


  GT
     : '>'
     ;


  LPAREN
     : '('
     ;


  RPAREN
     : ')'
     ;


  LBRACK
     : '['
     ;


  LBRACK2
     : '(.'
     ;


  RBRACK
     : ']'
     ;


  RBRACK2
     : '.)'
     ;


  POINTER
     : '^'
     ;


  AT
     : '@'
     ;


  DOT
     : '.'
     ;


  DOTDOT
     : '..'
     ;


  LCURLY
     : '{'
     ;


  RCURLY
     : '}'
     ;




  fragment A
     : ('a' | 'A')
     ;


  fragment B
     : ('b' | 'B')
     ;


  fragment C
     : ('c' | 'C')
     ;


  fragment D
     : ('d' | 'D')
     ;


  fragment E
     : ('e' | 'E')
     ;


  fragment F
     : ('f' | 'F')
     ;


  fragment G
     : ('g' | 'G')
     ;


  fragment H
     : ('h' | 'H')
     ;


  fragment I
     : ('i' | 'I')
     ;


  fragment J
     : ('j' | 'J')
     ;


  fragment K
     : ('k' | 'K')
     ;


  fragment L
     : ('l' | 'L')
     ;


  fragment M
     : ('m' | 'M')
     ;


  fragment N
     : ('n' | 'N')
     ;


  fragment O
     : ('o' | 'O')
     ;


  fragment P
     : ('p' | 'P')
     ;


  fragment Q
     : ('q' | 'Q')
     ;


  fragment R
     : ('r' | 'R')
     ;


  fragment S
     : ('s' | 'S')
     ;


  fragment T
     : ('t' | 'T')
     ;


  fragment U
     : ('u' | 'U')
     ;


  fragment V
     : ('v' | 'V')
     ;


  fragment W
     : ('w' | 'W')
     ;


  fragment X
     : ('x' | 'X')
     ;


  fragment Y
     : ('y' | 'Y')
     ;


  fragment Z
     : ('z' | 'Z')
     ;
