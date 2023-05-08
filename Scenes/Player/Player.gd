extends CharacterBody2D

const JUMP_BUFFER_TIME: float = 0.2;
const COYOTE_TIME: float = 0.15;

const INVINCIBILITY_TIME: float = 2.5;

@export_range(0.0, 800.0) var move_speed: float = 20.0;

@export var jump_height: float = 70.0;
@export var jump_time_to_peak: float = 2.0;
@export var jump_time_to_descend: float = 1.0;

@export var air_control: float = 0.15;

@onready var jump_velocity: float = (2.0 * jump_height) / jump_time_to_peak;
@onready var jump_gravity: float = (-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak);
@onready var fall_gravity: float = (-2.0 * jump_height) / (jump_time_to_descend * jump_time_to_descend);

@export var dash_time: float = 0.4;
@export var dash_speed: float = 40.0;
@export var attack_time: float = 0.1;
@export var attack_distance: float = 24.0;
@export_flags_2d_physics var attack_mask: int;
@export var attack_shape: Shape2D;

@onready var spawn_position: Vector2 = position;

@onready var _attack_cast: ShapeCast2D = $AttackCast;
@onready var _inv_timer: Timer = $Invincibility;
@onready var _sprite: Sprite2D = $Sprite;

var _wish_dir: float;
var _wants_to_attack: bool;

var _jump_buffer: float;
var _coyote_time: float;
var _jumped: bool;
var _dash_velocity: Vector2;
var _dash_time: float;
var _dashed: bool;

var _in_shock: bool;


func _ready() -> void:
	_in_shock = false;
	_wish_dir = 0.0;
	_wants_to_attack = false;
	_jump_buffer = 0.0;
	_coyote_time = 0.0;
	_dash_velocity = Vector2.ZERO;
	_jumped = false;


func _process(delta: float) -> void:
	_sprite.material.set(&"shader_parameter/active", _inv_timer.time_left > 0.0);
	
	if (_jump_buffer > 0.0):
		_jump_buffer = maxf(_jump_buffer - delta, 0.0);
	
	if (_coyote_time > 0.0):
		_coyote_time = maxf(_coyote_time - delta, 0.0);
	
	if (_dash_time > 0.0):
		_dash_time = maxf(_dash_time - delta, 0.0);
	
	_wish_dir = signf(Input.get_action_strength(&"move_right") - Input.get_action_strength(&"move_left"));
	if (Input.is_action_just_pressed(&"jump")):
		queue_jump();
	_wants_to_attack = Input.is_action_just_pressed(&"attack");


func _physics_process(delta: float) -> void:
	if (_wants_to_attack):
		queue_attack();
	
	if (_dash_time > 0.0):
		_update_attack();
	else:
		if (not is_on_floor() and _coyote_time == 0.0 and not _jumped):
			_coyote_time = COYOTE_TIME;
		velocity.y += _get_gravity() * delta;
		if (is_on_floor()):
			if (_in_shock):
				_in_shock = false;
				move_and_slide();
				return;
			_jumped = false;
			_dashed = false;
			_coyote_time = 0.0;
			velocity.x = _wish_dir * move_speed;
		else:
			velocity.x = lerp(velocity.x, _wish_dir * move_speed, air_control * delta);
	
		velocity.x = move_toward(velocity.x, minf(velocity.x, move_speed * signf(velocity.x)), delta);
	
		if (_jump_buffer > 0.0):
			jump();
	
	move_and_slide();
	position.x = clampf(position.x, 16.0, 464.0);


func jump() -> void:
	if (is_on_floor() or (_coyote_time > 0.0 and not _jumped)):
		_jumped = true;
		velocity.y = -jump_velocity;
		_coyote_time = 0.0;
		_jump_buffer = 0.0;


func queue_jump() -> void:
	if (not _in_shock):
		_jump_buffer = JUMP_BUFFER_TIME;


func queue_attack() -> void:
	if (_in_shock):
		return;
	
	if (_dash_time > 0.0):
		return;
	
	if (velocity.length() > 0.0 and not _dashed):
		_dashed = true;
		_dash_time = dash_time;
		_dash_velocity.x = signf(_wish_dir if _wish_dir != 0.0 else (velocity.x));
	elif (not _dashed):
		_dashed = true;
		_dash_time = attack_time;
		_dash_velocity = Vector2.ZERO;


func _on_taken_damage(result: DamageResult) -> void:
	if (_inv_timer.time_left > 0.0 or _dash_time > 0.0):
		return;
	_in_shock = true;
	_inv_timer.start(INVINCIBILITY_TIME);
	velocity.y = -700.0;
	velocity.x = -result.hit_velocity.x;


func _update_attack() -> void:
	velocity = _dash_velocity * dash_speed;
	var dir: Vector2 = (velocity.sign() if velocity.x != 0.0 else Vector2.UP);
	_attack_cast.target_position = dir * attack_distance;
	if (_attack_cast.is_colliding() and _attack_cast.get_collider(0).has_method(&"push")):
		_attack_cast.get_collider(0).push(dir, 500.0 if velocity.x == 0.0 else absf(velocity.x));
		_dash_time = 0.0;


func _get_gravity() -> float:
	return -(jump_gravity if velocity.y < 0.0 else fall_gravity);


