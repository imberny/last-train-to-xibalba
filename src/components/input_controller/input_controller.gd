extends Node

@export var _player: PlayerVehicle2D


func _physics_process(delta: float) -> void:
	var motion := _get_motion_adjusted()
	if Input.is_action_just_pressed("boost"):
		_player.boost(motion.normalized(), delta)
	else:
		_player.move(motion, delta)
	if Input.is_action_just_pressed("shoot_primary"):
		_player.primary_pull_trigger()
	elif Input.is_action_just_released("shoot_primary"):
		_player.primary_release_trigger()

	if Input.is_action_just_pressed("flip_around"):
		_player.flip_around()


func _get_motion_adjusted() -> Vector2:
	var base_motion := _get_motion()
	return base_motion


func _get_motion() -> Vector2:
	return Input.get_vector("move_left", "move_right", "move_up", "move_down")
