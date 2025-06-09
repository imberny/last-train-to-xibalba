class_name Level extends Node2D

signal back_to_main_menu
signal completed

@onready var _wave_manager: WaveManager = $WaveManager


func _ready() -> void:
	GameService.level = self
	_wave_manager.finished.connect(_on_wave_manager_finished)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("menu"):
		quit_to_main_menu()


func exit() -> void:
	queue_free()


func quit_to_main_menu() -> void:
	back_to_main_menu.emit()


func _on_wave_manager_finished() -> void:
	completed.emit()
