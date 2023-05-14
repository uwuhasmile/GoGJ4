extends Node

var current_session: Session = null;


func start_session(p_story: Story) -> void:
    end_session();
    current_session = Session.new(p_story);


func is_in_game() -> bool:
    return is_instance_valid(current_session);


func end_session() -> void:
    if (not is_instance_valid(current_session)):
        return;
    current_session.free();


func _ready() -> void:
    start_session(load("res://Assets/Story/Story.tres"));
    var timer: SceneTreeTimer = get_tree().create_timer(2.0);
    timer.timeout.connect(current_session.next_level);
