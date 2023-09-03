extends Node

var app_version = 1.0
var terms = {}
var subjects = []
var next_term_id = 0
var data_file_path = "user://Database.txt"
var data_file = File.new()
var term_returning_cycles = [1, 3, 5, 7, 10]

func _ready():
   load_data()
   pass

func load_data():
   terms.clear()
   subjects.clear()
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
   if lines.size() >= 5:    ##>>>>  ELSE --->>> SURELY DAMAGED/ CORRUPT FILE
      var data_pack_version = float(lines[0])
      if data_pack_version != app_version:
         pass ##here we can add extra data if reading from prev versions and also set the correct version type
      next_term_id = int(lines[1])
      var terms_size = int(lines[2])
      var subjects_size = int(lines[3])
      term_returning_cycles.clear()
      lines[4][0] = ""
      lines[4][-1] = ""   #### removing brackets "[" and "]"
      for i in range(lines[4].count(",") + 1):  #because it starts from 0 and the upper border is not included
         term_returning_cycles.append(int(lines[4].split(",")[i].strip_edges()))
      for _i in range(5):
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
         tmp_subject.text = tmp_data.split(",")[0].replace("[", "").strip_edges()
         tmp_data[0] = ""
         tmp_data = tmp_data.split("[")[1]
         tmp_data = tmp_data.replace("]]", "").strip_edges()
         for j in tmp_data.split(","):
            tmp_subject.topics.append(String(j.strip_edges()))
         lines.remove(0)
         subjects.append(tmp_subject)
         pass    #>>>>>>>>>>>>>>>>> PARSING SUBJECTS

   pass

func save_data():  #>>>>> SAFETY SAVE:   TMP_FILE --> REAL FILE
   for i in subjects:
      for j in i.topics:
         if j == "":
            remove_topic(i, j)
      if i.text == "":
         remove_subject_by_index(subjects.find(i))
   var text_to_save = String(
      String(app_version) + "\n" +
      String(next_term_id) + "\n" +
      String(terms.size()) + "\n" +
      String(subjects.size()) + "\n" +
      String(term_returning_cycles) + "\n"
      )
   for i in terms.keys():
      text_to_save += String(i) + ";" + String(terms[i].as_list()) + "\n"
   for i in subjects:
      text_to_save += String(i.as_list()) + "\n"
      pass
   data_file.open(data_file_path, File.WRITE)
   data_file.store_string(text_to_save)
   data_file.close()
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

func remove_term(term: Term):
   for i in terms:
      if terms[i] == term:
         terms.erase(i)
   save_data()
   pass

func remove_term_by_index(term_id: int):     ###not sure if it works cuz it's not string
   terms.erase(term_id)
   save_data()
   pass

func remove_subject_by_index(subject_id: int):
   remove_related_terms(subjects[subject_id], "")
   subjects.remove(subject_id)
   save_data()
   pass

func remove_topic(subject: Subject, topic: String):
   remove_related_terms(subject, topic)
   subject.remove_topic(topic)
   save_data()
   pass

func remove_related_terms(subject: Subject, topic: String):
   for i in terms.keys():
      if terms[i].subject == subject.text:
         if topic == "":
            remove_term_by_index(i)
         else:
            if terms[i].topic == topic:
               remove_term_by_index(i)
   pass

func get_terms_by_subject(subject: Subject):
   var tmp = []
   for i in terms:
      if terms[i].subject == subject.text:
         tmp.append(terms[i])
   return tmp
   pass

func get_terms_by_topic(topic: String):
   var tmp = []
   for i in terms:
      if terms[i].topic == topic:
         tmp.append(terms[i])
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

func filter(ignore_categories:bool, subject: String, topic: String, only_for_today: bool = true):
   var tmp_terms = {}
   if ignore_categories:
      if only_for_today:
         for i in terms:
            if calculate_actuality_of_term(terms[i]):
               tmp_terms[i] = terms[i]
      else:
         for i in terms:
            tmp_terms[i] = terms[i]
   else:
      if only_for_today:
         for i in terms:
            if (terms[i].subject == subject and terms[i].topic == topic) and calculate_actuality_of_term(terms[i]):
               tmp_terms[i] = terms[i]
               pass
      else:
        for i in terms:
           if terms[i].subject == subject and terms[i].topic == topic:
               tmp_terms[i] = terms[i]
               pass

   return tmp_terms
   pass

func calculate_actuality_of_term(term: Term):  ###NOT DONE --- calculates if the term needs to be asked at that time (1 day, 3 days, 1 week, etc.)
   var datetime_term = Time.get_unix_time_from_datetime_dict(term.creation_day.as_dict())
   var datetime_today = Time.get_unix_time_from_datetime_dict(Time.get_date_dict_from_system())
   if term.actuality_day_count == -1:
      return false   ### COMPLETELY LEARNED

   if datetime_today == (term.actuality_day_count * 86400) + datetime_term:
      return true #today is the day
   elif datetime_today < (term.actuality_day_count * 86400) + datetime_term:
      return false #its not the day yet
   else: #datetime_today + actuality days > datetime_term
     ## APPLYING PENALTY ------ YET ITS A RESET ON THE TERM'S PROGRESS
     term.actuality_day_count = GlobalDatabase.term_returning_cycles[0]
     term.creation_day.set_today()
     GlobalDatabase.save_data()
     return false
   pass

func reset_database():
   data_file.open(data_file_path, File.WRITE)
   data_file.close()
   load_data()
   pass

func rename_subject(subject: Subject, new_name: String):
   var old_name = subject.text
   for i in terms:
      if terms[i].subject == old_name:
         terms[i].subject = new_name
   subject.text = new_name
   save_data()
   pass

func rename_topic(subject: Subject, topic: String, new_name: String):
   for i in terms:
     if terms[i].subject == subject.text and terms[i].topic == topic:
        terms[i].topic = new_name
   for i in subject.topics.size():
      if subject.topics[i] == topic:
         subject.topics[i] = new_name
   save_data()
   pass

func exists(mode: String, subject: String, topic: String, term: String):  ## checks if the subject/topic already exists
   if mode == "subject":
      for i in subjects:
         if i.text.strip_edges().to_lower() == subject.strip_edges().to_lower():
            return true
      return false
      pass
     
   if mode == "topic":
      for i in subjects:
         for j in i.topics:
            if j.strip_edges().to_lower() == topic.strip_edges().to_lower():
               return true
      return false
      pass

   if mode == "term":
      for i in GlobalDatabase.terms:
         if (terms[i].text == term) and (terms[i].subject == subject) and (terms[i].topic == topic):
            return true
      return false
      pass
   pass
