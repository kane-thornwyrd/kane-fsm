extends Node
class_name StateMachine, "fsm_icon.svg"

# warning-ignore:unused_class_variable
var State = preload("res://addons/kane-FSM/state.gd")

var state:State setget set_state
var previous_state:State
# warning-ignore:unused_class_variable
var next_state:State
# warning-ignore:unused_class_variable
var next_state_time:float
var states:Dictionary = {}

# warning-ignore:unused_class_variable
onready var parent:Node = self.get_parent()

func _register_state(file:String):
  self.add_state(load(file).new().set_parent(parent).set_states(states)\
      .set_state_changer(funcref(self, "set_state")))

func _physics_process(delta: float) -> void:
  if state != null:
    _state_logic(delta)
    var _transition = _get_transition()
    if _transition != null:
      set_state(_transition)

# warning-ignore:unused_argument
func _state_logic(delta: float) -> void:
  pass

func _get_transition() -> State:
  return null

# warning-ignore:unused_argument
# warning-ignore:unused_argument
func _enter_state(new_state: State, old_state: State) -> void:
  pass

# warning-ignore:unused_argument
# warning-ignore:unused_argument
func _exit_state(old_state: State, new_state: State) -> void:
  pass

# warning-ignore:unused_argument
func set_state(new_state: State) -> void:
  previous_state = state
  state = new_state

  if previous_state != null:
    _exit_state(previous_state, state)
  if new_state != null:
    _enter_state(state, previous_state)

func add_state(state: State) -> void:
  states[state.name] = state
