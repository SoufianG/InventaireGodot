@icon("res://Assets/Sprites/UI/Icons/Items/weapon_icon.png")
extends Equipement
class_name Arme

@export var weapon_scene: PackedScene      # Scène affichée ou attachée en jeu
@export_enum("Physique", "Magique", "Feu", "Glace", "Poison", "Sacré") var damage_type: String = "Physique"
@export_range(0.1, 10.0) var range: float = 1.5  # Distance d'utilisation
@export_range(0.1, 5.0) var attack_speed: float = 1.0  # Attaques par seconde ou cooldown

# Méthode virtuelle, à surcharger par les sous-classes
func attack(target: Node) -> void:
	print("⚔️ Arme attaque la cible : %s (type %s)" % [target.name, damage_type])
