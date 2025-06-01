class_name EnemyDeath extends Node

@export var _death_scene: PackedScene


func die() -> void:
	var parent: Node2D = get_parent()
	parent.queue_free()
	var death: Node2D = _death_scene.instantiate()
	get_tree().root.add_child(death)
	death.global_transform = parent.global_transform
