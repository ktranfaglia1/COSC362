%{
#include <stdio.h>
#include "tiny.tab.h"
#define DEBUG 1
%}

/* Instruct flex not to require a yywrap function */
%option noyywrap
%option yylineno

/* Define a start condition for comment handling */
%x COMMENT

/* Definitions for character classes */
DIGIT    [0-9]
LETTER   [a-zA-Z]

%%
/* Ignore whitespace except newlines */
[ \t\r]+                ;

/* Print a newline if one is encountered. */
\n                      { yylineno++; printf("\n"); }

/* Begin a comment: switch to the COMMENT state */
"{"                   { BEGIN(COMMENT); }

/* COMMENT state rules */
<COMMENT>[^}\n]+      { /* Consume comment characters (except newline and } ) */ }
<COMMENT>\n          { yylineno++; }
<COMMENT>"}"         { BEGIN(INITIAL); }
<COMMENT><<EOF>>     { fprintf(stderr, "Error: Unterminated comment at line %d\n", yylineno); exit(1); }

/* Reserved words */
"if"                    { printf("IF "); return IF; }
"then"                  { printf("THEN "); return THEN; }
"else"                  { printf("ELSE "); return ELSE; }
"end"                   { printf("END "); return END; }
"repeat"                { printf("REPEAT "); return REPEAT; }
"until"                 { printf("UNTIL "); return UNTIL; }
"read"                  { printf("READ "); return READ; }
"write"                 { printf("WRITE "); return WRITE; }

/* Operators and punctuation */
":="                    { printf("ASSIGN "); return ASSIGN; }
"<"                     { printf("LT "); return LT; }
"="                     { printf("EQ "); return EQ; }
"+"                     { printf("PLUS "); return PLUS; }
"-"                     { printf("MINUS "); return MINUS; }
"*"                     { printf("TIMES "); return TIMES; }
"/"                     { printf("OVER "); return OVER; }
";"                     { printf("SEMI "); return SEMI; }

/* Number literals */
{DIGIT}+               { printf("NUM(%s) ", yytext); return NUM; }

/* Identifier: starts with a letter followed by letters or digits */
{LETTER}({LETTER}|{DIGIT})*  { printf("ID(%s) ", yytext); return ID; }

/* Catch-all for any unexpected character */
.                       { printf("Unknown character: %s\n", yytext); }
%%

/* Main program: opens the file and calls yylex() */
int main(int argc, char **argv) {
    if (argc > 1) {
        FILE *file = fopen(argv[1], "r");
        if (!file) {
            perror(argv[1]);
            return 1;
        }
        yyin = file;
    }
    yylex();
    printf("ENDOFFILE");
    return 0;
}