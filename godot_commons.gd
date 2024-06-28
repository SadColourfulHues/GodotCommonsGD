## Basically GodotCommons + extras for GDscript
class_name Utils

#region Maths Utils

## Alternate smoothing function.
## (Decay should be a value ranging between 1 (slow) to 25 (fast))
## [From https://www.youtube.com/watch?v=LSNQuFEDOyQ]
static func fhexpdecay(a: float, b: float, decay: float, delta: float) -> float:
	return b + (a - b) * exp(-decay * delta)

#endregion

#region 3D Utils

## ([Transform3D]setfwd) Sets the 'forward' axis of a specified transform.
static func t3dsetfwd(transform: Transform3D, forward: Vector3, weight: float = 0.1, up: Vector3 = Vector3.UP) -> Transform3D:
	var new_trans := transform
	new_trans.basis.z = forward
	new_trans.basis.y = up
	new_trans.basis.x = up.cross(forward)
	new_trans.basis = new_trans.basis.orthonormalized()

	return transform.interpolate_with(new_trans, weight)


## Linearly interpolates the XZ members of two Vector3s
static func xzlerp(a: Vector3, b: Vector3, fac: float) -> Vector3:
	return Vector3(
		lerp(a.x, b.x, fac),
		a.y,
		lerp(a.z, b.z, fac)
	)


## Returns a Vector3 that has its XZ values scaled by a value
static func xzscale(v: Vector3, scale: float) -> Vector3:
	return Vector3(v.x * scale, v.y, v.z * scale)


## Returns a flat normalised Vector3 along the XZ axes
static func xzflatten(v: Vector3) -> Vector3:
	return Vector3(v.x, 0.0, v.z).normalized()

#endregion

#region Animation

## ([Tween]init) Initialises a tween for use [Stops currently-running interpolations if the 'tween' reference is valid and active.]
static func twinit(owner: Node, tween: Tween) -> Tween:
	if is_instance_valid(tween) && tween.is_running():
		tween.kill()

	tween = owner.create_tween()
	return tween


## ([AnimationTree]blend) Blends an animation tree property with a specified value and weight
static func atblend(tree: AnimationTree, path: StringName, value: Variant, weight: float) -> void:
	var previous_value = tree.get(path)
	tree.set(path, lerp(previous_value, value, weight))


## Returns a pointer to a named AnimationNode in the specified tree's root.(Returns null if the root is null or if the node is nonexistent.)
static func atgetnode(tree: AnimationTree, node_name: StringName) -> AnimationNode:
	if !is_instance_valid(tree.tree_root):
		return null

	var root := tree.tree_root

	if !root.has_node(node_name):
		return null

	return root.get_node(node_name)


## Returns the root motion 'velocity' of the specified [tree] relative to the [target]'s current rotation.
static func atgetrootmotion(target: Node3D, tree: AnimationTree, delta: float, apply_rotation: bool = true) -> Vector3:
	var rotation := target.quaternion * tree.get_root_motion_rotation()

	if apply_rotation:
		target.quaternion = rotation

	return ((tree.get_root_motion_rotation_accumulator().inverse() * rotation)
		* tree.get_root_motion_position() / delta)

#endregion
