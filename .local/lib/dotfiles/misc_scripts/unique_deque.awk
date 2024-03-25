#!/usr/bin/env -S gawk -f

BEGIN {
	deque_head = deque_tail = -1; deque_left = 0; deque_right = 1
}
function deque_push(id) {
	if (id != deque_head) {
		if (deque[id, deque_left]) {
			if (deque[id, deque_left] != -1)
				deque[deque[id, deque_left], deque_right] = deque[id, deque_right]
			if (deque[id, deque_right] != -1)
				deque[deque[id, deque_right], deque_left] = deque[id, deque_left]
		}
		if (deque_head == -1) deque_tail = id
		else if (deque_tail == id) deque_tail = deque[id, deque_left]
		deque[id, deque_left] = -1
		deque[id, deque_right] = deque_head
		deque[deque_head, deque_left] = id
		deque_head = id
	}
}
function deque_push_tail(id) {
	if (id != deque_tail) {
		if (deque[id, deque_left]) {
			if (deque[id, deque_left] != -1)
				deque[deque[id, deque_left], deque_right] = deque[id, deque_right]
			if (deque[id, deque_right] != -1)
				deque[deque[id, deque_right], deque_left] = deque[id, deque_left]
		}
		if (deque_tail == -1) deque_head = id
		else if (deque_head == id) deque_head = deque[id, deque_right]
		deque[id, deque_left] = deque_tail
		deque[id, deque_right] = -1
		deque[deque_tail, deque_right] = id
		deque_tail = id
	}
}
function deque_remove(id) {
	if (deque[id, deque_left]) {
		if (id == deque_head)
			deque_head = deque[id, deque_right]
		if (id == deque_tail)
			deque_tail = deque[id, deque_left]
		if (deque[id, deque_left] != -1)
			deque[deque[id, deque_left], deque_right] = deque[id, deque_right]
		if (deque[id, deque_right] != -1)
			deque[deque[id, deque_right], deque_left] = deque[id, deque_left]
	}
}
