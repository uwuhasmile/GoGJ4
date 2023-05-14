extends Node

@export var stream: AudioStream;
@export var only_if_not_playing: bool = true;
@export var auto_play: bool = false;


func _ready() -> void:
    if (auto_play):
        play(0.0);


func play(p_volume: float = 0.0) -> void:
    if (only_if_not_playing
            and MusicPlayer.last_stream == stream
            and MusicPlayer.is_playing()):
        return;
    MusicPlayer.play(stream, p_volume);


func play_last(p_volume: float = 0.0) -> void:
    if MusicPlayer.last_stream == null:
        MusicPlayer.play(stream, p_volume);
    else:
        MusicPlayer.play_last(p_volume);
