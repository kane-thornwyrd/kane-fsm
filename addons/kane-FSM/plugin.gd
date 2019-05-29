tool
extends EditorPlugin

func _enter_tree():
  add_custom_type("State", "Node", preload("res://addons/kane-FSM/state.gd"), null)
  add_custom_type("State_Machine", "Node", preload("res://addons/kane-FSM/state_machine.gd"), preload("res://addons/kane-FSM/fsm_icon.svg"))

func _exit_tree():
  # When the plugin node exits the tree, remove the custom type
  remove_custom_type("State_Machine")
  remove_custom_type("State")
