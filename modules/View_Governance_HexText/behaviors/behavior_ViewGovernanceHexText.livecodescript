script "behavior_ViewGovernanceHexText"
--> MetaData
-
copyright: David Bovill
license: GPLv3
name: behavior_ViewGovernanceHexText
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
on resizeControl
   put the rect of me into viewRect
   LayoutControl viewRect
end resizeControl


--> Props
-
getprop show_Name
   return the showname of _HexGraphic()
end show_Name

setprop show_Name sBoolean
   set the showname of _HexGraphic() to sBoolean is true
end show_Name

getprop layer_Names
   return "HexText,HexAndText,HexGraphic"
end layer_Names

getprop visible_Names
   if the visible of _HexText() is true then
      put "HexText," after visibleNames
   end if
   
   if the visible of _HexAndText() is true then
      put "HexAndText," after visibleNames
   end if
   
   if the visible of _HexGraphic() is true then
      put "HexGraphic," after visibleNames
   end if
   --
   delete char -1 of visibleNames
   return visibleNames
end visible_Names

setprop visible_Names visibleNames
   replace comma with CR i visibleNames
   --
   put "HexText," is among the lines of visibleNames into sBoolean
   set the visible of _HexText() to sBoolean
   --
   put "HexAndText," is among the lines of visibleNames into sBoolean
   set the visible of _HexAndText() to sBoolean
   --
   put "HexGraphic," is among the lines of visibleNames into sBoolean
   set the visible of _HexGraphic() to sBoolean
end visible_Names

setprop toggle_Visible layerName
   put _layerObject (layerName) into layerObject
   --
   put the visible of layerObject into sBoolean
   set the visible of layerObject to (sBoolean is false)
end toggle_Visible

getprop layer_Visible [layerName]
   put _layerObject (layerName) into layerObject
   --
   put the visible of layerObject into sBoolean
   return sBoolean
end layer_Visible

setprop layer_Visible [layerName] sBoolean
   put _layerObject (layerName) into layerObject
   --
   set the visible of layerObject to sBoolean
   return layerObject
end layer_Visible

getprop text_Rotation
   return the angle of _HexText()
end text_Rotation

setprop text_Rotation sDegree
   set the angle of _HexText() to sDegree
end text_Rotation

setprop hex_Scale sScale
   -- put the rect of me into someRect
   put the view_RectOnCard of me into someRect
   --
   _SetRect someRect, sScale
   --
   put someRect & CR & the rect of me 
end hex_Scale


--> Events | Custom
-
on refreshDisplay
   put _InnerRect() into innerRect
   LayoutControl innerRect
end refreshDisplay

command LayoutControl pRect
   lock screen
   if pRect is empty then put _InnerRect() into pRect
   
   put 873 / 2.04 into sScale 
   _SetRect pRect, sScale
   unlock screen
end LayoutControl


--> Deps
-
command rect_ExtractDimensions someRect, @someW, @someH, pScale
   if pScale is not a number then put 1 into pScale
   --
   put pScale * (item 3 of someRect - item 1 of someRect) into someW
   put pScale * (item 4 of someRect - item 2 of someRect) into someH
end rect_ExtractDimensions


--> Private
-
private function _InnerRect
   put the rect of me into viewRect
   return viewRect
end _InnerRect

private command _SetRect someRect, pScale
   rect_ExtractDimensions someRect, someW, someH
   put someW / (500 - 76) into pScale -- 864.96
   
   rect_ExtractDimensions "98,93,479,471", hexGraphicW, hexGraphicH, pScale
   rect_ExtractDimensions "76,92,500,473", hexTextW, hexTextH, pScale
   rect_ExtractDimensions "76,92,500,473", hexAndTextW, hexAndTextH, pScale
   --  put "76,93,500,471" into hexAndTextRect
   
   put rect_FromWidthAndHeight (someRect, hexGraphicW, hexGraphicH) into hexGraphicRect
   put rect_FromWidthAndHeight (someRect, hexTextW, hexTextH) into hexTextRect
   put rect_FromWidthAndHeight (someRect, hexAndTextW, hexAndTextH) into hexAndTextRect
   
   set the rect of _HexGraphic() to hexGraphicRect
   set the rect of _HexAndText() to hexTextRect
   set the rect of _HexText() to hexAndTextRect
end _SetRect

private command _SetLocs pRect
   put rect_GetCentre (pRect) into myCentre
   --
   set the loc of _HexGraphic() to myCentre
   set the loc of _HexAndText() to myCentre
   set the loc of _HexText() to myCentre
end _SetLocs


--> Private | Objects
-
private function _layerObject layerName
   if exists (control layerName of me) is false then return empty
   put the long id of control layerName of me into layerObject
   return layerObject
end _layerObject

private function _HexGraphic
   return the long id of control "HexGraphic"
end _HexGraphic

private function _HexAndText
   return the long id of control "HexAndText"
end _HexAndText

private function _HexText
   return the long id of control "HexText"
end _HexText


--> Objects
-
getprop hexText_View
   return the long id of me
end hexText_View

getprop view_Object
   return the long id of me
end view_Object
