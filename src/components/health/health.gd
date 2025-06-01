class_name Health extends Node

signal died

@export var hitpoints_max := 100
@export var hitbox: Hitbox
@export var enemy_death: EnemyDeath

@onready var _hitpoints := hitpoints_max:
	set = _set_hitpoints


func _ready() -> void:
	hitbox.hurt.connect(_on_hitbox_hurt)


func _take_damage(damage: int) -> void:
	_hitpoints -= damage


func _set_hitpoints(value: int) -> void:
	_hitpoints = clampi(value, 0, hitpoints_max)
	if 0 == _hitpoints:
		died.emit()
		enemy_death.die()


func _on_hitbox_hurt(damage: int) -> void:
	_take_damage(damage)
