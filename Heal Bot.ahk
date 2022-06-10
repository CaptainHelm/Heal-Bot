#SingleInstance force
#UseHook
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
;#MaxThreadsPerHotkey
;#Warn  ; Enable Warnings To Assist With Detecting Common Errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

IniFile := "Configuration.ini"

;Heal_Bot_State := 0
HP_Monitor_State := [] ; group members
0_x_HP_Character := [1256, 1187, 1187, 1187, 1187, 1187] ; hp bar start
100_x_HP_Character := [1659, 1659, 1659, 1659, 1659, 1659] ; hp bar end
Y_HP_Character := [1149, 1473, 1473, 1473, 1473, 1473] ; Yloc of HP bar
HP_color_character := [0xD90000, 0xD90000, 0xD90000, 0xD90000, 0xD90000, 0xD90000] ; HP bar color RGB format
heal_at_Percent := [90, 90, 90, 90, 90, 90] ; percentage to heal
check_box_state :=[]
Healer_PID := 0
Primary_Client := 0
Primary_Heal := [0, 0, 0, 0, 0, 0]
Secondary_Heal := [0, 0, 0, 0, 0, 0] ;need to add toggle functionality or priority

IfExist, %IniFile%
{
	sleep, 100
	loop 
	{
		loop, 6
		{
			iniread, HP_Monitor_State_%a_index%, %inifile%, Group HP Monitor, Group Member %a_index% Enabled
			HP_Monitor_State[a_index] := HP_Monitor_State_%a_index%	
			
			iniread, 0_x_HP_Character_%a_index%, %inifile%, Group HP Monitor, Group Member %a_index% x Loc start
			0_x_HP_Character[a_index] := 0_x_HP_Character_%a_index%
			
			iniread, 100_x_HP_Character_%a_index%, %inifile%, Group HP Monitor, Group Member %a_index% x Loc End 
			100_x_HP_Character[a_index] := 100_x_HP_Character_%a_index%
			
			iniread, Y_HP_Character_%a_index%, %inifile%, Group HP Monitor, Group Member %a_index% y Loc
			Y_HP_Character[a_index] := Y_HP_Character_%a_index%
			
			iniread, HP_color_character_%a_index%, %inifile%, Group HP Monitor, Group Member %a_index% HP Color
			HP_color_character[a_index] := HP_color_character_%a_index%	
			
			iniread, heal_at_Percent_%a_index%, %inifile%, Group HP Monitor, Group Member %a_index% Heal at `%
			heal_at_Percent[a_index] := heal_at_Percent_%a_index%
			
			iniread, Healer_PID, %inifile%, Heal Bot Monitor, Healer PID
			
			iniread, Heal_Bot_State, %inifile%, Heal Bot Monitor, Enabled or Disabled
			
			iniread, Heal_Button, %inifile%, Heal Bot Monitor, Heal Button
			
			iniread, Primary_Client, %inifile%, Heal Bot Monitor, Primary Client
			
			iniread, Primary_Heal_%a_index%, %inifile%, Group HP Monitor, Group Member %a_index% Primary Heal
			Primary_Heal[a_index] := Primary_Heal_%a_index%
			
			iniread, Secondary_Heal_%a_index%, %inifile%, Group HP Monitor, Group Member %a_index% Secondary Heal
			Secondary_Heal[a_index] := Secondary_Heal_%a_index%
			
		}
		IfWinActive, %Primary_Client%
		{
			if Heal_Bot_State = 0
			{
				break
			}
			else if Heal_Bot_State = 1
			{
				sleep 50
				Health_Monitor(100_x_HP_Character, 0_x_HP_Character, Y_HP_Character, HP_color_character, heal_at_Percent, HP_Monitor_State, Heal_Bot_State, Heal_Button, Healer_PID, Primary_Heal, Primary_Client)
			}
			else
			{
				break
			}
		}
	}	
	return
}

Heal_Bot_GUI:
{ ;~~~~~~~~~~~~~~~~~~~~~~~~ Group Member 1 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	gui, font, underline 
	gui, font,, Verdana
	Gui Add, Text, x48 y24 w200 h23 +0x200, Group Member 1 Health Monitor
	
	Gui Add, Text, x250 y24 w95 h23 +0x200, Enable | Disable ; enable / disable group member 1
	Gui Add, CheckBox, x350 y24 w15 h23 vHP_Monitor_State_1 Checked%HP_Monitor_State_1% ; enable / disable group member 1
	
	gui, font, norm
	Gui Add, Text, x48 y48 w170 h23 +0x200, Group Member 1 Health Start
	
	Gui Add, Text, x48 y72 w100 h23 +0x200, X Coord Start:
	Gui Add, Edit, x155 y72 w56 h21 v0_x_HP_Character_1, % 0_x_HP_Character_1 ; X Start
	
	Gui Add, Text, x48 y96 w100 h23 +0x200, Y Coord Location:
	Gui Add, Edit, x155 y96 w56 h21 vY_HP_Character_1, % Y_HP_Character_1 ; Y start
	
	Gui Add, Text, x48 y120 w100 h23 +0x200, Primary Heal:
	Gui Add, hotkey, x130 y120 w90 h21 vPrimary_Heal_1, % Primary_Heal_1
	
	Gui Add, Text, x224 y120 w100 h23 +0x200, Secondary Heal:
	Gui Add, hotkey, x320 y120 w90 h21 vSecondary_Heal_1, % Secondary_Heal_1
	
	Gui Add, Text, x224 y48 w163 h23 +0x200, Group Member 1 Health End
	
	Gui Add, Text, x224 y72 w85 h23 +0x200, X Coord End:
	Gui Add, Edit, x305 y72 w56 h21 v100_x_HP_Character_1, % 100_x_HP_Character_1
	
	Gui Add, Text, x224 y96 w85 h23 +0x200, HP Color:
	Gui Add, Edit, x305 y96 w70 h21 vHP_color_character_1, % HP_color_character_1
;~~~~~~~~~~~~~~~~~~~~~~~~ Group Member 2 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	gui, font, underline 
	Gui Add, Text, x48 y152 w200 h23 +0x200, Group Member 2 Health Monitor
	
	Gui Add, Text, x250 y152 w95 h23 +0x200, Enable | Disable ; enable / disable group member 2
	Gui Add, CheckBox, x350 y152 w15 h23 vHP_Monitor_State_2 Checked%HP_Monitor_State_2% ; enable / disable group member 2
	
	gui, font, norm
	Gui Add, Text, x48 y176 w170 h23 +0x200, Group Member 2 Health Start
	
	Gui Add, Text, x48 y200 w100 h23 +0x200, X Coord Start:
	Gui Add, Edit, x155 y200 w56 h21 v0_x_HP_Character_2, % 0_x_HP_Character_2
	
	Gui Add, Text, x48 y224 w100 h23 +0x200, Y Coord Location:
	Gui Add, Edit, x155 y224 w56 h21 vY_HP_Character_2, % Y_HP_Character_2
	;Gui Add, Button, x48 y248 w80 h23, Save
	
	Gui Add, Text, x48 y248 w100 h23 +0x200, Primary Heal:
	Gui Add, hotkey, x130 y248 w90 h21 vPrimary_Heal_2, % Primary_Heal_2
	
	Gui Add, Text, x224 y248 w100 h23 +0x200, Secondary Heal:
	Gui Add, hotkey, x320 y248 w90 h21 vSecondary_Heal_2, % Secondary_Heal_2
	
	Gui Add, Text, x224 y176 w163 h23 +0x200, Group Member 2 Health End
	
	Gui Add, Text, x224 y200 w85 h23 +0x200, X Coord End:
	Gui Add, Edit, x305 y200 w56 h21 v100_x_HP_Character_2, % 100_x_HP_Character_2
	
	Gui Add, Text, x224 y224 w85 h23 +0x200, HP Color
	Gui Add, Edit, x305 y224 w70 h21 vHP_color_character_2, % HP_color_character_2
;~~~~~~~~~~~~~~~~~~~~~~~~ Group Member 3 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	gui, font, underline 
	Gui Add, Text, x48 y280 w200 h23 +0x200, Group Member 3 Health Monitor
	
	Gui Add, Text, x250 y280 w95 h23 +0x200, Enable | Disable
	Gui Add, CheckBox, x350 y280 w15 h23 vHP_Monitor_State_3 Checked%HP_Monitor_State_3%,
	
	gui, font, norm
	Gui Add, Text, x48 y304 w170 h23 +0x200, Group Member 3 Health Start
	
	Gui Add, Text, x48 y328 w100 h23 +0x200, X Coord Start:
	Gui Add, Edit, x155 y328 w56 h21 v0_x_HP_Character_3, % 0_x_HP_Character_3
	
	Gui Add, Text, x48 y352 w100 h23 +0x200, Y Coord Location:
	Gui Add, Edit, x155 y352 w56 h21 vY_HP_Character_3, % Y_HP_Character_3
	;Gui Add, Button, x48 y376 w80 h23, Save
	
	Gui Add, Text, x48 y376 w100 h23 +0x200, Primary Heal:
	Gui Add, hotkey, x130 y376 w90 h21 vPrimary_Heal_3, % Primary_Heal_3
	
	Gui Add, Text, x224 y376 w100 h23 +0x200, Secondary Heal:
	Gui Add, hotkey, x320 y376 w90 h21 vSecondary_Heal_3, % Secondary_Heal_3
	
	Gui Add, Text, x224 y304 w163 h23 +0x200, Group Member 3 Health End
	
	Gui Add, Text, x224 y328 w85 h23 +0x200, X Coord End:
	Gui Add, Edit, x305 y328 w56 h21 v100_x_HP_Character_3, % 100_x_HP_Character_3 
	
	Gui Add, Text, x224 y352 w85 h23 +0x200, HP Color:
	Gui Add, Edit, x305 y352 w70 h21 vHP_color_character_3, % HP_color_character_3
	;Gui Add, Button, x224 y376 w80 h23, Save
;~~~~~~~~~~~~~~~~~~~~~~~~ Group Member 4 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	gui, font, underline 
	Gui Add, Text, x48 y408 w200 h23 +0x200, Group Member 4 Health Monitor
	
	Gui Add, Text, x250 y408 w95 h23 +0x200, Enable | Disable
	Gui Add, CheckBox, x350 y408 w15 h23 vHP_Monitor_State_4 Checked%HP_Monitor_State_4%,
	
	gui, font, norm
	Gui Add, Text, x48 y432 w170 h23 +0x200, Group Member 4 Health Start
	
	Gui Add, Text, x48 y456 w100 h23 +0x200, X Coord Start:
	Gui Add, Edit, x155 y456 w56 h21 v0_x_HP_Character_4, % 0_x_HP_Character_4
	
	Gui Add, Text, x48 y480 w100 h23 +0x200, Y Coord Location:
	Gui Add, Edit, x155 y480 w56 h21 vY_HP_Character_4, % Y_HP_Character_4
	;Gui Add, Button, x48 y504 w80 h23, Save
	
	Gui Add, Text, x48 y504 w100 h23 +0x200, Primary Heal:
	Gui Add, hotkey, x130 y504 w90 h21 vPrimary_Heal_4, % Primary_Heal_4
	
	Gui Add, Text, x224 y504 w100 h23 +0x200, Secondary Heal:
	Gui Add, hotkey, x320 y504 w90 h21 vSecondary_Heal_4, % Secondary_Heal_4
	
	Gui Add, Text, x224 y432 w163 h23 +0x200, Group Member 4 Health End
	
	Gui Add, Text, x224 y456 w85 h23 +0x200, X Coord End:
	Gui Add, Edit, x305 y456 w56 h21 v100_x_HP_Character_4, % 100_x_HP_Character_4
	
	Gui Add, Text, x224 y480 w85 h23 +0x200, HP Color:
	Gui Add, Edit, x305 y480 w70 h21 vHP_color_character_4, % HP_color_character_4
;~~~~~~~~~~~~~~~~~~~~~~~~ Group Member 5 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	gui, font, underline
	Gui Add, Text, x48 y536 w200 h23 +0x200, Group Member 5 Health Monitor
	
	Gui Add, Text, x250 y536 w95 h23 +0x200, Enable | Disable
	Gui Add, CheckBox, x350 y536 w15 h23 vHP_Monitor_State_5 Checked%HP_Monitor_State_5%,
	
	gui, font, norm
	Gui Add, Text, x48 y560 w170 h23 +0x200, Group Member 5 Health Start
	
	Gui Add, Text, x48 y584 w100 h23 +0x200, X Coord Start:
	Gui Add, Edit, x155 y584 w56 h21 v0_x_HP_Character_5, % 0_x_HP_Character_5
	
	Gui Add, Text, x48 y608 w100 h23 +0x200, Y Coord Location:
	Gui Add, Edit, x155 y608 w56 h21 vY_HP_Character_5, % Y_HP_Character_5
	
	Gui Add, Text, x48 y632 w100 h23 +0x200, Primary Heal:
	Gui Add, hotkey, x130 y632 w90 h21 vPrimary_Heal_5, % Primary_Heal_5
	
	Gui Add, Text, x224 y632 w100 h23 +0x200, Secondary Heal:
	Gui Add, hotkey, x320 y632 w90 h21 vSecondary_Heal_5, % Secondary_Heal_5
	
	Gui Add, Text, x224 y560 w163 h23 +0x200, Group Member 5 Health End
	
	Gui Add, Text, x224 y584 w85 h23 +0x200, X Coord End:
	Gui Add, Edit, x305 y584 w56 h21 v100_x_HP_Character_5, % 100_x_HP_Character_5
	
	Gui Add, Text, x224 y608 w85 h23 +0x200, HP Color:
	Gui Add, Edit, x305 y608 w70 h21 vHP_color_character_5, % HP_color_character_5
;~~~~~~~~~~~~~~~~~~~~~~~~ Group Member 6 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	gui, font, underline
	Gui Add, Text, x48 y664 w200 h23 +0x200, Group Member 6 Health Monitor
	
	Gui Add, Text, x250 y664 w95 h23 +0x200, Enable | Disable
	Gui Add, CheckBox, x350 y664 w15 h23 vHP_Monitor_State_6 Checked%HP_Monitor_State_6%,
	
	gui, font, norm
	Gui Add, Text, x48 y688 w170 h23 +0x200, Group Member 6 Health Start
	
	Gui Add, Text, x48 y712 w100 h23 +0x200, X Coord Start:
	Gui Add, Edit, x155 y712 w56 h21 v0_x_HP_Character_6, % 0_x_HP_Character_6
	
	Gui Add, Text, x48 y736 w100 h23 +0x200, Y Coord Location:
	Gui Add, Edit, x155 y736 w56 h21 vY_HP_Character_6, % Y_HP_Character_6
	;Gui Add, Button, x48 y760 w80 h23, Save
	
	Gui Add, Text, x48 y760 w100 h23 +0x200, Primary Heal:
	Gui Add, hotkey, x130 y760 w90 h21 vPrimary_Heal_6, % Primary_Heal_6
	
	Gui Add, Text, x224 y760 w100 h23 +0x200, Secondary Heal:
	Gui Add, hotkey, x320 y760 w90 h21 vSecondary_Heal_6, % Secondary_Heal_6
	
	Gui Add, Text, x224 y688 w163 h23 +0x200, Group Member 6 Health End
	
	Gui Add, Text, x224 y712 w85 h23 +0x200, X Coord End:
	Gui Add, Edit, x305 y712 w56 h21 v100_x_HP_Character_6, % 100_x_HP_Character_6
	
	Gui Add, Text, x224 y736 w85 h23 +0x200, HP Color:
	Gui Add, Edit, x305 y736 w70 h21 vHP_color_character_6, % HP_color_character_6
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	Gui Add, Text, x424 y8 w180 h23 +0x200, When to heal. EXCEPT 48-52`%
	
	Gui Add, Text, x424 y48 w150 h23 +0x200, Group Member 1, Heal at:
	Gui Add, edit, x575 y48 w25 h23 vheal_at_Percent_1, % heal_at_Percent_1 ; group member 1 80% health check
	Gui Add, Text, x605 y48 w20 h23 +0x200, `%
	
	Gui Add, Text, x424 y72 w150 h23 +0x200, Group Member 2, Heal at:
	Gui Add, edit, x575 y72 w25 h23 vheal_at_Percent_2, % heal_at_Percent_2 ; group member 1 60% health check
	Gui Add, Text, x605 y72 w20 h23 +0x200, `%
	
	Gui Add, Text, x424 y96 w150 h23 +0x200, Group Member 3, Heal at:
	Gui Add, edit, x575 y96 w25 h23 vheal_at_Percent_3, % heal_at_Percent_3 ; group member 1 40% health check
	Gui Add, Text, x605 y96 w20 h23 +0x200, `%
	
	Gui Add, Text, x424 y120 w150 h23 +0x200, Group Member 4, Heal at:
	Gui Add, edit, x575 y120 w25 h23 vheal_at_Percent_4, % heal_at_Percent_4 ; group member 1 20% health check
	Gui Add, Text, x605 y120 w20 h23 +0x200, `%
	
	Gui Add, Text, x424 y144 w150 h23 +0x200, Group Member 5, Heal at:
	Gui Add, edit, x575 y144 w25 h23 vheal_at_Percent_5, % heal_at_Percent_5 ; group member 1 20% health check
	Gui Add, Text, x605 y144 w20 h23 +0x200, `%
	
	Gui Add, Text, x424 y168 w150 h23 +0x200, Group Member 6, Heal at:
	Gui Add, edit, x575 y168 w25 h23 vheal_at_Percent_6, % heal_at_Percent_6 ; group member 1 20% health check
	Gui Add, Text, x605 y168 w20 h23 +0x200, `%
	
	Gui Add, Text, x424 y264 w120 h23 +0x200, Ctrl F1 X Coord:
	Gui Add, edit, x552 y264 w40 h23 vx_mouse_position_hotkey, % x_mouse_position_hotkey
	
	Gui Add, Text, x424 y288 w120 h23 +0x200, Ctrl F1 Y Coord:
	Gui Add, edit, x552 y288 w40 h23 vY_mouse_position_hotkey, % Y_mouse_position_hotkey
	
	Gui Add, Text, x424 y312 w120 h23 +0x200, Ctrl F1 Get Color:
	Gui Add, edit, x552 y312 w60 h23 vgetcolor, % getcolor
	
	Gui Add, Text, x424 y436 w180 h23 +0x200, Primary Client :
	Gui Add, Edit, x520 y436 w161 h21 vPrimary_Client, % Primary_Client
	
	Gui Add, Text, x424 y460 w145 h23 +0x200, Healer PID:
	Gui Add, Edit, x500 y460 w161 h21 vhealer_PID, % healer_PID
	
	Gui Add, Text, x424 y484 w145 h23 +0x200, Heal Button:
	Gui Add, hotkey, x500 y484 w161 h21 vHeal_Button, % Heal_Button
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~	
	Gui Add, checkbox, x48 y896 w150 h25 vHeal_Bot_State Checked%Heal_Bot_State%, Heal monitor On | Off
	Gui Add, Button, x48 y944 w80 h23 gGuiSave, Apply
	Gui Add, Button, x136 y944 w80 h23 gGuiClose, Close
	
	Gui Show, w889 h989, Window
	Return
}

GUISave:
{
	gui Submit, NoHide
	;msgbox, saved
	loop 6
	{
		iniwrite,% HP_Monitor_State_%a_index%, %inifile%, Group HP Monitor, Group Member %a_index% Enabled
		HP_Monitor_State[a_index] := HP_Monitor_State_%a_index%
		
		iniwrite,% 0_x_HP_Character_%a_index%, %inifile%, Group HP Monitor, Group Member %a_index% x Loc start
		0_x_HP_Character[a_index] := 0_x_HP_Character_%a_index%
		
		iniwrite,% 100_x_HP_Character_%a_index%, %inifile%, Group HP Monitor, Group Member %a_index% x Loc End
		100_x_HP_Character[a_index] := 100_x_HP_Character_%a_index%
		
		iniwrite,% Y_HP_Character_%a_index%, %inifile%, Group HP Monitor, Group Member %a_index% y Loc
		Y_HP_Character[a_index] := Y_HP_Character_%a_index%
		
		iniwrite,% HP_color_character_%a_index%, %inifile%, Group HP Monitor, Group Member %a_index% HP Color
		HP_color_character[a_index] := HP_color_character_%a_index%
		
		iniwrite,% heal_at_Percent_%a_index%, %inifile%, Group HP Monitor, Group Member %a_index% Heal at `%
		heal_at_Percent[a_index] := heal_at_Percent_%a_index%
		
		iniwrite,% healer_PID, %inifile%, Heal Bot Monitor, Healer PID
		
		iniwrite,% Heal_Bot_State, %inifile%, Heal Bot Monitor, Enabled or Disabled
		
		iniwrite,% Heal_Button, %inifile%, Heal Bot Monitor, Heal Button
		
		iniwrite,% Primary_Client, %inifile%, Heal Bot Monitor, Primary Client
		
		iniwrite,% Primary_Heal_%a_index%, %inifile%, Group HP Monitor, Group Member %a_index% Primary Heal
		Primary_Heal[a_index] := Primary_Heal_%a_index%
		
		iniwrite,% Secondary_Heal_%a_index%, %inifile%, Group HP Monitor, Group Member %a_index% Secondary Heal
		Secondary_Heal[a_index] := Secondary_Heal_%a_index%
	}
	return
}

GuiEscape:
{
	gui, hide
}

GuiClose:
{
	gui, hide
	reload
}

^!t::
{
	gui, destroy
	gosub Heal_Bot_GUI
	return
}

^f1::
{
	gui, hide
	MouseGetPos, x_mouse_position_hotkey, y_mouse_position_hotkey
	PixelGetColor, getcolor, %x_mouse_position_hotkey%, %y_mouse_position_hotkey%, RGB
gui, show
	;msgbox, X %x_mouse_position_hotkey% Y %y_mouse_position_hotkey% color %thiscolor%
	return
}

!^r::
{
	reload
}

return

Health_Monitor(100_x_HP_Character, 0_x_HP_Character, Y_HP_Character, HP_color_character, heal_at_Percent, HP_Monitor_State, Heal_Bot_State, Heal_Button, Healer_PID, Primary_Heal, Primary_Client)
{
	
	if HP_Monitor_State[1] = 1
	{	
		Monitor_Health_1 := (((100_x_HP_Character[1] - 0_x_HP_Character[1]) / 100 * heal_at_Percent[1]) + 0_x_HP_Character[1])
		ifwinactive, %Primary_Client%
		{
			PixelGetColor, Current_Health_1, Monitor_Health_1, Y_HP_Character[1], RGB slow
			if (Current_Health_1 = HP_color_character[1]) ; verifying pixel grabbed is same as hp bar red
			{
				sleep, -1
			}
			else
			{
				controlsend,, % Primary_Heal[1], %Healer_PID% ; pixel grabbed is not red meaning health is lost
				sleep, 350 ; 3.5 seconds
			}
		}
		else
		{
			return
		}
	}
	
	if HP_Monitor_State[2] = 1
	{	
		Monitor_Health_2 := (((100_x_HP_Character[2] - 0_x_HP_Character[2]) / 100 * heal_at_Percent[2]) + 0_x_HP_Character[2])
		ifwinactive, %Primary_Client%
		{	
			PixelGetColor, Current_Health_2, Monitor_Health_2, Y_HP_Character[2], RGB slow
			if (Current_Health_2 = HP_color_character[2]) ; verifying pixel grabbed is same as hp bar red
			{
				sleep, -1
			}
			else
			{
				controlsend,, % Primary_Heal[2], %Healer_PID% ; pixel grabbed is not red meaning health is lost
				sleep, 350 ; 3.5 seconds
			}
		}
		else
		{
			return
		}
	}
	
	if HP_Monitor_State[3] = 1
	{	
		Monitor_Health_3 := (((100_x_HP_Character[3] - 0_x_HP_Character[3]) / 100 * heal_at_Percent[3]) + 0_x_HP_Character[3])
		ifwinactive, %Primary_Client%
		{	
			PixelGetColor, Current_Health_3, Monitor_Health_3, Y_HP_Character[3], RGB
			if (Current_Health_3 = HP_color_character[3]) ; verifying pixel grabbed is same as hp bar red
			{
				sleep -1
			}
			else
			{
				controlsend,, % Primary_Heal[3], %Healer_PID% ; pixel grabbed is not red meaning health is lost
				sleep, 350 ; 3.5 seconds
			}	
		}
		else
		{
			return
		}
	}
	
	if HP_Monitor_State[4] = 1
	{	
		Monitor_Health_4 := (((100_x_HP_Character[4] - 0_x_HP_Character[4]) / 100 * heal_at_Percent[4]) + 0_x_HP_Character[4])
		ifwinactive, %Primary_Client%
		{
			PixelGetColor, Current_Health_4, Monitor_Health_4, Y_HP_Character[4], RGB
			if (Current_Health_4 = HP_color_character[4]) ; verifying pixel grabbed is same as hp bar red
			{
			;msgbox, do nothing 4 ;	nothing						sleep -1
				sleep -1
			}
			else
			{
				controlsend,, % Primary_Heal[4], %Healer_PID% ; pixel grabbed is not red meaning health is lost
				sleep, 350 ; 3.5 seconds
			}	
		}
		else
		{
			return
		}
	}
	
	if HP_Monitor_State[5] = 1
	{	
		Monitor_Health_5 := (((100_x_HP_Character[5] - 0_x_HP_Character[5]) / 100 * heal_at_Percent[5]) + 0_x_HP_Character[5])
		ifwinactive, %Primary_Client%
		{	
			PixelGetColor, Current_Health_5, Monitor_Health_5, Y_HP_Character[5], RGB
			if (Current_Health_5 = HP_color_character[5]) ; verifying pixel grabbed is same as hp bar red
			{
			;msgbox, do nothing 5 ;	nothing						sleep -1
				sleep -1
			}
			else
			{
				controlsend,, % Primary_Heal[5], %Healer_PID% ; pixel grabbed is not red meaning health is lost
				sleep, 350 ; 3.5 seconds
			}
		}
		else
		{
			return
		}
	}
	
	if HP_Monitor_State[6] = 1
	{	
		Monitor_Health_6 := (((100_x_HP_Character[6] - 0_x_HP_Character[6]) / 100 * heal_at_Percent[6]) + 0_x_HP_Character[6])
		ifwinactive, %Primary_Client%
		{
		PixelGetColor, Current_Health_6, Monitor_Health_6, Y_HP_Character[6], RGB
		if (Current_Health_6 = HP_color_character[6]) ; verifying pixel grabbed is same as hp bar red
		{
			;msgbox, do nothing 6 ;	nothing						sleep -1
			sleep -1
		}
		else
		{
			controlsend,, % Primary_Heal[6], %Healer_PID% ; pixel grabbed is not red meaning health is lost
			sleep, 350 ; 3.5 seconds
		}	
		}
		else
		{
			return
		}
	}
	endfunction:
	return
}
