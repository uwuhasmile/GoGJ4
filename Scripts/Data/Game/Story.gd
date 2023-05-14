extends Resource
class_name Story

@export var chapters: Array[Chapter] = [];
@export var endings: Array[Ending] = [];


func has_chapter(p_chapter: int) -> bool:
    return p_chapter >= 0 and p_chapter < chapters.size();


func get_level_count() -> int:
    var count: int = 0;
    for c in chapters:
        count += c.levels.size();
    return count;


func get_passed_levels(p_chapter: int, p_level: int) -> int:
    var count: int = 0;
    for i in range(chapters.size()):
        if (i == p_chapter - 1):
            count += p_level;
            break;
        var c: Chapter = chapters[i];
        count += c.levels.size();
    return count;


func calculate_percentage(p_chapter: int, p_level: int) -> float:
    var count: int = get_level_count();
    var passed_levels: int = get_passed_levels(p_chapter, p_level);
    return 100.0 / count * passed_levels;


func get_chapter(p_chapter: int) -> Chapter:
    assert(has_chapter(p_chapter));
    return chapters[p_chapter];


func get_level(p_chapter: int, p_level: int) -> Level:
    var chapter: Chapter = get_chapter(p_chapter);
    assert(chapter.does_level_exists(p_level));
    return chapter.levels[p_level];
