extends Node

signal score_changed(new_score: int)
signal materials_changed(materials: Array)
signal echoes_discovered(echo: String)

var score: int = 0
var materials: Array = []
var discovered_echoes: Array = []
var current_weapon: Dictionary = {}
var forging_progress: float = 0.0

func add_score(points: int):
	score += points
	score_changed.emit(score)

func reset_score():
	score = 0
	score_changed.emit(score)

func add_material(material_name: String, amount: int = 1):
	for material in materials:
		if material.name == material_name:
			material.amount += amount
			materials_changed.emit(materials)
			return
	materials.append({"name": material_name, "amount": amount})
	materials_changed.emit(materials)

func use_material(material_name: String, amount: int = 1) -> bool:
	for material in materials:
		if material.name == material_name and material.amount >= amount:
			material.amount -= amount
			materials_changed.emit(materials)
			return true
	return false

func discover_echo(echo_text: String):
	discovered_echoes.append(echo_text)
	echoes_discovered.emit(echo_text)
	add_score(50)

func reset_game():
	reset_score()
	materials = []
	discovered_echoes = []
	current_weapon = {}
	forging_progress = 0.0