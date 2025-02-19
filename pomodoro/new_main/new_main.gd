extends Control
@onready var status_label: Label = $PanelContainer/VBoxContainer/Label
@onready var time_label: Label = $PanelContainer/VBoxContainer/TextureRect/Label
@onready var start_button: Button = $PanelContainer/VBoxContainer/HBoxContainer/MarginContainer/StartButton
@onready var reset_button: Button = $PanelContainer/VBoxContainer/HBoxContainer/MarginContainer/ResetButton
@onready var timer: Timer = $Timer
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var _is_working: bool = true
var timer_status: bool = false
var _work_time_min: int = 25
var _rest_time_min: int = 5
var _time_sec: int = 0
var _work_mins: int = 0
var _rest_mins: int = 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer.stop()

func _on_start_button_pressed() -> void:
	if timer_status == false:
		status_label.text = "Work"
		timer.start()
		animation_player.play("wiggle")
		timer_status = true


func _on_reset_button_pressed() -> void:
	timer.stop()
	time_label.text = "00:00"
	animation_player.stop(false)
	status_label.text = "Pomodoro"
	timer_status = false
	_time_sec = 0
	_rest_mins = 0
	_work_mins = 0


func _count_seconds(sec: int) -> void:
	if _is_working:
		status_label.text = "Work"
	else:
		status_label.text = "Rest"
	_time_sec += sec
	if _time_sec == 60 and _is_working:
		_work_mins += 1
		_time_sec = 0
		if _work_mins == _work_time_min:
			_is_working = false
	
	if _time_sec == 60 and not _is_working:
		_rest_mins += 1
		_time_sec = 0
		if _rest_mins == _rest_time_min:
			_is_working = true
		

	_update_time_label()

func _update_time_label() -> void:
	var _min_format: String = "0" + str(_work_mins)
	var _sec_format: String = "0" + str(_time_sec)

	if len(str(_work_mins)) > 1:
		_min_format = str(_work_mins)
	
	if len(str(_time_sec)) > 1:
		_sec_format = str(_time_sec)
	
	time_label.text = (_min_format + ":" + _sec_format)

# gets implicitly called by the engine
func _on_timer_timeout() -> void:
	_count_seconds(1)
