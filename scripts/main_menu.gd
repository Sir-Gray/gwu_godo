extends Control

@onready var logo = $LogoMain
@onready var buttons_root = $Buttons

func _ready():
	# Скрываем логотип
	logo.modulate.a = 0.0

	# Скрываем все кнопки
	for button in buttons_root.get_children():
		button.modulate.a = 0.0

	# Анимация логотипа
	var logo_tween := create_tween()
	logo_tween.tween_property(logo, "modulate:a", 1.0, 2.0).from(0.0)

	# Задержка перед анимацией кнопок
	await get_tree().create_timer(1.0).timeout
	
		# Воспроизводим звук включения
	$MTheme.play()
	# Анимация кнопок поочерёдно
	for button in buttons_root.get_children():
		var tween := create_tween()
		tween.tween_property(button, "modulate:a", 1.0, 0.4).from(0.0)
		await get_tree().create_timer(0.2).timeout
