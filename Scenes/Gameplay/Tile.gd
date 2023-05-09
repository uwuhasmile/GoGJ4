extends StaticBody2D

const FINISH_SOUND: AudioStream = preload("res://Assets/Sounds/Tiles/tiles_finish.ogg");
const TURN_SOUND: AudioStream = preload("res://Assets/Sounds/Tiles/tiles_turn.ogg");

const ANIMS: Array = [
    &"orange",
    &"cyan",
    &"green",
]

@onready var _sprite: AnimatedSprite2D = $Sprite;
@onready var _collision: CollisionShape2D = $Collision;
@onready var _sound_player: AudioStreamPlayer = $SoundPlayer;

@export_range(1, 3) var count: int = 1;
var _time: int = 0;


func take_damage(_r: DamageResult) -> void:
    if _time >= count:
        return;
        
    _time += 1;
    var anim: StringName = ANIMS[_time];
    if (_time >= count):
        _sound_player.stream = FINISH_SOUND;
        anim = ANIMS[_time - 1] + &"_end";
        _collision.set_deferred(&"disabled", true);
    else:
        _sound_player.stream = TURN_SOUND;
    
    _sprite.play(anim);
    _sound_player.play();
