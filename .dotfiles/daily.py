#!/usr/bin/env python
import sys
import datetime
input_title = sys.argv[1]
my_title = input_title.title()
my_time = datetime.datetime.now()
my_id = int(f"{my_time.year}{my_time.month}{my_time.day}{my_time.hour}{my_time.minute}")
file_name = f"{my_id}_{my_title.lower()}"

# todo create daily not only if it does not exist
# return the file name
with open("daily_template.txt") as f:
    print(f.read().format(title="My Title", id=my_id, date=my_time.strftime("%Y-%m-%d")))

# todo create separate function for normal notes