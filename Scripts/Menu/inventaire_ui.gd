extends Control

var current_category: String = "Ressource"
var categories := ["Equipement", "Consommable", "Ressource", "Quete"]

@onready var boutons_categorie := $NinePatchRect/HBoxContainer/InventaireJoueur/BoutonsCategorie

@onready var grille_items := $NinePatchRect/HBoxContainer/InventaireJoueur/GrilleItems

func _ready():
	_initialiser_categories()
	_ajouter_items_de_test()
	update_display()

func _initialiser_categories():
	boutons_categorie.clear()
	for cat in categories:
		var btn = Button.new()
		btn.text = cat
		btn.name = cat
		btn.connect("pressed", Callable(self, "_on_categorie_selected").bind(cat))
		boutons_categorie.add_child(btn)

func _on_categorie_selected(cat: String):
	current_category = cat
	update_display()

func update_display():
	grille_items.clear()

	var items = InventaireScript.data.get(current_category, [])
	for item_info in items:
		var item = item_info["item"]
		var quantite = item_info["quantite"]

		var btn = TextureButton.new()
		btn.texture_normal = item.inventory_icon if item.inventory_icon else item.icon
		btn.expand = true
		btn.stretch_mode = TextureButton.STRETCH_KEEP_ASPECT_CENTERED
		btn.tooltip_text = "%s x%d" % [item.name, quantite]

		grille_items.add_child(btn)

func _ajouter_items_de_test():
	var bois = preload("res://Resources/Items/Resources/bois.tres")
	var pepite = preload("res://Resources/Items/Resources/pepite_or.tres")

	InventaireScript.ajouter_item(bois, 5)
	InventaireScript.ajouter_item(pepite, 3)
