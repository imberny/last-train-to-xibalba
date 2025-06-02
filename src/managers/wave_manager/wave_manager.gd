class_name WaveManager extends Node

signal finished

@export var _waves: Array[WaveDefinition]
@export var _spawners: Array[Node2D]

var _wave_index := 0
var _enemy_count := 0


func _ready() -> void:
	start_next_wave.call_deferred()


func start_next_wave() -> void:
	if len(_waves) <= _wave_index:
		finished.emit()
		return

	var wave_def := _waves[_wave_index]

	for scene in wave_def.enemy_scenes:
		var enemy: Node2D = scene.instantiate()
		enemy.global_transform = _spawners.pick_random().global_transform
		add_child(enemy)
		_enemy_count += 1
		enemy.tree_exited.connect(_on_enemy_tree_exited)

	_wave_index += 1


func _on_enemy_tree_exited() -> void:
	_enemy_count -= 1
	if 0 == _enemy_count:
		start_next_wave.call_deferred()
