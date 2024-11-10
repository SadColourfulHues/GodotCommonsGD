## Defines a component for playing one-shot animation actions
@tool
class_name AnimatorPartOneShot
extends AnimatorPart

@export_group("Action")
@export
var m_original: AnimatorInput

@export
var m_animation: AnimatorInput

@export_category("Parameters")
@export
var m_fade_in: float = 0.0

@export
var m_fade_out: float = 0.0

@export
var m_break_loop := false

@export
var m_custom_fade_in_curve: Curve

@export
var m_custom_fade_out_curve: Curve


#region Part

func _init(id: StringName = &"",
		original: AnimatorInput = null,
		action: AnimatorInput = null) -> void:

	m_id = id
	m_original = original
	m_animation = action


func generate(_animator: AnimationTree) -> AnimationNode:
	var node := AnimationNodeOneShot.new()

	node.fadein_time = m_fade_in
	node.fadeout_time = m_fade_out
	node.fadein_curve = m_custom_fade_in_curve
	node.fadeout_curve = m_custom_fade_out_curve
	node.break_loop_at_end = m_break_loop

	return node


func connect_inputs(previous_id: StringName, root: AnimationNodeBlendTree) -> void:
	__connect_as_input(previous_id, root, m_original, 0)
	__connect(root, m_animation, 1)


#endregion

#region Properties

func with_fade_in(time: float, curve: Curve = null) -> AnimatorPartOneShot:
	m_fade_in = time

	if curve != null:
		m_custom_fade_in_curve = curve

	return self


func with_fade_out(time: float, curve: Curve = null) -> AnimatorPartOneShot:
	m_fade_out = time

	if curve != null:
		m_custom_fade_out_curve = curve

	return self


#endregion

#region Resource Name

func _validate_property(property: Dictionary) -> void:
	if !Engine.is_editor_hint() || property[&"name"] != &"m_id":
		return

	resource_name = "ACTION \"%s\"" % m_id
	emit_changed()

#endregion