#include"ast.h"
#include<stdlib.h>
#include<stdio.h>
struct expr* expr_create(expr_t type, struct expr* left, struct expr* right){
	struct expr* e=malloc(sizeof(*e));
	e->type=type;
	e->left=left;
	e->right=right;
	e->val=0;
	e->dval=0;
	e->name=0;
	return e;
}

struct expr* expr_val(int val){
	struct expr* e=expr_create(EXPR_VAL,0,0);
	e->val=val;
	return e;
}

struct expr* expr_dval(double val){
	struct expr* e=expr_create(EXPR_VAL,0,0);
	e->dval=val;
	return e;
}

struct expr* expr_name(char* name){
	struct expr* e=malloc(sizeof(*e));
	e->type=EXPR_NAME;
	e->left=0;
	e->right=0;
	e->val=0;
	e->dval=0;
	e->name=name;
	return e;
}

struct expr* expr_subscript(char* name){
	struct expr* e=malloc(sizeof(*e));
	e->type=EXPR_SUBSCRIPT;
	e->left=0;
	e->right=0;
	e->val=0;
	e->dval=0;
	e->name=name;
	return e;

}

int expr_eval(struct expr* e){
	if(!e) return 0;
	int l=expr_eval(e->left);
	int r=expr_eval(e->right);

	switch(e->type){
		case EXPR_ADD:{
			return l+r;
		}
		break;
		case EXPR_SUB:{
			return l-r;
		}
		break;
		case EXPR_MUL:{
			return l*r;
		}
		break;
		case EXPR_DIV:{
			if(r==0){
				printf("Error: Division by 0\n");
				exit(1);
			}
			else{
				return l/r;
			}
		}
		break;
		case EXPR_VAL:{
			return e->val;
		}
	}
	return 0;
}

void expr_print(struct expr* e){
	if(!e) return;

	printf("(");

	expr_print(e->left);

	switch(e->type){
		case EXPR_ADD:{
			printf("+");
		}
		break;
		case EXPR_SUB:{
			printf("-");
		}
		break;
		case EXPR_MUL:{
			printf("*");
		}
		break;
		case EXPR_DIV:{
			printf("/");
		}
		break;
		case EXPR_VAL:{
			printf("%d",e->val);
		}
	}

	expr_print(e->right);
	printf(")");
	return;
}

struct decl* decl_create(char* name,struct type* type, struct expr* value,
                         struct stmt* code, struct decl* next){

	struct decl* d=malloc(sizeof(*d));
	d->name=name;
	d->type=type;
	d->value=value;
	d->code=code;
	d->next=next;
	return d;
}

struct type* type_create(type_t type,struct type* subtype, struct param_list* param){
	struct type* t=malloc(sizeof(*t));
	t->type=type;
	t->subtype=subtype;
	t->param=param;
	return t;
}

struct param_list* param_list_create(char* name, struct type* type, struct param_list* next){
	struct param_list* p=malloc(sizeof(*p));
	p->name=name;
    p->type=type;
	p->next=next;
	return p;
}

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
