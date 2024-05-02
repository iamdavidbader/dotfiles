#!/bin/bash
NOTE_DIRECTORY="/c/Users/BaderD/OneDrive - SCHOTTEL/Eigene Dateien/Dokumente/Notes"
note() {
   ~/.dotfiles/notes.py note $1 "${NOTE_DIRECTORY}"
}

daily() {
    ~/.dotfiles/notes.py daily "Daily Note" "${NOTE_DIRECTORY}"
}

meeting() {
    ~/.dotfiles/notes.py meeting $1 "${NOTE_DIRECTORY}"
}