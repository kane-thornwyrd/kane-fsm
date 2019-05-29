extends State
class_name WaitMonsterState

func get_name() -> String: return "wait";

func logic() -> void:
  parent.anim_player.play(self.name)

func transitioning() -> State:
  if actions["ui_left"] or actions["ui_up"] or actions["ui_right"] or actions["ui_down"] :
    return states.awake
#  if abs(abs(parent.position.x) - abs(parent.player.position.x)) < 700.0:
#    return states.react
  return null