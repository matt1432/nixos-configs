# How to install Palia Map and Overwolf on Linux

Dependencies:
- latest GE-Proton: https://github.com/GloriousEggroll/proton-ge-custom
- protontricks: https://github.com/Matoking/protontricks
- protonhax: https://github.com/jcnils/protonhax


## First Step: Install and run Palia at least once


## Second Step: Setup Palia WINEPREFIX with latest GE-Proton

1. Delete prefix at /home/"$USER"/.steam/steam/steamapps/compatdata/2707930/pfx

```bash
rm -r /home/"$USER"/.steam/steam/steamapps/compatdata/2707930/pfx
```

2. Launch Palia with GE-Proton by going to game properties -> Compatibility -> Force the use ... -> Select GE-Proton...

3. Install dotnet48 and other Windows deps to allow for Overwolf installation

```bash
# Force proton version of protontricks
export PROTON_VERSION="GE-Proton9-10"
protontricks 2707930 dotnet48

# If VC is needed
protontricks 2707930 vcrun2010
protontricks 2707930 vcrun2012
protontricks 2707930 vcrun2013
```


## Third Step: Install Overwolf

1. Get this older version that worked for me here: https://overwolf.en.uptodown.com/windows/download/4714215

2. Install it with protontricks. Follow the GUI installer as if you were on Windows

```bash
export PROTON_VERSION="GE-Proton9-10"
protontricks-launch --appid 2707930 Downloads/overwolf-0-195-0-18.exe
```


## Fourth Step: Install Palia Map

1. Get the installer from here: https://www.overwolf.com/app/Leon_Machens-Palia_Map

2. Install it with protontricks.

```bash
export PROTON_VERSION="GE-Proton9-10"
protontricks-launch --appid 2707930 Downloads/Palia\ Map\ -\ Installer.exe
```

3. An error should popup saying `Installation failed` or something along those lines.
Close it and wait. You should see the Overwolf overlay on the left side of your screen
with the Palia Map icon saying `Installing` and then when it's done: `Palia Map`.

If nothing happens, try rebooting your PC and retrying the above shell commands until it works.


## Final Step: Setting it up in Steam

1. Add this line to Palia launch options
```bash
protonhax init %command%
```

2. Add random non-steam game to your library and then edit its properties:

Change the name to `Palia Map` or anything you like

Change the target to this command:

```bash
protonhax run 2707930 "/home/$USER/.local/share/Steam/steamapps/compatdata/2707930/pfx/drive_c/users/steamuser/AppData/Roaming/Microsoft/Windows/Start Menu/Programs/Overwolf/Palia Map.lnk"
```
