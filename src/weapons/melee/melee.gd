class_name Melee extends Node2D

@export var _damage := 10

@onready var _anim_player: AnimationPlayer = $AnimationPlayer
@onready var _hurtbox: Area2D = $Area2D


func _ready() -> void:
	_hurtbox.area_entered.connect(_on_area_entered)


func swing() -> void:
	_anim_player.play("swing")


func _on_area_entered(area: Area2D) -> void:
	if area is Hurtbox:
		area.hit_back(global_transform.x)
	elif area is Hitbox:
		area.hit(_damage)
