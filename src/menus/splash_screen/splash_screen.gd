extends Control

@onready var _anim_player: AnimationPlayer = $AnimationPlayer
@onready var _splash_container: Control = $SplashContainer

var _splash_index := 0


func _ready() -> void:
	_anim_player.animation_finished.connect(_on_animation_finished)
	_play_next_splash()


func _play_next_splash() -> void:
	if _splash_container.get_child_count() <= _splash_index:
		queue_free()
		return

	_anim_player.play("fadeinout")
	for splash in _splash_container.get_children():
		(splash as Control).visible = false
	_splash_container.get_child(_splash_index).visible = true
	_splash_index += 1


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		_play_next_splash()


func _on_animation_finished(_anim: String) -> void:
	_play_next_splash()
