extends Control

@onready var lamps = $Lamps

var lamp_colors = {
	"0000": "yellow", "0001": "yellow", "0002": "red",
	"0003": "green", "0004": "orange", "0005": "white",
	"0006": "red", "0007": "yellow", "0008": "yellow",
	"0009": "white", "0010": "yellow", "0011": "blue",
	"0012": "white", "0013": "orange", "0014": "red",
	"0015": "orange", "0016": "blue", "0017": "white", "0018": "white",
}

func _ready():
	# Воспроизводим звук включения
	$PCon.play()
	
	$Logo/Flash1_L1.modulate = Color(1.5, 1.5, 1.5, 0.0)
	$Logo/Flash1_L2.modulate = Color(1.5, 1.5, 1.5, 0.0)
	$Logo/Layer3.modulate = Color(1.5, 1.5, 1.5, 0.0)
	
	# Показываем фоновое изображение
	var bg_tween := create_tween()
	bg_tween.tween_interval(4.0)
	bg_tween.tween_property($Background, "modulate:a", 1.0, 4.0).from(0.0)
	
	# Анимируем лампы
	animate_all_lamps()
	
	# Анимируем логотип
	animate_logo()

	await get_tree().create_timer(10.0).timeout
	_go_to_main_menu()
	
# Функция анимации всех ламп
func animate_all_lamps():
	for lamp_id in lamp_colors:
		var color = lamp_colors[lamp_id]
		var lamp = lamps.get_node(lamp_id)
		animate_lamp(lamp, color)

# Создаёт анимацию конкретной лампы через Tween
func animate_lamp(lamp: Sprite2D, color: String):
	var tween := create_tween()
	tween.set_loops()  # бесконечный цикл
	
	match color:
		"green":
			tween.tween_property(lamp, "modulate:a", 1.0, 2.0).from(0.0)
			tween.tween_interval(1.0)
			tween.tween_property(lamp, "modulate:a", 0.5, 1.0)
			tween.tween_property(lamp, "modulate:a", 1.0, 1.0)

		"blue":
			tween.tween_interval(1.0)
			for i in range(3):
				tween.tween_property(lamp, "modulate:a", 1.0, 0.25)
				tween.tween_property(lamp, "modulate:a", 0.0, 0.25)
			tween.tween_interval(0.5)

		"yellow", "orange":
			tween.tween_interval(1.0) 
			tween.tween_property(lamp, "modulate:a", 1.0, 2.0).from(0.0)
			tween.tween_property(lamp, "modulate:a", 0.0, 1.0)
			tween.tween_property(lamp, "modulate:a", 1.0, 1.0)

		"red":
			tween.tween_interval(1.0)
			tween.tween_property(lamp, "modulate:a", 1.0, 0.1).from(0.0)
			tween.tween_interval(1.0)
			tween.tween_property(lamp, "modulate:a", 0.0, 2.0)

			for i in range(3):
				tween.tween_property(lamp, "modulate:a", 1.0, 0.1)
				tween.tween_property(lamp, "modulate:a", 0.0, 0.1)

		"white":
			tween.tween_interval(0.5)
			for i in range(3):
				tween.tween_property(lamp, "modulate:a", 1.0, 0.1)
				tween.tween_property(lamp, "modulate:a", 0.0, 0.1)
			tween.tween_property(lamp, "modulate:a", 0.7, 0.5)
			tween.tween_property(lamp, "modulate:a", 1.0, 1.0)
			tween.tween_property(lamp, "modulate:a", 0.3, 1.0)

func animate_logo():
	var flash_nodes = [
		$Logo/Flash1_L1,
		$Logo/Flash1_L2,
		$Logo/Flash1_L1
	]

	for node in flash_nodes:
		var tween := create_tween()
		tween.tween_property(node, "modulate:a", 1.0, 0.5).from(0.0)
		tween.tween_property(node, "modulate:a", 0.0, 0.2).set_delay(0.4)
		await get_tree().create_timer(0.6).timeout

	# Layer3 финальный всплеск (без исчезновения)
	var t_flash := create_tween()
	t_flash.tween_property($Logo/Layer3, "modulate:a", 1.0, 0.5).from(0.0)

	await get_tree().create_timer(0.6).timeout

	# FullLogo появляется и остаётся
	$Logo/FullLogo.modulate.a = 0.0
	var t_logo := create_tween()
	t_logo.tween_property($Logo/FullLogo, "modulate:a", 1.0, 3.0).from(0.0)
	
		# Ждём появления логотипа и паузу перед исчезновением
	await get_tree().create_timer(8.0).timeout

	# FullLogo исчезает
	var t_hide := create_tween()
	t_hide.tween_property($Logo/FullLogo, "modulate:a", 0.0, 2.0)

func _go_to_main_menu():
	var menu_scene = preload("res://scenes/main_menu.tscn")
	var menu_instance = menu_scene.instantiate()
	add_child(menu_instance)
