extends Sprite2D
class_name OrbHolder

const HOLD_SOUND: AudioStream = preload("res://Assets/Sounds/OrbHolder/orb_holder_hold.ogg");
const RELEASE_SOUND: AudioStream = preload("res://Assets/Sounds/OrbHolder/orb_holder_release.ogg");

@onready var _hold_timer: Timer = $HoldTimer;
@onready var _collision: ShapeCast2D = $Collision;
@onready var _cooldown: Timer = $Cooldown;
@onready var _sound_player: AudioStreamPlayer2D = $SoundPlayer;

@export var move_to_holders: Array[NodePath] = [];
@export var spawn_velocity: Vector2 = Vector2(500.0, 0.0);

@export var min_hold_time: float = 0.9;
@export var max_hold_time: float = 1.3;

@onready var _holders: Array = move_to_holders.map(get_node);

var _orb: PlayerOrb;


func _physics_process(_delta: float) -> void:
    if (_cooldown.time_left > 0.0):
        return;
    
    if (_collision.is_colliding()
            and _collision.get_collider(0) is PlayerOrb):
        var holder: OrbHolder = self;
        if (_holders.size() > 0):
            holder = _holders[randi_range(0, move_to_holders.size() - 1)];
        holder.hold(_collision.get_collider(0) as PlayerOrb);


func hold(p_orb: PlayerOrb) -> void:
    _orb = p_orb;
    _orb.disable();
    _orb.global_position = global_position;
    _orb.teleport(global_position);
    _orb.visible = false;
    _hold_timer.start(randf_range(min_hold_time, max_hold_time));
    _sound_player.stream = HOLD_SOUND;
    _sound_player.play();


func release() -> void:
    _cooldown.start();
    _orb.enable();
    _orb.linear_velocity = spawn_velocity;
    _hold_timer.stop();
    _orb.visible = true;
    _orb = null;
    _sound_player.stream = RELEASE_SOUND;
    _sound_player.play();
