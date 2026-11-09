class_name MovementSettings extends Resource

enum PrimaryMode {
    FLY,
    WALK
}

# Modes
@export_category("Modes")
@export var primary_mode: PrimaryMode = PrimaryMode.WALK
@export var can_dig: bool = false
@export var can_jump: bool = true
@export var can_push: bool = false

# Running
@export_category("Running")
@export var max_run_speed: float
@export var run_acceleration: float
@export var run_decceleration: float
@export var turn_acceleration: float

# Jumping
@export_category("Jumping")
@export var jump_strength: float
@export var downward_gravity_multiplier: float = 1.0
@export var air_acceleration: float
@export var air_decceleration: float
@export var air_turn_acceleration: float

# Assist
@export_category("Assist")
@export var coyote_time_ms: int
@export var jump_buffer_ms: int
@export var terminal_velocity: float

# Other
@export_category("Other")
@export var push_force: float = 80.0
