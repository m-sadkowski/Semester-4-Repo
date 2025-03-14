#include <stdlib.h>
#include "Node.h"

Node* createNode(int value) {
    Node* newNode = (Node*)malloc(sizeof(Node));
    if (newNode == NULL) {
        return NULL;
    }
    newNode->data = value;
    newNode->next = NULL;
    return newNode;
}

void deleteNode(Node* node) {
    free(node);
}
