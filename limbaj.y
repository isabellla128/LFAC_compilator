%{
#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>
#include <string.h>

extern FILE* yyin;
extern char* yytext;
extern int yylineno;
struct simboluri { char simbol[20];
                   char tip[10];
                   char valoare[10];
                   char status[50];
                 } sym[100];    /*symbol table*/

/*tipuri: 0-bool 1-int 2-float 3-char 4-string CONST: 5,6,7,8,9*/

struct functii { int nr_param;
                 struct simboluri param[100];
                 char nume[20];
                 char tip_functie[10];
               } func[100]; /*function table*/

int n=0, m=0; /*nr simboluri, nr functii*/

char functie_curenta[50]="", struct_curent[50]="", status_curent[50]=""; /*status:global,numele functiei,numele structului*/
int tip_curent=100;

char* itoa(int nr)
{
    char* str;
    int i=0;
    int cnr=nr, p=1, cifre=0; 
    if(nr<0) {str[0]='-'; i++; nr=nr*(-1);}
    while(nr>0){p*=10;nr/=10;cifre++;}
    p/=10;
    while(p>=1) {char c=(nr/p%10)+'0'; str[i]=c; p/=10;}
    return str;
}

char* ftoa(float n)
{
    char buffer[64];
    int ret = snprintf(buffer, sizeof buffer, "%f", n);
    char*p=(char*) buffer;
    return p;
}

void insert_simbol(char simbol[50])
{
    int i;
    for(i=0;i<n;i++)
    {
        if( strcmp(sym[i].simbol,simbol) == 0 ) 
            { 
                printf("Eroare! Simbolul %s a fost deja declarat!\n",sym[i].simbol);
            }
    }

    strcpy(sym[n].simbol, simbol);
}
void insert_tip(int tip)
{
    if(tip==-1) strcpy(sym[n].tip, "STRUCT");
    else
    if(tip == 0) strcpy(sym[n].tip, "BOOL");
    else
    if(tip == 1) strcpy(sym[n].tip, "INT");
    else
    if(tip == 2) strcpy(sym[n].tip, "FLOAT");
    else
    if(tip == 3) strcpy(sym[n].tip, "CHAR");
    else
    if(tip == 4) strcpy(sym[n].tip, "STRING");
    else
    if(tip == 5) strcpy(sym[n].tip, "CONST BOOL");
    else
    if(tip == 6) strcpy(sym[n].tip, "CONST INT");
    else
    if(tip == 7) strcpy(sym[n].tip, "CONST FLOAT");
    else
    if(tip == 8) strcpy(sym[n].tip, "CONST CHAR");
    else
    if(tip == 9) strcpy(sym[n].tip, "CONST STRING"); 
}
void insert_status(char* status)
{
     strcpy(sym[n].status, status);
}

void insert_valoare(char simbol[10], char valoare[10])
{
    int i=getIndiceSimbol(simbol);
    if(i==-1) printf("Nu exista simbolul in tabel.\n");
    else
    strcpy(sym[i].valoare,valoare);
}

void insert_param(char nume[50],char simbol[10], int tip)
{
    int i=getIndiceFunctie(nume);
    int j=func[i].nr_param;
    if(tip==-1) strcpy(func[i].param[j].tip, "STRUCT");
    else
    if(tip == 0) strcpy(func[i].param[j].tip, "BOOL");
    else
    if(tip == 1) strcpy(func[i].param[j].tip, "INT");
    else
    if(tip == 2) strcpy(func[i].param[j].tip, "FLOAT");
    else
    if(tip == 3) strcpy(func[i].param[j].tip, "CHAR");
    else
    if(tip == 4) strcpy(func[i].param[j].tip, "STRING");
    else
    if(tip == 5) strcpy(func[i].param[j].tip, "CONST BOOL");
    else
    if(tip == 6) strcpy(func[i].param[j].tip, "CONST INT");
    else
    if(tip == 7) strcpy(func[i].param[j].tip, "CONST FLOAT");
    else
    if(tip == 8) strcpy(func[i].param[j].tip, "CONST CHAR");
    else
    if(tip == 9) strcpy(func[i].param[j].tip, "CONST STRING");

    strcpy(func[i].param[j].simbol,simbol);
    
    func[i].nr_param++;
}

void insert_functie_tip(int tip) 
{
    if(tip == 0) strcpy(func[m].tip_functie, "BOOL");
    else
    if(tip == 1) strcpy(func[m].tip_functie, "INT");
    else
    if(tip == 2) strcpy(func[m].tip_functie, "FLOAT");
    else
    if(tip == 3) strcpy(func[m].tip_functie, "CHAR");
    else
    if(tip == 4) strcpy(func[m].tip_functie, "STRING");
    else
    if(tip == 5) strcpy(func[m].tip_functie, "CONST BOOL");
    else
    if(tip == 6) strcpy(func[m].tip_functie, "CONST INT");
    else
    if(tip == 7) strcpy(func[m].tip_functie, "CONST FLOAT");
    else
    if(tip == 8) strcpy(func[m].tip_functie, "CONST CHAR");
    else
    if(tip == 9) strcpy(func[m].tip_functie, "CONST STRING");
    
}
void insert_functie_nume(char nume[50])
{
     strcpy(func[m].nume, nume);
}
int getIndiceFunctie(char nume[50])
{
    int i;
    for(i=0;i<m;i++)
        if(strcmp(func[i].nume,nume) == 0) return i;
    return -1;
}

char* getValoare (char* simbol)
{  
    char valoare[100];
    bzero(valoare,100);
    strcpy(valoare,sym[getIndiceSimbol(simbol)].valoare);
    char* val= valoare;
    return val;
}

int getIndiceSimbol (char* simbol)
{
    int i;
    for(i=0;i<n;i++)
        if(strcmp(sym[i].simbol,simbol) == 0) return i;
    return -1;
}

int iconvertValoare(char* valoare)
{
    int val=atoi(valoare);
    return val;
}

float fconvertValoare(char* valoare)
{
    float val=atof(valoare);
    return val;
}

char* iValoareToChar(int val)
{
    char*p=itoa(val);
    return p;
}
char* fValoareToChar(float val)
{
    char*p=ftoa(val);
    return p;
}
char* sValoareToChar(char* val)
{
    return val;
}

void updateSimbolValoare(char* simbol, char* valoare)
{
  strcpy(sym[getIndiceSimbol(simbol)].valoare,valoare);  
}



%}
%union {char* nume; int iValue; float fValue; char* sValue;}
%token DA BGIN END ASSIGN CONST WHILE STRUCT FOR IF LW BG LWEQ BGEQ EQ NOTEQ ELSE BGIN_GLOBAL END_GLOBAL BGIN_DEFINE END_DEFINE 
%token <nume> ID
%token <iValue> NR BOOL INT FLOAT CHAR STRING
%start progr
%left '+'
%left '*'
%%
progr: declaratii_globale declaratii_user bloc {printf("program corect sintactic\n");}
     ;

