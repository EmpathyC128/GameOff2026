extends CanvasLayer

@onready var animation: AnimationPlayer = $AnimationPlayer
@onready var wait_timer: Timer = $WaitTimer

var _wait_duration: float = -1


enum GameScene {
    START_MENU
}

var _scene_paths: Dictionary[GameScene, String] = {
    GameScene.START_MENU: "uid://s07a6jx8rfxk"
}


func _ready() -> void:
    get_tree().scene_changed.connect(_on_scene_changed)


func fade_out() -> void:
    animation.play("fade_out")
    await animation.animation_finished


func fade_in() -> void:
    animation.play("fade_in")
    await animation.animation_finished


func _get_scene_path(scene: GameScene) -> String:
    return _scene_paths.get(scene)


func transition(scene: GameScene, wait_duration: float = -1) -> void:
    _wait_duration = wait_duration
    await fade_out()
    get_tree().change_scene_to_file(_get_scene_path(scene))


func _on_scene_changed() -> void:
    wait_timer.start(_wait_duration)


func _on_wait_timer_timeout() -> void:
    await fade_in()
