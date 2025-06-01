class_name Velocity extends Node

@export var max_speed := 40
@export var acceleration := 5.0

var _velocity: Vector2


func accelerate_in_direction(motion: Vector2, delta: float) -> void:
	var desired_velocity := motion * max_speed
	_velocity = _velocity.lerp(desired_velocity, 1.0 - exp(-acceleration * delta))


func move(node: Node2D, delta: float) -> void:
	node.position += _velocity * delta
