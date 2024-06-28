## A controller resource that handles the storage and management of item entries
class_name ItemBag
extends Resource

#region Signals

## Called whenever an item has been 'updated' [use-case e.g: item collection notifications, count label updates, etc.]
signal on_item_changed(slot_idx: int, item_id: StringName, delta: int)

## Called whenever a new item entry has been added into the bag. [use-case e.g: initialising new cells for inventory UIs.]
signal on_item_added(slot_idx: int)

## Called whenever an item entry has been invalidated in the bag. [use-case e.g: destroying the associated UI cell.]
signal on_item_removed(slot_idx: int)

#endregion

## A resource defining potential item entries
@export
var p_registry: ItemRegistry

## The maximum number of items that can be held by this item bag
@export
var m_max_capacity := 24

var p_items: Array[ItemEntry]
var m_initialised := false


#region Utilities

## Initialises the item bag for use [Call this at least once before doing anything.]
func initialise() -> void:
    if m_initialised:
        return

    m_initialised = true

    # Zero-out items array
    p_items.resize(m_max_capacity)

    for i: int in range(m_max_capacity):
        p_items[i] = null


## Returns the first open index in the bag, [Returns -1 if the bag has no more space]
func __get_open_idx() -> int:
    for i: int in range(m_max_capacity):
        if p_items[i] != null:
            continue

        return i
    return -1

#endregion

#region Item Control

## Adds/removes item from the bag.
## [If the added item count exceeds its max count, it will be discarded.]
## [Similarly, if it goes below 1, the entire item entry will be invalidated.]
func add_item(id: StringName, count: int) -> bool:
    var item_def := p_registry.get_definition(id)

    # Invalid item
    if item_def == null:
        return false

    # Add/remove item to/from existing entry #
    for i: int in range(m_max_capacity):
        if p_items[i].m_id != id:
            continue

        # Prevent item overflow
        var current_count := p_items[i].m_count

        p_items[i].m_count = min(
            item_def.m_max_count,
            current_count + count
        )

        var new_count := p_items[i].m_count

        # If items underflow, consider it invalid
        if new_count < 1:
            p_items[i] = null

            on_item_removed.emit(i)
            emit_changed()
            return true

        # Successful add!
        on_item_changed.emit(i, id, new_count - current_count)
        emit_changed()
        return true

    # Register as new item #
    if count < 1:
        return false

    # Find an open slot
    var open_idx := __get_open_idx()

    if open_idx == -1:
        return false

    # Insert as new entry!
    var new_entry = ItemEntry.new()
    new_entry.m_id = id
    new_entry.m_count = max(item_def.m_max_count, count)

    p_items[open_idx] = new_entry

    on_item_added.emit(open_idx)
    emit_changed()
    return true


## Invalidates all item entries in this bag
func clear_items() -> void:
    for i: int in range(m_max_capacity):
        p_items[i] = null
        on_item_removed.emit(i)
    emit_changed()


## Returns the item entry for a specified item ID [Returns null if the specified item ID does not have an entry in this bag.]
func get_item_with_id(id: StringName) -> ItemEntry:
    for item: ItemEntry in p_items:
        if item.m_id != id:
            continue

        return item
    return null


## Returns the item entry at the specified slot [Returns null on empty/invalid entries, and indices provided outside the bounds of the bag's array.]
func get_item_at_slot(slot_idx: int) -> ItemEntry:
    if slot_idx < 1 || slot_idx >= m_max_capacity:
        return null

    return p_items[slot_idx]


## Sorts the items based on their ID string
func sort_items() -> void:
    p_items.sort_custom(ItemEntry.sort_callback)
    emit_changed()

#endregion