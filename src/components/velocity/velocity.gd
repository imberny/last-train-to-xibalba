class_name Velocity extends Node

@export var _max_speed := 40
@export var _acceleration := 5.0
@export var _initial_speed := 0.0
@export var _initial_spread_degrees := 0.0

var x: float:
	get:
		return _velocity.x
var y: float:
	get:
		return _velocity.y

var _velocity: Vector2


func _ready() -> void:
	var spread := deg_to_rad(_initial_spread_degrees)
	_velocity = _initial_speed * Vector2.RIGHT.rotated(randf_range(-spread, spread))


func add_impulse(force: Vector2) -> void:
	_velocity += force


func accelerate_in_direction(motion: Vector2, delta: float) -> void:
	var desired_velocity := motion * _max_speed
	_velocity = _velocity.lerp(desired_velocity, 1.0 - exp(-_acceleration * delta))


func move(node: Node2D, delta: float) -> void:
	node.position += _velocity * delta
