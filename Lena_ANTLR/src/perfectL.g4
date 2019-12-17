grammar perfectL;

options {
    language = Java;
}

@members {
    String indent = "";
}

program
  : {System.out.print("#include <iostream>\n#include <cmath>\n#include <string>\n#include <vector>\n\nusing namespace std;\n");}(func_vars_main_block)+
  ;

WS: [ \n\t\r]+ -> skip;

func_vars_main_block
  : GLOBAL_VARIABLES LCURLY (plain_initialization {System.out.print("\n" + $plain_initialization.ret);}| initialization{System.out.print("\n" + $initialization.ret);})* RCURLY
  | START LCURLY block RCURLY FINISH {
    System.out.print("\n\nint main() {" + $block.ret + "\n}");
  }
  | {String local = "EE";} name_func LBRACK (formalParameterList)? RBRACK ( COLON {local = "NO";}typeIdentifier)? LCURLY block RCURLY {
    if (local.equals("EE")) {
      System.out.print("\nvoid ");
    } else {
      System.out.print("\n" + $typeIdentifier.ret + " ");
    }
    System.out.print($name_func.text + "(");
    System.out.print($formalParameterList.ret);
    System.out.print(") {");
    System.out.print( "  " + $block.ret  + "\n}\n");
  }
  ;

formalParameterList returns [String ret = ""]
  : formalParameterSection {
    $ret += $formalParameterSection.ret;
  }
  (COMMA formalParameterSection {
    $ret += ", ";
    $ret += $formalParameterSection.ret;
  })*
  ;

typeIdentifier returns [String ret]
  : (CHAR {$ret = "char";}| BOOLEAN {$ret = "bool";}| INT {$ret = "int";}| STRING {$ret = "string";})
  ;

name_func
  : IDENT
  ;

formalParameterSection returns [String ret = ""]
  : typeIdentifier IDENT {
    $ret = $typeIdentifier.ret + " " + $IDENT.text;
  }
  | typeIdentifier LBRACK RBRACK IDENT {
    $ret = "vector<" + $typeIdentifier.ret + "> " + $IDENT.text;
  }
  ;
//indent += "    ";
//indent = indent.substring(0, indent.length() - 4);
block returns [String ret = ""]
  : {indent += "    ";}(plain_initialization {
  $ret += $plain_initialization.ret;
  }
  | initialization {$ret += $initialization.ret;}
  | for_structure {$ret += $for_structure.ret;}
  | if_structure {$ret += $if_structure.ret;}
  | EXIT SEMI {$ret += ( "\n" + indent + "break;");}
  | while_structure {$ret += $while_structure.ret;}
  | SOUT LPAREN expression {$ret += "\n" + indent + "cout << " + $expression.ret;}(COMMA expression{$ret += " << " + $expression.ret;})* RPAREN SEMI {
    $ret += ";";
  }
  | run_func {$ret += $run_func.ret;})*
  {indent = indent.substring(0, indent.length() - 4);}
  ;


plain_initialization returns [String ret = ""]
  : formalParameterList SEMI {
    $ret = "\n" + indent + $formalParameterList.ret + ";";
  }
  | typeIdentifier {$ret = "\n" + indent + $typeIdentifier.ret + " ";} IDENT {$ret += $IDENT.text;} (COMMA IDENT{$ret = $ret + ", " + $IDENT.text;})* SEMI {$ret += ";";}
  ;

initialization returns [String ret = ""]
  : IDENT DOT INIT LPAREN expression RPAREN SEMI {$ret = "\n" + indent + $IDENT.text + " = " + $expression.ret + ";";}
  | IDENT DOT INIT LPAREN LCURLY {$ret = "\n" + indent + $IDENT.text + " = {";} expression {$ret += $expression.ret;}(COMMA expression{$ret += ", " + $expression.ret;})* RCURLY RPAREN SEMI {
    $ret += "};";
  }
  ;

for_structure returns [String ret = ""]
  : FOR LPAREN IDENT DOTDOT expression RPAREN LCURLY block RCURLY {
    $ret = "\n" + indent +"for (" + $IDENT.text + " <= " + $expression.ret + "; " + $IDENT.text + "++) {" + $block.ret + "\n" + indent + "}";}
  | FOR LPAREN IDENT DOWN expression RPAREN LCURLY block RCURLY {
        $ret = "\n" + indent +"for (" + $IDENT.text + " >= " + $expression.ret + "; " + $IDENT.text + "--) {" + $block.ret + "\n" + indent + "}";}
  ;

if_structure returns [String ret = ""]//TODO:: where is 'else'?
  : IF LPAREN expression {$ret = "\n" + indent + "if (" + $expression.ret;} (EQUAL{$ret += " == ";}|NOT_EQUAL{$ret += " != ";}|LT{$ret += " < ";}|LE{$ret += " <= ";}|GE {$ret += " >= ";}|GT {$ret += " > ";}) expression RPAREN THEN LCURLY block RCURLY {
    $ret += ($expression.ret + ") {" + $block.ret + "\n" + indent + "}");
  }
  ;

while_structure returns [String ret = ""]
  : WHILE LPAREN ((expression {$ret = "\n" + indent + "while (" + $expression.ret;}(EQUAL{$ret += " == ";}|NOT_EQUAL{$ret += " != ";}|LT{$ret += " < ";}|LE{$ret += " <= ";}|GE {$ret += " >= ";}|GT {$ret += " > ";})expression{$ret += ($expression.ret + ") {");}) | expression {$ret = "\n" + indent + "while (" + $expression.ret + ") {";}) RPAREN LCURLY block RCURLY {
    $ret += ($block.ret + "\n" + indent + "}");
  }
  ;

run_func returns [String ret = ""]
  : name_func {$ret = "\n" + indent + $name_func.text + "(";}LPAREN (expression {$ret += $expression.ret;}(COMMA expression{$ret += (", " + $expression.ret);})*)? RPAREN SEMI {
    $ret += ");";
  }
  ;

expression returns [String ret = ""]
  : IDENT {$ret = $IDENT.text;}
  | STRING_LITERAL {
    String temp = "\"" + ($STRING_LITERAL.text).substring(1, $STRING_LITERAL.text.length() - 1) + "\"";
    if($STRING_LITERAL.text.length() == 3) {
      $ret = $STRING_LITERAL.text;
    } else {
      $ret = temp;
    }
  }
  | NUM_INT {$ret = $NUM_INT.text;}
  | TRUE {$ret = "true";}
  | FALSE{$ret = "false";}
  | LCURLY
  ;

  DOWN
     : D O W N
     ;

  SOUT
     : S O U T
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

  GLOBAL_VARIABLES
     : G L O B A L UNDERSCORE V A R I A B L E S
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

   FUNC
       : F U N C
       ;

    START
       : S T A R T
       ;

    FINISH
       : F I N I S H
       ;

       STRING_LITERAL
            : '\'' ('\'\'' | ~ ('\''))* '\''
            ;

         NUM_INT
            : ('0' .. '9') +
            ;

  IDENT
     : ('a' .. 'z' | 'A' .. 'Z') ('a' .. 'z' | 'A' .. 'Z' | '0' .. '9' | '_')*
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
