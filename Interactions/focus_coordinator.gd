## An intermediary resource for interfacing with a [FocusHandler]
## (Note: using the same coordinator on multiple handlers will cause unexpected behaviour.)
class_name FocusCoordinator
extends Resource

signal request_add(focusable: Node)
signal request_remove(focusable: Node)
signal request_cycle(reverse: bool)
signal request_interact()

signal focus_changed(focus_element: Node)


#region Utils

## Adds an entry to an associated [FocusHandler].
## This function assumes that [focusable] has two methods implemented:
## - [_focus_can_interact(interactor: Node)]
## - [_focus_interact(interactor: Node)]
func add(focusable: Node) -> void:
    request_add.emit(focusable)


## Removes an entry from an associated [FocusHandler]
func remove(focusable: Node) -> void:
    request_remove.emit(focusable)


## Cycles the associated [FocusHandler]
func cycle(reverse: bool = false) -> void:
    request_cycle.emit(reverse)


## Triggers the currently-selected entry in the associated [FocusHandler]
func interact() -> void:
    request_interact.emit()


## (Used by focus controllers) notifies subscribers that the current focus target has changed
func notify_focus_change(focus_element: Node) -> void:
    focus_changed.emit(focus_element)


#endregion