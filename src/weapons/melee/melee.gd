class_name Melee extends Node2D

@export var _damage := 10
@export var swing_boost_speed := 800.0

@onready var _anim_player: AnimationPlayer = $AnimationPlayer
@onready var _hurtbox: Area2D = $Area2D


func swing() -> void:
	_anim_player.play("swing")


func hit_frame() -> void:
	for area in _hurtbox.get_overlapping_areas():
		if area is Hurtbox:
			area.hit_back(global_transform.x)
		elif area is Hitbox:
			area.hit(_damage)
