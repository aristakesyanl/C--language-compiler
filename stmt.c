#include<stdlib.h>
#include<stdio.h>
#include"stmt.h"

struct stmt* stmt_create(stmt_t type, struct decl* decl, struct expr* init_expr, struct expr* expr, struct expr* next_expr,
                         struct stmt* body, struct stmt* else_body, struct stmt* next){

	struct stmt* s=malloc(sizeof(*s));
	s->type=type;
	s->decl=decl;
	s->init_expr=init_expr;
	s->expr=expr;
	s->next_expr=next_expr;
	s->body=body;
	s->else_body=else_body;
	s->next=next;
	return s;
}

// int main(){
// 	struct expr* e1=expr_val(1);
// 	struct expr* e2=expr_val(2);
// 	struct expr* e3=expr_create(EXPR_ADD,e1,e2);
// 	struct stmt* s=stmt_create(STMT_DECL, 0,e3,0,0,0,0,0);
// }
