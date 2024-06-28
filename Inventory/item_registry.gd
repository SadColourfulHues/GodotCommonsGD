## A resource containing all possible item entry definitions in the game.
## [This resource is not expected to change at runtime!]
class_name ItemRegistry
extends Resource

@export
var p_entries: Array[ItemDefinition]


## Returns an ItemDefinition for a specified item ID [Returns null if nothing was found.]
func get_definition(id: StringName) -> ItemDefinition:
    for item: ItemDefinition in p_entries:
        if item.m_id != id:
            continue

        return item
    return null