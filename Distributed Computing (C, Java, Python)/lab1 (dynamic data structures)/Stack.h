#ifndef STACK_H
#define STACK_H

#include "Node.h"

typedef struct Stack {
    Node* top;
} Stack;

Stack* createStack();
void deleteStack(Stack* s);
void push(Stack* s, int value);
void pop(Stack* s);
int peek(Stack* s);
void printStack(Stack* s);

#endif
