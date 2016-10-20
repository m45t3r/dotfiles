from i3pystatus import Status, battery
from i3pystatus.network import Network, sysfs_interface_up
from i3pystatus.updates import pacman, cower
from i3pystatus.weather import weathercom


class MyNetwork(Network):
    """
    Modified Network class that automatic switch interface in case of
    the current interface is down.
    """
    on_upscroll = None
    on_downscroll = None

    def run(self):
        super().run()
        if not sysfs_interface_up(self.interface, self.unknown_up):
            self.cycle_interface()


def make_bar(percentage):
    """Modified function make_bar to substitute the original one"""
    bars = ['', '', '', '', '']
    base = 100 / len(bars)
    index = round(percentage / base) - 1
    return bars[index]


# Inject it in battery module, so it will display unicode icons instead
# of the (ugly) default bars
battery.make_bar = make_bar
status = Status()

# show updates in pacman/aur
status.register(
    "updates",
    format=" {Pacman}/{Cower}",
    backends=[pacman.Pacman(), cower.Cower()],
)

# show clock
status.register(
    "clock",
    format=["  %H:%M:%S", " %a %d/%m"],
    on_rightclick="scroll_format",
)
# show weather
status.register(
    "weather",
    format="{icon} {current_temp}{temp_unit}",
    refresh_icon="",
    colorize=True,
    backend=weathercom.Weathercom(
        location_code="BRXX0232:1:BR"
    ),
)

# show/change current keyboard layout
status.register(
    "xkblayout",
    format="  {name}",
    layouts=["br", "us"],
)

# show/change volume using PA
status.register(
    "pulseaudio",
    format=" {volume}%",
    format_muted=" Mute",
)

# show/control screen brightness
status.register(
    "backlight",
    format=" {percentage}%",
    backlight="intel_backlight",
)

# show network speed
status.register(
    MyNetwork,
    format_up="{interface:.2}  {bytes_recv}K  {bytes_sent}K",
    format_down="{interface:.2} ",
    interface="enp3s0",
)

# show battery status
status.register(
    battery,
    format="{bar} [{status} ]{percentage:.0f}% {remaining}",
    interval=5,
    alert=True,
    alert_percentage=15,
    status={
        "CHR": "",
        "DPL": "",
        "DIS": "",
        "FULL": "",
    },
)

# show disk available space
status.register(
    "disk",
    format=" {avail}G",
    path="/",
)

# show available memory
status.register(
    "mem",
    format=" {avail_mem}G",
    warn_percentage=70,
    alert_percentage=90,
    divisor=1024**3,
)

# show cpu usage
status.register(
    "load",
    format=" {avg1} {avg5}",
)

# show CPU temperature
status.register(
    "temp",
    format=" {temp}°C",
    file="/sys/class/thermal/thermal_zone7/temp",
)

# show current music info
status.register(
    "spotify",
    format='{status} [{artist} - {title} \[{length}\]]',
    format_not_running='',
    status={
        'playing': '',
        'paused': '',
        'stopped': '',
    },
    on_leftclick="playerctl play-pause",
    on_rightclick="playerctl next",
    on_upscroll="playerctl next",
    on_downscroll="playerctl previous",
)

status.run()