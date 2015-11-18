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



/**********************
	Script start
*/
ScriptStart:
script_version := 2.0
script_debug := TRUE
script_title = Windows Tags for Files

tagtoken = @
tag1name = done
tag2name = TODO


/*************
	Inits
*/
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

; Generated using SmartGUI Creator 4.0
Gui, Add, Radio, x-33 y-68 w100 h30 , Radio
Gui, Add, Radio, x102 y50 w60 h30, vTodo, Todo
Gui, Add, Radio, x102 y100 w60 h30, vDone, Done
Gui Add, Button, x20 y175 w50 h30 , &Tag
Return

; if the Tag button is clicked
ButtonTag:
Gui Submit   ; Save the input from the user to each control's associated variable
Goto ButtonQuit
Return


; if the Quit button is clicked
ButtonQuit:
GuiClose:
Return


/**********************
	Tagging menu GUI
	CTRL + Win + t
*/

^#t::
	/*
	selectedFiles := Explorer_GetSelected()	

	if (selectedFiles = "ERROR")
		MsgBox, 16, %script_title% Error, Windows Explorer is not in focus!
	else if (selectedFiles = "")
		MsgBox, 48, %script_title%, Windows Explorer is open and in focus, but no files are selected.
	else
	{
		Gosub GetFiles
		Gui, Show, Center, x195 y109 h194 w216, %script_title%
	}
	*/

	if GetFiles() = TRUE
	{	
		Gui, Show, Center, x195 y109 h194 w216, %script_title%
	}

; Rename a file loop
;FileMove, C:\File Before.txt, C:\File After.txt  



Return

	
	
/****************************
	GetFiles function
	looks for selected files
	returns TRUE/FALSE status
*/

GetFiles()
{
	; look up the selected files
	selectedFiles := Explorer_GetSelected()
	
	; error check
	if (selectedFiles = "ERROR")
	{
		MsgBox, 16, %script_title% Error, Windows Explorer is not in focus!
		Goto FilesError
	}
	else if (selectedFiles = "")
	{
		MsgBox, 48, %script_title%, Windows Explorer is open and in focus, but no files are selected.
		Goto FilesError
	}
	else
	{
		; parse the selected file paths, terminating on line feeds
		Loop, Parse, selectedFiles, `n, `r
		{
			path := A_LoopField
			
			if script_debug
				MsgBox, 0, (DEBUG) Original path #%A_Index%, %path%
			
			; split the path into its constituent parts in pseudo-arrays
			SplitPath, path, fullname%A_Index%, directory%A_Index%, extension%A_Index%, name%A_Index%
			
			if script_debug
				MsgBox, 64, (DEBUG) File #%A_Index% Parts, % "Full filename = " fullname%A_Index% "`nDirectory = " directory%A_Index% "`nExtension = " extension%A_Index% "`nName only = " name%A_Index%
			
			fileCount = %A_Index%
			
		/*
		;			StringReplace, newName, path, %tagtoken%%tag1name%, ¢
			
			;MsgBox, Renamed path, %newName%
			
			;Loop, Parse, path, ¢ ; Parse the string based on the chosen tag token.
			Loop, Parse, path, %tagtoken%
			{
				MsgBox, number %A_Index% is %A_LoopField%.
			}

			*/
		}
		return TRUE
	}
	
FilesError:
	return FALSE
}		
		
	
/**********************
	Shut down script
*/

QuitScriptSub:
ExitApp	; Terminate this script