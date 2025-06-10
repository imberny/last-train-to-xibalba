class_name WaveManager extends Node

signal finished

@export var _wave_definition: WaveDefinition
@export var _spawners: Array[Node2D]

var _wave_index := 0
var _enemy_count := 0


func _ready() -> void:
	start_next_wave.call_deferred()


func start_next_wave() -> void:
	if _wave_definition.num_waves <= _wave_index:
		finished.emit()
		return

	var candidates := _wave_definition.enemy_definitions.filter(
		func(def: EnemyDefinition): return _wave_index >= def.difficulty
	)

	for enemy_definition in candidates:
		enemy_definition = enemy_definition as EnemyDefinition
		@warning_ignore("integer_division")
		var num_instances: int = 1 + (8 - enemy_definition.difficulty) + _wave_index / 3
		num_instances = max(num_instances, 1)
		for _i in num_instances:
			var enemy: Node2D = enemy_definition.scene.instantiate()
			enemy.global_transform = _spawners.pick_random().global_transform
			GameService.spawn(enemy)
			_enemy_count += 1
			enemy.tree_exited.connect(_on_enemy_tree_exited)

	_wave_index += 1


func _on_enemy_tree_exited() -> void:
	_enemy_count -= 1
	if 0 == _enemy_count:
		start_next_wave.call_deferred()
