class_name Bullet2D extends Node2D

@export var _speed := 100.0

@onready var _hurtbox: Area2D = $Hurtbox

var _times_reversed := 0


func _ready() -> void:
	_hurtbox.area_entered.connect(_on_area_entered)
	_hurtbox.reversed.connect(_on_hurtbox_reversed)


func _physics_process(delta: float) -> void:
	position += _speed * delta * transform.x


func _reverse(direction: Vector2) -> void:
	if direction.angle_to(transform.x) < PI / 2.0:
		return

	_times_reversed += 1
	_speed += _speed * (0.5 / _times_reversed)

	rotation += PI
	# player hurtbox layer
	_hurtbox.collision_layer ^= 1 << 5
	# enemy hurtbox layer
	_hurtbox.collision_layer ^= 1 << 7
	# enemy hitbox mask
	_hurtbox.collision_mask ^= 1 << 6
	# player hitbox mask
	_hurtbox.collision_mask ^= 1 << 4


func _on_area_entered(_area: Area2D) -> void:
	queue_free()


func _on_hurtbox_reversed(in_direction: Vector2) -> void:
	_reverse(in_direction)
