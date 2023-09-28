extends Panel

onready var cycle_list = get_node("CycleList")
onready var cycle_number_selector = get_node("SpinBoxCycle")

func load_data():
   cycle_list.clear()
   for i in GlobalDatabase.term_returning_cycles:
     cycle_list.add_item(String(i))
   pass


func show_cycle_help():
   GlobalFunctions.show_warning(self, "show_cycle_help_2", "\n This setting is about the questioning cycles. \n The base values are 1, 3, 5, 7, 10. \n The numbers are declaring the required number of days to pass to make a 'term' actual again.")
   pass

func show_cycle_help_2():
   GlobalFunctions.show_warning(self, "show_cycle_help_3", "\n It means that with the base values, every 'term' will be asked you in the 1st, 3rd, 5th, 7th and 10th day, counting from the creation of the 'term' (when you added it to library).")
   pass

func show_cycle_help_3():
   GlobalFunctions.show_warning(self, "show_cycle_help_4", "If you miss a day on a 'term', it's creation day will be set to the next day you use the app, and the counting will start over from then.")
   pass

func show_cycle_help_4():
   GlobalFunctions.show_warning(self, "show_cycle_help_5", "If you are done with the 'term' entirely (answered every required day), it will be marked as 'known' and will never be asked again by the cycle system.")
   pass

func show_cycle_help_5():
   GlobalFunctions.show_warning(self, "", "According to the current version, if you modify te list, all term's cycle information will be deleted and reset, except those marked as known. (other solutions are coming soon)")
   pass

func add_cycle_number():
   if not(String(cycle_number_selector.value) in cycle_list.items):
     cycle_list.add_item(String(cycle_number_selector.value))
   cycle_list_refresh()
   pass


func modify_cycle_number():
   if not(String(cycle_number_selector.value) in cycle_list.items):
     if cycle_list.get_selected_items().size() > 0:
       cycle_list.set_item_text(cycle_list.get_selected_items()[0], String(cycle_number_selector.value))
   cycle_list_refresh()
   pass


func remove_cycle_number():
   if cycle_list.get_selected_items().size() > 0:
     cycle_list.remove_item(cycle_list.get_selected_items()[0])
   cycle_list_refresh()
   pass


func cycle_list_refresh():
   var tmp_array = []
   for i in cycle_list.get_item_count():
     tmp_array.append(int(cycle_list.get_item_text(i)))
   cycle_list.clear()
   tmp_array.sort()
   for i in tmp_array:
     cycle_list.add_item(String(i))
   cycle_number_selector.value = 0
   pass

func apply_settings():
   var tmp_array = []
   for i in cycle_list.get_item_count():
     tmp_array.append(int(cycle_list.get_item_text(i)))
   GlobalDatabase.term_returning_cycles = tmp_array
   for i in GlobalDatabase.terms:
      if i.actuality_day_count != -1:
         i.actuality_day_count = GlobalDatabase.term_returning_cycles[0]
   GlobalDatabase.save_data()
   
   self.hide()
   pass


func cancel_settings():
   self.hide()
   pass


func library_reset():
   GlobalFunctions.show_warning(self, "library_reset_accepted", "Warning: \n Are you sure you want to delete all the data saved in the app? \n (Resets the app to fresh install state)")
   pass

func library_reset_accepted():
   GlobalDatabase.reset_database()
   cancel_settings()
   pass
