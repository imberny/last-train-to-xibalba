class_name Gun extends Node2D

enum Kind { SINGLE, AUTO, CHARGE }

@export var _bullet_scene: PackedScene
@export var _kind: Kind
@export var _rate_of_fire := 0.1
@export var _spread_degrees := 5.0
@export var _num_projectiles_per_shot := 1
@export var _trauma_intensity := 0.1
@export var _ammo_max := 100

var bullet_spawner: Node2D
var ammo: int

var _shoot_tween: Tween
var _is_shooting := false
var _has_shot := false

@onready var _anim_tree: AnimationTree = $AnimationTree
@onready var _playback: AnimationNodeStateMachinePlayback = _anim_tree["parameters/playback"]
@onready var _cooldown_timer: Timer = $CooldownTimer


func _ready() -> void:
	_cooldown_timer.wait_time = _rate_of_fire
	ammo = _ammo_max


func pull_trigger() -> void:
	_is_shooting = true
	if _kind == Kind.AUTO:
		_shoot_auto()
	elif _kind == Kind.CHARGE:
		_start_charge()
	elif _cooldown_timer.is_stopped():
		_shoot()
		_cooldown_timer.start()
	else:
		_has_shot = false


func release_trigger() -> void:
	_is_shooting = false
	if _kind == Kind.CHARGE:
		_shoot_charged()
	if _shoot_tween:
		_shoot_tween.kill()
		_shoot_tween = null
	if _has_shot and _cooldown_timer.is_stopped():
		_cooldown_timer.start()
	_has_shot = false


func gain_ammo(count: int) -> void:
	ammo = clampi(ammo + count, 0, _ammo_max)


func _shoot_auto() -> void:
	if not _cooldown_timer.is_stopped():
		await _cooldown_timer.timeout
	# Tricky logic: if trigger is pressed and released during cooldown
	if not _is_shooting:
		return

	if _shoot_tween:
		_shoot_tween.kill()
	_shoot_tween = create_tween().set_loops()
	_shoot_tween.tween_callback(_shoot)
	_shoot_tween.tween_interval(_rate_of_fire)


func _shoot() -> void:
	if 0 == ammo:
		# play empty sound
		return
	ammo -= 1

	_has_shot = true

	var height := 70.0
	var v_pos := height / (_num_projectiles_per_shot + 1)
	for i in _num_projectiles_per_shot:
		var bullet: Node2D = _bullet_scene.instantiate()
		GameService.spawn(bullet)
		bullet.global_transform = bullet_spawner.global_transform
		bullet.global_position.y += (height / 2.0) - (i + 1) * v_pos
		bullet.rotate(deg_to_rad(randf_range(-_spread_degrees, _spread_degrees)))
		_playback.travel("shoot")
		EventBus.emit_trauma(_trauma_intensity)


func _start_charge() -> void:
	pass


func _shoot_charged() -> void:
	_shoot()
