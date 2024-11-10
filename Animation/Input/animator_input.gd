## Base class for input nodes to be used on [AnimatorPart]s
class_name AnimatorInput
extends Resource

#region Input

## Use this function to generate the animation node associated with this part
@warning_ignore("unused_parameter")
func generate(root: AnimationNodeBlendTree) -> AnimationNode:
    return AnimationNode.new()

#endregion