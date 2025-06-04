class_name LevelContainer extends Node2D

signal back_to_main_menu

var _current_level: Level


func change_level(level_scene: PackedScene) -> void:
	exit_level()

	_current_level = level_scene.instantiate()
	add_child(_current_level)

	_current_level.back_to_main_menu.connect(_on_current_level_back_to_main_menu)


func exit_level() -> void:
	if not _current_level:
		return

	_current_level.exit()
	_current_level.queue_free()
	_current_level = null


func _on_current_level_back_to_main_menu() -> void:
	back_to_main_menu.emit()
