#include <stdlib.h>
#include <stdio.h>
#include "LinkedList.h"


LinkedList* createLinkedList() {
	LinkedList* newList = (LinkedList*)malloc(sizeof(LinkedList));
	if (newList == NULL) {
		return NULL;
	}
	newList->head = NULL;
	return newList;
}

void addFront(LinkedList* l, int value) {
	Node* newNode = createNode(value);
	if (newNode == NULL) {
		return;
	}
	newNode->next = l->head;
	l->head = newNode;
}

void addBack(LinkedList* l, int value) {
	Node* newNode = createNode(value);
	if (newNode == NULL) {
		return;
	}
	if (l->head == NULL) {
		l->head = newNode;
		return;
	}
	Node* temp = l->head;
	while (temp->next != NULL) {
		temp = temp->next;
	}
	temp->next = newNode;
}

void removeFirst(LinkedList* l) {
    if (l->head == NULL) {
        return;
    }
    Node* temp = l->head;
    l->head = l->head->next;
    deleteNode(temp);
}

void removeLast(LinkedList* l) {
    if (l->head == NULL) {
        return;
    }
    if (l->head->next == NULL) {
        deleteNode(l->head);
        l->head = NULL;
        return;
    }
    Node* temp = l->head;
    while (temp->next->next != NULL) {
        temp = temp->next;
    }
    deleteNode(temp->next);
    temp->next = NULL;
}

int get(LinkedList* l, int index) {
    Node* temp = l->head;
    int count = 0;
    while (temp != NULL) {
        if (count == index) {
            return temp->data;
        }
        temp = temp->next;
        count++;
    }
    return -1;
}

int set(LinkedList* l, int index, int value) {
    Node* temp = l->head;
    int count = 0;
    while (temp != NULL) {
        if (count == index) {
            temp->data = value;
            return 1;
        }
        temp = temp->next;
        count++;
    }
    return 0;
}

int size(LinkedList* l) {
    int count = 0;
    Node* temp = l->head;
    while (temp != NULL) {
        count++;
        temp = temp->next;
    }
    return count;
}

int isListEmpty(LinkedList* l) {
    return l->head == NULL;
}

void insert(LinkedList* l, int index, int value) {
    if (index == 0) {
        addFront(l, value);
        return;
    }
    Node* temp = l->head;
    int count = 0;
    while (temp != NULL && count < index - 1) {
        temp = temp->next;
        count++;
    }
    if (temp == NULL) {
        return;
    }
    Node* newNode = createNode(value);
    if (newNode == NULL) {
        return;
    }
    newNode->next = temp->next;
    temp->next = newNode;
}

void removeAt(LinkedList* l, int index) {
    if (index == 0) {
        removeFirst(l);
        return;
    }
    Node* temp = l->head;
    int count = 0;
    while (temp != NULL && count < index - 1) {
        temp = temp->next;
        count++;
    }
    if (temp == NULL || temp->next == NULL) {
        return;
    }
    Node* toDelete = temp->next;
    temp->next = temp->next->next;
    deleteNode(toDelete);
}

void printList(LinkedList* l) {
	Node* temp = l->head;
	while (temp != NULL) {
		printf("%d ", temp->data);
		temp = temp->next;
	}
	printf("\n");
}