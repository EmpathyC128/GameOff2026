class_name Movement extends Node2D

@export var player: CharacterBody2D
@export var initial_movement_settings: MovementSettings

var settings: MovementSettings

var enabled: bool = true


# State
var last_jump_press: int = 0
var last_floor_touch: int = 0
var prev_tick_on_floor: bool = false
var last_jump: int = 0
var last_land: int = 0

var last_obstacle_collide: int = 0
var last_non_zero_velocity: int = 0


func _ready() -> void:
    settings = initial_movement_settings


func set_movement_settings(new_settings: MovementSettings) -> void:
    settings = new_settings


func enable_movement() -> void:
    enabled = true


func disable_movement() -> void:
    enabled = false


func _physics_process(delta: float) -> void:
    if not enabled:
        return

    if Global.paused:
        return 

    if settings.primary_mode == MovementSettings.PrimaryMode.FLY:
        process_fly(delta)
    else:  # WALK
        process_walk(delta)


func process_fly(delta: float) -> void:
    pass


func process_walk(delta: float) -> void:
    var now: int = Global.now

    if settings.can_jump and Input.is_action_just_pressed("up"):
        last_jump_press = now

    if player.is_on_floor():
        process_walk_on_ground(delta, now)
    else:
        process_walk_in_air(delta, now)

    # Clamping
    player.velocity.x = max(-settings.max_run_speed, min(settings.max_run_speed, player.velocity.x))
    player.velocity.y = min(settings.terminal_velocity, player.velocity.y)

    prev_tick_on_floor = player.is_on_floor()

    # Apply movement
    player.move_and_slide()
    if player.velocity.x != 0:
        last_non_zero_velocity = now

    # Pushing obstacles
    process_push(now)


func process_walk_in_air(delta: float, now: int) -> void:
    
    # Jump
    if (last_jump_press == now) and (now - last_floor_touch) <= max(0, settings.coyote_time_ms):
        jump(now)

    # Apply Gravity
    else:
        
        var gravity_multiplier: float = 1.0
        if player.velocity.y > 0:
            gravity_multiplier = settings.downward_gravity_multiplier
        player.velocity += player.get_gravity() * delta * gravity_multiplier

    var direction := Input.get_axis("left", "right")

    # Apply X velocity
    apply_x_velocity(
        direction,
        settings.air_acceleration,
        settings.air_turn_acceleration,
        settings.air_decceleration,
        delta
        )


func process_walk_on_ground(delta: float, now: int) -> void:
    last_floor_touch = now

    # Jump
    if (now - last_jump_press) <= max(0, settings.jump_buffer_ms):
        jump(now)
    
    # Land
    elif not prev_tick_on_floor:
        last_land = now

    var direction := Input.get_axis("left", "right")

    # Apply X velocity
    apply_x_velocity(
        direction,
        settings.run_acceleration,
        settings.turn_acceleration,
        settings.run_decceleration,
        delta
        )


func apply_x_velocity(
    direction: float, 
    acceleration: float, 
    turn_acceleration: float, 
    decceleration: float, 
    delta: float
    ):
    var turning: bool = (direction * player.velocity.x) < 0

    if direction:
        var acc: float = acceleration if not turning else turn_acceleration
        player.velocity.x += acc * direction * delta
    else:
        player.velocity.x = move_toward(player.velocity.x, 0, decceleration * delta)


func jump(now: int = -1) -> void:
    if now == -1:
        now = Global.now
    player.velocity.y = - settings.jump_strength
    last_jump = now
    last_jump_press = 0


func process_push(now: int):
    if not settings.can_push:
        return
    
    for i in player.get_slide_collision_count():
        var collision: KinematicCollision2D = player.get_slide_collision(i)
        if collision.get_collider() is RigidBody2D:
            last_obstacle_collide = now
            var collider: Object = collision.get_collider()
            collider.apply_central_impulse(-collision.get_normal() * settings.push_force)
