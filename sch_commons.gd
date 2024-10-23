## A collection of utilities that are relevant to my current game-dev workflow
class_name SCHUtils

#region Checks

## ([InputEvent]ButtonGuard)
## Returns true if [event] is not a button-press event (key/controller/mouse)
## (Meant to be used as a guard condition)
static func iebuttonguard(event: InputEvent) -> bool:
	return (
		event is not InputEventKey &&
		event is not InputEventJoypadButton &&
		event is not InputEventMouseButton
	)


## ([InputEvent]SetActionCallback)
## Assigns a button-press handler action [func(e: InputEvent) -> bool]
## [callback] should return true if an action is successfully performed.
## Call on [_input] or [_unhandled_input]
static func iesetactioncallback(event: InputEvent,
								viewport: Viewport,
								callback: Callable) -> void:

	if iebuttonguard(event) || !callback.call(event):
		return

	viewport.set_input_as_handled()

#endregion