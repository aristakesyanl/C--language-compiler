#include"decl.h"
#include<stdlib.h>
#include<stdio.h>

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

// void decl_print(struct decl* d){
// 	if(!d) return;

// 	switch(d->type){
// 		case 
// 	}
// }
