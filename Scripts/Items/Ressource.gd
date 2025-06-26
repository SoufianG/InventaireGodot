@icon("res://Assets/Sprites/UI/Icons/Items/resource_icon.png")
# Scripts/Items/ResourceItem.gd
extends Item
class_name ResourceItem

@export var used_in_recipes: Array[String] = []  # noms d'items ou d'id
