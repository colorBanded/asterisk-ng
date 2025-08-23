extends Node2D
class_name gameGD

@onready var leaderboard: Label = $timer
@onready var countdown: Label = $countdown
@onready var board: Board = $Board
@export var start_countdown: int = 3
@export var shrink_time: float = 0.8
@export var flash_time: float = 0.1
@onready var shadow: ColorRect = $shadow
@onready var music: Label = $countdown2
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D

var elapsed_ms := 0
var start_time := 0
var stopwatch_running := false

func _ready() -> void:
	shadow.modulate = Color(0,0,0,0.5)
	board.skyline_reached.connect(_on_skyline_reached)
	board.game_over.connect(_on_game_over)
	animstart()

func animstart():
	countdown.show()
	var count = start_countdown
	
	while count > 0:
		countdown.text = str(count)
		countdown.scale = Vector2(2, 2)
		countdown.modulate = Color(1, 1, 1, 0)
		var tween = get_tree().create_tween()
		tween.tween_property(countdown, "modulate:a", 1.0, flash_time)
		await tween.finished
		tween = get_tree().create_tween().set_parallel(true)
		tween.set_trans(Tween.TRANS_EXPO)
		tween.set_ease(Tween.EASE_OUT)
		tween.tween_property(countdown, "scale", Vector2(1, 1), shrink_time)
		tween.tween_property(countdown, "modulate:a", 0.0, shrink_time)
		await tween.finished
		count -= 1
	
	if count == 0:
		countdown.text = str("GO")
		countdown.scale = Vector2(2, 2)
		countdown.modulate = Color(1, 1, 1, 0)
		var tween = get_tree().create_tween()
		tween.tween_property(countdown, "modulate:a", 1.0, flash_time)
		await tween.finished
		tween = get_tree().create_tween().set_parallel(true)
		tween.set_trans(Tween.TRANS_EXPO)
		tween.set_ease(Tween.EASE_OUT)
		tween.tween_property(countdown, "scale", Vector2(1, 1), shrink_time)
		tween.tween_property(countdown, "modulate:a", 0.0, shrink_time)
		await tween.finished
		
	countdown.hide()
	var shadowAnim = get_tree().create_tween()
	shadowAnim.tween_property(shadow, "modulate:a", 0.0, flash_time)
	await shadowAnim.finished
	
	Properties.gamestarted = 1
	start_stopwatch()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("m"):
		if audio_stream_player_2d.stream_paused == true:
			audio_stream_player_2d.stream_paused = false
			music.text = "Paused."
		elif audio_stream_player_2d.stream_paused == false:
			audio_stream_player_2d.stream_paused = true
			music.text = "Idea - Origami JP"
		
	if stopwatch_running:
		var current_time = Time.get_ticks_msec()
		elapsed_ms = current_time - start_time
		update_stopwatch_label()

func format_time(ms: int) -> String:
	var total_seconds = ms / 1000.0
	var minutes = int(total_seconds) / 60
	var seconds = int(total_seconds) % 60
	var milliseconds = int(ms % 1000)
	return "%02d:%02d.%03d" % [minutes, seconds, milliseconds]

func update_stopwatch_label():
	var total_seconds = elapsed_ms / 1000.0
	var minutes = int(total_seconds) / 60
	var seconds = int(total_seconds) % 60
	var milliseconds = int(elapsed_ms % 1000)
	var current_str = format_time(elapsed_ms)
	var best_str = format_time(Properties.highscore) if Properties.highscore > 0 else "00:00.000"
	var highest_str = format_time(Properties.highestScore) if Properties.highestScore > 0 else "00:00.000"
	leaderboard.text = "Current: %s\nBest:    %s" % [current_str, best_str]

func start_stopwatch():
	start_time = Time.get_ticks_msec()
	stopwatch_running = true

func stop_stopwatch():
	stopwatch_running = false
	if Properties.highscore == 0 or elapsed_ms < Properties.highscore:
		Properties.highscore = elapsed_ms
	if Properties.highestScore == 0 or elapsed_ms < Properties.highestScore:
		Properties.highestScore = elapsed_ms
	update_stopwatch_label()

func _on_skyline_reached():
	stop_stopwatch()
	print("Congratulations! You reached the skyline!")
	print("Your time: ", format_time(elapsed_ms))
	print("Best time: ", format_time(Properties.highscore))

func _on_game_over():
	stop_stopwatch()
	print("Game Over!")
	print("Your time: ", format_time(elapsed_ms))
