class_name PlayerState extends State

@export var state_1: PlayerState
@export var state_2: PlayerState
@export var state_3: PlayerState
@export var state_4: PlayerState

@export_category("Movement")
@export var movement: Movement
@export var movement_settings: MovementSettings

@export_category("Sprite")
@export var sprite: AnimatedSprite2D
@export var collision: CollisionShape2D
@export var collision_shape: Shape2D
@export var collision_shape_position: Vector2 = Vector2(0, 0)


func _ready() -> void:
    if sprite:
        sprite.hide()


func enter_state() -> void:
    if movement:
        if movement_settings:
            movement.set_movement_settings(movement_settings)
            movement.enable_movement()
        else:
            movement.disable_movement()
    
    if sprite:
        sprite.show()

    if collision and collision_shape:
        collision.shape = collision_shape
        collision.position = collision_shape_position



func exit_state() -> void:
    if movement:
        movement.disable_movement()
    if sprite:
        sprite.hide()


func check_keys():
    if Input.is_action_just_pressed("transform_1") and state_1:
        switch_state.emit(state_1)
    elif Input.is_action_just_pressed("transform_2") and state_2:
        switch_state.emit(state_2)
    elif Input.is_action_just_pressed("transform_3") and state_3:
        switch_state.emit(state_3)
    elif Input.is_action_just_pressed("transform_4") and state_4:
        switch_state.emit(state_4)


func update(_delta: float) -> void:
    check_keys()
