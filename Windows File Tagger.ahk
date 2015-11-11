/* 
**** References ****
library for looking up selected files in the topmost Explorer instance (works in Windows 10):

http://autohotkey.com/board/topic/60985-get-paths-of-selected-items-in-an-explorer-window/
*/

#SingleInstance	force 

#include explorer window info.ahk

F1::
	sel := Explorer_GetSelected()
	
	if (sel = "ERROR")
		MsgBox, 16, File Tagger Error, Windows Explorer is not in focus!
	else if (sel = "")
		MsgBox, 48, File Tagger, Windows Explorer is open and in focus, but no files are selected.
	else
		MsgBox, 64, File Tagger Results, Paths`n`n%sel%
		
		
		
; Rename a file loop
FileMove, C:\File Before.txt, C:\File After.txt  


return


