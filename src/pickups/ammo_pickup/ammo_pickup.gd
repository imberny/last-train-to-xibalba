class_name AmmoPickup extends Node2D

@export var count := 20

@onready var _area: Area2D = $Area2D
@onready var _velocity: Velocity = $Velocity


func _ready() -> void:
	_area.area_entered.connect(_on_area_entered)


func _physics_process(delta: float) -> void:
	_velocity.accelerate_in_direction(Vector2.LEFT, delta)
	_velocity.move(self, delta)


func _on_area_entered(area: Area2D) -> void:
	if area.owner is PlayerVehicle2D:
		area.owner.gain_ammo(count)
		queue_free()
