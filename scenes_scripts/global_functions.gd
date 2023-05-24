extends Node


var font = load("res://lib/font/CourierPrime-Regular.ttf")

func set_font(node: Control, font_size: int = 32):
   var tmp_theme = Theme.new()
   tmp_theme.default_font = DynamicFont.new()
   tmp_theme.default_font.font_data = font
   tmp_theme.default_font.size = font_size
   node.theme = tmp_theme
   pass
