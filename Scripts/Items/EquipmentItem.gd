@icon("res://UI/Icons/Items/equipment_icon.png")
# Scripts/Items/Equipment.gd
extends "res://Scripts/Items/Item.gd"
class_name EquipmentItem

enum Slot { HEAD, CHEST, LEGS, FEET, WEAPON, RING, AMULET }

@export var slot: Slot

# Stats min/max pour la génération aléatoire
@export var min_health: int
@export var max_health: int
@export var min_force: int
@export var max_force: int
@export var min_mana: int
@export var max_mana: int
@export var min_attack_speed: float
@export var max_attack_speed: float
@export var min_magic_resist: float
@export var max_magic_resist: float
@export var min_physical_resist: float
@export var max_physical_resist: float
@export var min_move_speed: float
@export var max_move_speed: float

@export var on_character_scene: PackedScene 
#faut regarder packedScene, en gros j'peux call une scene on flick au besoin, la pour afficher une épée dans la main d'un boug 
