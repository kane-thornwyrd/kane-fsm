extends State
class_name AwakeMonsterState

var next_state:State = null

func get_name() -> String: return "awake";

# warning-ignore:unused_argument
func entering(old_state:State) -> void:
  next_state = null

func logic() -> void:
  parent.anim_player.play(self.name)
  yield(parent.anim_player, "animation_finished")
  if actions["ui_left"] or actions["ui_up"] or actions["ui_right"] or actions["ui_down"] :
    next_state = states.fly
func transitioning() -> State:
  return next_state
