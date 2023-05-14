extends CanvasLayer

@onready var _tabs: TabContainer = $Tabs;
@onready var _chapter_result_screen: ChapterResult = $Tabs/ChapterResult;


func chapter_result() -> void:
    _chapter_result_screen.show_screen();
    _tabs.current_tab = 1;
    

func hide_screen() -> void:
    _tabs.current_tab = 0;
