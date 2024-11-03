extends Node

# MIDI configuration
const MIDI_MIN_VELOCITY = 0.1
const MIDI_MAX_VELOCITY = 1.0

# Exported properties
export(bool) var enable_bark_effects = true

# Internal state
var _state = {
	"is_initialized": false
}
var _player_api

onready var _guitar_strummer = preload("res://mods/PotatoMidi/Scripts/Guitar/GuitarStrummer.gd").new()
onready var _bark_effect = preload("res://mods/PotatoMidi/Scripts/Bark/BarkEffect.gd").new()

func _ready():
	print("Midi: Initializing MIDI system...")
	_setup_player_api()
	
func _setup_player_api():
	_player_api = get_node_or_null("/root/BlueberryWolfiAPIs/PlayerAPI")
	if _player_api:
		_player_api.connect("_ingame", self, "_setup_midi")
	
func _setup_midi():
	if OS.open_midi_inputs():
		print("Midi: Successfully opened MIDI inputs")
		_state.is_initialized = true
	else:
		push_error("Midi: Failed to open MIDI inputs")

func _input(event):
	if not event is InputEventMIDI:
		return
	
	if event.channel == 0:
		 _guitar_strummer._input(event) 
	_handle_midi_event(event)

func _handle_midi_event(event):
	if event.message == MIDI_MESSAGE_NOTE_ON and event.velocity > 0:
		_handle_note_on(event)

func _handle_note_on(event):
	var player = _player_api.local_player
	if not is_instance_valid(player):
		return
		
	if enable_bark_effects and _bark_effect and event.channel >= 1:
		_bark_effect.trigger_bark(player, event.pitch, event.channel)
