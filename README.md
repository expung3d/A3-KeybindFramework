
# Arma 3 Keybind Framework

## What It Does
Vanilla Arma 3 Framework for adding keybinds that can be modified by players. Allows mission makers a simplified way to create new keybinds while allowing users the ability to modify said keybinds to other keys.

<p align="center">
  <img src="https://i.imgur.com/JGsLvuv.png" width="500">
</p>

## Keybind Creation
```sqf
EarplugsKeybindID = [
	"Earplugs", //Keybind display name
	"Put in your virtual earplugs", //Keybind description
	207, //Keybind DIKKey
	{1 fadeSound 0.3;}, //Keybind code on execute
	false, //Shift?
	false, //Ctrl?
	false, //Alt?
	false //Zeus Keybind?
] call ZAM_fnc_newKeybind; 
//Creates Keybind on END key that fades sound.
//Returns ID of keybind for removal.
```

## Keybind Removal
```sqf
[EarplugsKeybindID] call ZAM_fnc_removeKeybind;
//Removes the previously created earplugs keybind.
//Will return true if keybind was removed, false if it did not exist.
```

## License
A3-KeybindFramework is licensed under the ([MIT License](https://github.com/expung3d/A3-KeybindFramework/blob/main/LICENSE)).
