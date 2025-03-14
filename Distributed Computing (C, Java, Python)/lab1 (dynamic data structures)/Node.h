#ifndef NODE_H
#define NODE_H

typedef struct Node {
    int data;
    struct Node* next;
} Node;

Node* createNode(int value);
void deleteNode(Node* node);

#endif
