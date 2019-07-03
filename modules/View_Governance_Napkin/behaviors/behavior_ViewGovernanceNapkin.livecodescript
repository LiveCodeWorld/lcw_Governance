script "behavior_ViewGovernanceNapkin"
--> MetaData
-
license: GPLv3
name: behavior_ViewGovernanceNapkin
type: behavior
version: 0.1


--> Events
-
on sectorClicked sectorNum
   put the sector_Label [sectorNum] of me
end sectorClicked

on mouseDown pButton
   if pButton = 3 then
      menu_PopUp "Global | Governance | Person | Menu"
   else
      grab me
   end if
end mouseDown

on resizecontrol
   LayoutControl
end resizecontrol


--> Person
-
getprop person_Visible
   put _personView() into personView
   put the visible of personView into someBoolean
   return someBoolean
end person_Visible

setprop person_Visible someBoolean
   put _personView() into personView
   lock screen
   set the visible of personView to someBoolean
   set the pie_Visible of me to (not someBoolean)
   set the polo_Visible of me to (not someBoolean)
   unlock screen
   return someBoolean
end person_Visible


--> Pie
-
getprop pie_LabelVisible
   put _pieObject() into pieObject
   put the showLabels of pieObject into someBoolean
   return someBoolean
end pie_LabelVisible

setprop pie_LabelVisible someBoolean
   put _pieObject() into pieObject
   set the showLabels of pieObject to someBoolean
   return someBoolean
end pie_LabelVisible

getprop pie_Visible
   put _pieObject() into pieObject
   put the visible of pieObject into someBoolean
   return someBoolean
end pie_Visible

setprop pie_Visible someBoolean
   put _pieObject() into pieObject
   set the visible of pieObject to someBoolean
   return someBoolean
end pie_Visible


--> Polo
-
getprop polo_Visible
   put _circleObject() into circleObject
   put the visible of circleObject into someBoolean
   return someBoolean
end polo_Visible

setprop polo_Visible someBoolean
   put _circleObject() into circleObject
   set the visible of circleObject to someBoolean
   return someBoolean
end polo_Visible

getprop polo_Colour
   put _circleObject() into circleObject
   put the backgroundcolor of circleObject into someColour
   return someColour
end polo_Colour

setprop polo_Colour someColour
   put _circleObject() into circleObject
   set the backgroundcolor of circleObject to someColour
   return circleObject
end polo_Colour

-- getprop transparent_Polo
put _circleObject() into circleObject
put the ink of circleObject = "blendSrcOver" into someBoolean
return someBoolean
end transparent_Polo

-- setprop transparent_Polo someBoolean
put _circleObject() into circleObject
--
lock screen
if someBoolean is true then
   set the backgroundcolor of circleObject to "black"
   set the ink of circleObject to "blendSrcOver"
else
   set the backgroundcolor of circleObject to "white"
   set the ink of circleObject to "srcCopy"
end if
unlock screen
end transparent_Polo


--> Sector
-
getprop sector_Percent [sectorNum]
   -- sectorNum seems to get stuck
   put _pieObject() into pieObject
   --
   put the sectorValues of pieObject into valueList
   put item sectorNum of valueList into sectorValue
   put sum (valueList) into sectorTotal
   put 100*sectorValue/sectorTotal into sPercent
   return sPercent
end sector_Percent

getprop sector_Value [sectorNum]
   put _pieObject() into pieObject
   --
   put the sectorValues of pieObject into valueList
   put item sectorNum of valueList into sValue
   return sValue
end sector_Value

setprop sector_Value [sectorNum] someValue
   put _pieObject() into pieObject
   put the sectorValues of pieObject into valueList
   put someValue into item sectorNum of valueList
   set the sectorValues of pieObject to valueList
   return valueList
end sector_Value

setprop sector_Values
   put _pieObject() into pieObject
   set the sectorValues of pieObject to valueList
   return pieObject
end sector_Values

setprop sector_Values valueList
   put _pieObject() into pieObject
   set the sectorValues of pieObject to valueList
   return pieObject
end sector_Values

getprop sector_Labels labelList
   put _pieObject() into pieObject
   set the sectorLabels of pieObject to labelList
   return pieObject
end sector_Labels

getprop sector_Label [sectorNum]
   put _pieObject() into pieObject
   --
   put the sectorLabels of pieObject into labelList
   put item sectorNum of labelList into sLabel
   return sLabel
end sector_Label

getprop sector_Labels
   put _pieObject() into pieObject
   put the sectorLabels of pieObject into labelList
   return labelList
end sector_Labels

setprop sector_Labels labelList
   put _pieObject() into pieObject
   set the sectorLabels of pieObject to labelList
   return pieObject
end sector_Labels


--> Geometry
-
command LayoutControl pRect
   if pRect is empty then put the rect of me into pRect
   put _pieObject() into pieObject
   put _circleObject() into circleObject
   put _personView() into personView
   
   lock screen
   put the inner_Rect [pRect] of me into innerRect
   put rect_GetSquareWithin (innerRect, 0.4) into poloRect
   put innerRect into personRect
   rect_SubtractMargins personRect, 6
   --
   set the rect of pieObject to innerRect
   set the rect of circleObject to poloRect
   set the rect of personView to personRect
   --
   unlock screen
end LayoutControl


--> Deps
-
function rect_GetSquareWithin someRect, pScale
   put rect_GetCentre (someRect) into newCentre
   rect_ExtractDimensions someRect, someW, someH
   put min (someW, someH) into newWidth
   if pScale is a number then
      put newWidth * pScale into newWidth
   end if
   put rect_LocWidthHeight (newCentre, newWidth, newWidth) into squareRect
   return squareRect
end rect_GetSquareWithin

function rect_GetCentre someRect
   -- does not always return the same as the loc
   -- out by one pixel (rounding error)? trunc or round?
   put item 1 of someRect into someLeft
   put trunc((item 3 of someRect - someLeft)/2) into halfWidth
   -- put round((item 3 of someRect - someLeft)/2) into halfWidth
   put item 2 of someRect into someTop
   -- put round((item 4 of someRect - someTop)/2) into halfHeight
   put trunc((item 4 of someRect - someTop)/2) into halfHeight
   put someLeft + halfWidth into item 1 of someMiddle
   put someTop + halfHeight into item 2 of someMiddle
   return someMiddle
end rect_GetCentre

command rect_ExtractDimensions someRect, @someW, @someH
   put item 3 of someRect - item 1 of someRect into someW
   put item 4 of someRect - item 2 of someRect into someH
end rect_ExtractDimensions


--> Objects
-
function _personView
   put the long id of grp 1 of me into personView
   return personView
end _personView

function _pieObject
   put the long id of widget 1 of me into pieObject
   return pieObject
end _pieObject

function _circleObject
   put the long id of graphic "Polo Centre" of me into circleObject
   return circleObject
end _circleObject
