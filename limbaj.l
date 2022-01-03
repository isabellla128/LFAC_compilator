
%{
#include <stdio.h>
#include "y.tab.h"
%}
%option noyywrap
%%
"int"|"float"|"char"|"string"|"bool" {return TIP;} //tipul de date
"begin_progr" {return BGIN;}                //bgin ce delimiteaza un bloc de instructiuni
"end_progr" {return END;}                   //cuv rez
"struct" {return STRUCT;}
"const" {return CONST;}
"while" {return WHILE;}
"for" {return FOR;}
"if" {return IF;}
[_a-zA-Z][_a-zA-Z0-9]* {return ID;}        //iduri ce incep cu @, al 2 lea e _ sau litera si restul litere+cifre
"=" {return ASSIGN;}  
[0-9]+ {return NR;}
[ \t] ;
\n {yylineno++;}                            
. {return yytext[0];}

 
