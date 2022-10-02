#include"expr.h"
#include<stdlib.h>
#include<stdio.h>
struct expr* expr_create(expr_t type, struct expr* left, struct expr* right){
	struct expr* e=malloc(sizeof(*e));
	e->type=type;
	e->left=left;
	e->right=right;
	e->val=0;
	return e;
}

struct expr* expr_val(int val){
	struct expr* e=expr_create(EXPR_VAL,0,0);
	e->val=val;
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
