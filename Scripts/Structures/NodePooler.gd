extends RefCounted
class_name NodePooler

var parent: Node;

var max_num: int = 64;
var nodes: Array[Node];
var scene_to_instantiate: PackedScene;


func _init(p_parent, p_scene: PackedScene, p_max: int = 64) -> void:
    parent = p_parent;
    max_num = p_max;
    scene_to_instantiate = p_scene;
    nodes = [];


func grab() -> Node:
    var result: Node;
    if (nodes.size() == 0):
        result = scene_to_instantiate.instantiate();
        parent.add_child(result, true);
    else:
        result = nodes.pop_front();
    
    return result;


func release(p_node: Node) -> bool:
    if (nodes.size() >= max_num):
        return false;
    
    nodes.push_front(p_node);
    return true;
