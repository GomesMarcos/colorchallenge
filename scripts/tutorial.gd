extends Node

onready var texto =  get_node("game/texto")

var arrInstrucoes = [
					"Deseja ver o Tutorial?",
					"Seja bem-vind@ ao Color Challenge!", 
					"O desafio é dizer se a cor que está no texto está correta.",
					"Quanto mais acertos...",
					"... mais o desafio aumenta!",
					"Lembre-se: a cor é o que importa!",
					"Boa diversão!",
					"3",
					"2",
					"1"
					]

var i = 0

var rgbVermelho = Color(.89,.16,.15)
var rgbLaranja  = Color(1,.42,.02)
var rgbAmarelo  = Color(1,.90,.02)
var rgbVerde    = Color(.02,1,.30)
var rgbAzul	 	= Color(.02,.56,1)
var rgbRoxo 	= Color(.48,.02,1)
var rgbRosa		= Color(1,.02,.67)
var rgbPreto	= Color(0,0,0)

var coresrgb = [rgbVermelho, rgbLaranja, rgbAmarelo, rgbVerde, rgbAzul, rgbRoxo, rgbRosa, rgbPreto]

func _ready():
	print(i)
	get_node("game/musica").play()
	texto.set_text(arrInstrucoes[0])
	
func contagemRegressiva(i):
	if i > 5:
		get_node("game/AnimationPlayer").play("inicioJogo")
		get_node("game/Timer").set_wait_time(1)
		get_node("game/Timer").start()
		
		texto.set_text(arrInstrucoes[i])

func rever():
	pass

func colorirTexto():
	randomize()
	var indexCor = (randi() % coresrgb.size())
	var corRgb = coresrgb[indexCor]
	texto.set("custom_colors/font_color", corRgb)

func _on_btn_sim_pressed():
	i += 1
	colorirTexto()
	texto.set_text(arrInstrucoes[i])
	contagemRegressiva(i)

func _on_Timer_timeout():
	colorirTexto()
	i += 1
	if i > 5 and i <= 9:
		texto.set_text(arrInstrucoes[i])
		get_node("game/Timer").start()
	if i > 9:
		get_node("game/Timer").stop()
		get_tree().change_scene("res://cenas/game.tscn")


func verTutorial():
	recursos.rever = true
	if i <= 1:
		get_node("game/AnimationPlayer").play("inicioTutorial")
	


func naoVetTutorial():
	recursos.rever = false
	i = 7
	contagemRegressiva(i)
	if i > 9:
		get_tree().change_scene("res://cenas/game.tscn")
	
