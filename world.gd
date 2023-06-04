extends Node

const Player = preload("res://player.tscn")

const PORT = 4343
const HOST = "127.0.0.1"
var peer = ENetMultiplayerPeer.new()

func _enter_tree():
	multiplayer.peer_connected.connect(add_peer)
	multiplayer.peer_disconnected.connect(del_peer)

func start_server():
	$WorldUI.hide()
	peer.close()
	peer.create_server(PORT)
	multiplayer.multiplayer_peer = peer
	add_peer(1)


func start_client():
	$WorldUI.hide()
	peer.close()
	peer.create_client(HOST, PORT)
	multiplayer.multiplayer_peer = peer


func add_peer(id):
	if not is_multiplayer_authority():
		return
	spawn_player(id)


func del_peer(id):
	if not is_multiplayer_authority():
		return
	despawn_plaayer(id)


func spawn_player(id):
	var p = preload("res://player.tscn").instantiate()
	p.name = str(id)
	%Players.add_child(p)


func despawn_plaayer(id):
	for p in %Players.get_children():
		if p.name == str(id):
			p.queue_free()
			break

func get_player_by_id(id: int) -> CharacterBody2D:
	for player in $Players.get_children():
		if player.name == str(id):
			return player
	return null
