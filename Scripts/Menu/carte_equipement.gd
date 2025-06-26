extends "res://Scripts/Menu/carte_item.gd"

@onready var slot_label = $Fond/MarginContainer/VBoxContainer/LigneSlotNiveau/Slot
@onready var niveau_label = $Fond/MarginContainer/VBoxContainer/LigneSlotNiveau/Niveau
@onready var perfection_bar = $Fond/MarginContainer/VBoxContainer/Perfection
@onready var stats_container = $Fond/MarginContainer/VBoxContainer/StatsContainer


func _ready():
	super._ready()
	var equipement = item as Equipement
	if equipement:
		slot_label.text = equipement.slot
		niveau_label.text = "Niv. %d" % equipement.niveau
		perfection_bar.value = equipement.perfection
		
		for s in equipement.stats:
			var label = Label.new()
			label.text = "%s : %d" % [s, equipement.stats[s]]
			stats_container.add_child(label)
