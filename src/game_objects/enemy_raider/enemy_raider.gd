extends Node2D

enum State {
	SPAWNING,
	THINKING,
	MOVING,
	PREP_SHOOTING,
	SHOOTING,
}

@export var _speed := 100.0

var _state_machine: FuncStateMachine

@onready var _gun: Gun = $Gun
@onready var _enemy_ray: RayCast2D = $EnemyDetectorRay

var _destination: Vector2

# TODO: Desired behaviour: move to an initial position, prep fire, fire some bullets towards player, reposition


func _ready() -> void:
	_state_machine = FuncStateMachine.new()
	_state_machine.add_state(State.SPAWNING, _update_spawning)
	_state_machine.add_state(State.THINKING, _update_thinking)
	_state_machine.add_state(State.PREP_SHOOTING, _update_prep_shooting, _enter_prep_shooting)
	_state_machine.add_state(State.SHOOTING, _update_shooting, _enter_shooting, _exit_shooting)
	_state_machine.add_state(State.MOVING, _update_moving)
	_state_machine.set_start_state(State.SPAWNING)


func _physics_process(delta: float) -> void:
	_state_machine.update(delta)
	$StateLabel.text = State.find_key(_state_machine._current_state_key)


func _update_spawning(delta: float) -> void:
	_destination.x = global_position.x
	_destination.y = randf_range(200.0, 500.0)
	_state_machine.transition_to(State.MOVING)


func _update_thinking(delta: float) -> void:
	var player := GameService.get_player()
	if not player:
		_destination = Vector2(randf_range(100.0, 800.0), randf_range(100.0, 400.0))
		_state_machine.transition_to(State.MOVING)
		return

	if global_position.x > player.global_position.x:
		rotation = PI
	else:
		rotation = 0.0

	if RngUtil.coin_flip():
		_state_machine.transition_to(State.PREP_SHOOTING)
		return

	_destination.y = player.global_position.y
	_destination.x = global_position.x
	if absf(_destination.x - player.global_position.x) < 50.0:
		var offset := 150.0 if RngUtil.coin_flip() else -150.0
		_destination.x = global_position.x + offset
	_state_machine.transition_to(State.MOVING)


var _time_prep_shooting := 0.0


func _enter_prep_shooting() -> void:
	_time_shooting = 0.0


func _update_prep_shooting(delta: float) -> void:
	if not _is_player_in_sight():
		_state_machine.transition_to(State.THINKING)
		return

	_time_prep_shooting += delta
	if 1.0 < _time_prep_shooting:
		_state_machine.transition_to(State.SHOOTING)


var _time_shooting := 0.0


func _enter_shooting() -> void:
	_time_shooting = 0.0
	_gun.pull_trigger()


func _exit_shooting() -> void:
	_gun.release_trigger()


func _update_shooting(_delta: float) -> void:
	_time_shooting += _delta
	var player := GameService.get_player()
	if player:
		look_at(player.global_position)
	if _time_shooting >= 1.3:
		_state_machine.transition_to(State.THINKING)


func _update_moving(delta: float) -> void:
	if 1.0 > global_position.distance_to(_destination):
		_state_machine.transition_to(State.THINKING)
		return

	var dir := global_position.direction_to(_destination)
	global_position += dir * _speed * delta


func _is_player_in_sight() -> bool:
	var player := GameService.get_player()
	if not player:
		return false

	var is_player_aligned := absf(global_position.y - player.global_position.y) < 50.0
	if not is_player_aligned:
		return false

	if _enemy_ray.is_colliding():
		var enemy: Node2D = _enemy_ray.get_collider()
		if not is_instance_valid(enemy):
			# this fucks la patente
			return false

		return (
			global_position.distance_to(enemy.global_position)
			> global_position.distance_to(player.global_position)
		)

	return true
