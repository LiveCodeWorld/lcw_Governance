script "behavior_ViewGovernanceLove"
--> MetaData
-
copyright: David Bovill
license: GPLv3
name: behavior_ViewGovernanceLove
type: behavior
version: 0.1


/*
Here you make make notes as a basic form of help for this view.
Full help text can be found on the linked wiki for the view.
*/

--> Variables
-
local LocalArray


--> Working on
-

--> Events
-
on preOpenControl
   -- might not be needed as it is done autommatically
   dispatch "preOpenControl" to _GroupObject (1)
   dispatch "preOpenControl" to _GroupObject (2)
   dispatch "preOpenControl" to _GroupObject (3)
   -- pass preOpenControl
end preOpenControl

on mouseUp
   pass mouseUp
end mouseUp

on resizeControl
   put the rect of me into viewRect
   LayoutControl viewRect
end resizeControl


--> Events | Custom
-
on refreshDisplay
   put the rect of me into viewRect
   LayoutControl viewRect
end refreshDisplay

command LayoutControl pRect
   lock screen
   if pRect is empty then put the rect of me into pRect
   put rect_GetSquare (pRect) into councilRect
   put _CouncilWidth() into councilWidth
   put _InnerRect (2, councilWidth, councilRect) into committeeRect
   put _InnerRect (5, councilWidth, councilRect) into commisssionRect
   
   /*
   put the long id of me into tObject
   rect_CreateMask councilRect, "Test Council", tObject, "red"
   rect_CreateMask committeeRect, "Test Commmittee", tObject, "green"
   rect_CreateMask commisssionRect, "Test Committee", tObject, "yellow"
   */
   
   set the rect of _GroupObject ("Council") to councilRect
   set the rect of _GroupObject ("Committee") to committeeRect
   set the rect of _GroupObject ("Commission") to commisssionRect
   --
   unlock screen
end LayoutControl

function _InnerRect gNum, councilWidth, pRect
   put _InnerMargin (gNum, councilWidth) into sMargin
   put rect_Subtract (sMargin, pRect) into innerRect
   return innerRect
end _InnerRect

function _InnerMargin gNum, councilWidth
   put councilWidth / 12 into ringWidth
   put (gNum - 1) * ringWidth into innerMargin
   return innerMargin
end _InnerMargin

private function _CouncilWidth
   put the circle_Rect of _GroupObject (1) into councilRect
   -- put the width of me into councilWidth
   put item 3 of councilRect - item 1 of councilRect into councilWidth
   return councilWidth
end _CouncilWidth

private function _GroupObject gName
   put the long id of group gName of me into sGroup
   return sGroup
end _GroupObject


--> Objects
-
getprop view_Object
   return the long id of me
end view_Object

getprop council_View
   -- return _GroupObject (1)
   return _GroupObject ("Council")
end council_View

getprop commission_View
   -- return _GroupObject (3)
   return _GroupObject ("Commission")
end commission_View

getprop committee_View
   -- return _GroupObject (2)
   return _GroupObject ("Committee")
end committee_View

getprop hexText_View
   -- return _GroupObject (2)
   return _GroupObject ("Committee")
end hexText_View

getprop group_Names
   repeat with gNum = 1 to the number of groups of me
      put the short name of group gNum of me & comma after gNames
   end repeat
   delete char -1 of gNames
   return gNames
end group_Names

getprop group_Object [gName]
   return _GroupObject(gName)
end group_Object
