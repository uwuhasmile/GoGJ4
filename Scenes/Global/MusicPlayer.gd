extends Node

@onready var player: AudioStreamPlayer = $Player;

var last_stream: AudioStream;


func play(p_stream: AudioStream, p_volume: float = 0.0) -> void:
    player.stream = p_stream;
    player.volume_db = p_volume;
    player.play(0.0);
    last_stream = p_stream;


func play_last(p_volume: float = 0.0) -> void:
    player.stream = last_stream;
    player.volume_db = p_volume;
    player.play(0.0);


func is_playing() -> bool:
    return player.playing;


func stop() -> void:
    player.stop();
