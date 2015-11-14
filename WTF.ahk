/*
	File: "WTF.ahk"
	Author: Rob Lund
	License: freely distributable
	Description:
		Windows Tags for Files (WTF)
		Applies "tags" by renaming selected files in Explorer. 
		compatible up to Windows 10, except for desktop mode
	Notes: 
		Shortcut key is bound
		Avoid these illegal NTFS characters for tag name tokens  
		\ / : * ? " < > | 
	References:
		http://autohotkey.com/board/topic/60985-get-paths-of-selected-items-in-an-explorer-window/		
*/



;--------------
;Script start
;--------------
ScriptStart:
script_version := 2.0
script_title = Windows Tags for Files

tagtoken = @
tag1name = done
tag2name = TODO


;--------------
;Inits
;--------------
#SingleInstance	force 
#include explorer window info.ahk


/*
IniRead app1_path, script config.ini, paths, IniApp1Path		; read INI variable

If app1_path = ERROR
{
	MsgBox 4112, Config File Error!, Couldn't read "%IniApp1Path%" from the ini file.
	ExitApp
}
*/

Gui, Add, Radio, x-33 y-68 w100 h30 , Radio
Gui, Add, Radio, x102 y50 w60 h30 , TODO
Gui, Add, Radio, x102 y100 w60 h30 , Done
; Generated using SmartGUI Creator 4.0

Return

GuiClose:
ExitApp


F1::
	sel := Explorer_GetSelected()
	
	if (sel = "ERROR")
		MsgBox, 16, %script_title% Error, Windows Explorer is not in focus!
	else if (sel = "")
		MsgBox, 48, %script_title%, Windows Explorer is open and in focus, but no files are selected.
	else
	{
		MsgBox, 64, %script_title% Results, File paths`n`n%sel%
		
		; parse the selected file paths
		Loop, Parse, sel, `n, `r
		{
			Gui, Show, x195 y109 h194 w216, %script_title%
			path := A_LoopField
			MsgBox %path%
		}
	}
		
		
		
; Rename a file loop
;FileMove, C:\File Before.txt, C:\File After.txt  



	return
