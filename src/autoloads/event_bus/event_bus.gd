class_name EventBusAutoload extends Node

signal trauma(intensity: float)


func emit_trauma(intensity: float) -> void:
	trauma.emit(intensity)
