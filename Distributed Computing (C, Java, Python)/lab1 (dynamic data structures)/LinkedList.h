#ifndef LINKEDLIST_H
#define LINKEDLIST_H
#include "Node.h"

typedef struct {
	Node* head;
} LinkedList;

LinkedList* createLinkedList();
void addFront(LinkedList* l, int value);
void addBack(LinkedList* l, int value);
void removeFirst(LinkedList* l);
void removeLast(LinkedList* l);
int get(LinkedList* l, int index);
int set(LinkedList* l, int index);
int size(LinkedList* l);
int isListEmpty(LinkedList* l);
void insert(LinkedList* l, int index, int value);
void removeAt(LinkedList* l, int index);

#endif

