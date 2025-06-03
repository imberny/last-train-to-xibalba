class_name PlayerVehicle2D extends Node2D

@export var _boost_modifier := 12.0

@onready var _velocity: Velocity = $Velocity
@onready var _boost_timer: Timer = $BoostTimer
@onready var _primary_gun: Gun = $PrimaryGun
@onready var _anim_tree: AnimationTree = $AnimationTree
@onready var _playback: AnimationNodeStateMachinePlayback = _anim_tree["parameters/playback"]


func _process(_delta: float) -> void:
	%HealthCount.text = str($Health._hitpoints)


func move(motion: Vector2, delta: float) -> void:
	_velocity.accelerate_in_direction(motion, delta)
	_velocity.move(self, delta)


func can_boost() -> bool:
	return _boost_timer.is_stopped()


func boost(direction: Vector2, delta: float) -> void:
	if not can_boost():
		return

	_boost_timer.start()
	_playback.travel("boost")
	var actual_direction := direction if not direction.is_zero_approx() else transform.x
	move(actual_direction * _boost_modifier, delta)


func flip_around() -> void:
	# https://github.com/godotengine/godot/issues/17405
	# https://forum.godotengine.org/t/why-my-character-scale-keep-changing/13909/5
	rotation = wrapf(rotation + PI, -PI, PI)


func primary_pull_trigger() -> void:
	_primary_gun.pull_trigger()


func primary_release_trigger() -> void:
	_primary_gun.release_trigger()
