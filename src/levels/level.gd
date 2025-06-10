class_name Level extends Node2D

signal back_to_main_menu
signal completed

@onready var _wave_manager: WaveManager = $WaveManager
@onready var _player_spawn_point: Node2D = $PlayerSpawn


func _ready() -> void:
	_wave_manager.finished.connect(_on_wave_manager_finished)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("menu"):
		quit_to_main_menu()


func exit() -> void:
	queue_free()


func quit_to_main_menu() -> void:
	back_to_main_menu.emit()


func get_player_spawn_point() -> Node2D:
	return _player_spawn_point


func _on_wave_manager_finished() -> void:
	completed.emit()
