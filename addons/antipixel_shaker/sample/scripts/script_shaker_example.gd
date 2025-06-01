extends Node

@export var shakers: Array[Shaker]

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		for shaker: Shaker in shakers:
			shaker.play()
		
		#Shake.new(shakers[0].node, ShakeEnum.Transform.POSITION, ShakeEnum.Axis.X, 0.5, 0.5, 5)
