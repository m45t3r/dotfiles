#!/usr/bin/env python3

import asyncio
import logging
import signal
from pathlib import Path

import psutil

from i3pyblocks import Runner, types
from i3pyblocks.blocks import (
    datetime,
    dbus,
    http,
    i3ipc,
    inotify,
    ps,
    pulse,
    shell,
    x11,
)

logging.basicConfig(filename=Path.home() / ".i3pyblocks.log", level=logging.DEBUG)


async def weather_callback(resp):
    if resp.status != 200:
        return ""

    text = await resp.text()

    if "unknown" in text.lower():
        return ""

    return " ".join(text.split())


def partitions(excludes=("/boot", "/nix/store")):
    partitions = psutil.disk_partitions()
    return [p for p in partitions if p.mountpoint not in excludes]


async def main():
    runner = Runner()

    await runner.register_block(i3ipc.WindowTitleBlock(format=" {window_title:.41s}"))

    await runner.register_block(
        ps.NetworkSpeedBlock(
            format_up=" {interface:.2s}:  {upload}  {download}",
            format_down="",
            interface_regex="en*|wl*",
        )
    )

    for partition in partitions():
        await runner.register_block(
            ps.DiskUsageBlock(
                format=" {short_path}: {free:.1f}G",
                path=partition.mountpoint,
            )
        )

    await runner.register_block(ps.VirtualMemoryBlock(format=" {available:.1f}G"))

    await runner.register_block(
        ps.SensorsTemperaturesBlock(
            format="{icon} {current:.0f}°C",
            icons={0: "", 25: "", 50: "", 75: ""},
            sensor_regex=r"coretemp.*",
        )
    )

    cpu_count = psutil.cpu_count()
    await runner.register_block(
        ps.LoadAvgBlock(
            format=" {load1}",
            colors={
                0: types.Color.NEUTRAL,
                cpu_count / 2: types.Color.WARN,
                cpu_count: types.Color.URGENT,
            },
        ),
    )

    await runner.register_block(
        ps.SensorsBatteryBlock(
            format_plugged=" {percent:.0f}%",
            format_unplugged="{icon} {percent:.0f}% {remaining_time}",
            format_unknown="{icon} {percent:.0f}%",
            format_no_battery="",
            icons={0: "", 10: "", 25: "", 50: "", 75: ""},
        )
    )

    await runner.register_block(
        x11.CaffeineBlock(
            format_on="  ",
            format_off="  ",
            ignore_errors=True,
        )
    )

    await runner.register_block(dbus.KbddBlock(format=" {full_layout!l:.2s}"))

    await runner.register_block(
        inotify.BacklightBlock(
            format=" {percent:.0f}%",
            format_no_backlight="",
            command_on_click={
                types.MouseButton.SCROLL_UP: "light -A 5%",
                types.MouseButton.SCROLL_DOWN: "light -U 5",
            },
        )
    )

    await runner.register_block(
        pulse.PulseAudioBlock(format=" {volume:.0f}%", format_mute=" mute"),
        signals=(signal.SIGUSR1, signal.SIGUSR2),
    )

    await runner.register_block(
        http.PollingRequestBlock(
            "https://wttr.in/?format=1",
            format_error="",
            response_callback=weather_callback,
            sleep=60 * 60,
        ),
    )

    await runner.register_block(
        datetime.DateTimeBlock(format_time=" %T", format_date=" %a, %d/%m")
    )

    await runner.start()


if __name__ == "__main__":
    asyncio.run(main())
