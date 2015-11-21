/*
	File: "WTF.ahk"
	Author: Rob Lund
	License: freely distributable
	
	Description:
		Windows Tags for Files (WTF)
		Applies "tags" by renaming selected files in Explorer. 
		compatible up to Windows 10, except for desktop mode
		Tags are mutually exclusive, i.e., you can't have multiple tags on one file.
		
	Notes: 
		Shortcut key is bound
		Avoid these illegal NTFS characters for tag name tokens
			\ / : * ? " < > | 
		Icon created with Paint.net.  Photoshop compatible design file included.

	References:
		http://autohotkey.com/board/topic/60985-get-paths-of-selected-items-in-an-explorer-window/		

	Notes:	
*/

/********************
	Initialization
*/
#SingleInstance	force 
#include explorer window info.ahk

global script_version := 2.0
global script_debug := FALSE
script_title = Windows Tags for Files
script_title_short = WTF	; acroynms make the world go round

if (script_debug = FALSE)
{
	; customize the tray icon & menus
	Menu, Tray, Icon, %A_ScriptDir%\wtf.ico
	Menu, Tray, Tip, %script_title%
	Menu, Tray, NoStandard
	Menu, Tray, Add, Edit Preferences, MenuEdit
	Menu, Tray, Disable, Edit Preferences
	Menu, Tray, Add,		; separater line
	Menu, Tray, Add, Exit, QuitScriptSub
}

; Tagging setup
tagToken = @
tag1Name = done
tag2Name = TODO
tagNone	= none


; Generated using SmartGUI Creator 4.0
Gui, Add, Button, x22 y60 w80 h30 , &Todo
Gui, Add, Button, x132 y60 w80 h30 , &Done
Gui, Font, s14, Verdana
Gui, Add, Text, x20 y10, %script_title%
Gui, Font, S10 CDefault, Verdana
Gui, Font, S10 CDefault Bold, Verdana
Gui, Add, Button, x132 y140 w80 h30 , &Quit
Gui, Font, S8 CDefault, Verdana
Gui, Add, Button, x22 y140 w80 h30 , &Delete

Return


/******************
	All tags GUI
	Win + F1
*/

#F1::

; look up selected files
Gosub, GetFiles

; proceed only if there were files
if fileCount > 0
{	
	Gui, Show, x127 y87 h205 w239, %script_title_short%
}
	
Return


/****************************
	TODO hotkey or GUI button
	Win + t
*/

#t::

; look up selected files
Gosub, GetFiles

ButtonTodo:		; label order is vital!

; now tag them
Tagger(tag2Name)
Gui, Cancel
Return


/****************************
	Done hotkey or GUI button
	Win + d
*/

#d::

; look up selected files
Gosub, GetFiles

ButtonDone:		; label order is vital!

; now tag them
Tagger(tag1Name)
Gui, Cancel
Return


/*********************
	Delete GUI button
*/

ButtonDelete:
Tagger(tagNone)
Gui, Cancel
Return


/*********************
	Quit GUI button
*/

ButtonQuit:
Gui, Cancel
Return


/****************************
	GetFiles subroutine
	looks for selected files
	returns TRUE/FALSE status
*/

GetFiles:

; initialize
global fileCount = 0

; look up the selected files
selectedFiles := Explorer_GetSelected()

; error check
if (selectedFiles = "ERROR")
{
	MsgBox, 16, %script_title_short% Error, Windows Explorer is not in focus!
}
else if (selectedFiles = "")
{
	MsgBox, 48, %script_title%, Windows Explorer is open and in focus, but no files are selected.
}
else
{
	; parse the selected file paths, terminating on line feeds
	Loop, Parse, selectedFiles, `n, `r
	{
		path := A_LoopField
		
		; split the path into its constituent parts in pseudo-arrays
		SplitPath, path, fullname%A_Index%, directory%A_Index%, extension%A_Index%, name%A_Index%
		
		if script_debug
			MsgBox, 64, (DEBUG) File #%A_Index% Parts, % "Full filename = " fullname%A_Index% "`nDirectory = " directory%A_Index% "`nExtension = " extension%A_Index% "`nName only = " name%A_Index%
		
		fileCount = %A_Index%
	}
}

Return		


/****************************
	Tagger Function
	tags the selected files
	with input tag type
*/

Tagger(tagType)
{
	; assume all variables used here are global
	global	
	
	Loop, %fileCount%
	{
		; strip out any previous tags first, regardless of called tag
		IfInString, name%A_Index%, %tagToken%%tag1Name%
		{
			StringTrimRight, newName, name%A_Index%, StrLen(tagToken . tag1Name) + 1
		}
		Else IfInString, name%A_Index%, %tagToken%%tag2Name%
		{
			StringTrimRight, newName, name%A_Index%, StrLen(tagToken . tag2Name) + 1
		}
		Else
		{
			; file isn't tagged, use as is
			newName := name%A_Index%
		}
		
		; build old and new full file paths
		oldPath := directory%A_Index% . "\" . name%A_Index% . "." . extension%A_Index%
		
		if (tagType = tagNone)
			newPath := directory%A_Index% . "\" . newName . "." . extension%A_Index%
		else
			newPath := directory%A_Index% . "\" . newName . " " . tagToken . tagType . "." . extension%A_Index%
		
		if script_debug
		{
			MsgBox, 64, (DEBUG) Old Name, %oldPath%
		
			MsgBox, 64, (DEBUG) New Name, %newPath%
		}
		
		; now rename
		FileMove, %oldPath%, %newPath%
		
		; error check
		if ErrorLevel <> 0
			MsgBox, 16, %script_title_short% Error, %ErrorLevel% files/folders could not be tagged.
	}
}


/**********************
	Script preferences
*/

MenuEdit:

if script_debug
	MsgBox You selected %A_ThisMenuItem% from menu %A_ThisMenu%.

Return

	
/**********************
	Shut down script
*/

QuitScriptSub:
GuiClose:
ExitApp	; Terminate this script