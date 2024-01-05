# jpassmenu

Jalil's [`passmenu`](https://git.zx2c4.com/password-store/tree/contrib/dmenu) script.

## Usage

See the help message:

```console
$ jpassmenu --help
Jalil's passmenu script

Usage: result/bin/jpassmenu [OPTIONS]

OPTIONS:
    -c, --clip         Copy password to clipboard [this is the default action]
    -s, --show         Print the password to stdout
    -q, --qrcode       Print the password as a QR code using qrencode
    -m, --menu <PROG>  The dmenu compatible command to use [default: rofi -dmenu]
    -h, --help         Display this help message and exit

```

## Differences from the original passmenu script

- It uses `rofi` by default.
- You can change the menu program with `--menu 'fuzzel --dmenu'`
- Does not support typing the password (I don't use it)
- It supports printing the password entry to stdout in case you want to do
  something else with it (ie. implement typing functionality)
- It supports printing a qr code with `qrencode`.
