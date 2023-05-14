extends Object
class_name Session

var story: Story;
var current_chapter: int;
var current_level: int;

var chapter_data: Array[Dictionary];
var level_data: Array[Dictionary];


func _init(p_story: Story) -> void:
    story = p_story;
    chapter_data = [];
    start_chapter(0);


func start_chapter(p_chapter: int) -> void:
    MusicPlayer.stop();
    assert(is_instance_valid(story));
    current_chapter = p_chapter;
    level_data.clear();
    for i in range(story.get_chapter(current_chapter).levels.size()):
        level_data.push_front({
            &"time": time,
            &"points": points,
            &"deaths": deaths,
        });
    load_level(0);


func next_chapter() -> void:
    if (not story.has_chapter(current_chapter + 1)):
        print(&"End of the game");
        return;
    start_chapter(current_chapter + 1);


func end_chapter() -> void:
    var time: float = 0.0;
    var time_points: int = 0;
    var points: int = 0;
    var deaths: int = 0;
    
    for l in level_data:
        time += l[&"time"];
        time_points += l[&"time_points"];
        points += l[&"points"];
        deaths += l[&"deaths"];
    
    chapter_data.push_front({
        &"time": time,
        &"points": points,
        &"deaths": deaths,
        &"total": time_points * 10 + points - deaths * 10,
    });


func load_level(p_level: int) -> void:
    assert(is_instance_valid(story));
    
    var level: Level = story.get_level(current_chapter, p_level);
    current_level = p_level;
    
    Game.get_tree().change_scene_to_packed(story.chapters[current_chapter].levels[p_level].scene);


func next_level() -> void:
    if (not story.get_chapter(current_chapter).does_level_exists(current_level + 1)):
        end_chapter();
        Game.get_tree().paused = true;
        Screens.chapter_result();
        return;
    load_level(current_level + 1);


func end_level(data: Dictionary) -> void:
    if (not story.get_chapter(current_chapter).does_level_exists(current_level + 1)):
        end_chapter();
        return;
    Game.get_tree().paused = true;
    level_data.push_front(data);


func get_current_chapter_data() -> Dictionary:
    return chapter_data[current_chapter];


func calculate_results() -> Dictionary:
    
    
    return {
        &""
    };
