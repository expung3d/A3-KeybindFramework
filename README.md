# Arma 3 Keybind Framework

## What It Does
Vanilla Arma 3 Framework for adding keybinds that can be modified by players. Allows mission makers a simplified way to create new keybinds while allowing users the ability to modify said keybinds to other keys.

<p align="center">
  <img src="https://i.imgur.com/JGsLvuv.png" width="500">
</p>

## Keybind Syntax

```sqf
["Earplugs","Put in your virtual earplugs",207,{1 fadeSound 0.3;},false,false,false,false] call ZAM_fnc_newKeybind; 
//Creates Keybind on END key that fades sound.
```

0. Keybind display name (STRING)
1. Keybind description (STRING)
2. Keybind DIK Keycode (NUM)
3. Keybind expression (CODE)
4. Does keybind require SHIFT? (BOOL) DEFAULT: FALSE
5. Does keybind require CTRL? (BOOL) DEFAULT: FALSE
6. Does keybind require ALT? (BOOL) DEFAULT: FALSE
7. Is keybind for Zeus? (BOOL) DEFAULT: FALSE

## License
A3-KeybindFramework is licensed under the ([MIT License](https://github.com/expung3d/A3-KeybindFramework/blob/main/LICENSE)).
