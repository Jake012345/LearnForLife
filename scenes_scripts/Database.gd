extends Node

var terms = {}
var subjects = []
var next_term_id = 0
var data_file_path = "user://Database.txt"
var data_file = File.new()

func _ready():
   load_data()
   pass

func load_data():
   var raw_data = ""
   if data_file.file_exists(data_file_path):
      data_file.open(data_file_path, File.READ)
      raw_data = data_file.get_as_text()
   else:
      data_file.open(data_file_path, File.WRITE)
      #>>maybe a warning asw (there were problems)
   data_file.close()

   var line = ""
   var lines = []
   for i in raw_data:
      if i != "\n":
         line += i
      else:
         if line == "":
            continue
         lines.append(line.strip_edges())
         line.clear()
#   print(lines)   #> PARSING IS REQUIRED
   if lines.size() >= 3:    ##>>>>  ELSE --->>> SURELY DAMAGED/ CORRUPT FILE
      next_term_id = int(lines[0])
      var terms_size = int(lines[1])
      var subjects_size = int(lines[2])
      for i in range(3):
         lines.remove(0)
      for i in terms_size:
         var tmp_term = Term.new()
         var tmp_term_id = int(String(lines[0]).split(";")[0].strip_edges())
         var tmp_term_data = String(lines[0]).split(";")[1].strip_edges()
         tmp_term.from_list_string(tmp_term_data)
         terms[int(tmp_term_id)] = tmp_term
         lines.remove(0)
      for i in subjects_size:
         var tmp_data = lines[0]
         var tmp_subject = Subject.new()
         tmp_data = tmp_data.remove(0)
         tmp_data = tmp_data.split(",")
         pass    #>>>>>>>>>>>>>>>>> PARSING SUBJECTS

   pass

func save_data():  #>>>>> SAFETY SAVE:   TMP_FILE --> REAL FILE
   var text_to_save = String(
      String(next_term_id) + "\n" +
      String(terms.size()) + "\n" +
      String(subjects.size()) + "\n"
      )
   for i in terms.keys():
      text_to_save += String(i) + ";" + String(terms[i].as_list()) + "\n"
   for i in subjects:
      text_to_save += String(i.as_list()) + "\n"
      pass
   data_file.open(data_file_path, File.WRITE)
   data_file.store_string(text_to_save)
   data_file.close()
   print(text_to_save)
   pass

func add_term(term: Term):
   terms[next_term_id] = term
   next_term_id += 1
   save_data()
   pass

func add_subject(text: String, topics: Array = []):
   var tmp_subject = Subject.new()
   tmp_subject.text = text
   tmp_subject.topics += topics
   subjects.append(tmp_subject)
   save_data()
   pass

func add_topic(topic: String, subject: Subject):
   subject.add_topic(topic)
   save_data()
   pass

func remove_term(term_id: int):     ###not sure if it works cuz it's not string
   terms.erase(term_id)
   save_data()
   pass

func remove_subject(subject: int):
   subjects.remove(subject)
   save_data()
   pass

func remove_topic(topic: String, subject: Subject):
   subject.remove_topic(topic)
   save_data()
   pass

func get_terms_by_subject(subject: Subject):
   var tmp = []
   for i in terms:
      if terms[i].subject == subject:
         tmp.append(terms[i])
   return tmp
   pass

func get_terms_by_topic(topic: String):
   var tmp = []
#####################################
   return tmp
   pass

func get_term_count():
   return terms.size()
   pass

func get_subject(id: int):
   return subjects[id]
   pass

func get_subject_by_name(name: String):
   for i in subjects:
      if i.text == name:
         return i
   pass
