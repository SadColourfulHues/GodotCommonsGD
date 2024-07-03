## An intermediary resource for audio playback
class_name AudioPlayback
extends Resource

#region Signals

signal on_request_stream_np_playback(
    stream: AudioStream,
    volume: float,
    max_pitch_variance: float,
    bus: StringName
)

signal on_request_item_np_playback(
    id: StringName,
    volume: float,
    max_pitch_variance: float,
    bus: StringName
)

signal on_request_stream_2d_playback(
    stream: AudioStream,
    position: Vector2,
    volume: float,
    max_pitch_variance: float,
    max_distance_mod: float,
    bus: StringName
)

signal on_request_item_2d_playback(
    id: StringName,
    position: Vector2,
    volume: float,
    max_pitch_variance: float,
    max_distance_mod: float,
    bus: StringName
)

signal on_request_stream_3d_playback(
    stream: AudioStream,
    position: Vector3,
    volume: float,
    max_pitch_variance: float,
    max_distance_mod: float,
    unit_size_mod: float,
    bus: StringName
)

signal on_request_item_3d_playback(
    id: StringName,
    position: Vector3,
    volume: float,
    max_pitch_variance: float,
    max_distance_mod: float,
    unit_size_mod: float,
    bus: StringName
)

@export
var m_default_bus: StringName = &"Master"

#endregion

#region Methods

## Requests a playback handler to play an AudioStream non-positionally
func play_stream(stream: AudioSample,
                volume: float = 1.0,
                max_pitch_variance: float = 0.0,
                bus = m_default_bus) -> void:

    on_request_stream_np_playback.emit(
        stream,
        volume,
        max_pitch_variance,
        bus
    )


## Requests a playback handler to play an AudioStream at a specified point in 2D space
func play_stream_2d(stream: AudioSample,
                position: Vector2,
                volume: float = 1.0,
                max_pitch_variance: float = 0.0,
                max_distance_mod: float = 1.0,
                bus = m_default_bus) -> void:

    on_request_stream_2d_playback.emit(
        stream,
        position,
        volume,
        max_pitch_variance,
        max_distance_mod,
        bus
    )


## Requests a playback handler to play an AudioStream at a specified point in 3D space
func play_stream_3d(stream: AudioSample,
                position: Vector3,
                volume: float = 1.0,
                max_pitch_variance: float = 0.0,
                max_distance_mod: float = 1.0,
                unit_size_mod: float = 1.0,
                bus = m_default_bus) -> void:

    on_request_stream_3d_playback.emit(
        stream,
        position,
        volume,
        max_pitch_variance,
        max_distance_mod,
        unit_size_mod,
        bus
    )


## Requests a playback handler to play a named audio item non-positionally
func play_item(id: StringName,
                volume: float = 1.0,
                max_pitch_variance: float = 0.0,
                bus = m_default_bus) -> void:

    on_request_item_np_playback.emit(
        id,
        volume,
        max_pitch_variance,
        bus
    )


## Requests a playback handler to play a named audio item at a specified point in 2D space
func play_item_2d(id: StringName,
                position: Vector2,
                volume: float = 1.0,
                max_pitch_variance: float = 0.0,
                max_distance_mod: float = 1.0,
                bus = m_default_bus) -> void:

    on_request_item_2d_playback.emit(
        id,
        position,
        volume,
        max_pitch_variance,
        max_distance_mod,
        bus
    )


## Requests a playback handler to play a named audio item at a specified point in 3D space
func play_item_3d(id: StringName,
                position: Vector3,
                volume: float = 1.0,
                max_pitch_variance: float = 0.0,
                max_distance_mod: float = 1.0,
                unit_size_mod: float = 1.0,
                bus = m_default_bus) -> void:

    on_request_item_3d_playback.emit(
        id,
        position,
        volume,
        max_pitch_variance,
        max_distance_mod,
        unit_size_mod,
        bus
    )

#endregion