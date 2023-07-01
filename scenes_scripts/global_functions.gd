extends Node


var font = load("res://lib/font/CourierPrime-Regular.ttf")
var warning_accepted = false
signal accept_warning

func set_font(node: Control, font_size: int = 32):
   var tmp_theme = Theme.new()
   tmp_theme.default_font = DynamicFont.new()
   tmp_theme.default_font.font_data = font
   tmp_theme.default_font.size = font_size
   node.theme = tmp_theme
   pass

func show_warning(parent: Node = self, triggered_func: String = "", text: String = ""):
   var warning = PopupDialog.new()
   var label = Label.new()
   var ok = Button.new()
   var cancel = Button.new()
   parent.call_deferred("add_child", warning)
   yield(warning, "tree_entered")
   warning.add_child(label)
   warning.rect_size.x = 780
   warning.rect_size.y = 440
   warning.popup_exclusive = true
   set_font(label)
   label.rect_size.x = warning.rect_size.x - 40
   label.rect_size.y = warning.rect_size.y - 110
   label.rect_position.x = 20
   label.rect_position.y = 10
   label.valign = Label.VALIGN_CENTER
   label.autowrap = true
   label.clip_text = true
   label.text = text
   warning.add_child(ok)
   warning.add_child(cancel)
   ok.rect_position.x = 430
   ok.rect_position.y = 340
   ok.rect_size.x = 200
   ok.rect_size.y = 100
   ok.text = "Ok"
   set_font(ok)
   cancel.rect_position.x = 130
   cancel.rect_position.y = 340
   cancel.rect_size.x = 200
   cancel.rect_size.y = 100
   cancel.text = "Cancel"
   set_font(cancel)
   ok.connect("pressed", self, "warning_answered", [true])
   cancel.connect("pressed", self, "warning_answered", [false])
   warning.popup_centered()
   yield(self, "accept_warning")
   if warning_accepted and triggered_func != "":
      parent.call(triggered_func)
   warning.call_deferred("free")
   pass

func warning_answered(accepted: bool):
   warning_accepted = accepted
   emit_signal("accept_warning")
   pass
