script "behavior_ViewMultichainLayer"
--> MetaData
-
copyright: David Bovill
license: GPLv3
name: behavior_ViewMultichainLayer
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
getprop multichain_LayerNames
   -- only for these fixed layers for now
   return "Application,Aggregation,Execution,Relay,Core"
end multichain_LayerNames

private function _LayerColour layerName
   -- only for these fixed layers for now
   switch layerName
      case "Application"
         return "254,249,83"
      case "Aggregation"
         return "212,234,75"
      case "Execution"
         return "155,211,64"
      case "Relay"
         return "94,204,210"
      case "Core"
         return "60,65,185"
      default
         return "red"
   end switch
end _LayerColour

getprop label_Behavior
   return the behavior of labelButton to _LabelButton()
end label_Behavior

setprop label_Behavior bObject
   put _LabelButton() into labelButton
   set the behavior of labelButton to bObject
   return labelButton
end label_Behavior

command label_SetProps
   put _LabelButton() into labelButton
   
   lock screen
   --
   set the visible of labelButton to true
   
   set the foregroundColor of labelButton to empty
   set the bordercolor of labelButton to orange
   set the borderwidth of labelButton to 1
   
   set the opaque of labelButton to false
   set the traversalOn of labelButton to false
   set the showFocusBorder of labelButton to false
   set the threeD of labelButton to false
   set the showBorder of labelButton to false
   unlock screen
end label_SetProps


--> Props
-
getprop circle_Rect
   return the rect of _CircleGraphic()
end circle_Rect
   
setprop circle_Rect [pRingH] squareRect
   lock screen
   set the rect of _CircleGraphic() to squareRect
   set the title_Rect [pRingH] of _LabelButton() to squareRect
   unlock screen
end circle_Rect

getprop title_Rect [pRingH]
   put _LabelButton() into labelButton
   put the formattedWidth of labelButton into fWidth
   if pRingH is empty then
      put the formattedHeight of labelButton into pRingH
      add 8 to pRingH
   end if
   
   put the rect of me into pRect
   put rect_GetSquare (pRect) into squareRect
   put _TitleRect (squareRect, fWidth, pRingH) into titleRect
   set the rect of _LabelButton() to titleRect
   return titleRect
end title_Rect

setprop title_Rect [pRingH] squareRect
   put _LabelButton() into labelButton
   put the formattedWidth of labelButton into fWidth
   if pRingH is empty then
      put the formattedHeight of labelButton into pRingH
      add 12 to pRingH
   end if
   
   put pRingH > 28 into showLabel
   set the visible of labelButton to showLabel
   --  label_SetProps
   
   put _TitleRect (squareRect, fWidth, pRingH) into titleRect
   set the rect of labelButton to titleRect
end title_Rect

getprop title_Top
   return the visible of _LabelButton()
end title_Top

setprop title_Top sBoolean
   put sBoolean is true into sBoolean
   
   lock screen
   set the visible of _labelButton() to sBoolean
   set the showname of _CircleGraphic() to (sBoolean is false)
   unlock screen
end title_Top

getprop multichain_LayerName
   put the label of _labelButton() into layerName
   return word 1 of layerName
end multichain_LayerName

setprop multichain_LayerName layerName
   put _CircleGraphic() into circleGraphic
   
   get word 1 of layerName
   put it into layerName
   -- put it && "Layer" into layerName
   
   set the name of me to layerName
   set the name of circleGraphic to layerName
   --
   put _LayerColour (it) into layerColour
   put it is "Core"  into isCore
   --
   lock screen
   set the label of _labelButton() to layerName
   set the backgroundcolor of circleGraphic to layerColour
   set the title_Top of me to (not isCore)
   unlock screen
end multichain_LayerName

private function _TitleRect squareRect, fWidth, ringH
   put squareRect into titleRect
   put item 2 of squareRect + ringH into item 4 of titleRect
   add 12 to fWidth
   rect_SetWidth titleRect, fWidth
   return titleRect
end _TitleRect


--> Events
-
on mouseDown
   switch the short name of the target
      case "Core"
         menu_PopUp "Global | Multichain | Layer | Menu"
         break
      default
         --
   end switch
end mouseDown

on mouseUp
   /*
   answer color
   put it into layerColour
   put layerColour
   --
   set the backgroundcolor of _CircleGraphic() to layerColour
   */
