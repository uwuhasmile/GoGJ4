extends Sprite2D
class_name Bullet

@export var data: BulletData:
    set(p_data):
        data = p_data;
        if (p_data == null):
            return;
        texture = p_data.texture;
        material.set_deferred(&"shader_parameter/color", p_data.regular_color);

@export_flags_2d_physics var collision_mask: int = 1;

@export var speed_change_curve: Curve;
@export var rot_change_curve: Curve;

var _distance: float;
var _grazing: bool;

var pooler: NodePooler;


func _ready() -> void:
    if (not is_instance_valid(data)):
        visible = false;
        set_process(false);
        set_physics_process(false);


func spawn(p_pos: Vector2, p_rot: float, p_data: BulletData,
        p_speed_change_curve: Curve = null,
        p_rot_change_curve: Curve = null) -> void:
    
    _grazing = false;
    _distance = 0.0;
    rotation = p_rot;
    position = p_pos;
    data = p_data;
    speed_change_curve = p_speed_change_curve;
    rot_change_curve = p_rot_change_curve;
    set_process(true);
    set_physics_process(true);
    visible = true;


func _process(delta: float) -> void:
    if (_distance >= data.max_distance):
        kill();
    
    if (not is_instance_valid(data)):
        visible = false;
        set_process(false);
        set_physics_process(false);
        return;
        
    var pos_add: float = data.move_speed * delta;
    if (is_instance_valid(speed_change_curve)):
        pos_add *= speed_change_curve.sample(_distance / data.max_distance);
    
    var rot_add: float = data.rotation_speed * delta;
    if (is_instance_valid(rot_change_curve)):
        rot_add *= rot_change_curve.sample(_distance / data.max_distance);
    
    rotation += rot_add;
    var add: Vector2 = Vector2(pos_add, 0.0);
    position += add.rotated(rotation);
    _distance += pos_add;
    
    material.set(&"shader_parameter/color",
            data.graze_color if _grazing else data.regular_color);


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
        visible = false;
        set_process(false);
        set_physics_process(false);
        return;
    
    var query: PhysicsShapeQueryParameters2D = PhysicsShapeQueryParameters2D.new();
    query.shape = data.shape;
    query.collide_with_bodies = true;
    query.collide_with_bodies = true;
    query.collision_mask = collision_mask;
    query.transform = global_transform;
    var result: Array[Dictionary] = get_world_2d().direct_space_state.intersect_shape(query, 1);
    if (result.size() > 0):
        var result_node: Node = result[0][&"collider"] as Node;
        if (result_node is PlayerOrb):
            kill();
            return;
        if (result_node.has_method(&"graze")):
            if (not _grazing):
                _grazing = true;
                result_node.graze();
        elif (result_node.has_method(&"take_damage")):
            var dmg_result: DamageResult = DamageResult.new(1.0, self);
            result_node.take_damage(dmg_result);
            kill();
            return;
    else:
        _grazing = false;
