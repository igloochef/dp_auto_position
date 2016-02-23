# Auto Position scripts for DevilsPie2
Scripts for remembering window positions in desktop environments that do not store the positions of windows.

Some programs will remember their own window state when closed, but in some desktop environments - like Cinnamon - there is no choice to have this functionality.  With these Auto Position scripts, when a window is closed its state will be stored in a 'positions' file, and when the same program creates a window again, the positions file will be read and set the window position to the last recorded close position.

These scripts support the following window states:
 * Position
 * Maximized
 * Full screen
 * Pin window (manual setting)
 * Skip task bar (manual setting: doesn't work in all desktop environments)
 * Ignore window type (manual setting: for windows that remember their own position already)

## Setup
These scripts require a slightly modified version of DevilsPie2.
The project page for this version is located here: [link]

Clone this repository into your devilspie2 config directory, or just copy the `.lua` files there.

If your devilspie2 config directory is the default `~/.config/devilspie2`, nothing more needs to
be done, otherwise edit both `auto_position.lua` and `write_position.lua` and change `CONFIG_PATH`
to point to your custom directory.

## Running and Customizing
Two files are created in a subdirectory in the devilspie2 config directory.

The file named `windows` keeps track of the currently open windows, and is required for the `write_position.lua` file to execute properly. This file **MUST** be blank or not exist when you start devilspie2.

An easy script for running devilspie2:
```bash
#!/bin/bash
rm ~/.config/devilspie2/auto_position/windows
devilspie2
```


The file named `positions` stores the state of windows as they are closed. Open windows will not be written to this file, only after you close a window will it exist in this file. Each line in the file has the format:
Class name [tab] x pos, y pos, width, height, maximized, full screen, pinned, skip task bar, ignore

Maximized through ignore are all boolean values which must be either `false` or `true`.
Pinned, skip task bar, and ignore are all manual settings, which means you must edit the file to change them. By default they are all set to `false`.


## Positions file properties
| Name | Type | Description |
|:-----|:----:|:------------|
| Class name | String | Either the class name that is provided to X from the program, or the window title if no class name is given. |
| X Pos | Integer | X screen position of the left side. |
| Y Pos | Integer | Y screen position of the top side. |
| Width | Integer | Width of the window. |
| Height | Integer | Height of the window. |
| Maximized | Boolean | If the window was closed while maximized. If set to `true`, the position will not be updated so that the window can be moved into correct position the next time the window opens. The window **will** be maximized when the window opens again, but will then restore down to the previous position. |
| Full screen | Boolean | The window was closed while full screen. |
| Pinned | Boolean | The window was pinned to show on all workspaces. |
| Skip task bar | Boolean | The window should not show in the task bar. (Does not work on all desktop environments.) |
| Ignore | Boolean | Ignore the settings in this file. (Useful for windows that remember their own status.) |
