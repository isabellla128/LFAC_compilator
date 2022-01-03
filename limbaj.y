%{
#include <stdio.h>
extern FILE* yyin;
extern char* yytext;
extern int yylineno;
%}
%token ID TIP BGIN END ASSIGN NR CONST WHILE
%start progr
%left '+'
%left '*'
%%
progr: declaratii bloc {printf("program corect sintactic\n");}
     ;

declaratii :  declaratie ';'
	   | declaratii declaratie ';'
	   ;
declaratie : TIP lista_id
           | TIP ID '(' lista_param ')'
           | TIP ID '(' ')'
           | CONST TIP lista_asignari
           ;

dim : NR
    ;

lista_asignari : ID ASSIGN NR
                | lista_asignari ',' ID ASSIGN NR
                ;

lista_id  : ID 
          | ID '[' dim ']'
          | lista_id ',' ID '[' dim ']'
          | lista_id ',' ID
          ;

lista_param : param
            | lista_param ','  param 
            ;
            
param : TIP ID
      ; 

/* bloc */
bloc : BGIN list END  
     ;
     
/* lista instructiuni */
list : statement ';' 
     | list statement ';'
     ;

/* instructiune */
statement: ID ASSIGN expr 	 
         | ID '(' lista_apel ')'
         | WHILE '(' expr ')' '{' statement '}'
         ;

expr : elem
  | expr '+' expr
  | expr '*' expr
  | '(' expr ')'
  ;
        
lista_apel : expr
           | lista_apel ',' expr
           ;
elem : ID
     | NR
     ;

%%
int yyerror(char * s){
printf("eroare: %s la linia:%d\n",s,yylineno);
}

int main(int argc, char** argv){
yyin=fopen(argv[1],"r");
yyparse();
} 
