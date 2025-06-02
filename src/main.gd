extends Node

@export var _splash_scene: PackedScene
@export var _title_scene: PackedScene

@onready var _level_container: LevelContainer = $LevelContainer


func _ready() -> void:
	_level_container.back_to_main_menu.connect(_on_back_to_main_menu)
	_show_splash()


func _show_splash() -> void:
	var _splash := _splash_scene.instantiate()
	add_child(_splash)
	_splash.tree_exiting.connect(_on_splash_tree_exiting)


func _show_title_screen() -> void:
	var title_screen: TitleScreen = _title_scene.instantiate()
	title_screen.level_container = _level_container
	add_child(title_screen)


func _on_splash_tree_exiting() -> void:
	_show_title_screen.call_deferred()


func _on_back_to_main_menu() -> void:
	_level_container.exit_level()
	_show_title_screen()
