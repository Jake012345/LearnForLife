extends TabContainer


func _ready():
   current_tab = 0
   pass

func _process(delta):
   if Input.is_action_just_pressed("ui_cancel"):
      go_back()
   pass

func _notification(what):
   if what == MainLoop.NOTIFICATION_WM_GO_BACK_REQUEST or \
   what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
      go_back()

func go_back():
      if current_tab < 4:
         current_tab = 0  #back to selector screen
      if current_tab == 4 or current_tab == 5:
         current_tab = 2 #back to test screen from it's "children"

func change_screen(to: int):
   current_tab = to
   pass
