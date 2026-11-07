extends AudioStreamPlayer
class_name MusicPlayer


enum SongName {
    ASTEROID
}


var loop: bool = true
var fading_out: bool = false
var fading_in: bool = false
var prev_position: float = 0
var base_volume_lin: float = 1.0

@onready var fade_out_timer: Timer = $FadeOutTimer
@onready var fade_in_timer: Timer = $FadeInTimer


func prepare_song(song_file: String, loop_: bool, volume_db_: float = 0.0) -> void:
    if playing:
        stop()
    prev_position = 0
    fading_out = false
    fading_in = false

    stream = load(song_file)
    volume_db = volume_db_
    base_volume_lin = db_to_linear(volume_db_)
    loop = loop_


func pause(fade_out: float = -1) -> void:
    prev_position = get_position()
    if fade_out == 0:
        stop()
    else:
        fade_out_timer.start(fade_out)
        fading_out = true


func resume(fade_in_: float = -1) -> void:
    fading_out = false
    if fade_in_ == 0:
        play(prev_position)
    else:
        fade_in_timer.start(fade_in_)
        fading_in = true
        volume_db = linear_to_db(0)
        play(prev_position)


func fade_in(duration: float = -1) -> void:
    fading_in = true
    fade_in_timer.start(duration)
    volume_db = linear_to_db(0)
    play()


func _process(_delta: float) -> void:
    if fading_out:
        var volume_lin: float = (fade_out_timer.time_left / fade_out_timer.wait_time) * base_volume_lin
        volume_db = linear_to_db(volume_lin)
    elif fading_in:
        var volume_lin: float = (1 - (fade_in_timer.time_left / fade_in_timer.wait_time)) * base_volume_lin
        volume_db = linear_to_db(volume_lin)
    

func _on_fade_out_timer_timeout() -> void:
    if fading_out:
        stop()
        fading_out = false
    

func get_position() -> float:
    return get_playback_position() + AudioServer.get_time_since_last_mix()


func get_length() -> float:
    if stream:
        return stream.get_length()
    return 0.0


func _on_finished() -> void:
    if loop:
        $LoopTimer.start()


func _on_fade_in_timer_timeout() -> void:
    if fading_in:
        volume_db = linear_to_db(base_volume_lin)
        fading_in = false


func _on_loop_timer_timeout() -> void:
    if not playing:
        play()
