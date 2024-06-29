## A resource used by SCHLib's audio system to handle playback of named audio items
class_name AudioLibrary
extends Resource

@export
var p_items: Array[AudioItem]

#region Methods

## Returns an AudioItem at the specified index. [Returns null on invalid indices.]
func get_audio_item_by_index(index: int) -> AudioItem:
    if index < 0 || index >= p_items.size():
        return null
    return p_items[index]


## Returns the first AudioItem named [id]
func get_audio_item(id: StringName) -> AudioItem:
    for item: AudioItem in p_items:
        if item.m_id != id:
            continue
        return item
    return null


## Returns the AudioStream of the first AudioItem named [id]
func get_stream(id: StringName) -> AudioStream:
    var item := get_audio_item(id)

    if item == null:
        return null

    return item.get_stream()

#endregion