extends AnimationPlayer
class_name GameAnimationPlayer


func _ready() -> void:
    if (has_animation(&"READY")):
        play(&"READY");
        stop(false);
