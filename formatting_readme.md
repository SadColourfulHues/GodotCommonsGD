# Godot Commons: GDscript Formatting Guidelines!

## Order and Naming

1. Class header (`class_name`, `extends`, `tool`, etc.)
2. Enums
3. Constants
4. Exports
5. Class Members
6. Onready Variables
7. Functions
    8. Godot Events (`_ready`, `_process`, etc.)
    9. Event Handlers (`_on_area_entered`, etc.)
    10. Public Methods (`play_action`, `is_doing_stuff`, etc.)
    11. Private Methods (`__handle_input`, `__do_stuff`, etc.)
    12. Static Functions

(Try adding as much region blocks as possible to help improve navigation in VScode.)

Constants should be in ALL-CAPS.

```gdscript
const BLEND_WALK := &"parameters/walk/blend_amount"
const OS_ACTION := &"parameters/action/request"
const KEY_POSITION := &"position"
```

Member-bound variables are prefixed with `m_`

```gdscript
var m_current_state: State
var m_max_distance: float
var m_name: String
```

Variables that make references to objects or resources are prefixed with `p_`

```gdscript
var p_icon: Texture2D
var p_node_list: Array[Node]
```

## Spacing

```gdscript
class_name SampleClass
extends Node3D

# One space between class header lines #
const MAX_DISTANCE := 32.0
const ANOTHER_CONST := 100.0

@export
var p_some_node_ref: Node

@export
var m_speed: float = 3.0

#region Events

# Two spaces between functions
# One space between region blocks as padding
func _ready() -> void:
    pass


func within_distance(other: Node3D) -> bool:
    return global_position.distance_to(other) < MAX_DISTANCE

#endregion


# Complex functions can be broken up into multiple lines
# When aligning prefer leaning towards the 'left' side of
# the first parameter tab.
func complex_function(a: float,
                    b: float,
                    c: float,
                    d: SomeFancyEnum) -> float:

    # One space before the first func line for readability
    pass
```