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
   pass

func from_list_string(term_list_as_string: String):
   term_list_as_string.remove(0)
   term_list_as_string.remove(term_list_as_string.length())  ## why not -1 ?
   term_list_as_string.remove(term_list_as_string.length())
   var data = term_list_as_string
   text = term_list_as_string.split(",")[0].strip_edges()
   definition = term_list_as_string.split(",")[1].strip_edges()
   subject = term_list_as_string.split(",")[2].strip_edges()
   topic = term_list_as_string.split(",")[3].strip_edges()
   creation_day = int(term_list_as_string.split(",")[4].strip_edges())
   pass
