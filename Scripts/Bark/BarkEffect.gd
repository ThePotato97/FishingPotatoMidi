extends Node
class_name BarkEffect

# Audio settings
const LETTER_TO_SING = "aeiouaeiouaeiou"
const MIDI_ORIGINAL_NOTE = 53  # C3
# Exported properties
export(float) var bark_pitch_multiplier = 1.0




func trigger_bark(player, midi_pitch: int, channel: int):
	var pitch = _calculate_bark_pitch(midi_pitch)
	_play_bark_effect(player, pitch, channel)
#	_last_bark_time = current_time

func _calculate_bark_pitch(midi_pitch):
	var semitone_difference = midi_pitch - MIDI_ORIGINAL_NOTE
	return pow(2, semitone_difference / 12.0) * bark_pitch_multiplier

func _play_bark_effect(player, pitch, LetterIndex):
	
	# Send network event
	Network._send_actor_action(player.actor_id, "_talk", [LETTER_TO_SING, pitch], false)
	
	# Play local effect
	player._talk(LETTER_TO_SING[LetterIndex-1], pitch)
	print("Bark effect triggered with pitch: ", pitch)
