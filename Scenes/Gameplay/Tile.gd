extends StaticBody2D

const ANIMS: Array = [
	&"orange",
	&"cyan",
	&"green",
]

@onready var sprite: AnimatedSprite2D = $Sprite;
@onready var collision: CollisionShape2D = $Collision;

@export_range(1, 3) var count: int = 1;
var _time: int = 0;


func take_damage(_r: DamageResult) -> void:
	_time += 1;
	if (_time >= count):
		sprite.play(ANIMS[_time - 1] + &"_end");
		collision.set_deferred(&"disabled", true);
	else:
		sprite.play(ANIMS[_time]);
