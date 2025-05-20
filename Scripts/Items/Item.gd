@icon("res://Assets/Icons/default_item.png")
extends Resource
class_name Item

enum Category { EQUIPMENT, CONSUMABLE, RESOURCE, QUEST }
enum Rank { D, C, B, A, S }

@export var id: String
@export var name: String
@export var description: String
@export var icon: Texture2D

@export var category: Category
@export var rank: Rank

@export var is_stackable: bool = true
@export var max_stack: int = 99

@export var drop_rate: float = 0.0
