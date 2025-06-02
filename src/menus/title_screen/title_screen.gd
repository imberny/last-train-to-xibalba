class_name TitleScreen extends Control

@export var _debug_scene: PackedScene

var level_container: LevelContainer


func _load_level(level_scene: PackedScene) -> void:
	level_container.change_level(level_scene)
	queue_free()


func _on_debug_scene_button_pressed() -> void:
	_load_level(_debug_scene)


func _on_exit_button_pressed() -> void:
	get_tree().quit()
