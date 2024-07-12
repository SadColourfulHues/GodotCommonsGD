## A base class for focus-based actions
class_name BaseFocusable
extends Node

var p_unfocus_function: Callable

## A flag determining whether or not this action is in focus
## (This variable should only be written to by the action's
## focus control functions.)
var m_is_focused := false


#region Events

func _init() -> void:
    __focus_callback_invalidate()

#endregion


#region Focusable

## This function is called to query as to whether or not
## this action can be used
func _focus_can_interact() -> bool:
    return true


## Override this function to implement handling the focusable's action
func _focus_perform() -> void:
    pass


## This function is called when the action is selected
func _focus_entered() -> void:
    pass


## This function is called when the controller moves to another action
func _focus_exited() -> void:
    pass

#endregion

#region Control

## Sets the action's current 'focus' state
func set_focus(is_focused: bool) -> void:
    if m_is_focused == is_focused:
        return

    m_is_focused = is_focused

    if is_focused:
        _focus_entered()
    else:
        _focus_exited()


## Forces this action to be unfocused before requesting the
## owning controller to cycle to the next available one.
func unfocus_and_cycle() -> void:
    m_is_focused = false
    _focus_exited()

    p_unfocus_function.call()

#endregion

#region Controller Interaction

## (Sets up the unfocus callback behaviour for the focus controller)
func __focus_callback_bind(callback: Callable) -> void:
    p_unfocus_function = callback


func __focus_callback_invalidate() -> void:
    p_unfocus_function = func(_caller): pass

#endregion