%{
#include "TVAR.h"
#include <string.h>
#include <stdlib.h>
#include <stdio.h>
int yylex();
int yyerror(const char *mess);

int Corect = 1;
char mess[500];

%}

%union{int val;char *sir;}

%token TK_punctvirgula TK_douapuncte TK_virgula TK_primeste TK_plus TK_minus TK_inmultire TK_div TK_punct
%token <val> TK_stanga TK_dreapta
%token TK_do TK_to TK_for
%token TK_read TK_write
%token TK_program TK_var TK_begin TK_end TK_integer
%token <sir> TK_id TK_eroare
%token <val> TK_int

%type <sir> id_list 
%type <val> factor exp term

%start prog
%locations
%left TK_plus TK_minus
%left TK_inmultire TK_impartire

%%

prog: TK_program prog_name TK_var dec_list TK_begin stmt_list TK_end TK_punct
	|
	error 
       { Corect = 0; }
;
prog_name: TK_id
;

dec_list: dec
	|
	dec_list TK_punctvirgula dec
;

dec: id_list TK_douapuncte type
{
	char *aux,*p;
	aux=new char[100];
	p=new char[100];
	strcpy(aux,$1);
	p=strtok(aux,",");
	while(p)
	{
		if(ts != NULL)
		{
	 	 if(ts->exists(p) == 0)
	  	 {
	  	  ts->add(p);
	 	 }
	 	 else
	 	 {
	    	sprintf(mess,"LIN:%d Eroare semantica: Declaratii multiple pentru variabila %s!", @1.first_line, p);
	    	yyerror(mess);
	    	YYERROR;
	  	 }
		}
		else
		{
	 	 ts = new TVAR();
		 ts->add(p);
		}	
	p=strtok(NULL,",");
	}
}
;

type: TK_integer
;

id_list: TK_id
	|
	id_list TK_virgula TK_id
{
	strcat($$,",");
	strcat($$,$3);
	
}

;

stmt_list: stmt
	|
	stmt_list TK_punctvirgula stmt
;

stmt: assign
	|
	read
	|
	write
	|
	for
;

assign: TK_id TK_primeste exp
{
	if(ts != NULL)
	{
	  if(ts->exists($1) == 0)
	  {
	    sprintf(mess,"LIN:%d Eroare semantica: Variabila %s este utilizata fara sa fi fost declarata!", @1.first_line, $1);
	    yyerror(mess);
	    YYERROR;
	  }
	  else
	  {
		ts->setValue($1,1);
	  }
	}
	else
	{
	  sprintf(mess,"LIN:%d Eroare semantica: Variabila %s este utilizata fara sa fi fost declarata!", @1.first_line, $1);
	  yyerror(mess);
	  YYERROR;
	}
}
;

exp: term
	|
	exp TK_plus term 
	|
	exp TK_minus term 
;

term: factor
	|
	term TK_inmultire factor 
	|
	term TK_div factor
{
	if($3 == 0) 
	  { 
	      sprintf(mess,"LIN:%d Eroare semantica: Impartire la zero!", @1.first_line);
	      yyerror(mess);
	      YYERROR;
	  } 
}

;
factor: TK_id 
{
	if(ts != NULL)
	{
	  if(ts->exists($1) == 0)
	  {
	    sprintf(mess,"LIN:%d Eroare semantica: Variabila %s este utilizata fara sa fi fost declarata!", @1.first_line, $1);
	    yyerror(mess);
	    YYERROR;
	  }
		else
		{
		if(ts->getValue($1) == -1)
	    		{
	      sprintf(mess,"LIN:%d Eroare semantica: Variabila %s este utilizata fara sa fi fost initializata!", @1.first_line,$1);
	      yyerror(mess);
	      YYERROR;
	    		}		
		}
	}
	else
	{
	  sprintf(mess,"LIN:%d Eroare semantica: Variabila %s este utilizata fara sa fi fost declarata!", @1.first_line, $1);
	  yyerror(mess);
	  YYERROR;
	}
}
	|
	TK_int
	|
	TK_stanga exp TK_dreapta 
;

read: TK_read TK_stanga id_list TK_dreapta
{
	char *aux,*p;
	aux=new char[100];
	p=new char[100];
	strcpy(aux,$3);
	p=strtok(aux,",");
	while(p)
	{
		if(ts != NULL)
		{
	 	 if(ts->exists(p) == 0)
			{
	   			 sprintf(mess,"LIN:%d Eroare semantica: Variabila %s este utilizata fara sa fi fost declarata!", @1.first_line,p);
	    			yyerror(mess);
	    			YYERROR;
	 		 }
			  else
			{
				ts->setValue(p,1);
			}		 		
	 	}
		else
		{
	   			 sprintf(mess,"LIN:%d Eroare semantica: Variabila %s este utilizata fara sa fi fost declarata!", @1.first_line,p);
	    			yyerror(mess);
	    			YYERROR;
	 	}
	p=strtok(NULL,",");
	}
}
;
write: TK_write TK_stanga id_list TK_dreapta
{
	char *aux,*p;
	aux=new char[100];
	p=new char[100];
	strcpy(aux,$3);
	p=strtok(aux,",");
	while(p)
	{
		if(ts != NULL)
		{
	 	 if(ts->exists(p) == 0)
			{
	   			 sprintf(mess,"LIN:%d Eroare semantica: Variabila %s este utilizata fara sa fi fost declarata!", @1.first_line,p);
	    			yyerror(mess);
	    			YYERROR;
	 		}
			  else
			 {
				if(ts->getValue(p) == -1)
	   			 {
	     			 sprintf(mess,"LIN:%d Eroare semantica: Variabila %s este utilizata fara sa fi fost initializata!", @1.first_line,p);
	    			  yyerror(mess);
	    			  YYERROR;
	   			 }
			}		 		
	 	}
		else
		{
	   			 sprintf(mess,"LIN:%d Eroare semantica: Variabila %s este utilizata fara sa fi fost declarata!", @1.first_line,p);
	    			yyerror(mess);
	    			YYERROR;
	 	}
	p=strtok(NULL,",");
	}
}
;
for: TK_for index_exp TK_do body
;
index_exp: TK_id TK_primeste exp TK_to exp
{
	if(ts != NULL)
	{
	  if(ts->exists($1) == 0)
	  {
	    sprintf(mess,"LIN:%d Eroare semantica: Variabila %s este utilizata fara sa fi fost declarata!", @1.first_line, $1);
	    yyerror(mess);
	    YYERROR;
	  }
	  else
	  {
		ts->setValue($1,1);
	  }
	}
	else
	{
	  sprintf(mess,"LIN:%d Eroare semantica: Variabila %s este utilizata fara sa fi fost declarata!", @1.first_line, $1);
	  yyerror(mess);
	  YYERROR;
	}
}
;
body: stmt
	|
	TK_begin stmt_list TK_end
;



%%

int main()
{
yyparse();
if(Corect==1)
	printf("Programul este corect\n");
return 0;
}

int yyerror(const char *mess)
{
printf("\nerror: %s\n",mess);
return 1;
}
