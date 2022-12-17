comment "
	Keybind Framework by Expung3d

	Creates Keybinds easily, saves their code, and allows for users to modify the keybinds to their liking.

	Syntax:
		0: STRING - Display name for keybind
		1: STRING - Description for keybind
		2: NUMBER - DIK Keycode for keybind
		3: CODE - Code that executes when button pressed
			PARAMS:
			_display: Display
			_key: DIK Keycode pressed
			_shift: Bool if shift is pressed
			_ctrl: Bool if ctrl is pressed
			_alt: Bool if alt is pressed
		4: BOOL - Shift needed
		5: BOOL - Ctrl needed
		6: BOOL - Alt needed
		7: BOOL - Is it a Zeus keybind?

	Return:
		Index of keybind in keybind data array

	Examples:
		(End Key)
		['Earplugs','Put in virtual earplugs',207,{call insertEarplugs;}] call ZAM_fnc_newKeybind;

		(Shift + V)
		['Jump','Make your character go boing',47,{call fn_doJump;},true] call ZAM_fnc_newKeybind;

		(Ctrl + 0)
		['Keybinds Menu','Edit the in-game keybinds.',11,{call ZAM_fnc_modifyKeybindsInterface;},false,true] call ZAM_fnc_newKeybind;

		(Ctrl + Y)
		['Close Zeus','Close the Zeus interface.',21,{call closeZeusInterface;},false,true,false,true] call ZAM_fnc_newKeybind;
";

ZAM_fnc_newKeybind = {
	params ["_displayName","_description","_keyCode","_code",["_shift",false],["_ctrl",false],["_alt",false],["_zeusKeybind",false]];
	if(isNil "ZAM_keyBindData") then {
		ZAM_keyBindData = [];
	};
	private _display = if(_zeusKeybind) then {findDisplay 312} else {findDisplay 46};

	ZAM_keyBindData pushBack [_displayName,_description,_display,_keyCode,_code,[_shift,_ctrl,_alt]];
};

ZAM_fnc_removeKeybind = {
	params ["_keybindID"];
	if((count ZAM_keyBindData - 1) >= _keyBindId) exitWith {
		ZAM_keyBindData deleteAt _keyBindID;
		true
	};
	false
};

ZAM_fnc_changeKeybindKey = {
	params ["_index","_newKeyCode","_modifierDataNew"];
	private _keyBindData = ZAM_keyBindData select _index;
	_keyBindData params ["_displayName","_description","_display","_keyCode","_code","_modifierData"];
	if(_keyCode != _newKeyCode) then {
		ZAM_keyBindData set [_index,[_displayName,_description,_display,_newKeyCode,_code,_modifierDataNew]]
	};
};

ZAM_fnc_populateKeybindsInterface = {
	params ["_listnbox"];
	if(isNil "ZAM_keyBindData") exitWith {};
	{
		_x params ["_displayName","_description","","_keyCode","","_modiferData"];
		private _keyBindText = keyName _keyCode;
		{
			if(_x) then {
				switch (_forEachIndex) do {
					case 0: {
						_keyBindText = _keyBindText insert [0,"[SHIFT] + "];
					};
					case 1: {
						_keyBindText = _keyBindText insert [0,"[CTRL] + "];
					};
					case 2: {
						_keyBindText = _keyBindText insert [0,"[ALT] + "];
					};
				};
			};
		}forEach _modiferData;
		private _descriptionText = _description;
		if(count _descriptionText > 28) then {
			_descriptionText = [_descriptionText,0,27] call BIS_fnc_trimString;
			_descriptionText = _descriptionText insert [28,"..."];
		};
		private _index = _listnbox lnbAddRow [_keyBindText,_displayName,_descriptionText];
		_listnBox lnbSetTooltip [[_index,0],_description];
	}forEach ZAM_keyBindData;
};

