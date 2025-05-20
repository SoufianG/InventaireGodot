@icon("res://Assets/Icons/consumable_item.png")
extends Item
class_name ConsumableItem

# Le type d'effet déclenché par l'item
enum EffectType { HEAL, MANA, STAMINA, DAMAGE, BUFF }
@export var effect_type: EffectType 

# Type de dégâts ou de buff (force, vie, mana...)
enum StatType { NONE, HP, MANA, STAMINA, STRENGTH, MAGIC, RES_PHYS, RES_MAG, SPEED, ATTACK_SPEED }
@export var stat_type: StatType 

# Valeur de l’effet
@export var amount: int = 0

# Si c’est un buff, durée en secondes
@export var duration: float = 0.0

# Zone d’effet
@export var is_aoe: bool = false
@export var aoe_radius: float = 0.0

@export var on_map_scene: PackedScene
