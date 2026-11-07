extends Node2D

func _ready() -> void:
    Transition.transition(Transition.GameScene.START_MENU, 0.05)
