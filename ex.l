%{
#include "y.tab.h"

int nr_coloana=1;
int nr_linie=1;

%}


%%
"PROGRAM"	{ECHO;nr_coloana=nr_coloana+7;return TK_program;}
"VAR"		{ECHO;nr_coloana=nr_coloana+3;return TK_var;}
"BEGIN"		{ECHO;nr_coloana=nr_coloana+5;return TK_begin;}
"END"		{ECHO;nr_coloana=nr_coloana+3;return TK_end;}
"INTEGER"	{ECHO;nr_coloana=nr_coloana+7;return TK_integer;}
"DIV"		{ECHO;nr_coloana=nr_coloana+3;return TK_div;}
"READ"		{ECHO;nr_coloana=nr_coloana+4;return TK_read;}
"WRITE" 	{ECHO;nr_coloana=nr_coloana+5;return TK_write;}
"FOR"		{ECHO;nr_coloana=nr_coloana+3;return TK_for;}
"DO"		{ECHO;nr_coloana=nr_coloana+2;return TK_do;}
"TO"		{ECHO;nr_coloana=nr_coloana+2;return TK_to;}

";"		{ECHO;nr_coloana++;return TK_punctvirgula;}
":"		{ECHO;nr_coloana++;return TK_douapuncte;}
","		{ECHO;nr_coloana++;return TK_virgula;}
":="		{ECHO;nr_coloana=nr_coloana+2;return TK_primeste;}
"+"		{ECHO;nr_coloana++;return TK_plus;}
"-"		{ECHO;nr_coloana++;return TK_minus;}
"*"		{ECHO;nr_coloana++;return TK_inmultire;}
"("		{ECHO;nr_coloana++;return TK_stanga;}
")"		{ECHO;nr_coloana++;return TK_dreapta;}
"\."		{ECHO;nr_coloana++;return TK_punct;}


[ ]			{ECHO;nr_coloana++;}
\r\n|\n			{ECHO;nr_coloana++;nr_linie++;}

[a-zA-Z][_a-zA-Z0-9]*	{ECHO;
			yylloc.first_line=nr_linie;
			yylloc.first_column=nr_coloana;
			nr_coloana=nr_coloana+strlen(yytext);
			yylval.sir=new char[strlen(yytext)+1];
			strcpy(yylval.sir,yytext);
			return TK_id;}
0|[1-9][0-9]*		{ECHO;
			yylloc.first_line=nr_linie;
			yylloc.first_column=nr_coloana;
			nr_coloana=nr_coloana+strlen(yytext);
			yylval.val=atoi(yytext);
			return TK_int;}


.			{nr_coloana++;return TK_eroare;}
%%


