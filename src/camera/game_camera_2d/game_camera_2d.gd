class_name GameCamera2D extends Camera2D

@export var _trauma_maximum := 0.5
@export var _trauma_fade := 5.0
@export var _trauma_factor := 1.0

var _rng := RandomNumberGenerator.new()
var _trauma := 0.0


func _ready() -> void:
	EventBus.trauma.connect(_on_trauma)


func _process(delta: float) -> void:
	if is_zero_approx(_trauma):
		offset = Vector2.ZERO
	else:
		offset = (
			Vector2(
				_rng.randf_range(-_trauma, _trauma),
				_rng.randf_range(-_trauma, _trauma),
			)
			. round()
		)

	_trauma = lerpf(_trauma, 0.0, delta * _trauma_fade)


func _on_trauma(intensity: float) -> void:
	_trauma = clampf(_trauma + intensity * _trauma_factor, 0.0, _trauma_maximum)
