#include<stdlib.h>
#include<stdio.h>
#include"type.h"

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
