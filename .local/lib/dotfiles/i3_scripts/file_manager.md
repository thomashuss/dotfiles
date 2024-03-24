# Floating file manager

## Problem

Traditional GUI and TUI file managers assume file management is linear.  The
cost of this assumption is time wasted digging through folders whose hierarchy
you already know.  Symbolic links solve this problem but are inelegant compared
to simply opening the folder (which you are going to do anyway), and are
similarly inelegant to destroy when your work is done.  Spatial file managers
solve this problem, with the action of opening a folder also creating a
re-usable "link" to that folder, but create window clutter which is cumbersome
to sift through.

## Solution

* Use `caja` in spatial mode with i3's floating mode.
* Move the `caja` windows to/from i3's scratchpad with a keypress.
* Prompt the user for a `caja` window to focus upon moving windows from
  scratchpad to visible, or upon a keypress while `caja` windows are visible.
  - Sort the windows by recency, with the most recently focused window at the
    top.
* Switch i3 to a `file` mode when `caja` windows are visible.
  - `file` mode exists to bind the `/` key to displaying of the window prompt
    while windows are visible.

## Implementation

### `file_mode`

Invoked when entering i3 `file` mode.  For floating windows, i3's
`_NET_CLIENT_LIST_STACKING` order is reset upon keypress, meaning we cannot use
it for a list activated by a keypress.  Therefore, we must maintain a queue of
window focus events from `i3-msg`, disregarding the most recent event (the most
recently opened window being focused upon keypress), to be flushed to
`rofi_focus_file` (`RFF`) upon request.  `RFF` enqueues window selection events
originating from the user and handles adjacent duplicate events in its deque.
However, when only one event is in the queue, and it isn't the first recorded
event (so the order isn't disrupted), this will be sent to `RFF`, as this
corresponds to the most recently focused window being manually chosen (`RFF`
enqueued this event, not `i3-msg`).  This script also tracks the number of open
file windows and exits file mode when no more windows exist.  We make use of
two named pipes to achieve the asynchronous communication between this script
and `RFF`.  Maintaining a queue of focus events, rather than updating a cache
upon every focus event, reduces file I/O when the mouse is used for rapidly
changing focus.  Upon exiting file mode, the cache is updated using `RFF`'s
deque implementation.


### `rofi_focus_file` and `rff_deque.awk`

Invoked by `rofi` for displaying prompts.  This script displays a list of file
windows sorted by recency.  It utilizes a cache stored in `XDG_RUNTIME_DIR` for
recalling the window order at the last invocation of this script, and obtains a
queue of window focus events from `file_mode` (`FM`) to update the cache with
interim events.  The embedded awk script uses a deque to track window recency.
Windows are pushed onto the deque in their presumed order of recency, with the
front being most recent.  Windows which already exist in the deque upon a push
operation for that window are removed from their original position.  The deque
is first populated with the currently open windows, so the most recently opened
window is assumed to be most recently focused at this point.  Then the cache is
pushed onto the tail of the deque (the cache is stored in reverse for
efficiency when writing), and finally any window focus events from `FM`'s queue
are pushed onto the head.  Pushes from the cache and focus events are ignored
for windows which do not exist in the currently open list, to handle closed
windows without recording close events.  When a window is selected from the
prompt, a focus event is sent to `FM` to handle the edge case where the most
recently opened window is selected and another prompt is immediately opened
(accounting for `FM` ignoring the most recent event).  The cache is written
to after the prompt is displayed but before the user makes a selection.

