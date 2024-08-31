#include "Settings.h"

void Settings::saveSettings() {
    prefs.begin("heatercontrol");
    PidCalibration& pidCal = pid.getPidCalibration();
    prefs.putFloat("pid::Kp", pidCal.Kp);
    prefs.putFloat("pid::Ki", pidCal.Ki);
    prefs.putFloat("pid::Kd", pidCal.Kd);
    prefs.end();
}

void Settings::loadSettings() {
    prefs.begin("heatercontrol");
    PidCalibration& pidCal = pid.getPidCalibration();
    pidCal.Kp = prefs.getFloat("pid::Kp");
    pidCal.Ki = prefs.getFloat("pid::Ki");
    pidCal.Kd = prefs.getFloat("pid::Kd");
    prefs.end();
}