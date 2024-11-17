## A high-level controller for AnimationTree-based animators
## (Note: the purpose of this node is to provide an (often) faster-to-setup alternative to
## creating blend trees, one that DOESN'T include the graph editor
@tool
class_name Animator
extends AnimationTree

@export_tool_button("Pre-Generate", "AnimationTree")
var editor_pregen_button = __editor_generate_tree_action

@export
var p_parts: Array[AnimatorPart]

var p_key_paths: Dictionary[StringName, StringName]


#region Events

func _ready() -> void:
    if Engine.is_editor_hint():
        return

    apply_default_values()
    p_parts.clear()


#endregion

#region Main Functions

## Generates a blend tree and clears the parts array
func generate(root_id_override: StringName = &"") -> void:
    var part_count := p_parts.size()

    if part_count < 1:
        printerr("Animator: warning: empty parts on tree generation")
        return

    # Prepare parts #
    var root := AnimationNodeBlendTree.new()

    for part: AnimatorPart in p_parts:
        var node := part.generate(self)
        root.add_node(part.m_id, node)

    # Finalise inputs #
    if part_count == 1:
        p_parts[0].connect_inputs(&"", root)
    else:
        for i: int in range(part_count):
            p_parts[i].connect_inputs(&"" if i == 0 else p_parts[i-1].m_id, root)

    if root_id_override.is_empty():
        root.connect_node(&"output", 0, p_parts[-1].m_id)
    else:
        root.connect_node(&"output", 0, root_id_override)

    if !Engine.is_editor_hint():
        p_parts.clear()

    tree_root = root
    apply_default_values.call_deferred()


## Sets parameters to their default value
func apply_default_values() -> void:
    for part: AnimatorPart in p_parts:
        part.apply_default_value(self)


#endregion

#region Utils

func __get_key(property_id: StringName, path_format: StringName) -> StringName:
    if !p_key_paths.has(property_id):
        var path := StringName(path_format % property_id)
        p_key_paths[property_id] = path

        return path

    return p_key_paths[property_id]


func __editor_generate_tree_action() -> void:
    if !Engine.is_editor_hint():
        return

    generate()

#endregion

#region Setters

func action_fire(id: StringName) -> void:
    set(__get_key(id, &"parameters/%s/request"), AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)


func action_stop(id: StringName) -> void:
    set(__get_key(id, &"parameters/%s/request"), AnimationNodeOneShot.ONE_SHOT_REQUEST_ABORT)


func action_fade_out(id: StringName) -> void:
    set(__get_key(id, &"parameters/%s/request"), AnimationNodeOneShot.ONE_SHOT_REQUEST_FADE_OUT)


func trans_set_state(id: StringName, state: StringName) -> void:
    set(__get_key(id, &"parameters/%s/transition_request"), state)


func set_blend(id: StringName, fac: float) -> void:
    set(__get_key(id, &"parameters/%s/blend_amount"), fac)


func set_blendspace(id: StringName, value: float) -> void:
    set(__get_key(id, &"parameters/%s/blend_position"), value)


func set_blendspace_2d(id: StringName, value: Vector2) -> void:
    set(__get_key(id, &"parameters/%s/blend_position"), value)


func set_time_scale(id: StringName, scale: float) -> void:
    set(__get_key(id, &"parameters/%s/scale"), scale)


func lerp_blend(id: StringName, fac: float, weight: float = 0.1) -> void:
    var key := __get_key(id, &"parameters/%s/blend_amount")
    return set(key, lerp(float(get(key)), fac, weight))


func lerp_blendspace(id: StringName, fac: float, weight: float = 0.1) -> void:
    var key := __get_key(id, &"parameters/%s/blend_position")
    return set(key, lerp(float(get(key)), fac, weight))


func lerp_blendspace_2d(id: StringName, fac: Vector2, weight: float = 0.1) -> void:
    var key := __get_key(id, &"parameters/%s/blend_position")
    return set(key, Vector2(get(key)).lerp(fac, weight))


func lerp_time_scale(id: StringName, fac: float, weight: float = 0.1) -> void:
    var key := __get_key(id, &"parameters/%s/scale")
    return set(key, lerp(float(get(key)), fac, weight))


#endregion