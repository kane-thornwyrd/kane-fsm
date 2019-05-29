extends State
class_name FlyMonsterState

const TIME_BEFORE_SLEEP:float = 2.0

var timer:SceneTreeTimer
var next_state:State

func get_name() -> String: return "fly";

# warning-ignore:unused_argument
func entering(old_state:State) -> void:
  next_state = null
  timer = parent.get_tree().create_timer(TIME_BEFORE_SLEEP)
  # warning-ignore:return_value_discarded
  timer.connect("timeout", self, "_go_to_sleep")

func logic() -> void:
  parent.move_direction.x = -int(actions["ui_left"]) + int(actions["ui_right"])
  parent.move_direction.y = -int(actions["ui_up"]) + int(actions["ui_down"])
  if actions["ui_left"] or actions["ui_up"] or actions["ui_right"] or actions["ui_down"] :
    timer.set_time_left(TIME_BEFORE_SLEEP)
  parent.anim_player.play(self.name)

func transitioning() -> State:
  return next_state

func _go_to_sleep():
  next_state = states.wait