extends CollisionObject2D
class_name Hitbox

signal taken_damage(result: DamageResult);


func take_damage(p_result: DamageResult) -> void:
    taken_damage.emit(p_result);
