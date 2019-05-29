extends Node
class_name State

var parent:Node
var states:Dictionary
var state_change:FuncRef
# warning-ignore:unused_class_variable
var actions:Dictionary

func _init() -> void:
  self.name = self.get_name()

func set_parent(parent:Node) -> State:
  self.parent = parent
  return self

func set_states(s:Dictionary) -> State:
  self.states = s
  return self

func set_state_changer(sc:FuncRef) -> State:
  self.state_change = sc
  return self

func get_name() -> String: return "";

# warning-ignore:unused_argument
func entering(old_state:State) -> void:
  pass

func logic() -> void:
  pass

func transitioning() -> State:
  return null

# warning-ignore:unused_argument
func exiting(new_state:State) -> void:
  pass