class_name Hitbox extends Area2D

signal hurt(damage: int)


func _ready() -> void:
	area_entered.connect(_on_area_entered)


func _on_area_entered(area: Area2D) -> void:
	if area is Hurtbox:
		hurt.emit(area.damage)
