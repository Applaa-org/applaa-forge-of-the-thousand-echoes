extends Control

func _ready():
	$VBoxContainer/StartButton.pressed.connect(_on_start_pressed)
	$VBoxContainer/CloseButton.pressed.connect(_on_close_pressed)
	
	# Initialize starting materials
	Global.add_material("Iron Ore", 5)
	Global.add_material("Mystic Crystal", 2)
	Global.add_material("Ancient Wood", 3)

func _on_start_pressed():
	get_tree().change_scene_to_file("res://scenes/Main.tscn")

func _on_close_pressed():
	get_tree().quit()