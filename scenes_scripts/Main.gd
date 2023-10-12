extends TabContainer

onready var settings = get_node("SelectorScreen/Settings")


func _ready():
   GlobalDatabase.connect("database_missing", self, "show_first_start_warning")
   GlobalDatabase.load_data() ## calling from here so the signal is surely bound at it's run
   settings.hide()
   current_tab = 0
   randomize()
   pass

func _process(_delta):
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
      leave_request()

func leave_request():
   GlobalFunctions.show_warning(self, "leave_request_accepted", "It's not a good idea to stop midway at learning. You will have to start over.")
   GlobalDatabase.load_data()
   pass

func leave_request_accepted():
   current_tab = 2
   pass

func change_screen(to: int):
   current_tab = to
   pass

func go_to_add():
   change_screen(1)
   pass


func show_settings():
   settings.show()
   pass

func show_first_start_warning():
   print("show")
   GlobalFunctions.show_warning(self, "show_first_start_warning_2", "Oops....\nIt seems you are running the application the first time or your database is missing for some reason.\n" \
    + "If you just updated the application and lost all your data, contact the author(s).")
pass

func show_first_start_warning_2():
   GlobalFunctions.show_warning(self, "", "In case you are new to this application, you might consider to check the settings first, using the little gear icon at the top on the main screen.\nAnywhere in the app you can use the blue information buttons whenever something complicated shows up.")
   pass

