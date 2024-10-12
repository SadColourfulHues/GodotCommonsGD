## A node that handles focus-related interactions using a [FocusCoordinator]
class_name FocusHandler
extends Node

@export
var p_coordinator: FocusCoordinator

@export
var p_interactor: Node

var p_focusables: Array[Node]

var m_idx := 0


#region Events

func _enter_tree() -> void:
    p_coordinator.request_add.connect(_on_request_add)
    p_coordinator.request_remove.connect(_on_request_remove)
    p_coordinator.request_cycle.connect(_on_request_cycle)
    p_coordinator.request_interact.connect(_on_interact)


func _exit_tree() -> void:
    p_coordinator.request_add.disconnect(_on_request_add)
    p_coordinator.request_remove.disconnect(_on_request_remove)
    p_coordinator.request_cycle.disconnect(_on_request_cycle)
    p_coordinator.request_interact.disconnect(_on_interact)


func _on_request_add(focusable: Node) -> void:
    # Verify node functionality
    if OS.is_debug_build():
        if (!focusable.has_method(&"_focus_can_interact") ||
            !focusable.has_method(&"_focus_perform")):

            printerr("FocusHandler: tried to add a non-valid focusable item \"%s\"." % focusable.name)
            return

    var was_empty := p_focusables.is_empty()
    p_focusables.append(focusable)

    # Auto-focus newly-added nodes
    if !was_empty:
        return

    m_idx = 0
    p_coordinator.notify_focus_change(focusable)


func _on_request_remove(focusable: Node) -> void:
    var match_idx := p_focusables.find(focusable)

    if match_idx == -1:
        return

    p_focusables.remove_at(match_idx)

    # Auto-select next item (if there's still any left)
    var size_remaining := p_focusables.size()

    if size_remaining < 1:
        p_coordinator.notify_focus_change(null)
        return

    m_idx = wrapi(match_idx + 1, 0, size_remaining)
    p_coordinator.notify_focus_change(p_focusables[m_idx])


func _on_request_cycle(reverse: bool) -> void:
    var size := p_focusables.size()

    if size < 1:
        p_coordinator.notify_focus_change(null)
        return

    m_idx = wrapi(m_idx + (-1 if reverse else 1), 0, size)
    p_coordinator.notify_focus_change(p_focusables[m_idx])


func _on_interact() -> void:
    var size := p_focusables.size()

    # Validity check
    if size < 1:
        return

    if m_idx < 0 || m_idx >= size:
        p_coordinator.notify_focus_change(null)
        m_idx = wrapi(m_idx, 0, size)

    var focus_target := p_focusables[m_idx]

    if (!is_instance_valid(focus_target) ||
        !focus_target._focus_can_interact(p_interactor)):
        return

    p_focusables[m_idx]._focus_perform(p_interactor)


#endregion
