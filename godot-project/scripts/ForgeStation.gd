extends Area2D

@export var station_name: String = ""
@export var interaction_prompt: String = "Press E to interact"

func _ready():
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body):
	if body.name == "Player":
		show_interaction_prompt()

func _on_body_exited(body):
	if body.name == "Player":
		hide_interaction_prompt()

func show_interaction_prompt():
	# This would show a UI prompt in a full implementation
	pass

func hide_interaction_prompt():
	# This would hide the UI prompt
	pass