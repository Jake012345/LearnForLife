class_name Term

var text = ""
var definition = ""
var subject = ""
var topic = ""
var creation_day = {}


func as_list():
   return [text, definition, subject, topic, creation_day]

func from_list(term_as_list: Array):
   text = term_as_list[0]
   definition = term_as_list[1]
   subject = term_as_list[2]
   topic = term_as_list[3]
   creation_day = term_as_list[4]

func from_list_string(term_list_as_string: String):
   term_list_as_string.remove(0)
   term_list_as_string.remove(term_list_as_string.length())  ## why not -1 ?
   term_list_as_string.remove(term_list_as_string.length())
   var data = term_list_as_string.split("{")
   text = data[0].split(",")[0].strip_edges()
   definition = data[0].split(",")[1].strip_edges()
   subject = data[0].split(",")[2].strip_edges()
   topic = data[0].split(",")[3].strip_edges()
   var tmp_creation_day = {}
   for i in data[1].split(","):
      tmp_creation_day[i.split(":")[0].strip_edges()] = i.split(":")[1].strip_edges()
   creation_day = Dictionary(tmp_creation_day)
   pass
