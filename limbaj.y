%{
#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>
#include <string.h>

extern FILE* yyin;
extern char* yytext;
extern int yylineno;
struct simboluri { char simbol[100];
                   char tip[100];
                   char sValue[100];
                   char status[100];
                   int iValue; float fValue; 
                 } sym[100];    /*symbol table*/

/*tipuri: 0-bool 1-int 2-float 3-char 4-string CONST: 5,6,7,8,9*/

struct functii { int nr_param;
                 struct simboluri param[100];
                 char nume[100];
                 char tip_functie[100];
               } func[100]; /*function table*/

struct structuri { int nr; /*nr campuri*/
                   struct simboluri campuri[100];
                   char nume[100];
                 } str[100];

int n=0, m=0, o=0; /*nr simboluri, nr functii, nr structuri*/

char functie_curenta[50]="", struct_curent[50]="", status_curent[50]=""; /*status:global,numele functiei,numele structului*/
int tip_curent=100;

void insert_struct(char nume[50])
{
   strcpy(str[o].nume,nume);
}

void insert_campuri(char simbol[50], int tip)
{   
    int i=o;
    int j=str[i].nr;
    if(tip==-1) strcpy(str[i].campuri[j].tip, "STRUCT");
    else
    if(tip == 0) strcpy(str[i].campuri[j].tip, "BOOL");
    else
    if(tip == 1) strcpy(str[i].campuri[j].tip, "INT");
    else
    if(tip == 2) strcpy(str[i].campuri[j].tip, "FLOAT");
    else
    if(tip == 3) strcpy(str[i].campuri[j].tip, "CHAR");
    else
    if(tip == 4) strcpy(str[i].campuri[j].tip, "STRING");
    else
    if(tip == 5) strcpy(str[i].campuri[j].tip, "CONST BOOL");
    else
    if(tip == 6) strcpy(str[i].campuri[j].tip, "CONST INT");
    else
    if(tip == 7) strcpy(str[i].campuri[j].tip, "CONST FLOAT");
    else
    if(tip == 8) strcpy(str[i].campuri[j].tip, "CONST CHAR");
    else
    if(tip == 9) strcpy(str[i].campuri[j].tip, "CONST STRING");

    strcpy(str[i].campuri[j].simbol,simbol);
    
    str[i].nr++;   
}

void insert_campuri_iValue(char simbol[50],int val)
{
    int pozitie_simbol=str[o].nr-1;
    str[o].campuri[pozitie_simbol].iValue=val;
}
void insert_campuri_fValue(char simbol[50],float val)
{
    int pozitie_simbol=str[o].nr-1;
    str[o].campuri[pozitie_simbol].fValue=val;
}
void insert_campuri_sValue(char simbol[50],char val[100])
{
    int pozitie_simbol=str[o].nr-1;
    strcpy(str[o].campuri[pozitie_simbol].sValue,val);
}

void insert_simbol(char simbol[50])
{
    int i;
    for(i=0;i<n;i++)
    {
        if( strcmp(sym[i].simbol,simbol) == 0 ) 
            {
                if(strcmp(status_curent,sym[i].status) == 0) 
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

void insert_iValue(char simbol[10], int valoare)
{
    int i=getIndiceSimbol(simbol);
    if(i==-1) printf("Nu exista simbolul %s in tabel.\n",simbol);
    else
    sym[i].iValue=valoare;
}
void insert_fValue(char simbol[10], float valoare)
{
    int i=getIndiceSimbol(simbol);
    if(i==-1) printf("Nu exista simbolul %s in tabel.\n",simbol);
    else
    sym[i].fValue=valoare;
}
void insert_sValue(char simbol[10], char valoare[100])
{
    int i=getIndiceSimbol(simbol);
    if(i==-1) printf("Nu exista simbolul %s in tabel.\n",simbol);
    else
    {
        if(strcmp(sym[i].tip,"CHAR")==0 || strcmp(sym[i].tip,"CONST CHAR")==0)
            {
                if(strlen(valoare) != 1) printf("Eroare! Char trebuie sa aiba un singur caracter!\n");
            }
        strcpy(sym[i].sValue,valoare);
    }
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
    for(i=0;i<=m;i++)
        if(strcmp(func[i].nume,nume) == 0) return i;
    return -1;
}

int getIndiceSimbol (char* simbol)
{
    int i;
    for(i=0;i<=n;i++)
        if(strcmp(sym[i].simbol,simbol) == 0) return i;
    return -1;
}


void elimin_tot_dupa_var(char s[100])
{
    int i=0;
    while(i<strlen(s)&&((s[i]>='a'&&s[i]<='z')||(s[i]>='A'&&s[i]<='Z')||s[i]=='_'))
    {
        i++;    
    }
    s[i]='\0';
}
void insert_variabila_struct(char aux[50])
{   
    char p[50];
    int i;
    for(i=0;i<str[o].nr;i++)
    {    
        strcpy(p,aux);
        strcat(p,".");
        strcat(p,str[o].campuri[i].simbol);
        insert_simbol(p);
        strcpy(sym[n].tip,str[o].campuri[i].tip);
        if(strcmp(str[o].campuri[i].tip,"BOOL")==0 || strcmp(str[o].campuri[i].tip,"CONST BOOL")==0)
            insert_iValue(p,str[o].campuri[i].iValue);
        else
        if(strcmp(str[o].campuri[i].tip,"INT")==0 || strcmp(str[o].campuri[i].tip,"CONST INT")==0)
            insert_iValue(p,str[o].campuri[i].iValue);
        else
        if(strcmp(str[o].campuri[i].tip,"FLOAT")==0 || strcmp(str[o].campuri[i].tip,"CONST FLOAT")==0)
            insert_fValue(p,str[o].campuri[i].fValue);
        else
        if(strcmp(str[o].campuri[i].tip,"CHAR")==0 || strcmp(str[o].campuri[i].tip,"CONST CHAR")==0)
            insert_sValue(p,str[o].campuri[i].sValue);
        else
        if(strcmp(str[o].campuri[i].tip,"STRING")==0 || strcmp(str[o].campuri[i].tip,"CONST STRING")==0)
            insert_sValue(p,str[o].campuri[i].sValue);

        insert_status(status_curent);
        strcpy(p,"");
        n++;
    }
}

%}
%union {char* nume; int iValue; float fValue; char* sValue;}
%token BGIN END ASSIGN CONST WHILE STRUCT FOR IF LW BG LWEQ BGEQ EQ NOTEQ ELSE BGIN_GLOBAL END_GLOBAL BGIN_DEFINE END_DEFINE
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

const_tip : CONST tip { tip_curent=tip_curent+5; $<iValue>$=tip_curent;}

definitii  : definitie 
	       | definitii definitie 
	       ;

definitie   : tip nume_functie '(' lista_param ')' ';'{ insert_functie_tip($<iValue>1); m++; }
            | tip nume_functie '(' ')' ';'{ insert_functie_tip($<iValue>1); m++; }
            | const_tip nume_functie '(' lista_param ')'';'{ insert_functie_tip($<iValue>1); m++; }
            | const_tip nume_functie '(' ')' ';'{ insert_functie_tip($<iValue>1); m++; }
            | STRUCT nume_struct '{' continut_struct '}' lista_id_s ';'{ o++; }
            | tip nume_functie '(' lista_param ')' '{' declaratii list '}'{ insert_functie_tip($<iValue>1); m++; }
            | tip nume_functie '(' ')' '{' declaratii list '}'{ insert_functie_tip($<iValue>1); m++; }
            | const_tip nume_functie '(' lista_param ')''{' declaratii list '}'{ insert_functie_tip($<iValue>1); m++; }
            | const_tip nume_functie '(' ')' '{' declaratii list '}'{ insert_functie_tip($<iValue>1); m++; }            
            ;

nume_functie : ID { insert_functie_nume($1); strcpy(functie_curenta,$1); strcpy(status_curent,$1); }
             ;
nume_struct : ID { strcpy(struct_curent,$1); strcpy(status_curent,$1); insert_struct($1); }
            ;

lista_id_s : variabila_s 
           | lista_id_s ',' variabila_s 
           ;

variabila_s    : ID { elimin_tot_dupa_var($1); insert_variabila_struct($1); }
               | ID '[' dim ']' { elimin_tot_dupa_var($1); insert_variabila_struct($1); }
               ;

continut_struct : declaratie_struct ';'
                | continut_struct declaratie_struct ';'
                ;

declaratie_struct : tip lista_id_init_s 
                  | const_tip lista_asignari_s 
                  ;
lista_id_init_s   : variabila_struct 
                  | initializare_struct 
                  | lista_id_init_s ',' variabila_struct 
                  | lista_id_init_s ',' initializare_struct 
                  ;
variabila_struct    : ID { elimin_tot_dupa_var($1); insert_campuri($1,tip_curent);}
                    | ID '[' dim ']' { elimin_tot_dupa_var($1); insert_campuri($1,tip_curent); }
                    ;
lista_asignari_s    : initializare_struct
                    | lista_asignari ',' initializare_struct 
                    ;
initializare_struct : ID ASSIGN expr { elimin_tot_dupa_var($1); insert_campuri($1,tip_curent); insert_campuri_iValue($1,$<iValue>3);} 
                    | ID ASSIGN sir { elimin_tot_dupa_var($1); insert_campuri($1,tip_curent); insert_campuri_sValue($1,$<nume>3); }
                    ;


lista_id_init     : variabila { n++; }
                  | initializare { n++; }
                  | lista_id_init ',' variabila { n++; }
                  | lista_id_init ',' initializare { n++; }
                  ;

variabila      : ID { elimin_tot_dupa_var($1); insert_simbol($1); insert_tip(tip_curent); insert_status(status_curent);}
               | ID '[' dim ']' { elimin_tot_dupa_var($1); insert_simbol($1); insert_tip(tip_curent); insert_status(status_curent); }
               ;

initializare : ID ASSIGN expr { elimin_tot_dupa_var($1); insert_simbol($1); insert_tip(tip_curent); insert_status(status_curent); insert_iValue($1,$<iValue>3);} 
             | ID ASSIGN sir { elimin_tot_dupa_var($1); insert_simbol($1); insert_tip(tip_curent); insert_status(status_curent); insert_sValue($1,$<nume>3); }
             ;
/*pot initializa doar cu expresii, si avand in vedere ca facem arbori pt expresii, pot fi doar int*/


dim : NR
    ;
sir : '*' ID '*' { elimin_tot_dupa_var($2); $<nume>$=$2;}
    ;

lista_asignari    : initializare { n++; }
                  | lista_asignari ',' initializare { n++; }
                  ;

lista_param : param
            | lista_param ','  param 
            ;
            
param   : tip variabila_f 
        | const_tip variabila_f 
        ; 


variabila_f      : ID {elimin_tot_dupa_var($1); insert_param(functie_curenta,$1,tip_curent);}
                 | ID '[' dim ']' {elimin_tot_dupa_var($1); insert_param(functie_curenta,$1,tip_curent);}
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
for(i=0;i<100;i++) {func[i].nr_param=0; str[i].nr=0;}

yyin=fopen(argv[1],"r");
yyparse();

printf("SIMBOL | TIP | VALOARE | STATUS\n");

for(i=0;i<n;i++)
{
    printf("%s | %s | ",sym[i].simbol,sym[i].tip);
    if(strcmp(sym[i].tip,"BOOL")==0 || strcmp(sym[i].tip,"CONST BOOL")==0 ) printf("%d | ",sym[i].iValue);
    else
    if(strcmp(sym[i].tip,"INT")==0 || strcmp(sym[i].tip,"CONST INT")==0 ) printf("%d | ",sym[i].iValue);
    else
    if(strcmp(sym[i].tip,"FLOAT")==0 || strcmp(sym[i].tip,"CONST FLOAT")==0 ) printf("%f | ",sym[i].fValue);
    else
    if(strcmp(sym[i].tip,"CHAR")==0 || strcmp(sym[i].tip,"CONST CHAR")==0 ) printf("%s | ",sym[i].sValue);
    else
    if(strcmp(sym[i].tip,"STRING")==0 || strcmp(sym[i].tip,"CONST STRING")==0 ) printf("%s | ",sym[i].sValue);
    printf("%s\n",sym[i].status);
}

printf("FUNCTII:\n");
printf("TIP | NUME | NR_PARAM | TIP_PARAMETRU PARAMETRU\n");
for(i=0;i<m;i++)
{
    printf("%s | %s | %d | ",func[i].tip_functie, func[i].nume, func[i].nr_param);
    if(func[i].nr_param==0) printf("-\n");
    else
    {
        int j;
        for(j=0;j<func[i].nr_param;j++)
        {
            printf("%s %s ",func[i].param[j].tip,func[i].param[j].simbol);
        }
        printf("\n");
    }
}
printf("%d %d\n",n,m);
} 
