extends Object
class_name DamageResult

var damage: float;
var damage_causer: Node;
var hit_object: CollisionObject2D;
var hit_velocity: Vector2;


func _init(dmg: float, csr: Node = null,
        obj: CollisionObject2D = null,
        vel: Vector2 = Vector2.ZERO) -> void:
    damage = dmg;
    damage_causer = csr;
    hit_object = obj;
    hit_velocity = vel;
