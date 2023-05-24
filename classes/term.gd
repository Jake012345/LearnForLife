class_name Term

var text = ""
var definition = ""
var subject = null
var topic = ""
var creation_day = ""


func as_list():
   return [text, definition, subject, topic, creation_day]
