extends Node

onready var wait_time = 2

var score = 0
var maiorPontuacao = 0

var resposta = false

var rgbVermelho = Color(.89,.16,.15)
var rgbLaranja  = Color(1,.42,.02)
var rgbAmarelo  = Color(1,.90,.02)
var rgbVerde    = Color(.02,1,.30)
var rgbAzul	 	= Color(.02,.56,1)
var rgbRoxo 	= Color(.48,.02,1)
var rgbRosa		= Color(1,.02,.67)
var rgbPreto	= Color(0,0,0)

var coresrgb = [rgbVermelho, rgbLaranja, rgbAmarelo, rgbVerde, rgbAzul, rgbRoxo, rgbRosa, rgbPreto]
var coresNome = ["Vermelho", "Laranja", "Amarelo", "Verde", "Azul", "Roxo", "Rosa", "Preto"]

var indexCor
var indexNome

onready var contagemRegressiva = get_node("Timer")
onready var barraContagem = get_node("ProgressBar")



#início de salvando maior score
const SAVE_PATH = "user://savegame.save"

var saveFile = File.new()

var _settings = { "record" : recorde,
				  "rever"  : rever}

onready var recorde = 0
onready var rever = true

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

#fim de salvando maior score



func _ready():
	
	if not saveFile.file_exists(SAVE_PATH):
		criarSalvaJogo()
	else:
		carregarJogo()
		
	get_node("musica").play()
	contagemRegressiva.start()
	get_node("score").set_text(str(score))
	set_process(true)
	gerarResposta()
	
	

func _process(delta):
	
	acelerar()
	if wait_time == 1:
		barraContagem.set_value(contagemRegressiva.get_time_left() * 100)
	else:
		barraContagem.set_value(contagemRegressiva.get_time_left() * 50)
	contagemRegressiva.set_wait_time(wait_time)

func _on_Timer_timeout():
	game_over()

func game_over():
	get_node("Timer").set_wait_time(2)
	
	if score >= maiorPontuacao:
		maiorPontuacao = score
		recursos.recorde = maiorPontuacao
		
	get_node("AnimationPlayer").play("GameOver")
	
	get_node("erro").play()
	get_node("texto").set_text("GAME OVER!")
	get_node("maxScore").set_text("Recorde = " + str(recursos.recorde))
	get_tree().set_pause(true)

func gerarResposta():
	randomize()
	indexCor = (randi() % coresrgb.size())
	indexNome = (randi() % coresrgb.size())
	
	var corRgb = coresrgb[indexCor]
	var corNome = coresNome[indexNome]
	
	
	get_node("texto").set("custom_colors/font_color", corRgb)
	get_node("texto").set_text(corNome)
	
	
func verificarResposta():
	if indexCor == indexNome:
		resposta = true
		gerarResposta()
	else:
		resposta = false
		gerarResposta()
	contagemRegressiva.start()
	
	
func _on_btn_nao_pressed():
	verificarResposta()
	if !resposta:
		score += 1
		get_node("acerto").play()
		get_node("score").set_text(str(score))
		gerarResposta()
		
	else:
		game_over()
	

func _on_btn_sim_pressed():
	verificarResposta()
	if resposta:
		score += 1
		get_node("acerto").play()
		get_node("score").set_text(str(score))
		gerarResposta()
	else:
		game_over()


func _on_btn_voltar_pressed():
	restart()
	
func restart():
	get_node("AnimationPlayer").stop()
	
	get_node("maxScore").set_text("")
	score = 0
	get_node("score").set_text(str(score))
	get_tree().set_pause(false)
	gerarResposta()
	get_node("Timer").start()
	

func acelerar():
	if score > 5:
		wait_time = 1
	else: 
		wait_time = 2
	if score > 10:
		get_node("texto").set("custom_fonts/font", "res://fonte/bandmess.fnt")