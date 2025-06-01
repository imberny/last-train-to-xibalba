@icon("res://addons/antipixel_shaker/icons/icon_antipixel_shaker.svg")
class_name Shaker extends Node

signal started
signal ended

@export var node: Node
@export var transform: ShakeEnum.Transform
@export var curve: Curve
@export_group("Duration")
@export var min_duration: float
@export var max_duration: float
@export_group("Magnitude")
@export var min_magnitude: float
@export var max_magnitude: float
@export_group("Frequency")
@export var min_frequency: float
@export var max_frequency: float
@export_group("Constraints")
@export var constraint_x: bool
@export var constraint_y: bool
@export var constraint_z: bool

var shakes: Array[Shake]

var random_duration: float:
	get: return randf_range(min_duration, max_duration)
var random_magnitude: float:
	get: return randf_range(min_magnitude, max_magnitude)
var random_frequency: float:
	get: return randf_range(min_frequency, max_frequency)

var is_shaking: bool:
	get:
		for shake: Shake in shakes:
			if shake.is_shaking: return true
		return false

func _on_shake_ended(shake: Shake) -> void:
	shake.ended.disconnect(_on_shake_ended)
	shakes.erase(shake)
	if not is_shaking:
		ended.emit()

func play() -> void:
	if not constraint_x: create_shake(ShakeEnum.Axis.X)
	if not constraint_y: create_shake(ShakeEnum.Axis.Y)
	if not constraint_z: create_shake(ShakeEnum.Axis.Z)
	started.emit()

func stop() -> void:
	for shake: Shake in shakes:
		shake.stop()

func kill() -> void:
	for shake: Shake in shakes:
		shake.kill()

func create_shake(axis: ShakeEnum.Axis) -> Shake:
	var shake: Shake = Shake.new(node, transform, axis, random_duration, random_magnitude, random_frequency, curve)
	shake.ended.connect(_on_shake_ended)
	shakes.append(shake)
	return shake
