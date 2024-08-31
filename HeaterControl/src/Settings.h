#pragma once

#include <Preferences.h>
#include "PidController.h"
\
/*
    Manages the settings
*/
class Settings {
    private:
        Stream& output;
        PidController& pid;
        Preferences prefs;

    public:
        Settings(Stream& output, PidController& pid) : output(output), pid(pid)
        {}

        void saveSettings();
        void loadSettings();
};