ZAM_fnc_changeKeybindInterface = {
	params ["_index"];
	private _indexRow = _index + 1;
	private _listNBox = uiNamespace getVariable 'keyBindListnBox';
	private _keybindMenu = uiNamespace getVariable 'ZAM_keybindMenu';
	if(isNil "ZAM_isChangingKeybind") then {
		ZAM_isChangingKeybind = false;
		ZAM_isChangingKeybindIndex = -1;
		ZAM_isChangingKeybindEH = -1;
	};

	if(ZAM_isChangingKeybind) then {
		private _data = ZAM_keyBindData select (ZAM_isChangingKeybindIndex - 1);
		_data params ["","","","_keyCode","","_modifierData"];
		private _keyBindText = keyName _keyCode;
		{
			if(_x) then {
				switch (_forEachIndex) do {
					case 0: {
						_keyBindText = _keyBindText insert [0,"[SHIFT] + "];
					};
					case 1: {
						_keyBindText = _keyBindText insert [0,"[CTRL] + "];
					};
					case 2: {
						_keyBindText = _keyBindText insert [0,"[ALT] + "];
					};
				};
			};
		}forEach _modifierData;
		_listnbox lnbSetText [[ZAM_isChangingKeybindIndex,0],_keyBindText];
		_keybindMenu displayRemoveEventHandler ["KeyDown",ZAM_isChangingKeybindEH];
	};

	ZAM_isChangingKeybind = true;
	ZAM_isChangingKeybindIndex = _indexRow;
	_listnbox lnbSetText [[ZAM_isChangingKeybindIndex,0],"Recording input..."];
	ZAM_isChangingKeybindEH = _keybindMenu displayAddEventHandler ["KeyDown",{
		params ["_displayOrControl", "_key", "_shift", "_ctrl", "_alt"];
		if(_key == 29 || _key == 56 || _key == 42) exitWith {};
		if(_key == 1) exitWith {
			ZAM_isChangingKeybind = false;
			ZAM_isChangingKeybindIndex = -1;
			_displayOrControl displayRemoveEventHandler [_thisEvent,_thisEventHandler];
			ZAM_isChangingKeybindEH = nil;
		};
		[ZAM_isChangingKeybindIndex - 1,_key,[_shift,_ctrl,_alt]] call ZAM_fnc_changeKeybindKey;
		private _listNBox = uiNamespace getVariable 'keyBindListnBox';
		private _keyBindText = keyName _key;
		{
			if(_x) then {
				switch (_forEachIndex) do {
					case 0: {
						_keyBindText = _keyBindText insert [0,"[SHIFT] + "];
					};
					case 1: {
						_keyBindText = _keyBindText insert [0,"[CTRL] + "];
					};
					case 2: {
						_keyBindText = _keyBindText insert [0,"[ALT] + "];
					};
				};
			};
		}forEach [_shift,_ctrl,_alt];
		_listnbox lnbSetText [[ZAM_isChangingKeybindIndex,0],_keyBindText];


		ZAM_isChangingKeybind = false;
		ZAM_isChangingKeybindIndex = -1;
		_displayOrControl displayRemoveEventHandler [_thisEvent,_thisEventHandler];
		ZAM_isChangingKeybindEH = nil;
	}];
};

