extends Node2D

@export var _trauma_intensity := 10.0

@onready var _anim_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	_anim_player.animation_finished.connect(_on_anim_player_animation_finished)
	EventBus.emit_trauma(_trauma_intensity)


func _on_anim_player_animation_finished(_animation: String) -> void:
	queue_free()
