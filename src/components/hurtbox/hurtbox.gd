class_name Hurtbox extends Area2D

signal reversed(in_direction)

@export var damage := 5


func hit_back(direction: Vector2) -> void:
	reversed.emit(direction)
