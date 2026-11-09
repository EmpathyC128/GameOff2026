extends Node2D


var paused: bool = false:
    set(value):
        paused = value
        SignalBus.paused_status.emit(value)


func pause():
    paused = true


var now: int:
    get:
        return Time.get_ticks_msec()