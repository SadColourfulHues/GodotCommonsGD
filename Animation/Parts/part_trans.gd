## Defines a component for handling switching between various animation "states"
@tool
class_name AnimatorPartTransition
extends AnimatorPart

@export_group("Transition")
## If set to 'true', the generated node will contain a 'default' state pointing to the previous node.
## If it's not available, this option will be ignored.
@export
var m_add_previous := false

@export
var p_states: Dictionary[StringName, AnimatorInput]

@export
var m_default_state: StringName

@export_category("Parameters")
@export
var m_fade := 0.0

@export
var m_allow_transition_to_self := false

@export
var m_custom_fade_curve: Curve


#region Part

func _init(id: StringName = &"", states: Dictionary[StringName, AnimatorInput] = {}) -> void:
	m_id = id

	if states.is_empty():
		return

	p_states = states


func generate(_animator: AnimationTree) -> AnimationNode:
	var node := AnimationNodeTransition.new()
	var base := 0

	node.xfade_time = m_fade
	node.xfade_curve = m_custom_fade_curve
	node.allow_transition_to_self = m_allow_transition_to_self

	node.input_count = p_states.size()

	if m_add_previous:
		node.input_count += 1
		base = 1
		node.set_input_name(0, &"default")

	var state_names := p_states.keys()

	for i: int in range(p_states.size()):
		node.set_input_name(base + i, state_names[i])

	return node


func connect_inputs(previous_id: StringName, root: AnimationNodeBlendTree) -> void:
	var base := 0

	if m_add_previous && !previous_id.is_empty():
		root.connect_node(m_id, 0, previous_id)
		base = 1

	var inputs := p_states.values()

	for i: int in range(p_states.size()):
		__connect(root, inputs[i], base + i)


func apply_default_value(animator: AnimationTree) -> void:
	if !m_default_state.is_empty():
		animator.set(&"parameters/%s/transition_request" % m_id, m_default_state)
		return

	if !m_add_previous:
		return

	animator.set(&"parameters/%s/transition_request" % m_id, &"default")


#endregion

#region Properties

func with_fade(time: float, curve: Curve = null) -> AnimatorPartTransition:
	m_fade = time

	if curve != null:
		m_custom_fade_curve = curve

	return self

#endregion

#region Resource Name

func _validate_property(property: Dictionary) -> void:
	if !Engine.is_editor_hint() || property[&"name"] != &"m_id":
		return

	resource_name = "FSM \"%s\"" % m_id
	emit_changed()

#endregion