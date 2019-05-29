extends StateMachine
class_name MonsterFSM

export var debug_path:NodePath

#debug for fun & profit
onready var debug:Label = self.get_node(debug_path)

# We'll store the key pressed in a dictionnary !
var actions:Dictionary

func _init() -> void:
  # First we retrieve the actions declared and use them as keys of this dictionnary
  for action in InputMap.get_actions():
    # Defaulted to false indeed
    actions[action] = false

# We handle all the input events
func _unhandled_input(event: InputEvent) -> void:
  for action in actions:
    if event.is_action_pressed(action):
      actions[action] = true
    elif event.is_action_released(action):
      actions[action] = false

func _ready() -> void:
  #################################################################################
  # Registering states in a smart/dumb way, useful if you have tonnes of states ! #
  #################################################################################
  var states_dir = Directory.new()
  # We open the states directory…
  states_dir.open("res://fsm_example/scripts/monster/states")
  # Then start the listing of files by filtering nav folders (. and ..) and hidden files
  states_dir.list_dir_begin(true, true)
  var state_file:String = states_dir.get_next()
  # We register the files as long as there is one in the stream, the stream will auto-close
  # when there is none, therefore the while loop will end too.
  while state_file.length() > 0:
    # The format string feature is really nice
    self._register_state("res://fsm_example/scripts/monster/states/%s" % state_file)
    # We **MUST** name the files by the name of the state !!!
    # Because, here, we transform the filename into the state name.
    var state_name = (state_file as String).replace(".gd", "")
    # Need to set a var in the states ? easy as a pie !
    self.states[state_name].actions = actions
    # Let's get the next file name in the stream
    state_file = states_dir.get_next()
  #######
  # END #
  #######

  # Set the default state
  self.next_state = self.states.wait
  self.call_deferred("set_state", self.states.wait)

func _state_logic(delta: float) -> void:
# If your game has gravity, guess where to call the method ;)
#  parent._apply_gravity(delta)

  # Ooooh I'm bad bad bad, oneliner in GDScript! That's banned by the styleguide !
  if debug : debug.text = state.name;

  # We invoke the logic() method, if the state has one, if you forget this in
  # your implementation you won't be able to use process call !
  states[state.name].logic()

  # that's here that we call the velocity process
  parent._apply_velocity(delta)

# That's where we manage the transition between states
func _get_transition() -> State:
  # Self explanatory, no ?
  var nxt_state = states[state.name].transitioning()
  if nxt_state != null:
    self.next_state = nxt_state

  # Why the time part ? To implement state changes with a reaction time !
  # more on this later.
  if self.state != self.next_state and OS.get_ticks_msec() > self.next_state_time:
    return self.next_state

  return null

# Here we call the `entering` method of each states and…
func _enter_state(new_state: State, old_state: State) -> void:
  # … we set the time at wich it will transition by retrieving the reaction time of the monster
  self.next_state_time = OS.get_ticks_msec() + parent.get_reaction_time()
  states[new_state.name].entering(old_state)

# Here we call the `exiting` method of each states.
func _exit_state(old_state: State, new_state: State) -> void:
  states[old_state.name].exiting(new_state);