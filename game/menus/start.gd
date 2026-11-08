extends Node2D

func _on_button_pressed() -> void:
	Transition.transition(Transition.GameScene.TEST_LEVEL)
