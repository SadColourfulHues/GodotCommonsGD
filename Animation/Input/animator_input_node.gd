## An input node that resolves to a particular node in the tree
@tool
class_name AnimatorInputNode
extends AnimatorInput

@export
var m_target_id: StringName


#region Input

func _init(target: StringName = &"") -> void:
	m_target_id = target


func generate(root: AnimationNodeBlendTree) -> AnimationNode:
	if !root.has_node(m_target_id):
		printerr("AnimatorInputNode: invalid node \"%s\"" % m_target_id)
		return super.generate(root)

	return super.generate(root)

#endregion

#region Resource Name

func _validate_property(property: Dictionary) -> void:
	if !Engine.is_editor_hint() || property[&"name"] != &"m_target_id":
		return

	resource_name = "^%s^" % m_target_id
	emit_changed()

#endregion