#!/usr/bin/env -S gawk -f

BEGIN {
	stack_file = ENVIRON["XDG_RUNTIME_DIR"] "/rofi_focus_file_stack"
	deque_head = deque_tail = -1; left = 0; right = 1
}
function push(id) {
	if (id != deque_head) {
		if (deque[id, left]) {
			if (deque[id, left] != -1)
				deque[deque[id, left], right] = deque[id, right]
			if (deque[id, right] != -1)
				deque[deque[id, right], left] = deque[id, left]
		}
		if (deque_head == -1) deque_tail = id
		else if (deque_tail == id) deque_tail = deque[id, left]
		deque[id, left] = -1
		deque[id, right] = deque_head
		deque[deque_head, left] = id
		deque_head = id
	}
}
function push_tail(id) {
	if (id != deque_tail) {
		if (deque[id, left]) {
			if (deque[id, left] != -1)
				deque[deque[id, left], right] = deque[id, right]
			if (deque[id, right] != -1)
				deque[deque[id, right], left] = deque[id, left]
		}
		if (deque_tail == -1) deque_head = id
		else if (deque_head == id) deque_head = deque[id, right]
		deque[id, left] = deque_tail
		deque[id, right] = -1
		deque[deque_tail, right] = id
		deque_tail = id
	}
}
function push_post(id) { if (id in out) push(id) }
function push_tail_post(id) { if (id in out) push_tail(id) }
function load_cache(push) {
	push = "push_tail" push
	while ((getline id < stack_file) > 0) @push(id)
	close(stack_file)
}
function save_cache() {
	printf("") > stack_file
	while (deque_head != -1) {
		print deque_head >> stack_file
		deque_head = deque[deque_head, right]
	}
	close(stack_file)
}
