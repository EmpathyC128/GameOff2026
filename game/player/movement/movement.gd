class_name Movement extends Node2D

@export var player: CharacterBody2D
@export var initial_movement_settings: MovementSettings

var movement_settings: MovementSettings

var enabled: bool = true


func set_movement_settings(new_settings: MovementSettings) -> void:
    movement_settings = new_settings


func enable_movement() -> void:
    enabled = true


func disable_movement() -> void:
    enabled = false
