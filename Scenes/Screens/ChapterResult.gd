extends Control
class_name ChapterResult

@export var can_continue: bool = false;

@onready var _time_value: Label = $Interface/VBoxContainer/Time/Value;
@onready var _points_value: Label = $Interface/VBoxContainer/Points/Value;
@onready var _deaths_value: Label = $Interface/VBoxContainer/Deaths/Value;

@onready var _total_title: Label = $Interface/Total/Title;
@onready var _total_value: Label = $Interface/Total/Value;

@onready var _anim_player: AnimationPlayer =  $AnimationPlayer;


func show_screen() -> void:
    assert(Game.is_in_game());
    _anim_player.play(&"Show");
    randomize();
    var chance: float = randf_range(0.0, 1.0);
    if (chance < 0.23):
        _total_title.text = "Totle: ";
    visible = false;
    
    var data: Dictionary = Game.current_session.get_current_chapter_data();
    _time_value.text = "%02d:%02d" % [int(data[&"time"]) % 60, int(data[&"time"] / 60.0) % 60];
    _points_value.text = "%06d" % data[&"points"];
    _deaths_value.text = "%d" % data[&"deaths"];
    _total_value.text = "%08d" % data[&"total"];


func hide_screen() -> void:
    _anim_player.play(&"Hide");


func _input(p_event: InputEvent) -> void:
    if (p_event.is_action_pressed(&"ui_accept") and can_continue):
        Game.current_session.next_chapter();
        hide_screen();


func _on_animation_player_animation_finished(p_anim_name: StringName) -> void:
    match p_anim_name:
        &"Hide":
            Screens.hide_screen();
