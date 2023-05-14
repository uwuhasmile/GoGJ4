extends Resource
class_name Chapter

@export var levels: Array[Level];


func does_level_exists(p_level: int) -> bool:
    return p_level >= 0 and p_level < levels.size();
