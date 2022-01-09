%{
#include <stdio.h>
#include "y.tab.h"
%}
%option noyywrap
%%
"int" {yylval.iValue=1; return INT;} //tipul de date
"float" {yylval.iValue=2; return FLOAT;} //tipul de date
"char" {yylval.iValue=3; return CHAR;} //tipul de date
"string" {yylval.iValue=4; return STRING;} //tipul de date
"bool" {yylval.iValue=0; return BOOL;} //tipul de date
"begin_progr" {return BGIN;}                //bgin ce delimiteaza un bloc de instructiuni
"end_progr" {return END;}                   //cuv rez
"begin_global" {return BGIN_GLOBAL;}
"end_global" {return END_GLOBAL;}
"begin_define" {return BGIN_DEFINE;}
"end_define" {return END_DEFINE;}
"struct" {return STRUCT;}
"const" {return CONST;}
"while" {return WHILE;}
"for" {return FOR;}
"if" {return IF;}
"else" {return ELSE;}
"print" {return PRINT;}
[_a-zA-Z][_a-zA-Z0-9]* {yylval.nume = yytext; return ID;} 
"<=" {return LWEQ;}
">=" {return BGEQ;} 
"<" {return LW;}  
">" {return BG;}  
"==" {return EQ;}
"!=" {return NOTEQ;}
"=" {return ASSIGN;}   
[0-9]+[0-9]*\.[0-9]+[0-9]* { yylval.fValue=atof(yytext); return NR_REAL;}
[0-9]+ {yylval.iValue = atoi(yytext); return NR;}
[ \t] ;
\n {yylineno++;}                            
. {return yytext[0];}

 
