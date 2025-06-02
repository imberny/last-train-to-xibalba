extends Node2D

enum State { SPAWNING, SHOOTING, WANDERING }

@export var _speed := 100.0

var _state_machine: FuncStateMachine

@onready var _gun: Gun = $Gun

var _destination: Vector2


func _ready() -> void:
	_state_machine = FuncStateMachine.new()
	_state_machine.add_state(State.SPAWNING, _update_spawning, _enter_spawning)
	_state_machine.add_state(State.SHOOTING, _update_shooting, _enter_shooting, _exit_shooting)
	_state_machine.add_state(State.WANDERING, _update_wandering, _enter_wandering)
	_state_machine.set_start_state(State.SPAWNING)


func _physics_process(delta: float) -> void:
	_state_machine.update(delta)


func _enter_spawning() -> void:
	_destination.x = global_position.x
	_destination.y = randf_range(200.0, 500.0)


func _update_spawning(delta: float) -> void:
	if 1.0 > global_position.distance_to(_destination):
		_state_machine.transition_to(State.SHOOTING)
		return

	var dir := global_position.direction_to(_destination)
	global_position += dir * _speed * delta


func _enter_shooting() -> void:
	_time_shooting = 0.0
	_gun.pull_trigger()


func _exit_shooting() -> void:
	_gun.release_trigger()


var _time_shooting := 0.0


func _update_shooting(_delta: float) -> void:
	_time_shooting += _delta
	if _time_shooting >= 2.0:
		_state_machine.transition_to(State.WANDERING)


func _enter_wandering() -> void:
	_destination = Vector2(randf_range(200.0, 800.0), randf_range(200.0, 500.0))
	if randi_range(0, 2) == 1:
		rotation = clampf(rotation + PI, -PI, PI)


func _update_wandering(delta: float) -> void:
	if 1.0 > global_position.distance_to(_destination):
		_state_machine.transition_to(State.SHOOTING)
		return

	var dir := global_position.direction_to(_destination)
	global_position += dir * _speed * delta
