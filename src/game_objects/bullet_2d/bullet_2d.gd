extends Node2D

@export var _speed := 100.0

@onready var _hurtbox: Area2D = $Hurtbox


func _ready() -> void:
	_hurtbox.area_entered.connect(_on_area_entered)


func _physics_process(delta: float) -> void:
	position += _speed * delta * transform.x


func _on_area_entered(_area: Area2D) -> void:
	queue_free()
