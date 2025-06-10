extends Node


func _physics_process(delta: float) -> void:
	var player := GameService.get_player()
	if not player:
		return

	var motion := _get_motion_adjusted()
	if Input.is_action_just_pressed("boost"):
		player.boost(motion.normalized(), delta)
	else:
		player.move(motion, delta)
	if Input.is_action_just_pressed("shoot_primary"):
		player.primary_pull_trigger()
	elif Input.is_action_just_released("shoot_primary"):
		player.primary_release_trigger()
	if Input.is_action_just_pressed("shoot_secondary"):
		player.secondary_pull_trigger()
	elif Input.is_action_just_released("shoot_secondary"):
		player.secondary_release_trigger()
	if Input.is_action_just_pressed("melee_primary"):
		player.melee_swing()

	if Input.is_action_just_pressed("flip_around"):
		player.flip_around()


func _get_motion_adjusted() -> Vector2:
	var base_motion := _get_motion()
	return base_motion


func _get_motion() -> Vector2:
	return Input.get_vector("move_left", "move_right", "move_up", "move_down")
