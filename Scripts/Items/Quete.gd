#@icon("res://Assets/Sprites/UI/Icons/Items/quest_icon.png")
# Scripts/Items/QuestItem.gd
extends Item
class_name QuestItem

@export var quest_name: String
@export var is_consumed_on_use: bool = false
