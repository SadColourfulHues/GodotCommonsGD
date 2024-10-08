## A resource used by SCHLib's audio system to handle playback of named audio items
class_name AudioLibrary
extends Resource

@export
var p_entries: Dictionary[StringName, AudioItem]

#region Methods

## Returns the first AudioItem named [id]
func get_audio_item(id: StringName) -> AudioItem:
    if !p_entries.has(id):
        return null

    return p_entries[id]


## Returns the AudioStream of the first AudioItem named [id]
func get_stream(id: StringName) -> AudioStream:
    if !p_entries.has(id):
        return null

    return p_entries[id].get_stream()

#endregion