class_name ShakeEnum

enum Transform {
	NONE,
	POSITION,
	ROTATION,
	SCALE
}

enum Axis {
	NONE,
	X,
	Y,
	Z
}

static var transform_dict: Dictionary[Transform, String] = {
	Transform.POSITION: "position",
	Transform.ROTATION: "rotation_degrees",
	Transform.SCALE: "scale"
}

static var axis_dict: Dictionary[Axis, String] = {
	Axis.X: "x",
	Axis.Y: "y",
	Axis.Z: "z"
}
