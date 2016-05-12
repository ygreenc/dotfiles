#!/usr/bin/env python

from i3pystatus import Status

status = Status()

# Time
status.register('clock', format="%F %R",)

# CPU Load
status.register('load')

# Memory Load
status.register('mem')

# CPU Temp
status.register('temp', format="{temp:.0f}°C")

# Battery load
status.register("battery",
        format="{status}/{consumption:.2f}W {percentage:.2f}% [{percentage_design:.2f}%] {remaining:%E%hh:%Mm}",
        alert=True,
        alert_percentage=5,
        status={
            "DIS": "↓",
            "CHR": "↑",
            "FULL": "=",
        },)

# Wired interface
status.register('network',
        interface='enp0s31f6',
        format_up="{v4cidr}",)

# Wireless
status.register('network',
        interface='wlp4s0',
        format_up='{essid} {quality:03.0f}%',)

# Screen backlighting
status.register('backlight',
        format='Brightness: {percentage}',
        base_path='/sys/class/backlight/intel_backlight/',)

status.run()
