%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

extern FILE* yyin;
extern char* yytext;
extern int yylineno;

struct AST
{
    char symb[100];
    int nr;
    char type[100];
    struct AST* left;
    struct AST* right;
};

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

struct parametrii
{
    char tip[100];
}verif[100];
int nr_s=0;
int n=0, m=0, o=0; /*nr simboluri, nr functii, nr structuri*/
int err=0;
char functie_curenta[50]="", struct_curent[50]="", status_curent[50]=""; /*status:global,numele functiei,numele structului*/
int tip_curent=100;
int ifuri=1, whileuri=1, foruri=1;

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
                {
                    char eroare[200];
                    sprintf(eroare, "simbolul %s a fost deja declarat, iar eroarea este",sym[i].simbol);
                    yyerror(eroare);
                    exit(1);
                }
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
    if(i==-1 && strcmp(simbol,"VECT")!=0)
    {
        char eroare[200];
        sprintf(eroare, "nu exista simbolul %s in tabel, iar eroarea este",simbol);
        yyerror(eroare);
        exit(1);
    }
    else
    sym[i].iValue=valoare;
}
void insert_fValue(char simbol[10], float valoare)
{
    int i=getIndiceSimbol(simbol);
    if(i==-1 && strcmp(simbol,"VECT")!=0)
    {
        char eroare[200];
        sprintf(eroare, "nu exista simbolul %s in tabel, iar eroarea este",simbol);
        yyerror(eroare);
        exit(1);
    }
    else
    sym[i].fValue=valoare;
}
void insert_sValue(char simbol[10], char valoare[100])
{
    int i=getIndiceSimbol(simbol);
    if(i==-1  && strcmp(simbol,"VECT")!=0)
    {
        char eroare[200];
        sprintf(eroare, "nu exista simbolul %s in tabel, iar eroarea este",simbol);
        yyerror(eroare);
        exit(1);
    }
    else
    {
        if(strcmp(sym[i].tip,"CHAR")==0 || strcmp(sym[i].tip,"CONST CHAR")==0)
        {
                if(strlen(valoare) != 1 && strcmp(simbol,"VECT")!=0)
                {
                    char eroare[200];
                    sprintf(eroare, "nu exista simbolul %s in tabel, iar eroarea este",simbol);
                    yyerror(eroare);
                    exit(1);
                }
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
char* convert_tip(int tip)
{
    char* tip_char;
    if(tip == 0) strcpy(tip_char, "BOOL");
    else
    if(tip == 1) strcpy(tip_char, "INT");
    else
    if(tip == 2) strcpy(tip_char, "FLOAT");
    else
    if(tip == 3) strcpy(tip_char, "CHAR");
    else
    if(tip == 4) strcpy(tip_char, "STRING");
    else
    if(tip == 5) strcpy(tip_char, "CONST BOOL");
    else
    if(tip == 6) strcpy(tip_char, "CONST INT");
    else
    if(tip == 7) strcpy(tip_char, "CONST FLOAT");
    else
    if(tip == 8) strcpy(tip_char, "CONST CHAR");
    else
    if(tip == 9) strcpy(tip_char, "CONST STRING");

    return tip_char;
}

void insert_functie_nume(char nume[50])
{
     int i;
     for(i=0;i<=m;i++)
    {
        if(strcmp(nume,func[i].nume)==0 && strcmp(convert_tip(tip_curent),func[i].tip_functie)==0)
        {
            char eroare[200];
            sprintf(eroare, "exista deja o functie cu numele %s si tipul %s, iar eroarea este",nume,func[i].tip_functie);
            yyerror(eroare);
            exit(1); 
        }
    }
     strcpy(func[m].nume, nume);
}

int getIndiceFunctie(char nume[50])
{
    int i;
    for(i=m;i>=0;i--)
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
    while(i<strlen(s)&&((s[i]>='a'&&s[i]<='z')||(s[i]>='A'&&s[i]<='Z')||s[i]=='_')||(s[i]>='0'&&s[i]<='9'))
    {
        i++;    
    }
    s[i]='\0';
}
void elimin_tot_dupa_ghilimele(char s[100])
{
    int i=0;
    while(i<strlen(s)&&s[i]!='"')
    {
        i++;    
    }
    s[i]='\0';
}

void elimin_tot_dupa_struct(char s[100])
{
    int i=0;
    while(i<strlen(s)&&((s[i]>='a'&&s[i]<='z')||(s[i]>='A'&&s[i]<='Z')||s[i]=='_')||(s[i]>='0'&&s[i]<='9')||(s[i]=='.'))
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

struct AST* buildAST(char root[100], struct AST* left, struct AST* right, char type[100])
{
    struct AST* r=malloc(sizeof(struct AST));
    r->left=left;
    r->right=right;
    strcpy(r->symb, root);
    strcpy(r->type, type);
    return r;
}
struct AST* buildASTt(int x, struct AST* left, struct AST* right, char type[100])
{
    struct AST* r=malloc(sizeof(struct AST));
    r->left=left;
    r->right=right;
    r->nr=x;
    strcpy(r->type, type);
    return r;
}
int evalAST(struct AST* root)
{
    if(root==NULL)
        return 0;
    if(root->left==NULL&&root->right==NULL)
    {
        if(strcmp(root->type, "NUMBER")==0)
            return root->nr;
        else
            if(strcmp(root->symb,"VECTOR")==0 ) return 0;
            else
            if(strcmp(root->type, "IDENTIFIER")==0)
            {
                int pozitie=getIndiceSimbol(root->symb);
                return sym[pozitie].iValue;   //valoarea luata din tabel
            }
            else
                return 0;
    }
    if(strcmp(root->symb, "+")==0)
        return evalAST(root->left)+evalAST(root->right);
    else
        if(strcmp(root->symb, "-")==0)
            return evalAST(root->left)-evalAST(root->right);
        else
            if(strcmp(root->symb, "*")==0)
                return evalAST(root->left)*evalAST(root->right);
            else
                if(strcmp(root->symb, "/")==0)
                    return evalAST(root->left)/evalAST(root->right);
}
void combina(char s[100], char t[100])
{
    char aux[100];
    strcpy(aux, s);
    strcat(aux, ".");
    strcat(aux, t);
    strcpy(s, aux);
}

void caut_functia_in_tabel(char s[100])
{
    
    int gasit=0;
    for(int i=0;i<m;i++)
    {
        if(strcmp(s, func[i].nume)==0)
            gasit=1;
    }
    if(gasit==0)
    {
        char eroare[200];
        sprintf(eroare, "functia %s nu este definita, iar eroarea este",s);
        yyerror(eroare);
        exit(1);
    }
}
char* getTip(char s[100])
{
    int i=getIndiceSimbol(s);
    return sym[i].tip;
}
void verif_stanga_dreapta(char nume[100], char tip[100])
{
    if(strcmp(getTip(nume),tip)!=0)
    {
        char eroare[200];
        sprintf(eroare, "variabila %s este de tip %s, iar eroarea este",nume,getTip(nume));
        yyerror(eroare);
        exit(1);
    }
}
void verif_stanga_dreapta_init(char nume[100], char tip[100])
{
    char const_tip[100]="";
    strcpy(const_tip,"CONST ");
    strcat(const_tip,tip);
    
    if(strcmp(getTip(nume),tip)!=0 && strcmp(getTip(nume),const_tip)!=0)
    {
        char eroare[200];
        sprintf(eroare, "variabila %s este de tip %s, iar eroarea este",nume,getTip(nume));
        yyerror(eroare);
        exit(1);
    }
}
char* getTipFunctie(char s[100])
{
    int i=getIndiceFunctie(s);
    return func[i].tip_functie;
}

void verif_param(char s[100])
{
    int i=getIndiceFunctie(s);
    for(int j=0;j<func[i].nr_param;j++)
    {
        if(strcmp(func[i].param[j].tip, verif[j].tip)!=0)
        {
            char eroare[200];
            sprintf(eroare, "parametrii apelati nu au acelasi tip cu parametrii functiei %s, iar eroarea este",s);
            yyerror(eroare);
            exit(1);
        }
    }
    
}

void caut_variabila_in_tabel(char s[100])
{
    int i=getIndiceSimbol(s);
    if(i==-1 && strcmp(s,"VECT")!=0)
    {
        char eroare[200];
        sprintf(eroare, "nu exista simbolul %s in tabel, iar eroarea este",s);
        yyerror(eroare);
        exit(1);
    }
}

int getiValue (char s[100])
{
    int i=getIndiceSimbol(s);
    if(i==-1 && strcmp(s,"VECT")!=0)
    {
        char eroare[200];
        sprintf(eroare, "nu exista simbolul %s in tabel, iar eroarea este",s);
        yyerror(eroare);
        exit(1);
    }
    return sym[i].iValue;
}
float getfValue (char s[100])
{
    int i=getIndiceSimbol(s);
    if(i==-1 && strcmp(s,"VECT")!=0)
    {
        char eroare[200];
        sprintf(eroare, "nu exista simbolul %s in tabel, iar eroarea este",s);
        yyerror(eroare);
        exit(1);
    }
    return sym[i].fValue;
}
char* getsValue (char s[100])
{
    int i=getIndiceSimbol(s);
    if(i==-1 && strcmp(s,"VECT")!=0)
    {
        char eroare[200];
        sprintf(eroare, "nu exista simbolul %s in tabel, iar eroarea este",s);
        yyerror(eroare);
        exit(1);
    }
    return sym[i].sValue;
}
void eroare_const(char s[100])
{
    char eroare[200];
    sprintf(eroare, "variabila %s are tipul constant, iar eroarea este",s);
    yyerror(eroare);
    exit(1);
}
void eroare_bool(char s[100])
{
    char eroare[200];
    sprintf(eroare, "variabila %s are tipul bool, iar eroarea este",s);
    yyerror(eroare);
    exit(1);
} 

%}
%union {char* nume; int iValue; float fValue; char* sValue; struct AST * node; }
%token BGIN END ASSIGN CONST WHILE STRUCT FOR IF LW BG LWEQ BGEQ EQ NOTEQ ELSE BGIN_GLOBAL END_GLOBAL BGIN_DEFINE END_DEFINE PRINT 
%token <nume> ID
%token <fValue> NR_REAL
%token <iValue> NR BOOL INT FLOAT CHAR STRING
%start progr
%left '+' '-'
%left '*' '/'
%left OR 
%left AND
%left NOT
%left LW BG LWEQ BGEQ EQ NOTEQ
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

definitie   : tip nume_functie '(' lista_param ')' ';'{ m++; }
            | tip nume_functie '(' ')' ';'{ insert_functie_tip($<iValue>1); m++; }
            | const_tip nume_functie '(' lista_param ')'';'{ insert_functie_tip($<iValue>1); m++; }
            | const_tip nume_functie '(' ')' ';'{ insert_functie_tip($<iValue>1); m++; }
            | STRUCT nume_struct '{' continut_struct '}' lista_id_s ';'{ o++; }
            | tip nume_functie '(' lista_param ')' '{' declaratii list '}'{ insert_functie_tip($<iValue>1); m++; }
            | tip nume_functie '(' ')' '{' declaratii list '}'{ insert_functie_tip($<iValue>1); m++; }
            | const_tip nume_functie '(' lista_param ')''{' declaratii list '}'{ insert_functie_tip($<iValue>1); m++; }
            | const_tip nume_functie '(' ')' '{' declaratii list '}'{ insert_functie_tip($<iValue>1); m++; }            
            ;

nume_functie : ID { insert_functie_nume($1); insert_functie_tip(tip_curent); strcpy(functie_curenta,$1); strcpy(status_curent,$1); }
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
initializare_struct : ID ASSIGN expr { elimin_tot_dupa_var($1); insert_campuri($1,tip_curent);  insert_campuri_iValue($1,evalAST($<node>3));} 
                    | ID ASSIGN sir { elimin_tot_dupa_var($1); insert_campuri($1,tip_curent); insert_campuri_sValue($1,$<nume>3); }
                    | ID ASSIGN real { elimin_tot_dupa_var($1); insert_campuri($1, tip_curent); insert_campuri_fValue($1,$<fValue>3); }
                    ;


lista_id_init     : variabila { n++; }
                  | initializare { n++; }
                  | lista_id_init ',' variabila { n++; }
                  | lista_id_init ',' initializare { n++; }
                  ;

variabila      : ID { elimin_tot_dupa_var($1); insert_simbol($1); insert_tip(tip_curent); insert_status(status_curent);}
               | ID '[' dim ']' { elimin_tot_dupa_var($1); insert_simbol($1); insert_tip(tip_curent); insert_status(status_curent); }
               ;

initializare : ID ASSIGN ID { elimin_tot_dupa_var($1); insert_simbol($1); insert_tip(tip_curent); insert_status(status_curent); verif_stanga_dreapta_init($<nume>1, getTip($3)); 
if(strcmp(getTip($1),"CONST INT")==0 || strcmp(getTip($1),"INT")==0 || strcmp(getTip($1),"CONST BOOL")==0 || strcmp(getTip($1),"BOOL")==0 ) insert_iValue($1,getiValue($3)); 
else if(strcmp(getTip($1),"CONST FLOAT")==0 || strcmp(getTip($1),"FLOAT")==0 ) insert_fValue($1,getfValue($3)); 
else insert_sValue($1,getsValue($3));} 
             | ID ASSIGN NR { elimin_tot_dupa_var($1); insert_simbol($1); insert_tip(tip_curent); insert_status(status_curent); 
if(strcmp(getTip($1),"BOOL")==0 || strcmp(getTip($1),"CONST BOOL")==0 ) {if($3!=0 && $3 != 1) eroare_bool($1); else insert_iValue($1,$<iValue>3);} else verif_stanga_dreapta_init($<nume>1, "INT"); insert_iValue($1,$<iValue>3); }
             | ID ASSIGN sir { elimin_tot_dupa_var($1); insert_simbol($1); insert_tip(tip_curent); insert_status(status_curent); if(strlen($<sValue>3) <=1 ) verif_stanga_dreapta_init($<nume>1, "CHAR"); else verif_stanga_dreapta_init($<nume>1, "STRING"); insert_sValue($1,$<sValue>3); }
             | ID ASSIGN real { elimin_tot_dupa_var($1); insert_simbol($1); insert_tip(tip_curent); insert_status(status_curent); verif_stanga_dreapta_init($<nume>1, "FLOAT"); insert_fValue($1,$<fValue>3); }
             ;
/*pot initializa doar cu expresii, si avand in vedere ca facem arbori pt expresii, pot fi doar int*/

real : NR_REAL { $<fValue>$=$1; }
     ;

dim : NR
    ;
sir : '"' ID '"' { elimin_tot_dupa_var($2); $<nume>$=$2;}
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
statement : elem ASSIGN expr {elimin_tot_dupa_struct($<nume>1); if(strcmp($<nume>1,"VECT")!=0) {  if(strncmp(getTip($<nume>1),"CONST",5)==0) eroare_const($<nume>1); insert_iValue($<nume>1, evalAST($<node>3));}}
          |	ID '(' lista_apel ')' { elimin_tot_dupa_var($<nume>1); caut_functia_in_tabel($<nume>1); verif_param($<nume>1); nr_s=0; }
          | PRINT '(' '"' text '"' ',' expr ')' { elimin_tot_dupa_ghilimele($<nume>4); printf("%s %d\n",$<nume>4, evalAST($<node>7)); }
          | elem ASSIGN real { elimin_tot_dupa_var($<nume>1); verif_stanga_dreapta($<nume>1, "FLOAT"); insert_fValue($<nume>1, $<fValue>3);}
          | elem ASSIGN sir { elimin_tot_dupa_var($<nume>1); if(strlen($<sValue>3) <=1 ) verif_stanga_dreapta($<nume>1, "CHAR"); else verif_stanga_dreapta($<nume>1, "STRING"); insert_sValue($<nume>1, $<sValue>3); }
          ;

text : ID
     | text ID
     | caracter
     | text caracter
     | text NR
     | NR
     ;
     

caracter : ' '
         | '+'
         | '-'
         | '*'
         | '/'
         | ';'
         | ':'
         ;

control_statement : WHILE '(' expr_bool ')' '{' list '}' { if($<iValue>3!=0) printf("while %d este ADEVARAT\n",whileuri); else printf("while %d este FALS\n",yylineno); whileuri++; }
                  | WHILE '(' expr_b ')' '{' list '}' { if($<iValue>3!=0) printf("while %d este ADEVARAT\n",whileuri); else printf("while %d este FALS\n",yylineno); whileuri++; }
                  | FOR '(' pentru_for ')' '{' list '}' { if($<iValue>3!=0) printf("for %d este ADEVARAT\n",foruri); else printf("for %d este FALS\n",foruri); foruri++; }
                  | IF '(' expr_bool ')' '{' list '}' { if($<iValue>3!=0) printf("if %d este ADEVARAT\n",ifuri); else printf("if %d este FALS\n",ifuri); ifuri++; }
                  | IF '(' expr_bool ')' '{' list '}' ELSE '{' list '}' { if($<iValue>3!=0) printf("if %d este ADEVARAT, nu se va executa else \n",ifuri); else printf("if %d este FALS, se va executa else\n",ifuri); ifuri++; }
                  | IF '(' expr_b ')' '{' list '}' { if($<iValue>3!=0) printf("if %d este ADEVARAT\n",ifuri); else printf("if %d este FALS\n",ifuri); ifuri++; }
                  | IF '(' expr_b ')' '{' list '}' ELSE '{' list '}' { if($<iValue>3!=0) printf("if %d este ADEVARAT, nu se va executa else \n",ifuri); else printf("if %d este FALS, se va executa else\n",ifuri); ifuri++; }
                  ;

pentru_for : elem ASSIGN expr ';' expr_bool ';' elem ASSIGN expr   { $<iValue>1=evalAST($<node>3); $<iValue>$=$<iValue>5; $<iValue>7=evalAST($<node>9); }
           | elem ASSIGN expr ';' ';' elem ASSIGN expr { $<iValue>1=evalAST($<node>3); $<iValue>$=1; $<iValue>6=evalAST($<node>8); }
           | elem ASSIGN expr ';' ';' { $<iValue>1=evalAST($<node>3); $<iValue>$=1; }
           | elem ASSIGN expr ';' expr_bool ';' { $<iValue>1=evalAST($<node>3); $<iValue>$=$<iValue>5; }
           | ';' expr_bool ';' elem ASSIGN expr { $<iValue>$=$<iValue>2; $<iValue>4=evalAST($<node>6); }
           | ';' expr_bool ';' { $<iValue>$=$<iValue>2; }  
           | ';' ';' elem ASSIGN expr { $<iValue>3=evalAST($<node>5); $<iValue>$=1; }
           | ';' ';' { $<iValue>$=1; }
           ;

lista_apel : e { nr_s++; }
           | lista_apel ',' e
           ;
    
e :    expr_s                { strcpy(verif[nr_s].tip,"INT"); }        
     | NR                    { strcpy(verif[nr_s].tip,"INT"); }
     | NR_REAL               { strcpy(verif[nr_s].tip,"FLOAT"); }
     | elem                  { elimin_tot_dupa_struct($<nume>1); caut_variabila_in_tabel($<nume>1); strcpy(verif[nr_s].tip, getTip($<nume>1)); }
     | ID '(' lista_apel ')' { elimin_tot_dupa_var($<nume>1); strcpy(verif[nr_s].tip, getTipFunctie($<nume>1)); } 
     ;

expr_s : NR '+' NR
       | NR '-' NR
       | NR '*' NR
       | NR '/' NR
       | '(' NR ')'
       ;

expr : expr '+' expr         { $<node>$=buildAST("+",$<node>1, $<node>3, "OP"); }
     | expr '-' expr         { $<node>$=buildAST("-",$<node>1, $<node>3, "OP"); }
     | expr '*' expr         { $<node>$=buildAST("*",$<node>1, $<node>3, "OP"); }
     | expr '/' expr         { $<node>$=buildAST("/",$<node>1, $<node>3, "OP"); }
     | '(' expr ')'          { $<node>$=$<node>2; }
     | NR                    { $<node>$=buildASTt($1, (struct AST *)NULL, (struct AST *)NULL, "NUMBER"); }
     | elem                  { $<node>$=buildAST($<nume>1, (struct AST *)NULL, (struct AST *)NULL, "IDENTIFIER"); }
     | ID '(' lista_apel ')' { elimin_tot_dupa_var($<nume>1); caut_functia_in_tabel($<nume>1); $<node>$=buildASTt(0, (struct AST *)NULL, (struct AST *)NULL, "NUMBER"); }
     ;
    
expr_b : expr_b '+' expr_b     { $<iValue>$ = $<iValue>1 + $<iValue>3; }
       | expr_b '-' expr_b     { $<iValue>$ = $<iValue>1 - $<iValue>3; }
       | expr_b '*' expr_b     { $<iValue>$ = $<iValue>1 * $<iValue>3; }
       | expr_b '/' expr_b     { $<iValue>$ = $<iValue>1 / $<iValue>3; }
       | '(' expr_b ')'        { $<iValue>$ = $<iValue>2; }
       | NR                    { $<iValue>$ = $<iValue>1; }
       | elem_b                { $<iValue>$ = $<iValue>1; }
       | ID '(' lista_apel ')' { elimin_tot_dupa_var($<nume>1); caut_functia_in_tabel($<nume>1); $<iValue>$ = 0; }
       ; 
elem_b  : ID { elimin_tot_dupa_var($1); $<iValue>$ = getiValue($1); } //in loc de 0 valoarea variabilei
        | ID '.' ID { elimin_tot_dupa_var($1); elimin_tot_dupa_var($3); combina($1, $3); $<iValue>$ = getiValue($1); }
        | ID '[' ID ']' { $<iValue>$ = 0; }
        | ID '[' NR ']' { $<iValue>$ = 0; }
        ;     

elem : ID            { elimin_tot_dupa_var($1); $<nume>$ = $1;}
     | ID '.' ID     { elimin_tot_dupa_var($1); elimin_tot_dupa_var($3); combina($1, $3); strcpy($<nume>$, $1);}
     | ID '[' ID ']' { strcpy($<nume>$, "VECTOR"); }
     | ID '[' NR ']' { strcpy($<nume>$, "VECTOR"); }
     ;

expr_bool : expr_bool AND expr_bool { $<iValue>$ = $<iValue>1 && $<iValue>3; } 
          | expr_b  AND expr_bool   { $<iValue>$ = $<iValue>1 && $<iValue>3; } 
          | expr_bool AND expr_b    { $<iValue>$ = $<iValue>1 && $<iValue>3; }  
          | expr_b  AND expr_b      { $<iValue>$ = $<iValue>1 && $<iValue>3; } 
          | expr_bool OR expr_bool  { $<iValue>$ = $<iValue>1 || $<iValue>3; } 
          | expr_bool OR expr_b     { $<iValue>$ = $<iValue>1 || $<iValue>3; } 
          | expr_b  OR expr_bool    { $<iValue>$ = $<iValue>1 || $<iValue>3; } 
          | expr_b  OR expr_b       { $<iValue>$ = $<iValue>1 || $<iValue>3; } 
          | bool                    { $<iValue>$ = $<iValue>1; } 
          ;
bool : expr_b LW expr_b      { $<iValue>$ = $<iValue>1 < $<iValue>3; } 
     | expr_b BG expr_b      { $<iValue>$ = $<iValue>1 > $<iValue>3;  }
     | expr_b LWEQ expr_b    { $<iValue>$ = $<iValue>1 <= $<iValue>3;  }
     | expr_b BGEQ expr_b    { $<iValue>$ = $<iValue>1 >= $<iValue>3;  }
     | expr_b EQ expr_b      { $<iValue>$ = $<iValue>1 == $<iValue>3;  }
     | expr_b NOTEQ expr_b   { $<iValue>$ = $<iValue>1 != $<iValue>3;  }
     | NOT '(' expr_bool ')' { $<iValue>$ = !($<iValue>3); }
     | NOT '(' expr_b  ')'   { $<iValue>$ = !($<iValue>3); }
     ;



%%
int yyerror(char * s){
err=1;
printf("eroare: %s la linia:%d\n",s,yylineno);
}

int main(int argc, char** argv)
{
int i;
for(i=0;i<100;i++) {func[i].nr_param=0; str[i].nr=0;}

yyin=fopen(argv[1],"r");
yyparse();
if(err==1) return 0;



FILE *fp;
fp = fopen("symbol_table.txt", "w");
fprintf(fp,"VARIABILE\n\n");
fprintf(fp,"SIMBOL | TIP | VALOARE | STATUS\n");
for(i=0;i<n;i++)
{
    fprintf(fp, "%s | %s | ",sym[i].simbol,sym[i].tip);
    if(strcmp(sym[i].tip,"BOOL")==0 || strcmp(sym[i].tip,"CONST BOOL")==0 ) fprintf(fp,"%d | ",sym[i].iValue);
    else
    if(strcmp(sym[i].tip,"INT")==0 || strcmp(sym[i].tip,"CONST INT")==0 ) fprintf(fp,"%d | ",sym[i].iValue);
    else
    if(strcmp(sym[i].tip,"FLOAT")==0 || strcmp(sym[i].tip,"CONST FLOAT")==0 ) fprintf(fp,"%f | ",sym[i].fValue);
    else
    if(strcmp(sym[i].tip,"CHAR")==0 || strcmp(sym[i].tip,"CONST CHAR")==0 ) fprintf(fp,"%s | ",sym[i].sValue);
    else
    if(strcmp(sym[i].tip,"STRING")==0 || strcmp(sym[i].tip,"CONST STRING")==0 ) fprintf(fp,"%s | ",sym[i].sValue);
    fprintf(fp,"%s\n",sym[i].status);
}

fp = fopen("symbol_table_functions.txt", "w");

fprintf(fp,"FUNCTII\n\n");
fprintf(fp,"TIP | NUME | NR_PARAM | TIP_PARAMETRU PARAMETRU\n");
for(i=0;i<m;i++)
{
    fprintf(fp,"%s | %s | %d | ",func[i].tip_functie, func[i].nume, func[i].nr_param);
    if(func[i].nr_param==0) fprintf(fp,"-\n");
    else
    {
        int j;
        for(j=0;j<func[i].nr_param;j++)
        {
            fprintf(fp,"%s %s ",func[i].param[j].tip,func[i].param[j].simbol);
        }
        fprintf(fp,"\n");
    }
}
} 
