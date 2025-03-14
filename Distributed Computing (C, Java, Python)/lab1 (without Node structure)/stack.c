#include <stdio.h>
#include <stdlib.h>

/*
    !!! IMPORTANT !!!
    How to compile and execute:
    gcc -Wall -fsanitize=leak -pedantic -o stack stack.c && ./stack
*/

typedef struct StackNode {
    int data;
    struct StackNode* node;
} StackNode;

void push(StackNode** top, int value) {
    StackNode* new = (StackNode*)malloc(sizeof(StackNode));
    if(!new) {
        exit(0);
    }
    new->data = value;
    new->node = *top;
    *top = new;
}

int pop(StackNode** top) {
    if(*top == NULL) {
        return -1;
    }
    StackNode* temp = *top;
    int value = temp->data;
    *top = temp->node;
    free(temp);
    return value;
}

void print_stack(StackNode* top) {
    if(top == NULL) {
        printf("Pusty stos\n");
        return;
    }
    printf("Stos: ");
    while(top) {
        printf(" %d", top->data);
        top = top->node;
    }
    printf("\n");
}


int main() {
    StackNode* stack = NULL;
    
    push(&stack, 10);
    push(&stack, 20);
    push(&stack, 30);
    print_stack(stack);
    

    pop(&stack);
    print_stack(stack);
    pop(&stack);
    print_stack(stack);
    pop(&stack);
    print_stack(stack);
    

    return 0;
}
