## A resource defining a playable audio item
## [This resource is not expected to change at runtime!]
class_name AudioItem
extends Resource

## Set this to an audio file for single-stream mode
@export
var p_single_sample: AudioStream

## Add at least one audio file to this array for multi-stream mode
## [Setting this value has priority over 'single sample'.]
@export
var p_multi_sample: Array[AudioStream]


#region Methods

## Returns a playable sample from this audio item
## (If at least one entry exists in the [multi sample] array, the stream will be drawn randomly from there)
func get_stream() -> AudioStream:
    if p_multi_sample.size() < 1:
        return p_single_sample

    return p_multi_sample.pick_random()

#endregion