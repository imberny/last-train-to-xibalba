class_name Shake extends Node

signal started(shake: Shake)
signal ended(shake: Shake)

const THRESHOLD: float = 0.01

var node: Node
var transform: ShakeEnum.Transform
var axis: ShakeEnum.Axis
var duration: float
var magnitude: float
var frequency: float
var curve: Curve
var initial_value: float = NAN
var target_value: float
var time: float
var progress: float
var is_shaking: bool
var sign: float = 1

var value: float:
	get: return node[ShakeEnum.transform_dict[transform]][ShakeEnum.axis_dict[axis]]
	set(value): node[ShakeEnum.transform_dict[transform]][ShakeEnum.axis_dict[axis]] = value

func _init(node: Node, transform: ShakeEnum.Transform, axis: ShakeEnum.Axis, duration: float, magnitude: float, frequency: float, curve: Curve = null) -> void:
	for child: Node in node.get_children():
		if child is Shake and child.transform == transform and child.axis == axis:
			initial_value = child.initial_value
			break
	
	self.node = node
	self.transform = transform
	self.axis = axis
	self.duration = duration
	self.magnitude = magnitude
	self.frequency = frequency
	self.curve = curve
	if curve: self.curve.bake()
	
	if is_nan(initial_value): initial_value = value
	target_value = initial_value
	
	node.add_child(self)
	play()

func _process(delta: float) -> void:
	if is_shaking:
		value = move_toward(value, target_value, frequency * delta)
		
		if abs(target_value - value) <= THRESHOLD:
			target_value = get_random_target_value()
			target_value = lerpf(initial_value, target_value, 1 if not curve else curve.sample_baked(progress))
			sign *= -1
		
		time += delta
		progress = time / duration
		if time >= duration:
			stop()
	else:
		value = move_toward(value, initial_value, frequency * delta)
		
		if abs(initial_value - value) <= THRESHOLD:
			value = initial_value
			queue_free()

func play() -> void:
	sign = -1 if randf() < 0.5 else 1
	time = 0
	is_shaking = true
	started.emit(self)

func stop() -> void:
	is_shaking = false
	ended.emit(self)

func kill() -> void:
	stop()
	value = initial_value

func get_random_target_value() -> float:
	return initial_value + randf_range(0, magnitude) * sign
