extends Node

@onready var player: AudioStreamPlayer = $Player;

var last_stream: AudioStream;

func play(stream: AudioStream, vol: float = 0.0) -> void:
    player.stream = stream;
    player.volume_db = vol;
    player.play(0.0);
    last_stream = stream;


func play_last(vol: float = 0.0) -> void:
    player.stream = last_stream;
    player.volume_db = vol;
    player.play(0.0);


func is_playing() -> bool:
    return player.playing;


func stop() -> void:
    player.stop();