ZAM_fnc_modifyKeybindsInterface = {
	if(!isNull (findDisplay 49)) then {
		(findDisplay 49) closeDisplay 0;
		waitUntil {(isNull (findDisplay 49))};
	};
	with uiNamespace do {
		private _fn_convertGUIGRID = {
			params ["_mode","_value"];

			comment "Defines";
				private _GUI_GRID_WAbs = ((safeZoneW / safeZoneH) min 1.2);
				private _GUI_GRID_HAbs = (_GUI_GRID_WAbs / 1.2);
				private _GUI_GRID_W = (_GUI_GRID_WAbs / 40);
				private _GUI_GRID_H = (_GUI_GRID_HAbs / 25);
				private _GUI_GRID_X = (safeZoneX);
				private _GUI_GRID_Y = (safeZoneY + safeZoneH - _GUI_GRID_HAbs);

				private _GUI_GRID_CENTER_WAbs = _GUI_GRID_WAbs;
				private _GUI_GRID_CENTER_HAbs = _GUI_GRID_HAbs;
				private _GUI_GRID_CENTER_W = _GUI_GRID_W;
				private _GUI_GRID_CENTER_H = _GUI_GRID_H;
				private _GUI_GRID_CENTER_X = (safeZoneX + (safeZoneW - _GUI_GRID_CENTER_WAbs)/2);
				private _GUI_GRID_CENTER_Y = (safeZoneY + (safeZoneH - _GUI_GRID_CENTER_HAbs)/2);

			comment "Mode Selection";
			private _return = switch (toUpper _mode) do {
				case "X": {((_value) * _GUI_GRID_W + _GUI_GRID_CENTER_X)};
				case "Y": {((_value) * _GUI_GRID_H + _GUI_GRID_CENTER_Y)};
				case "W": {((_value) * _GUI_GRID_W)};
				case "H": {((_value) * _GUI_GRID_H)};
			};
			_return
		};
		createDialog "RscDisplayEmpty";
		showchat true;
		ZAM_keybindMenu = findDisplay -1;

		private _label = ZAM_keybindMenu ctrlCreate ["RscText", 1000];
		_label ctrlSetText "Modify Keybinds";
		_label ctrlSetPosition [["X",7] call _fn_convertGUIGRID, ["Y",5] call _fn_convertGUIGRID, ["W",26] call _fn_convertGUIGRID, ["H",1] call _fn_convertGUIGRID];
		_label ctrlSetTextColor [1,1,1,1];
		_label ctrlSetBackgroundColor [(profilenamespace getvariable ['GUI_BCG_RGB_R',0.13]),(profilenamespace getvariable ['GUI_BCG_RGB_G',0.54]),(profilenamespace getvariable ['GUI_BCG_RGB_B',0.21]),(profilenamespace getvariable ['GUI_BCG_RGB_A',0.8])];
		_label ctrlCommit 0;

		private _bg = ZAM_keybindMenu ctrlCreate ["IGUIBack", 2200];
		_bg ctrlSetPosition [["X",7] call _fn_convertGUIGRID, ["Y",6.2] call _fn_convertGUIGRID, ["W",26] call _fn_convertGUIGRID, ["H",13.8] call _fn_convertGUIGRID];
		_bg ctrlSetBackgroundColor [0,0,0,0.5];
		_bg ctrlCommit 0;

		private _listBG = ZAM_keybindMenu ctrlCreate ["RscText", 1001];
		_listBG ctrlSetPosition [["X",7.5] call _fn_convertGUIGRID, ["Y",6.5] call _fn_convertGUIGRID, ["W",25] call _fn_convertGUIGRID, ["H",1] call _fn_convertGUIGRID];
		_listBG ctrlSetBackgroundColor [0,0,0,1];
		_listBG ctrlCommit 0;

		private _listBG2 = ZAM_keybindMenu ctrlCreate ["RscText", 1002];
		_listBG2 ctrlSetPosition [["X",7.5] call _fn_convertGUIGRID, ["Y",7.5] call _fn_convertGUIGRID, ["W",25] call _fn_convertGUIGRID, ["H",12.2] call _fn_convertGUIGRID];
		_listBG2 ctrlSetBackgroundColor [0,0,0,0.4];
		_listBG2 ctrlCommit 0;

		private _listBG2 = ZAM_keybindMenu ctrlCreate ["RscText", 1002];
		_listBG2 ctrlSetPosition [["X",7.5] call _fn_convertGUIGRID, ["Y",7.5] call _fn_convertGUIGRID, ["W",25] call _fn_convertGUIGRID, ["H",12.2] call _fn_convertGUIGRID];
		_listBG2 ctrlSetBackgroundColor [0,0,0,0.4];
		_listBG2 ctrlCommit 0;

		private _listBG3 = ZAM_keybindMenu ctrlCreate ["RscText", 1002];
		_listBG3 ctrlSetPosition [["X",12.95] call _fn_convertGUIGRID, ["Y",7.5] call _fn_convertGUIGRID, ["W",9.8] call _fn_convertGUIGRID, ["H",12.2] call _fn_convertGUIGRID];
		_listBG3 ctrlSetBackgroundColor [0.25,0.25,0.25,0.4];
		_listBG3 ctrlCommit 0;

		keyBindListnBox = ZAM_keybindMenu ctrlCreate ["RscListNBox", 1500];
		keyBindListnBox ctrlSetPosition [["X",7.5] call _fn_convertGUIGRID, ["Y",6.5] call _fn_convertGUIGRID, ["W",25] call _fn_convertGUIGRID, ["H",13.2] call _fn_convertGUIGRID];
		keyBindListnBox ctrlSetBackgroundColor [0,0,0,0.5];
		lnbClear keyBindListnBox;
		for "_i" from 0 to 10 do {	
			keyBindListnBox lnbDeleteColumn _i;
		};
		keyBindListnBox lnbAddColumn 0;
		keyBindListnBox lnbAddColumn 0.2;
		keyBindListnBox lnbAddColumn 0.8;
		keyBindListnBox lnbAddRow ["Keybind","Action","Description"];
		keyBindListnBox ctrlAddEventHandler ["lbDblClick",{
			params ["_control", "_selectedIndex"];
			[_selectedIndex - 1] call ZAM_fnc_changeKeybindInterface;
		}];
		keyBindListnBox ctrlCommit 0;

		private _cancel = ZAM_keybindMenu ctrlCreate ["RscButtonMenuCancel",2700];
		_cancel ctrlSetPosition [["X",7] call _fn_convertGUIGRID, ["Y",20.1] call _fn_convertGUIGRID, ["W",6] call _fn_convertGUIGRID, ["H",1] call _fn_convertGUIGRID];
		_cancel ctrlAddEventHandler ["ButtonClick",{
			params ["_control"];
			(uiNamespace getVariable 'ZAM_keybindMenu') closeDisplay 2;
		}];
		_cancel ctrlCommit 0;

		private _confirm = ZAM_keybindMenu ctrlCreate ["RscButtonMenuOk",2600];
		_confirm ctrlSetPosition [["X",27] call _fn_convertGUIGRID, ["Y",20.1] call _fn_convertGUIGRID, ["W",6] call _fn_convertGUIGRID, ["H",1] call _fn_convertGUIGRID];
		_confirm ctrlAddEventHandler ["ButtonClick",{
			params ["_control"];
			(uiNamespace getVariable 'ZAM_keybindMenu') closeDisplay 1;
		}];
		_confirm ctrlCommit 0;
	};
	[uiNamespace getVariable 'keyBindListnBox'] call ZAM_fnc_populateKeybindsInterface;
};

