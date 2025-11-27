extends Node2D

@onready var player: CharacterBody2D = $Player
@onready var anvil: Area2D = $Anvil
@onready var grindstone: Area2D = $Grindstone
@onready var quench_tank: Area2D = $QuenchTank
@onready var ui_layer: CanvasLayer = $UILayer
@onready var score_label: Label = $UILayer/ScoreLabel
@onready var materials_label: Label = $UILayer/MaterialsLabel
@onready var crafting_panel: Control = $UILayer/CraftingPanel
@onready var echo_panel: Control = $UILayer/EchoPanel

var current_station: String = ""
var crafting_steps: Array = []
var current_step: int = 0

func _ready():
	Global.score_changed.connect(_on_score_changed)
	Global.materials_changed.connect(_on_materials_changed)
	Global.echoes_discovered.connect(_on_echo_discovered)
	
	# Connect station signals
	anvil.body_entered.connect(_on_station_entered.bind("anvil"))
	grindstone.body_entered.connect(_on_station_entered.bind("grindstone"))
	quench_tank.body_entered.connect(_on_station_entered.bind("quench"))
	
	# Hide panels initially
	crafting_panel.visible = false
	echo_panel.visible = false
	
	update_ui()

func _on_score_changed(new_score: int):
	score_label.text = "Score: %d" % new_score

func _on_materials_changed(materials: Array):
	var text = "Materials:\n"
	for material in materials:
		text += "%s: %d\n" % [material.name, material.amount]
	materials_label.text = text

func _on_echo_discovered(echo: String):
	echo_panel.visible = true
	echo_panel.get_node("EchoText").text = echo
	echo_panel.get_node("CloseButton").pressed.connect(_on_close_echo_panel)

func _on_close_echo_panel():
	echo_panel.visible = false

func _on_station_entered(station_name: String, body: Node):
	if body.name == "Player":
		current_station = station_name
		show_crafting_options()

func show_crafting_options():
	crafting_panel.visible = true
	var vbox = crafting_panel.get_node("VBoxContainer")
	
	# Clear existing buttons
	for child in vbox.get_children():
		if child is Button:
			child.queue_free()
	
	# Add crafting options based on station
	match current_station:
		"anvil":
			add_crafting_button("Forge Blade", "forge_blade")
			add_crafting_button("Forge Hammer", "forge_hammer")
		"grindstone":
			add_crafting_button("Sharpen Weapon", "sharpen")
			add_crafting_button("Polish Edge", "polish")
		"quench":
			add_crafting_button("Quench in Water", "water_quench")
			add_crafting_button("Quench in Oil", "oil_quench")
	
	# Add close button
	var close_btn = Button.new()
	close_btn.text = "Close"
	close_btn.pressed.connect(_on_close_crafting_panel)
	vbox.add_child(close_btn)

func add_crafting_button(text: String, action: String):
	var btn = Button.new()
	btn.text = text
	btn.pressed.connect(_on_crafting_action.bind(action))
	crafting_panel.get_node("VBoxContainer").add_child(btn)

func _on_crafting_action(action: String):
	match action:
		"forge_blade":
			if Global.use_material("Iron Ore", 2):
				Global.add_score(100)
				Global.discover_echo("The blade remembers a knight's final stand...")
				complete_crafting_step()
		"forge_hammer":
			if Global.use_material("Iron Ore", 3) and Global.use_material("Ancient Wood", 1):
				Global.add_score(150)
				Global.discover_echo("This hammer once shattered the gates of an ancient fortress...")
				complete_crafting_step()
		"sharpen":
			Global.add_score(50)
			Global.discover_echo("A warrior's prayer echoes from the edge...")
			complete_crafting_step()
		"polish":
			Global.add_score(75)
			Global.discover_echo("The reflection shows faces of past wielders...")
			complete_crafting_step()
		"water_quench":
			Global.add_score(60)
			Global.discover_echo("Steam rises like the breath of a dragon...")
			complete_crafting_step()
		"oil_quench":
			Global.add_score(80)
			Global.discover_echo("The oil preserves memories of ancient battles...")
			complete_crafting_step()

func complete_crafting_step():
	current_step += 1
	if current_step >= 5:  # Victory condition
		get_tree().change_scene_to_file("res://scenes/VictoryScreen.tscn")

func _on_close_crafting_panel():
	crafting_panel.visible = false

func update_ui():
	_on_score_changed(Global.score)
	_on_materials_changed(Global.materials)