## An object that can be used to handle cycling between
## 'focusable' elements. As well as triggering their
## associated action.

## (Remember to call 'free' when the controller is no longer in use!)
class_name FocusController
extends Object

## This signal is fired when the last action is unregistered from the controller
signal emptied()

var m_action_idx := -1
var p_actions: Array[BaseFocusable]


#region Events

func _on_action_request_unfocus() -> void:
    cycle(false)

#endregion

#region Organisation

## Registers an action to the controller
## (By default, the controller will also automatically cycle
## to the first focusable action, if nothing is currently in focus.)
func register(action: BaseFocusable,
            prevent_autocycle_on_empty := false) -> void:

    if p_actions.has(action):
        return

    action.__focus_callback_bind(_on_action_request_unfocus)

    cleanup()
    p_actions.append(action)

    if (prevent_autocycle_on_empty ||
        (__is_valid_index(m_action_idx) &&
        p_actions[m_action_idx]._focus_can_interact())):
        return

    cycle()


## Removes an action from the controller
func unregister(action: BaseFocusable) -> void:
    # Cleanup #
    if action.m_is_focused:
        action.set_focus(false)

    action.__focus_callback_invalidate()

    p_actions.erase(action)
    __restrict_index()

    # Check for empty #
    if !p_actions.is_empty():
        return

    m_action_idx = -1
    emptied.emit()


## Removes invalid actions from the controller
func cleanup() -> void:
    var null_count := 0

    for i: int in range(p_actions.size()):
        if is_instance_valid(p_actions[i]):
            continue

        p_actions[i] = null
        null_count += 1

    if null_count == 0:
        return

    p_actions.sort_custom(func(a, _b): is_instance_valid(a))
    p_actions.resize(p_actions.size() - null_count)


#endregion

#region Control

## Activates the currently in-focus action
func activate() -> void:
    if !__is_valid_index(m_action_idx):
        return

    if !is_instance_valid(p_actions[m_action_idx]):
        m_action_idx = -1
        return

    if !p_actions[m_action_idx]._focus_can_interact():
        return

    p_actions[m_action_idx]._focus_perform()


## Cycles between current focusable elements
func cycle(backwards: bool = false) -> void:
    var action_count := p_actions.size()

    if action_count < 1:
        return

    var previous_idx := m_action_idx
    var success := false

    # Cycle #
    for _attempt in range(action_count):
        # <-- #
        if backwards:
            m_action_idx -= 1

            if m_action_idx < 0:
                m_action_idx = action_count - 1
        # --> #
        else:
            m_action_idx = (m_action_idx + 1) % action_count

        # Validation #
        if (!__is_valid_index(m_action_idx) ||
            !p_actions[m_action_idx]._focus_can_interact()):
            continue

        success = true
        break

    # Notify #
    if !success:
        return

    if __is_valid_index(previous_idx):
        p_actions[previous_idx].set_focus(false)

    if __is_valid_index(m_action_idx):
        p_actions[m_action_idx].set_focus(true)


## Resets the controller's focus state
func deselect() -> void:
    if __is_valid_index(m_action_idx):
        p_actions[m_action_idx].set_focus(false)

    m_action_idx = -1

#endregion

#region Utils

func __is_valid_index(idx: int) -> bool:
    return idx >= 0 && idx < p_actions.size()


func __restrict_index() -> void:
    if m_action_idx == -1:
        return

    cleanup()
    m_action_idx = clamp(m_action_idx, 0, p_actions.size())

#endregion