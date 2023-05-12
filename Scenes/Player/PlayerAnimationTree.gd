extends AnimationTree

@onready var _parent: Player = get_parent() as Player;
@onready var _sprite: Sprite2D = _parent.get_node("Sprite") as Sprite2D;


func _process(_delta: float) -> void:
    set("parameters/Main/Grounded/blend_position", 1.0 if _parent.velocity.x != 0.0 else 0.0);
    if (_parent.wish_dir != 0.0 and not _parent.is_attacking() and _parent.is_on_floor()):
        _sprite.flip_h = _parent.wish_dir < 0.0;
    elif (_parent.velocity.x != 0.0):
        _sprite.flip_h = _parent.velocity.x < 0.0;


func _get_configuration_warnings() -> PackedStringArray:
    var arr: PackedStringArray = [];
    if (not get_parent() is Player):
        arr.append("Only Player node can be parent of this PlayerAnimationTree");
    return arr;
