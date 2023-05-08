extends Sprite2D
class_name OrbHolder

@onready var hold_timer: Timer = $HoldTimer;
@onready var collision: ShapeCast2D = $Collision;
@onready var cooldown: Timer = $Cooldown;

@export var move_to_holders: Array[NodePath] = [];
@export var spawn_velocity: Vector2 = Vector2(500.0, 0.0);

@export var min_hold_time: float = 0.9;
@export var max_hold_time: float = 1.3;

@onready var _holders: Array = move_to_holders.map(get_node);

var _orb: PlayerOrb;


func _physics_process(_delta: float) -> void:
	if (cooldown.time_left > 0.0):
		return;
	
	if (collision.is_colliding()
			and collision.get_collider(0) is PlayerOrb):
		var holder: OrbHolder = self;
		if (_holders.size() > 0):
			holder = _holders[randi_range(0, move_to_holders.size() - 1)];
		holder.hold(collision.get_collider(0) as PlayerOrb);


func hold(orb: PlayerOrb) -> void:
	_orb = orb;
	_orb.disable();
	_orb.global_position = global_position;
	_orb.teleport(global_position);
	_orb.visible = false;
	hold_timer.start(randf_range(min_hold_time, max_hold_time));


func release() -> void:
	cooldown.start();
	_orb.enable();
	_orb.linear_velocity = spawn_velocity;
	hold_timer.stop();
	_orb.visible = true;
	_orb = null;
