extends Resource
class_name BulletData

@export var texture: Texture2D;
@export var shape: CircleShape2D;
@export var regular_color: Color = Color.WHITE;
@export var graze_color: Color = Color.YELLOW;
@export var move_speed: float = 200.0;
@export var rotation_speed: float = 5.0;
@export var max_distance: float = 2000.0;
@export var orb_kills: bool = true;
