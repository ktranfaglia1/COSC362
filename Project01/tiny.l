/* I pledge my Honor that I have not cheated, and will not cheat, on this assignment. 
 * Author: Kyle Tranfaglia
 * Tile: COSC362 - Project01
 * Last Updated: 03/03/25
 * Description: This lexical analyzer program is designed to tokenize source code written in the TINY language. It scans the input
 * file, identifies keywords, identifiers, numbers, operators, and symbols, and generates tokens for further processing by a parser.
*/
%option yylineno
%option noyywrap

%{
  #define DEBUG 1
  typedef int Token;
  Token scanned(Token t);
%}

/* Regular expressions */
digit   [0-9]
letter  [a-zA-Z]
id      {letter}({letter}|{digit}|_)*
num     {digit}+
wspace  [ \t\r]+
newline [\n]

/* Match keywords, identifiers, numbers, operators, and punctuation */

%%

"if"        {return scanned(IF);}
"then"      {return scanned(THEN);}
"else"      {return scanned(ELSE);}
"end"       {return scanned(END);}
"repeat"    {return scanned(REPEAT);}
"until"     {return scanned(UNTIL);}
"read"      {return scanned(READ);}
"write"     {return scanned(WRITE);}

{num}       {return scanned(NUM);}
{id}        {return scanned(ID);}

":="       {return scanned(ASSIGN);}
"="        {return scanned(EQ);}
"<"        {return scanned(LT);}
"+"        {return scanned(PLUS);}
"-"        {return scanned(MINUS);}
"*"        {return scanned(TIMES);}
"/"        {return scanned(OVER);}
"("        {return scanned(LPAREN);}
")"        {return scanned(RPAREN);}
";"        {return scanned(SEMI);}

"{"[^}]*"}"   { /* Skip comments */ }

{wspace}    { /* skip whitespace */ }
{newline}   { printf("\n"); }
<<EOF>>     {return scanned(ENDFILE);}
.           {
              printf("Lexical error on line %d: Illegal character %s\n", yylineno, yytext);
              return scanned(ERROR);
            }

%%

/* process and return scanned tokens */
Token scanned(Token t) {
  if(DEBUG) {
    switch(t) {
      case IF: printf("IF "); break;
      case THEN: printf("THEN "); break;
      case ELSE: printf("ELSE "); break;
      case END: printf("END "); break;
      case REPEAT: printf("REPEAT "); break;
      case UNTIL: printf("UNTIL "); break;
      case READ: printf("READ "); break;
      case WRITE: printf("WRITE "); break;
      case ID: printf("ID(%s) ", yytext); break;
      case NUM: printf("NUM(%s) ", yytext); break;
      case ASSIGN: printf("ASSIGN "); break;
      case EQ: printf("EQ "); break;
      case LT: printf("LT "); break;
      case PLUS: printf("PLUS "); break;
      case MINUS: printf("MINUS "); break;
      case TIMES: printf("TIMES "); break;
      case OVER: printf("OVER "); break;
      case LPAREN: printf("LPAREN "); break;
      case RPAREN: printf("RPAREN "); break;
      case SEMI: printf("SEMI "); break;
      case ENDFILE: printf("ENDFILE\n"); break;
      case ERROR: printf("ERROR "); break;
      default: printf("ERROR: invalid token in scanned().\n"); exit(-1);
    }
  }
  return t;
}
