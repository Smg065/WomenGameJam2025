extends Control
class_name TalkingUi

@export var characterStyles : Array[TalkingCharInfo]
@export var text : Label
@export var dialogeBox : TextureRect
@export var imageLeft : TextureRect
@export var imageRight : TextureRect
var currentLine : DialogueEvent

func _process(delta: float) -> void:
	if currentLine == null:
		return
	if text.visible_ratio == 1:
		return
	text.visible_ratio += delta
	if text.visible_ratio > 1:
		text.visible_ratio = 1

func switch_line(newLine : DialogueEvent) -> void:
	currentLine = newLine
	var charStyle : TalkingCharInfo = characterStyles[currentLine.character]
	dialogeBox.texture = charStyle.textBackdrop
	text.label_settings.font_color = charStyle.textColor
	
	#Set based off language
	match SaveData.language:
		Save.Language.ENGLISH:
			text.text = currentLine.mainLine.textEn
		Save.Language.SPANISH:
			text.text = currentLine.mainLine.textEs
	
	text.visible_ratio = 0
	imageLeft.texture = currentLine.characterSprite
	imageRight.texture = currentLine.reactionSprite

func push_nextline() -> int:
	if text.visible_ratio < 1:
		text.visible_ratio = 1
		return -1
	if currentLine.mainLine.exitDialogue:
		return -2
	if currentLine.optionsLines.size() > 0:
		return -1
	return currentLine.mainLine.nextLineIndex
