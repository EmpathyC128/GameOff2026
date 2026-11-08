class_name StateMachine extends Node2D


@export var initial_state: State

var active_state: State

func _ready() -> void:
    for child in get_children():
        if child is State:
            child.switch_state.connect(change_state)

    active_state = initial_state
    if active_state:
        active_state.enter_state()


func _process(delta: float) -> void:
    if active_state:
        active_state.update(delta)


func _physics_process(delta: float) -> void:
    if active_state:
        active_state.physics_udpate(delta)


func change_state(new_state: State) -> void:
    if new_state == active_state:
        return
    
    if active_state:
        active_state.exit_state()
    
    active_state = new_state

    if active_state:
        active_state.enter_state()
