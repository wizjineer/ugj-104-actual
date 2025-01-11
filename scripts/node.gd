extends Node

class_name inventory

@export var rescources: Dictionary = {}

func add_resources(type: Resource, ammound: int):
	rescources[type] = rescources[type] + ammound
