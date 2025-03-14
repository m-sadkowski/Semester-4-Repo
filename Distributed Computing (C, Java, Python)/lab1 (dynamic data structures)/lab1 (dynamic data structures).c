#include <stdio.h>
#include "Stack.h"
#include "LinkedList.h"

int main() {
	Stack* s = createStack();
	push(s, 1);
	// 1
	push(s, 2);
	// 2 <- 1 
	push(s, 3);
	// 3 <- 2 <- 1
	pop(s);
	// 2 <- 1
	push(s, 4);
	// 4 <- 2 <- 1
	printStack(s);

	LinkedList* l = createLinkedList();
	addFront(l, 1);
	// 1
	addFront(l, 2);
	// 2 -> 1
	addBack(l, 5);
	// 2 -> 1 -> 5
	addFront(l, 8);
	// 8 -> 2 -> 1 -> 5
	insert(l, 1, 3);
	// 8 -> 3 -> 2 -> 1 -> 5
	removeFirst(l);
	// 3 -> 2 -> 1 -> 5
	removeAt(l, 2);
	// 3 -> 2 -> 5
	set(l, 1, 4);
	// 3 -> 4 -> 5
	printList(l);

    return 0;
}