end mouseUp

on resizeControl
   put the rect of me into viewRect
   LayoutControl viewRect
end resizeControl


--> Events | Custom
-
command LayoutControl pRect
   if pRect is empty then put the rect of me into pRect
   put rect_GetSquare (pRect, 0) into squareRect
   --
   set the circle_Rect of me to squareRect
end LayoutControl


--> Geometry
-
function rect_GetSquare someRect, pSquareMargin
   local squareRect, squareCentre, squareWidth, halfSquareWidth
   rect_SetSquare someRect, squareRect, squareCentre, squareWidth, halfSquareWidth, pSquareMargin
   return squareRect
end rect_GetSquare

command rect_SetSquare pRect, @squareRect, @squareCentre, @squareWidth, @halfSquareWidth, pSquareMargin
   put item 3 of pRect - item 1 of pRect into someX
   put item 4 of pRect - item 2 of pRect into someY
   
   put min (someX, someY) into squareWidth
   put squareWidth / 2 into halfSquareWidth
   put 2 * halfSquareWidth into squareWidth
   
   put rect_GetCentre (pRect) into squareCentre
   put rect_LocWidthHeight (squareCentre, squareWidth, squareWidth) into squareRect
   
   rect_SubtractMargins squareRect, pSquareMargin
   return squareRect
end rect_SetSquare

command rect_SetWidth @someRect, newWidth, pDontCentre
   if pDontCentre is true then
      put item 1 of someRect + newWidth into item 3 of someRect
   else
      put item 1 of rect_GetCentre(someRect) into centreX
      put newWidth/2 into leftWidth
      put newWidth - leftWidth into rightWidth
      put centreX - leftWidth into item 1 of someRect
      put centreX + rightWidth into item 3 of someRect
   end if
end rect_SetWidth

function rect_LocWidthHeight someLoc, newW, newH
   put newW/2 into leftBit
   put newW - leftBit into rightBit
   put item 1 of someLoc into someX
   put someX - leftBit into item 1 of someRect
   put someX + rightBit into item 3 of someRect
   
   put newH/2 into upBit
   put newH - upBit into downBit
   put item 2 of someLoc into someY
   put someY - upBit into item 2 of someRect
   put someY + downBit into item 4 of someRect
   
   return someRect
end rect_LocWidthHeight

function rect_GetCentre someRect
   -- removed truncation
   put item 1 of someRect into someLeft
   put (item 3 of someRect - someLeft)/2 into halfWidth
   put item 2 of someRect into someTop
   put (item 4 of someRect - someTop)/2 into halfHeight
   put someLeft + halfWidth into item 1 of someMiddle
   put someTop + halfHeight into item 2 of someMiddle
   return someMiddle
end rect_GetCentre

command rect_SubtractMargins @someRect, pMargin
   margin_Normalize pMargin, leftM, topM, rightM, bottomM   
   add leftM to item 1 of someRect
   add topM to item 2 of someRect
   subtract rightM from item 3 of someRect
   subtract bottomM from item 4 of someRect
end rect_SubtractMargins

command margin_Normalize @someMargin, @leftM, @topM, @rightM, @bottomM
   -- fixed bug in setting bottomM when 4th item is empty
   if the number of items of someMargin < 4 then
      put item 1 of someMargin into defaultMargin
      put defaultMargin into leftM
      
      put item 2 of someMargin into actualMargin
      if actualMargin is empty then
         put leftM into topM
      else
         put actualMargin into topM
      end if
      
      put item 3 of someMargin into actualMargin
      if actualMargin is empty then
         put leftM into rightM
      else
         put actualMargin into rightM
      end if
      
      put item 4 of someMargin into actualMargin
      if actualMargin is empty then
         put topM into bottomM
      else
         put actualMargin into bottomM
      end if
   else
      put item 1 of someMargin into leftM
      put item 2 of someMargin into topM
      put item 3 of someMargin into rightM
      put item 4 of someMargin into bottomM
   end if
   put leftM,topM,rightM,bottomM into someMargin
end margin_Normalize


--> Objects
-
getprop view_Object
   return the long id of me
end view_Object

private function _CircleGraphic
   put the long id of grc 1 of me into circleGraphic
   return circleGraphic
end _CircleGraphic

private function _labelButton
   put the long id of btn 1 of me into labelButton
   return labelButton
end _labelButton
