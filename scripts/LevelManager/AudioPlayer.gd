extends Node

@export var bus_names: Array[String]

func _ready():
	for bus_name in bus_names:
		var bus_index = AudioServer.get_bus_index(bus_name)
		AudioServer.set_bus_volume_db(bus_index, linear_to_db(0.5))
