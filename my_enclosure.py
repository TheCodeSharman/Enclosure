import octoprint.plugin
import re
import board
import adafruit_tmp117

def is_temperature_line(line):
    return (" T:" in line
        or line.startswith("T:")
        or " T0:" in line
        or line.startswith("T0:")
        or ((" B:" in line or line.startswith("B:")) and "A:" not in line))

class MyEnclosurePlugin(octoprint.plugin.StartupPlugin):
    def on_startup(self, *args, **kwargs):
        self._logger.info("My Enclosure starting...")
        self._i2c = board.I2C()
        self._tmp117 = adafruit_tmp117.TMP117(self._i2c)
        self._targetChamberTemp = 0.0
        self._re_parse_chamber_temp = re.compile("M141\s+S(\d+(\.\d+)?)")

    def parse_chamber_temperature(self, cmd):
        match = self._re_parse_chamber_temp.match(cmd)
        if match:
            return float(match.group(1))

    def report_chamber_temperature(self, comm, line, *args, **kwargs):
        if not is_temperature_line(line):
            return line
        return line + " C:{:.1f} /{:.1f}".format(self._tmp117.temperature, self._targetChamberTemp)
    
    def manage_chamber_target_temperature(self, com, phase, cmd, cmd_type, gcode, subcode=None, tags=None, *args, **kwargs):
        if gcode == "M141":
            chamberTemp = self.parse_chamber_temperature(cmd)
            if chamberTemp:
                self._logger.info(f"targetChamberTemp = {chamberTemp}")
                self._targetChamberTemp = self.parse_chamber_temperature(cmd)
                return ("M105",) # Report temperatures immediately
        # TODO: 
        # M191 optionally set chamber temperature and wait
        # M118 - print an action to octoprint:
        # M118 A1 action:paused
        # M118 A1 action:resumed

__plugin_name__ = "MyEnclosure"
__plugin_version__ = "1.0.0"
__plugin_description__ = "My printers enclosure"
__plugin_pythoncompat__ = ">=3.7,<4"

def __plugin_load__():
    global __plugin_implementation__
    __plugin_implementation__ = MyEnclosurePlugin()

    global __plugin_hooks__
    __plugin_hooks__ = {
        "octoprint.comm.protocol.gcode.received": __plugin_implementation__.report_chamber_temperature,
        "octoprint.comm.protocol.gcode.queuing": __plugin_implementation__.manage_chamber_target_temperature
    }