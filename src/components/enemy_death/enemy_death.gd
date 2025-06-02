class_name EnemyDeath extends Node

@export var _health: Health
@export var _death_scene: PackedScene


func _ready() -> void:
	_health.died.connect(_on_health_died)


func die() -> void:
	var parent: Node2D = get_parent()
	parent.queue_free()
	var death: Node2D = _death_scene.instantiate()
	GameService.level.add_child(death)
	death.global_transform = parent.global_transform


func _on_health_died() -> void:
	die()
