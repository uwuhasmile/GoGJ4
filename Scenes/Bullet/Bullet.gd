extends Sprite2D
class_name Bullet

@export var data: BulletData:
    set(p_data):
        data = p_data;
        if (p_data == null):
            return;
        texture = p_data.texture;
        material.set_deferred(&"shader_parameter/color", p_data.regular_color);

@export var shape: CircleShape2D;
@export_flags_2d_physics var collision_mask: int = 1;

@export var speed_change_curve: Curve;
@export var rot_change_curve: Curve;

var _distance: float;

var pooler: NodePooler;


func _ready() -> void:
    if (not is_instance_valid(data)):
        kill();


func spawn(p_pos: Vector2, p_rot: float, p_data: BulletData,
        p_speed_change_curve: Curve = null,
        p_rot_change_curve: Curve = null) -> void:
    
    _distance = 0.0;
    position = p_pos;
    rotation_degrees = p_rot;
    data = p_data;
    speed_change_curve = p_speed_change_curve;
    rot_change_curve = p_rot_change_curve;
    set_process(true);
    set_physics_process(true);
    visible = true;


func _process(_delta: float) -> void:
    if (_distance >= data.max_distance):
        kill();


func kill() -> void:
    if (is_instance_valid(pooler) and pooler.release(self)):
        data = null;
        speed_change_curve = null;
        rot_change_curve = null;
        set_process(false);
        set_physics_process(false);
        visible = false;
        _distance = 0.0;
    else:
        queue_free();


func _physics_process(_delta: float) -> void:
    if (not is_instance_valid(data)):
        return;
    var pos_add: float = data.move_speed ;
    if (is_instance_valid(speed_change_curve)):
        pos_add *= speed_change_curve.sample(_distance / data.max_distance);
    
    var rot_add: float = data.rotation_speed;
    if (is_instance_valid(rot_change_curve)):
        rot_add *= rot_change_curve.sample(_distance / data.max_distance);
    
    rotate(rot_add);
    var add: Vector2 = Vector2(pos_add, 0.0).rotated(rotation);
    position += add;
    _distance += pos_add;
