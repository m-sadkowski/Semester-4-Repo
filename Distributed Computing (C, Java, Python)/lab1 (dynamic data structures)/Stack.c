#include <stdlib.h>
#include <stdio.h>
#include "Stack.h"

Stack* createStack() {
    Stack* newStack = (Stack*)malloc(sizeof(Stack));
    if (newStack == NULL) {
        return NULL;
    }
    newStack->top = NULL;
    return newStack;
}

void deleteStack(Stack* s) {
    Node* temp;
    while (s->top) {
        temp = s->top;
        s->top = s->top->next;
        deleteNode(temp);
    }
    free(s);
}

void push(Stack* s, int value) {
    Node* newNode = createNode(value);
    if (newNode == NULL) {
        return;
    }
    newNode->next = s->top;
    s->top = newNode;
}

void pop(Stack* s) {
	if (s->top == NULL) {
        return;
    }
    Node* temp = s->top;
    s->top = s->top->next;
    deleteNode(temp);
}

int isStackEmpty(Stack* s) {
	return s->top == NULL;
}

int peek(Stack* s) {
    if (s->top == NULL) {
        return -1;
    }
    return s->top->data;
}

void printStack(Stack* s) {
	Node* temp = s->top;
	while (temp != NULL) {
		printf("%d ", temp->data);
		temp = temp->next;
	}
	printf("\n");
}
