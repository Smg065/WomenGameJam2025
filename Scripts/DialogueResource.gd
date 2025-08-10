extends Resource
class_name DialogueEvent

enum CharacterSpeaking {LULU, DONUT, GOOB}

@export var mainLine : DialogueLine
@export var character : CharacterSpeaking
@export var characterSprite : Texture2D
@export var reactionSprite : Texture2D
@export var sound : AudioStream
@export var optionsLines : Array[DialogueLine]
