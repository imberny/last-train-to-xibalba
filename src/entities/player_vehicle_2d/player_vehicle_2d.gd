class_name PlayerVehicle2D extends Node2D

@export var definition: PlayerVehicleDefinition
@export var _boost_modifier := 12.0

@onready var _velocity: Velocity = $Velocity
@onready var _health: Health = $Health
@onready var _boost_timer: Timer = $BoostTimer
@onready var _primary_gun: Gun
@onready var _secondary_gun: Gun
@onready var _melee: Melee
@onready var _anim_tree: AnimationTree = $AnimationTree
@onready var _playback: AnimationNodeStateMachinePlayback = _anim_tree["parameters/playback"]

var _is_flipped := false


func _process(_delta: float) -> void:
	%HealthCount.text = str($Health._hitpoints)
	%PrimaryAmmoCount.text = str(_primary_gun.ammo)
	%SecondaryAmmoCount.text = str(_secondary_gun.ammo)


func _physics_process(delta: float) -> void:
	var target_rotation: float = _velocity.y * deg_to_rad(15.0) / _velocity._max_speed
	if _is_flipped:
		target_rotation += PI
	rotation = lerpf(rotation, target_rotation, delta * 15.0)


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
	_is_flipped = !_is_flipped


func equip_primary(gun: Gun) -> void:
	_primary_gun = gun
	$PrimarySlot.add_child(gun)
	gun.bullet_spawner = $BulletSpawner


func unequip_primary() -> void:
	_primary_gun.queue_free()
	_primary_gun = null


func equip_secondary(gun: Gun) -> void:
	_secondary_gun = gun
	$SecondarySlot.add_child(gun)
	gun.bullet_spawner = $BulletSpawner


func unequip_secondary() -> void:
	_secondary_gun.queue_free()
	_secondary_gun = null


func equip_melee(melee: Melee) -> void:
	_melee = melee
	$MeleeSlot.add_child(melee)


func unequip_melee() -> void:
	_melee.queue_free()
	_melee = null


func primary_pull_trigger() -> void:
	if not _primary_gun:
		return
	_primary_gun.pull_trigger()


func primary_release_trigger() -> void:
	if not _primary_gun:
		return
	_primary_gun.release_trigger()


func secondary_pull_trigger() -> void:
	if not _secondary_gun:
		return
	_secondary_gun.pull_trigger()


func secondary_release_trigger() -> void:
	if not _secondary_gun:
		return
	_secondary_gun.release_trigger()


func melee_swing() -> void:
	_melee.swing()


func gain_repair(amount: int) -> void:
	_health.heal(amount)


func gain_ammo(count: int) -> void:
	_primary_gun.gain_ammo(count)
	_secondary_gun.gain_ammo(count)
