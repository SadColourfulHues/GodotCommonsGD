## A helper resource for implementing drop chances
class_name LootTable
extends Resource

## Use to compare against [pick] to see if it failed to yield a result
const VALUE_NO_PICKS := &"__invalid"

static var p_rng := RandomNumberGenerator.new()

@export
var p_loot: Dictionary[StringName, float]

var p_weights: Array[float]
var m_weight_sum := 0.0

#region Utilities

## Returns an ID from the [loot] array with the a weighted chance
## (Could return [VALUE_NO_PICKS] if no picks were made.)
func pick() -> StringName:
    initialise()

    if p_weights.size() == 0:
        return VALUE_NO_PICKS

    var roll := p_rng.randf() * m_weight_sum

    for i in range(p_loot.size()):
        if p_weights[i] < roll:
            continue

        return p_loot.keys()[i]

    return VALUE_NO_PICKS


## Updates the internal 'weights' array
## (This is called automatically by [LootTable])
func initialise() -> void:
    var size := p_loot.size()

    if size == 0 || p_weights.size() == size:
        return

    var keys := p_loot.keys()

    p_weights.resize(size)

    var total_weight := 0.0

    for i in range(size):
        total_weight += p_loot[keys[i]]
        p_weights[i] = total_weight

    m_weight_sum = total_weight

#endregion