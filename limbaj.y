%{
#include <stdio.h>
extern FILE* yyin;
extern char* yytext;
extern int yylineno;
%}
%token ID TIP BGIN END ASSIGN NR CONST WHILE STRUCT FOR IF LW BG LWEQ BGEQ EQ NOTEQ
%start progr
%left '+'
%left '*'
%%
progr: declaratii bloc {printf("program corect sintactic\n");}
     ;

declaratii : declaratie ';'
	       | declaratii declaratie ';'
	       ;

declaratie : TIP lista_id_init
           | TIP ID '(' lista_param ')'
           | TIP ID '(' ')'
           | CONST TIP lista_asignari
           | STRUCT ID '{' continut_struct '}' lista_id
           ;

initializare : ID ASSIGN expr

lista_id_init : variabila
              | initializare
              | lista_id_init ',' variabila
              | lista_id_init ',' initializare
              ;

continut_struct : declaratie_struct ';'
                | continut_struct declaratie_struct ';'
                ;

declaratie_struct   : TIP lista_id_init 
                    | CONST TIP lista_asignari 
                    ;

dim : NR
    ;

lista_asignari  : ID ASSIGN NR
                | lista_asignari ',' ID ASSIGN NR
                ;

variabila  : ID
           | ID '[' dim ']'
           ;

lista_id   : variabila 
           | lista_id ',' variabila
           ;

lista_param : param
            | lista_param ','  param 
            ;
            
param : TIP variabila
      | CONST TIP ID
      ; 

/* bloc */
bloc : BGIN list END  
     ;
     
/* lista instructiuni */
list : statement ';' 
     | list statement ';'
     ;

/* instructiune */
statement : elem ASSIGN expr 
          |	ID '(' lista_apel ')'
          | WHILE '(' expr ')' '{' statement ';' '}'
          | FOR '(' pentru_for ')' '{' statement ';' '}'
          | IF '(' expr ')' '{' statement ';' '}'
         ;

pentru_for : elem ASSIGN expr ';' expr ';' expr
           | elem ASSIGN expr ';' ';' expr
           | elem ASSIGN expr ';' ';'
           | elem ASSIGN expr ';' expr ';'
           | ';' expr ';' expr
           | ';' expr ';'
           | ';' ';' expr
           | ';' ';'
           ;

lista_apel : expr
           | lista_apel ',' expr
           ;

expr : elem
     | NR    
     | expr '+' expr
     | expr '*' expr
     | ID '(' lista_apel ')'
     | '(' expr ')'
     ;
        
elem : ID
          | ID '.' ID
          | ID '[' ID ']'
          | ID '[' NR ']'
          ;




%%
int yyerror(char * s){
printf("eroare: %s la linia:%d\n",s,yylineno);
}

int main(int argc, char** argv){
yyin=fopen(argv[1],"r");
yyparse();
} 
