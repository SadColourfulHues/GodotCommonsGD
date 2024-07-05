## A resource containing detailed information about an item
## [This resource is not expected to change at runtime!]
@tool
class_name ItemDefinition
extends Resource

#region Essential Info

@export_group("Essential")
## The identifier used by the system to track this item type
@export
var m_id: StringName

## The maximum allowed count of this particular item type
@export
var m_max_count: int = 99

## A flag for verifying whether or not this item type can be 'used' by the player
@export
var m_is_usable: bool = false

## An identifier used for finding the appropriate processor when using the item
@export
var m_usability_id: StringName

#endregion

#region UI

@export_group("UI")
## The title text presented to the user in UIs
@export
var m_display_name: String

## A longer text string describing the item to the user (used mostly in UIs)
@export_multiline
var m_display_description: String

## An image that can be used to represent this item in UIs
@export
var p_icon: Texture2D

#endregion

#region Resource Name

func _validate_property(property: Dictionary) -> void:
    Utils.rsyncprop2name(self, &"m_id", property)

#endregion