%{
#include <stdio.h>
extern FILE* yyin;
extern char* yytext;
extern int yylineno;
%}
%token ID TIP BGIN END ASSIGN NR CONST WHILE STRUCT FOR IF LW BG LWEQ BGEQ EQ NOTEQ ELSE BGIN_GLOBAL END_GLOBAL BGIN_DEFINE END_DEFINE
%start progr
%left '+'
%left '*'
%%
progr: declaratii_globale declaratii_user bloc {printf("program corect sintactic\n");}
     ;

declaratii_globale : BGIN_GLOBAL declaratii END_GLOBAL  
                   ;

declaratii_user : BGIN_DEFINE definitii END_DEFINE
                ;

declaratii : declaratie ';'
	       | declaratii declaratie ';'
	       ;

definitii  : definitie ';'
	       | definitii definitie ';'
	       ;

declaratie : TIP lista_id_init
           | CONST TIP lista_asignari
           ;

definitie  : TIP ID '(' lista_param ')'
           | TIP ID '(' ')'
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
     | control_statement
     | list control_statement
     ;

/* instructiune */
statement : elem ASSIGN expr 
          |	ID '(' lista_apel ')'
          ;

control_statement : WHILE '(' expr_bool ')' '{' statement ';' '}'
                  | FOR '(' pentru_for ')' '{' statement ';' '}'
                  | IF '(' expr_bool ')' '{' statement ';' '}'
                  ;

pentru_for : elem ASSIGN expr ';' expr_bool ';' expr
           | elem ASSIGN expr ';' ';' expr
           | elem ASSIGN expr ';' ';'
           | elem ASSIGN expr ';' expr_bool ';'
           | ';' expr_bool ';' expr
           | ';' expr_bool ';'
           | ';' ';' expr
           | ';' ';'
           ;

lista_apel : expr
           | lista_apel ',' expr
           ;

expr : elem_NR   
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

elem_NR : elem
        | NR
        ;

expr_bool : elem_NR LW elem_NR
          | elem_NR BG elem_NR
          | elem_NR LWEQ elem_NR
          | elem_NR BGEQ elem_NR
          | elem_NR EQ elem_NR
          | elem_NR NOTEQ elem_NR
          ;



%%
int yyerror(char * s){
printf("eroare: %s la linia:%d\n",s,yylineno);
}

int main(int argc, char** argv){
yyin=fopen(argv[1],"r");
yyparse();
} 
