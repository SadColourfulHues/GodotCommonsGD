## An object representing an entry slot in an ItemBag
class_name ItemEntry
extends Object

## The item ID associated with this entry
var m_id: StringName

## The current item count of this entry
var m_count: int


## Use with Array::sort
static func sort_callback(a: ItemEntry, b: ItemEntry) -> bool:
    return a.m_id < b.m_id