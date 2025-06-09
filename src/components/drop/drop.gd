class_name Drop extends Node

@export var _health: Health
@export var _drops: Array[DropDefinition]


func _ready() -> void:
	_health.died.connect(_on_health_died)


func _spawn_drop() -> void:
	var drop: Node2D = _drops.pick_random().scene.instantiate()
	drop.global_transform = owner.global_transform
	GameService.level.add_child(drop)


func _on_health_died() -> void:
	_spawn_drop.call_deferred()
