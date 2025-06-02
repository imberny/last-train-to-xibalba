class_name FuncStateMachine


class State:
	var enter: Callable
	var exit: Callable
	var update: Callable

	func _init(update_: Callable, enter_: Callable, exit_: Callable) -> void:
		update = update_
		enter = enter_
		exit = exit_


var noop := func(): pass

var _states: Dictionary[Variant, State] = {}
var _current_state_key: Variant


func add_state(
	key: Variant,
	update_func: Callable,
	enter_func: Callable = noop,
	exit_func: Callable = noop,
) -> void:
	_states[key] = State.new(update_func, enter_func, exit_func)


func set_start_state(key: Variant) -> void:
	_current_state_key = key
	current_state().enter.call()


func current_state() -> State:
	return _states[_current_state_key]


func update(delta: float) -> void:
	current_state().update.call(delta)


func transition_to(state_key: Variant) -> void:
	current_state().exit.call()
	_current_state_key = state_key
	current_state().enter.call()
