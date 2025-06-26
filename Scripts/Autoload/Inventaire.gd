extends Node
class_name Inventaire

var data: Dictionary = {
	"Equipement": [],
	"Consommable": [],
	"Ressource": [],
	"Quete": []
}

func ajouter_item(item: Item, quantite: int = 1) -> void:
	var type := item.item_type
	if item.stackable:
		for i in data[type]:
			if i["item"] == item:
				i["quantite"] += quantite
				return
		data[type].append({"item": item, "quantite": quantite})
	else:
		for i in quantite:
			data[type].append({"item": item.duplicate(true)})

func retirer_item(item: Item, quantite: int = 1) -> void:
	var type := item.item_type
	for i in data[type]:
		if i["item"] == item:
			if item.stackable:
				i["quantite"] -= quantite
				if i["quantite"] <= 0:
					data[type].erase(i)
			else:
				data[type].erase(i)
			return