ZAM_fnc_keyBindSystemInit = {
	waitUntil {uisleep 0.1;!isNull (findDisplay 46) && alive player};
	sleep 0.1;
	if(isNil "ZAM_keyBindData") then {
		ZAM_keyBindData = [];
	};
	ZAM_keyBinds46 = (findDisplay 46) displayAddEventHandler ["KeyDown",{
		params ['_display', '_key', '_shift', '_ctrl', '_alt'];
		{
			_x params ["","","_displayBind","_keyCode","_code","_modifiers"];
			_modifiers params ["_isShift","_isCtrl","_isAlt"];
			if(_shift == _isShift && _ctrl == _isCtrl && _alt == _isAlt && _key == _keyCode && _displayBind == _display) then {
				[] call _code;
			};
		}forEach ZAM_keyBindData;
	}];
	ZAM_keyBinds312 = (findDisplay 312) displayAddEventHandler ["KeyDown",{
		params ['_display', '_key', '_shift', '_ctrl', '_alt'];
		{
			_x params ["","","_displayBind","_keyCode","_code","_modifiers"];
			_modifiers params ["_isShift","_isCtrl","_isAlt"];
			if(_shift == _isShift && _ctrl == _isCtrl && _alt == _isAlt && _key == _keyCode && _displayBind == _display) then {
				[] call _code;
			};
		}forEach ZAM_keyBindData;
	}];
};

["Keybinds Menu","Edit the in-game keybinds.",11,{call ZAM_fnc_modifyKeybindsInterface;},false,true] call ZAM_fnc_newKeybind;
[] call ZAM_fnc_keyBindSystemInit;
