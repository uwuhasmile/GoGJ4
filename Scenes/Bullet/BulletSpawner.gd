extends Node2D

const BULLET_SCENE: PackedScene = preload("res://Scenes/Bullet/Bullet.tscn");

@export var max_bullets: int = 2048;
@export var data: Array[BulletData] = [];
@export var speed_change_curves: Array[Curve] = [];
@export var rot_change_curves: Array[Curve] = [];

@export_group("Pattern: Turn")
@export var num_turns: int = 0;
@export var turn_interval_min: float = 0.7;
@export var turn_interval_max: float = 0.8;
@export var rot_speed: float = 15.0;
@export var arc_angle: float = 360.0;

@export_group("Pattern: Spawn")
@export var num_spawns: int = 1;
@export var num_bullets: int = 5;
@export var spawn_interval_min: float = 0.1;
@export var spawn_interval_max: float = 0.2;
@export var spawn_sound: AudioStream;

@export_subgroup("Iteration")
@export var num_iteration_bullets: int = 1;
@export var angle_variation_min: float = -15.0;
@export var angle_variation_max: float = 15.0;
@export var spawn_radius_min: float = 32.0;
@export var spawn_radius_max: float = 47.0;

@onready var _spawn_timer: Timer = $SpawnTimer;
@onready var _turns_timer: Timer = $TurnsTimer;
@onready var _sound_player: AudioStreamPlayer = $SoundPlayer;

var spawn_angle: float = 0.0;

var _pooler: NodePooler;

var _turns: int = 0;
var _spawns: int = 0;


func _ready() -> void:
    _pooler = NodePooler.new(self, BULLET_SCENE, max_bullets);
    _sound_player.stream = spawn_sound;


func play_spawn() -> void:
    assert(is_instance_valid(_pooler));
    
    var step: float = deg_to_rad(arc_angle) / num_bullets;
    
    for i in num_bullets:
        var radius: float = randf_range(spawn_radius_min, spawn_radius_max);
        
        for j in num_iteration_bullets:
            var bullet: Bullet = get_bullet();
            var curr_data: BulletData = data.pick_random();
            var curr_speed_curve: Curve = null;
            if (speed_change_curves.size() > 0):
                curr_speed_curve = speed_change_curves.pick_random();
            var curr_rot_curve: Curve = null;
            if (rot_change_curves.size() > 0):
                curr_rot_curve = rot_change_curves.pick_random();
            var angle: float = step * i \
                    + deg_to_rad(randf_range(angle_variation_min, angle_variation_max));
            var pos: Vector2 = Vector2(radius, 0.0) \
                    .rotated(angle).rotated(spawn_angle).rotated(rotation);
            bullet.spawn(position + pos, pos.angle(), curr_data, curr_speed_curve, curr_rot_curve);
            
        spawn_angle += deg_to_rad(rot_speed);
    _sound_player.play();


func play_turn(p_finished: Callable = func() -> void: return) -> void:
    _spawns = 0;
    _spawn_timer.timeout.connect(_play_turn_internal.bind(p_finished));
    _play_turn_internal(p_finished);


func get_bullet() -> Bullet:
    assert(is_instance_valid(_pooler));
    
    var result: Bullet = _pooler.grab() as Bullet;
    result.pooler = _pooler;
    if (not result.is_inside_tree()):
        add_child(result);
        result.top_level = true;
    
    return result;


func play(p_delayed: bool = false) -> void:
    _turns_timer.timeout.connect(play_turn.bind(_play_internal));
    
    if (p_delayed):
        _turns_timer.start(randf_range(turn_interval_min, turn_interval_max));
    else:
        play_turn(_play_internal);


func _play_turn_internal(p_finished: Callable) -> void:
    if (num_spawns > 0 and _spawns == num_spawns):
        _spawns = 0;
        _spawn_timer.timeout.disconnect(_play_turn_internal);
        if (p_finished):
            p_finished.call();
    else:
        _spawns += 1;
        play_spawn();
        _spawn_timer.start(randf_range(spawn_interval_min, spawn_interval_max));


func _play_internal() -> void:
    _turns += 1;
    if (num_turns > 0 and _turns == num_turns):
        _turns = 0;
        _turns_timer.timeout.disconnect(play_turn);
    else:
        _turns_timer.start(randf_range(turn_interval_min, turn_interval_max));
        

func stop() -> void:
    _turns = 0;
    _spawns = 0;
    if (_turns_timer.timeout.is_connected(play_turn)):
        _turns_timer.timeout.disconnect(play_turn);
    if (_spawn_timer.timeout.is_connected(_play_turn_internal)):
        _spawn_timer.timeout.disconnect(_play_turn_internal);
    _turns_timer.stop();
    _spawn_timer.stop();
