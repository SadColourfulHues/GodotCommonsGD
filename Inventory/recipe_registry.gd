## A resource containing all possible crafting recipes in the game
class_name RecipeRegistry
extends Resource

@export
var p_entries: Array[RecipeDefinition]


#region Main Fns

## Returns a RecipeDefinition for a specified item ID [Returns null if nothing was found.]
func get_definition(id: StringName) -> RecipeDefinition:
    var idx := p_entries.find_custom(__match_callback.bind(id))

    if idx == -1:
        return null

    return p_entries[idx]


## Queries as to whether or not the specified item is craftable in the given bag
func can_craft(item_id: StringName, bag: ItemBag, multiplier: int = 1) -> bool:
    var idx := p_entries.find_custom(__match_callback.bind(item_id))

    if idx == -1:
        return false

    return p_entries[idx].can_craft(bag, multiplier)


## Tries to craft the specified item in the given bag
func craft(item_id: StringName, bag: ItemBag, multiplier: int = 1) -> bool:
    var idx := p_entries.find_custom(__match_callback.bind(item_id))

    if idx == -1:
        return false

    return p_entries[idx].craft(bag, multiplier)


## Returns an array of recipes that include the specified ingredient item
func get_definitions_using(ingredient_id: StringName) -> Array[RecipeDefinition]:
    return p_entries.filter(func(recipe: RecipeDefinition):
        return recipe.has_ingredient(ingredient_id)
    )

#endregion

#region Utils

func __match_callback(recipe: RecipeDefinition, id: StringName) -> bool:
    return recipe.m_output_id == id

#endregion