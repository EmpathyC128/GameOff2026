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

@export_category("Skew")
@export var jump_skew: float = 0.1
@export var land_skew: float = 0.1
@export var skew_time_ms: int = 20


# State
var last_jump: int = 0
var last_land: int = 0
var direction: int = 1

func _ready() -> void:
    if sprite:
        sprite.hide()
    if movement:
        movement.on_jump.connect(on_jump)
        movement.on_land.connect(on_land)
        movement.on_change_direction.connect(on_change_direction)


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


func check_keys() -> void:
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

    if sprite:
        process_scale()


func process_scale() -> void:
    var now := Global.now
    if (now - last_jump) <= skew_time_ms:
        # Jump
        sprite.scale.x = get_squash(now - last_jump, jump_skew) * direction
        sprite.scale.y = get_stretch(now - last_jump, jump_skew)
    elif (now - last_land) <= skew_time_ms:
        # Land
        sprite.scale.x = get_stretch(now - last_land, jump_skew) * direction
        sprite.scale.y = get_squash(now - last_land, jump_skew)
    else:
        sprite.scale.x = 1 * direction
        sprite.scale.y = 1

func get_skew_multiplier(time_since_event: int):
    var a: float = -4.0 / (skew_time_ms ** 2)
    var b: float = 4.0 / skew_time_ms

    var func_value: float = (a * (time_since_event ** 2)) + (b * time_since_event)

    return max(0.3, func_value)


func get_squash(time_since_event: int, squash_amount: float):
    var multiplier = get_skew_multiplier(time_since_event)
    var squash: float = squash_amount * multiplier
    return 1 - squash



func get_stretch(time_since_event: int, stretch_amount: float):
    var multiplier = get_skew_multiplier(time_since_event)
    var stretch: float = stretch_amount * multiplier
    return 1 + stretch

func on_jump() -> void:
    last_jump = Global.now


func on_land() -> void:
    last_land = Global.now


func on_change_direction(new_direction: int) -> void:
    direction = new_direction
