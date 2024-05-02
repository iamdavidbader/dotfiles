#!/usr/bin/env python
import sys
import os.path
import datetime
from string import Template

home = os.path.expanduser("~")
input_title = sys.argv[2] if len(sys.argv) > 2 else ""
my_title = input_title.title()
my_time = datetime.datetime.now()
my_id = int(my_time.strftime("%Y%m%d%H%M"))
file_name = f"{my_id}_{my_title.lower()}.adoc"  # Add the file extension


def create_or_return_file(directory, filename, template_path, template_variables):
    file_path = os.path.join(directory, filename)

    if os.path.isfile(file_path):
        # File already exists, return the filename
        return file_path

    # Read the template
    with open(template_path) as template_file:
        template_content = template_file.read()

        # Substitute template variables
        rendered_content = template_content.format(**template_variables)

        # Write to the new file
        with open(file_path, "w") as new_file:
            new_file.write(rendered_content)

        return file_path


def create_note(title, note_path):
    template_path = f"{home}/.dotfiles/notes_template.txt"  # Adjust this to the actual path of your note template file
    template_variables = {
        "title": title,
        "id": my_id,
        "date": my_time.strftime("%Y-%m-%d"),
    }
    file_name = f"{my_id}_{my_title.lower()}.adoc"
    return create_or_return_file(
        os.path.join(note_path, "_inbox"), file_name, template_path, template_variables
    )


def create_daily(title, note_path):
    template_path = f"{home}/.dotfiles/daily_template.txt"  # Adjust this to the actual path of your daily template file
    template_variables = {
        "title": "Daily Note",
        "id": my_id,
        "date": my_time.strftime("%Y-%m-%d"),
    }
    file_name = f"{int(my_time.strftime('%Y%m%d'))}_daily.adoc"
    return create_or_return_file(
        os.path.join(note_path, "_dailies"),
        file_name,
        template_path,
        template_variables,
    )


def create_meeting(title, note_path):
    template_path = f"{home}/.dotfiles/meetings_template.txt"  # Adjust this to the actual path of your meeting template file
    template_variables = {
        "title": title,
        "id": my_id,
        "date": my_time.strftime("%Y-%m-%d"),
        "time": my_time.strftime("%H:%M"),
    }
    file_name = f"{my_time.strftime('%Y_%m_%d')}_{my_title.lower()}.adoc"
    return create_or_return_file(
        os.path.join(note_path, "_meetings"),
        file_name,
        template_path,
        template_variables,
    )


note_path = sys.argv[3] if len(sys.argv) > 3 else "."
print(note_path)
# Example usage
user_input = sys.argv[1] if len(sys.argv) > 1 else ""
if user_input.startswith("note"):
    result = create_note(my_title, note_path)
elif user_input.startswith("daily"):
    result = create_daily(my_title, note_path)
elif user_input.startswith("meeting"):
    result = create_meeting(my_title, note_path)
else:
    result = "Invalid command. Use 'note', 'daily', or 'meeting' followed by a title."

print(result)