declaratii_globale : start_global declaratii END_GLOBAL  
                   ;
start_global : BGIN_GLOBAL { strcpy(status_curent,"global"); }
             ;

declaratii_user : BGIN_DEFINE definitii END_DEFINE
                ;

declaratii : declaratie ';'
	       | declaratii declaratie ';'
	       ;

declaratie : tip lista_id_init 
           | const_tip lista_asignari 
           ;

tip : BOOL { $<iValue>$=$1; tip_curent=$<iValue>1; }
    | INT  { $<iValue>$=$1; tip_curent=$<iValue>1; }
    | FLOAT { $<iValue>$=$1; tip_curent=$<iValue>1; }
    | CHAR  { $<iValue>$=$1; tip_curent=$<iValue>1; }
    | STRING { $<iValue>$=$1; tip_curent=$<iValue>1; }
    ;

const_tip : CONST tip { tip_curent=tip_curent+5; }

definitii  : definitie ';'
	       | definitii definitie ';'
	       ;

definitie   : tip nume_functie '(' lista_param ')'{ insert_functie_tip($<iValue>1); m++; }
            | tip nume_functie '(' ')' { insert_functie_tip($<iValue>1); m++; }
            | STRUCT nume_struct '{' continut_struct '}' lista_id_s 
            ;
nume_functie : ID { insert_functie_nume($1); strcpy(functie_curenta,$1); strcpy(status_curent,$1); printf("functia: %s\n",$1); }
             ;
nume_struct : ID { strcpy(struct_curent,$1); strcpy(status_curent,$1); }
            ;

lista_id_s : variabila_s { n++; }
           | lista_id_s ',' variabila_s
           ;

variabila_s    : ID { insert_simbol($1); insert_tip(-1); insert_status(struct_curent); }
               | ID '[' dim ']' { insert_simbol($1); insert_tip(-1); insert_status(struct_curent); }
               ;

initializare : ID ASSIGN expr { insert_simbol($1); insert_tip(tip_curent); insert_status(status_curent); /*insert_valoare($1,iValoareToChar($<iValue>3));*/} 
/*pot initializa doar cu expresii, si avand in vedere ca facem arbori pt expresii, pot fi doar int*/


lista_id_init     : variabila { n++; }
                  | initializare { n++; }
                  | lista_id_init ',' variabila { n++; }
                  | lista_id_init ',' initializare { n++; }
                  ;

continut_struct : declaratie_struct ';'
                | continut_struct declaratie_struct ';'
                ;

declaratie_struct : tip lista_id_init 
                  | const_tip lista_asignari 
                  ;

dim : NR
    ;

lista_asignari    : initializare { n++; }
                  | lista_asignari ',' initializare { n++; }
                  ;


variabila      : ID { insert_simbol($1); insert_tip(tip_curent); insert_status(status_curent); printf("%s# %d %s\n",$1,tip_curent,status_curent);}
               | ID '[' dim ']' { insert_simbol($1); insert_tip(tip_curent); insert_status(status_curent); }
               ;

variabila_f      : ID {insert_param(functie_curenta,$1,tip_curent);}
                 | ID '[' dim ']' {insert_param(functie_curenta,$1,tip_curent);}
                 ;

lista_param : param
            | lista_param ','  param 
            ;
            
param   : tip variabila_f 
        | const_tip variabila_f 
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

expr : elem_NR { $<iValue>$=$<iValue>1; }  
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
        | NR {$<iValue>$=$1;}
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

int main(int argc, char** argv)
{
int i;
for(i=0;i<100;i++) func[i].nr_param=0;

yyin=fopen(argv[1],"r");
yyparse();

printf("SIMBOL | TIP | VALOARE | STATUS\n");

for(i=0;i<n;i++)
{
    printf("%s | %s | %s | %s\n",sym[i].simbol,sym[i].tip,sym[i].valoare,sym[i].status);
}
printf("FUNCTII:\n");
printf("TIP | NUME | NR_PARAM | PARAMETRI\n");
for(i=0;i<m;i++)
{
    printf("%s | %s | %d | ",func[i].tip_functie, func[i].nume, func[i].nr_param);
    if(func[i].nr_param==0) printf("-\n");
    else
    {
        int j;
        for(j=0;j<func[i].nr_param;j++)
        {
            printf("%s ",func[i].param[j].simbol);
        }
        printf("\n");
    }
}
printf("%d %d\n",n,m);
} 


