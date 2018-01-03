extends Node

const SAVE_PATH = "user://savegame.save"

var saveFile = File.new()

var _settings = { "record" : recorde,
				  "rever"  : rever}

onready var recorde = 0
onready var rever = true

func _ready():
	if not saveFile.file_exists(SAVE_PATH):
		criarSalvaJogo()
	else:
		carregarJogo()

func criarSalvaJogo():
	saveFile.open(SAVE_PATH, File.WRITE)
	saveFile.store_var(_settings)
	saveFile.close()
	
func salvarJogo():
	_settings.record = recorde
	saveFile.open(SAVE_PATH, File.WRITE)
	saveFile.store_var(_settings)
	saveFile.close()

func carregarJogo():
	saveFile.open(SAVE_PATH, File.READ)
	_settings = saveFile.get_var()
	saveFile.close()
	recorde = _settings.record

