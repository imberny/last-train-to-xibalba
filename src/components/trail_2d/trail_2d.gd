extends Line2D

@export var _num_points := 30

var _offset := position


func _ready() -> void:
	for _i in get_point_count():
		remove_point(0)


func _process(_delta: float) -> void:
	add_point(get_parent().global_position + _offset)
	if get_point_count() > _num_points:
		remove_point(0)
