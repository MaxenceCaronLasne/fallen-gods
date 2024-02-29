extends Node2D
class_name CoinSpawner

var COIN := preload("res://coin.tscn")

func generate_coins(positions: Array[Vector2]) -> void:
	var mult := len(positions)
	
	for p in positions:
		for i in range(mult):
			var coin := COIN.instantiate() as Coin
			coin.global_position = p
			add_child(coin)
