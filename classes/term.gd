class_name Term

var text = ""
var definition = ""
var subject = ""
var topic = ""
var creation_day: Date
var actuality_day_count = 0


func as_list():
   return [text, definition, subject, topic, creation_day.year, creation_day.month, creation_day.day, creation_day.weekday, actuality_day_count]

func from_list_string(term_list_as_string: String):
   term_list_as_string.remove(0)
   term_list_as_string.remove(term_list_as_string.length())  ## why not -1 ?
   text = term_list_as_string.split(",")[0].strip_edges()
   definition = term_list_as_string.split(",")[1].strip_edges()
   subject = term_list_as_string.split(",")[2].strip_edges()
   topic = term_list_as_string.split(",")[3].strip_edges()
   creation_day = Date.new()
   creation_day.year = int(term_list_as_string.split(",")[4].strip_edges())
   creation_day.month = int(term_list_as_string.split(",")[5].strip_edges())
   creation_day.day = int(term_list_as_string.split(",")[6].strip_edges())
   creation_day.weekday = int(term_list_as_string.split(",")[7].strip_edges())
   creation_day.unix = Time.get_unix_time_from_datetime_dict(creation_day.as_dict())
   actuality_day_count = int(term_list_as_string.split(",")[8].strip_edges())
   pass
