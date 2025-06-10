class_name PlayerSelectorCarousel extends Control

@export var _player_vehicle_definitions: Array[PlayerVehicleDefinition]

var _index := 0


func _ready() -> void:
	%SelectButton.pressed.connect(_on_select_button_pressed)


func _spawn_player() -> void:
	GameService.spawn_player(_player_vehicle_definitions[_index])
	hide()


func _on_select_button_pressed() -> void:
	_spawn_player()
