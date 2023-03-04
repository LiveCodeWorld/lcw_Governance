script "behavior_ViewGovernanceCircle"
--> David Bovill
-
copyright: David Bovill
license: GPLv3
name: behavior_ViewGovernanceCircle
type: behavior
version: 0.1

/*
This view displays a circle of governance agents.
It is based on behavior_ViewMultichainLayer
*/

--> Variables
-
local LocalArray


--> Working on
-
getprop constrain_Circle
   return LocalArray ["constrain_Circle"] is not false
end constrain_Circle

setprop constrain_Circle sBoolean
   put sBoolean into LocalArray ["constrain_Circle"]
end constrain_Circle

private function _LayoutRect pRect
   put the margins of me into sMargins
   rect_SubtractMargins pRect, sMargins
   return pRect
end _LayoutRect

private function _LayoutSquareRect pRect
   put _CircleGraphic() into circleGraphic
   if pRect is empty then
      put the rect of circleGraphic into pRect
   end if
   put the margins of me into sMargins
   put rect_GetSquare (pRect, sMargins) into squareRect
   return squareRect
end _LayoutSquareRect

getprop ring_Angle
   put LocalArray ["ring_Angle"] into sRadians
   if sRadians is empty then
      return 0
   else
      angle_RadiansToDegrees sRadians
      return sRadians
   end if
end ring_Angle

setprop ring_Angle sDegree
   angle_DegreesToRadians sDegree
   put sDegree into LocalArray ["ring_Angle"]
   --
   put the circle_Rect of me into cRect
   put the ring_GraphicPoints [true] of me into ringPoints
   put the ring_MarkerWidth of me into mWidth
   
   lock screen
   _ResizeMarkers ringPoints, mWidth
   LayoutControl cRect
   unlock screen
end ring_Angle

function angle_DegreesToRadians sDegree
   put sDegree * pi/180 into sRadian
   return sRadian
end angle_DegreesToRadians

function angle_RadiansToDegrees sRadian
   put 180 * sRadian/pi into sDegree
   return sDegree
end angle_RadiansToDegrees

command _ResizeMarkers ringPoints, pMarkerWidth
   if pMarkerWidth is empty then put 22 into pMarkerWidth
   put _PeopleGroup() into pGroup
   put _RingMarkerScale() into ringMarkerScale
   put _SquareRect() into squareRect
   put _MarkerWidth (squareRect, ringMarkerScale) into markerWidth
   --   
   lock screen
   repeat with cNum = 1 to the number of controls of pGroup
      if exists (control cNum of pGroup) is false then exit repeat
      
      put line cNum of ringPoints into ringPoint
      put rect_LocWidthHeight (ringPoint, markerWidth) into pRect
      --
      set the rect of control cNum of pGroup to pRect
   end repeat
   unlock screen
end _ResizeMarkers

setprop marker_Views vName
   lock screen
   switch vName
      case empty
         ring_ClearThings
         break
      case "graphic"
         put the circle_Rect of me into cRect
         ring_ClearThings
         -- _RedrawMarkers
         LayoutControl cRect
         break
      default
         put the circle_Rect of me into cRect
         put _RingMarkerScale() into sScale
         ring_ClearThings
         _RedrawMarkers sScale, vName
         LayoutControl cRect
   end switch
   unlock screen
end marker_Views

getprop person_Graphic
   if the short name of the owner of the target = "People" then
      return the long id of the target
   else
      return empty
   end if
end person_Graphic

setprop people_Props [pName] pValue
   put _PeopleGroup() into pGroup
   lock screen
   repeat with cNum = the number of controls of pGroup down to 1
      set the pName of control cNum of pGroup to pValue
   end repeat
   unlock screen
   return pGroup
end people_Props

getprop ring_ThingNums
   put _PeopleGroup() into mGroup
   repeat with gNum = the number of controls of mGroup down to 1
      put gNum & comma after thingNums
   end repeat
   delete char -1 of thingNums
   return thingNums
end ring_ThingNums


--> Events | Custom
-
command LayoutControl pRect
   if the constrain_Circle of me is false then
      put _LayoutRect (pRect) into sRect
   else
      put _LayoutSquareRect (pRect) into sRect
   end if
   put _RingMarkerScale() into ringMarkerScale
   put _MarkerWidth (sRect, ringMarkerScale) into markerWidth
   
   lock screen
   --
   _ResizeRing sRect
   put the result into ringMarkerPoints
   _RecreateMarkers ringMarkerPoints, markerWidth
   --
   set the rect of _CircleGraphic() to sRect
   unlock screen
end LayoutControl


--> Events
-
on resizeControl
   put the rect of me into pRect
   LayoutControl pRect
end resizeControl

on mouseDown
   switch
      case the short name of the target = "Core"
         menu_PopUp "Global | Multichain | Layer | Menu"
         break
      case the short name of the owner of the target = "People"
         menu_PopUp "Global | Governance | Person | Graphic | Menu"
         break
      default
         --
   end switch
end mouseDown

on preOpenControl
   put the default_Array ["ring_NumberOfPoints"] of me into ringNumberOfPoints
   if ringNumberOfPoints is not a number then put 12 into ringNumberOfPoints
   put ringNumberOfPoints into LocalArray ["numberOfPoints"]
   --
   put the default_Array ["ring_Width"] of me into ringWidth
   if ringWidth is not a number then put 0 into ringWidth
   put ringWidth into LocalArray ["ringWidth"]
   --
   LayoutControl
   -- pass preOpenControl
end preOpenControl


--> Props | Marker
-
getprop ring_Width [realWidth]
   if realWidth is true then
      return _RealRingWidth()
   else
      return LocalArray ["ringWidth"]
   end if
end ring_Width

setprop ring_Width ringWidth
   put _ForceRingGraphic() into ringGraphic
   put ringWidth into LocalArray ["ringWidth"]
   --
   lock screen
   put _LayoutSquareRect() into oRect
   --  put the rect of me into oRect
   -- put the rect of _CircleGraphic() into innerCircleRect
   put _GetInnerCircleRect (ringWidth, oRect) into innerCircleRect
   --
   set the rect of ringGraphic to innerCircleRect
   -- set the rect of me to oRect
   LayoutControl oRect
   unlock screen
   return innerCircleRect
end ring_Width

getprop ring_NumberOfPoints
   put LocalArray ["numberOfPoints"] into numberOfPoints
   if numberOfPoints is a number then return numberOfPoints
   
   put  _CalculateRingGraphicPoints() into numberOfPoints
   if numberOfPoints is a number then
      put numberOfPoints into LocalArray ["numberOfPoints"]
      return numberOfPoints
   end if
   
   put 12 into LocalArray ["numberOfPoints"]
   return 12
end ring_NumberOfPoints

setprop ring_NumberOfPoints [pStartAngle] numberOfPoints
   put _ForceRingGraphic() into ringGraphic
   put numberOfPoints into LocalArray ["numberOfPoints"]
   put pStartAngle into LocalArray ["ring_Angle"]
   
   if numberOfPoints = 0 then
      set the style of ringGraphic to "oval"
      return empty
   else
      -- put the rect of me into oRect
      put _LayoutSquareRect() into oRect
      put the inner_Radius of ringGraphic into sRadius
      put the loc of ringGraphic into cCentre
      --
      lock screen
      ring_ClearThings
      set the style of ringGraphic to "polygon"
      put circle_ListPoints (numberOfPoints, sRadius, cCentre, pStartAngle) into sPoints
      set the Points of ringGraphic to sPoints
      --
      LayoutControl oRect
      unlock screen
      return sPoints
   end if
end ring_NumberOfPoints

getprop ring_MarkerScale
   return _RingMarkerScale()
end ring_MarkerScale

setprop ring_MarkerScale sScale
   put sScale into LocalArray ["ring_MarkerScale"]
   _RedrawMarkers sScale
   return the result
end ring_MarkerScale

private function _RingMarkerScale
   put LocalArray ["ring_MarkerScale"] into ringMarkerScale
   if ringMarkerScale is a number then
      return ringMarkerScale
   else
      return 1
   end if
end _RingMarkerScale

private function _MarkerWidth squareRect, ringMarkerScale
   put item 3 of squareRect - item 1 of squareRect into squareW
   put ringMarkerScale * squareW / 11.727273 into ringMarkerWidth
   return ringMarkerWidth
end _MarkerWidth

private function _SquareRect
   put the rect of me into pRect
   put the margins of me into sMargins
   put rect_GetSquare (pRect, sMargins) into squareRect
   return squareRect
end _SquareRect

getprop ring_MarkerRect [pointNum]
   put _SquareRect() into squareRect
   put _RingMarkerScale() into markerScale
   put _MarkerWidth (squareRect, markerScale) into markerWidth
   put the ring_GraphicPoints [true] of me into ringPoints
   --
   put line pointNum of ringPoints into ringPoint
   put rect_LocWidthHeight (ringPoint, markerWidth) into markerRect
   return markerRect
end ring_MarkerRect

getprop ring_MarkerWidth [pRect]
   if pRect is empty then put the rect of me into pRect
   put the margins of me into sMargins
   put rect_GetSquare (pRect, sMargins) into squareRect
   put _RingMarkerScale() into markerScale
   put _MarkerWidth (squareRect, markerScale) into markerWidth
   return markerWidth
end ring_MarkerWidth

getprop show_Markers
   return the visible of _PeopleGroup()
end show_Markers

setprop show_Markers sBoolean
   set the visible of _PeopleGroup() to sBoolean
end show_Markers


--> Circle | Create
-
command ring_ClearThings
   put _PeopleGroup() into mGroup
   --
   lock screen
   repeat with gNum = the number of controls of mGroup down to 1
      delete control gNum of mGroup
   end repeat
   unlock screen
end ring_ClearThings

private command _RedrawMarkers sScale, pViewName
   put _SquareRect() into squareRect
   put the ring_GraphicPoints [true] of me into ringPoints
   put _MarkerWidth (squareRect, sScale) into ringMarkerWidth
   _RecreateMarkers ringPoints, ringMarkerWidth, pViewName
   return ringPoints
end _RedrawMarkers

command _RecreateMarkers ringPoints, pMarkerWidth, pViewName
   if pMarkerWidth is empty then put 22 into pMarkerWidth
   put _PeopleGroup() into mGroup
   --   
   repeat with pointNum = 1 to the number of lines of ringPoints
      put line pointNum of ringPoints into ringPoint
      put rect_LocWidthHeight (ringPoint, pMarkerWidth) into pointRect
      --
      switch pViewName
         case empty
         case "graphic"
            _CreateMarkerGraphic pointNum, pointRect, mGroup
            put the result into createdObject
            break
         default
            put view_GetTemplateObject (pViewName) into vObject
            view_InsertObject vObject, mGroup, pointRect
            put the result into createdObject
            --
            put "Person" && pointNum into pName
            set the name of createdObject to pName
      end switch
      --
      put createdObject & CR after createdObjects
   end repeat
   delete char -1 of createdObjects
   return createdObjects
end _RecreateMarkers

command _CreateMarkerGraphic pointNum, pointRect, mGroup
   put "Person" && pointNum into pName
   if exists (control pName of mGroup) then
      put the long id of control pName of mGroup into mControl
      set the rect of mControl to pointRect
      return mControl
   end if
   --
   set the style of the templategraphic to "oval"
   set the lineSize of the templategraphic to 1
   set the rect of the templategraphic to pointRect
   set the backgroundcolor of the templategraphic to ""
   set the opaque of the templategraphic to true
   --
   create graphic pName in mGroup
   choose browse tool
   return it
end _CreateMarkerGraphic

private function _MarkerRect pointNum, mWidth
   if mWidth is empty then put 22 into mWidth
   put _InnerRingPoint (pointNum) into pointCentre
   put rect_LocWidthHeight (pointCentre, mWidth) into pointRect
   return pointRect
end _MarkerRect

setprop create_RingThing [mWidth] pointNum
   put _PeopleGroup() into mGroup
   --
   put _MarkerRect (pointNum, mWidth) into pointRect
   _CreateMarkerGraphic pointNum, pointRect, mGroup
   put the result into createdObject
   
   -- set the rect of createdObject to pointRect
   -- view_Insert "View|Governance|Person", mGroup, pointRect, pName
   -- put the result into createdObject
   --
   return createdObject
end create_RingThing

private function _ForceRingGraphic pCircleName, pRect
   if exists (graphic pCircleName of me) is false then
      put LocalArray ["ringWidth"] into ringWidth
      _CreateRingGraphic ringWidth, pRect
   end if
   return _RingGraphic()
end _ForceRingGraphic


--> Defaults
-
getprop default_Array [propName]
   put the rect_Array of me into rectArray
   if propName is empty then return rectArray
   
   put rectArray ["view"][propName] into propValue
   return propValue
end default_Array

getprop ring_GraphicPoints [pRemoveEnd]
   put _RingGraphic() into ringGraphic
   if ringGraphic is empty then return empty
   if the ring_Style of me is not "polygon" then return empty
   
   put the effective points of ringGraphic into ringPoints
   if pRemoveEnd is true then
      delete line -1 of ringPoints
   end if
   return ringPoints
end ring_GraphicPoints


--> Props | Colour
-
getprop ring_MarkerFilled
   if _RingExists() is false then return false
   put the markerFilled of _RingGraphic() into sBoolean
   return sBoolean
end ring_MarkerFilled

setprop ring_MarkerFilled sBoolean
   if _RingExists() is false then return false
   put _RingGraphic() into ringGraphic
   set the markerFilled of ringGraphic to sBoolean
   return ringGraphic
end ring_MarkerFilled

getprop ring_MarkerDrawn
   if _RingExists() is false then return false
   put the markerDrawn of _RingGraphic() into sBoolean
   return sBoolean
end ring_MarkerDrawn

setprop ring_MarkerDrawn sBoolean
   if _RingExists() is false then return false
   put _RingGraphic() into ringGraphic
   set the markerDrawn of ringGraphic to sBoolean
   return ringGraphic
end ring_MarkerDrawn

getprop ring_MarkerColour
   if _RingExists() is false then return false
   put the bordercolor of _RingGraphic() into sColour
   return sColour
end ring_MarkerColour

setprop ring_MarkerColour sColour
   if _RingExists() is false then return false
   put _RingGraphic() into ringGraphic
   set the bordercolor of ringGraphic to sColour
   return ringGraphic
end ring_MarkerColour

getprop ring_MarkerBorderColour
   if _RingExists() is false then return false
   put the hilitecolor of _RingGraphic() into sColour
   return sColour
end ring_MarkerBorderColour

setprop ring_MarkerBorderColour sColour
   if _RingExists() is false then return false
   put _RingGraphic() into ringGraphic
   set the hilitecolor of ringGraphic to sColour
   return ringGraphic
end ring_MarkerBorderColour

getprop ring_BorderColour
   if _RingExists() is false then return false
   put the foregroundcolor of _RingGraphic() into sColour
   return sColour
end ring_BorderColour

setprop ring_BorderColour sColour
   if _RingExists() is false then return false
   put _RingGraphic() into ringGraphic
   set the foregroundcolor of ringGraphic to sColour
   return ringGraphic
end ring_BorderColour

getprop ring_FillColour
   if _RingExists() is false then return false
   put the backgroundcolor of _RingGraphic() into sColour
   return sColour
end ring_FillColour

setprop ring_FillColour sColour
   if _RingExists() is false then return false
   put _RingGraphic() into ringGraphic
   set the backgroundcolor of ringGraphic to sColour
   return ringGraphic
end ring_FillColour

getprop ring_Colour
   if _RingExists() is false then return false
   put the foregroundcolor of _RingGraphic() into sColour
   return sColour
end ring_Colour

setprop ring_Colour sColour
   if _RingExists() is false then return false
   put _RingGraphic() into ringGraphic
   --
   set the opaque of _RingGraphic() to false
   set the ring_ShowLines of me to false
   --
   set the foregroundcolor of ringGraphic to sColour
   return ringGraphic
end ring_Colour

getprop oval_Colour
   put the foregroundcolor of _CircleGraphic() into sColour
   return sColour
end oval_Colour

setprop oval_Colour sColour
   put _CircleGraphic() into cGraphic
   --
   set the opaque of cGraphic to false
   set the ring_ShowLines of me to false
   set the foregroundcolor of cGraphic to sColour
   return ringGraphic
end oval_Colour


getprop oval_LineSize
   return the lineSize of _CircleGraphic()
end oval_LineSize

setprop oval_LineSize sLineSize
   if _RingExists() is false then return false
   put _CircleGraphic() into cGraphic
   set the lineSize of cGraphic to sLineSize
   return cGraphic
end oval_LineSize

getprop ring_LineSize
   if _RingExists() is false then return false
   return the lineSize of _RingGraphic()
end ring_LineSize

setprop ring_LineSize sLineSize
   if _RingExists() is false then return false
   if sLineSize = 0 then
      lock screen
      set the lineSize of _RingGraphic() to 0
      set the opaque of _RingGraphic() to false
      unlock screen
   else
      set the lineSize of _RingGraphic() to sLineSize
   end if
   return true
end ring_LineSize

getprop ring_ShowLines
   if _RingExists() is false then return false
   
   put the lineSize of _RingGraphic() > 0 into lineShowing
   return lineShowing
end ring_ShowLines

setprop ring_ShowLines isShowing
   if _RingExists() is false then return false
   if isShowing is true then
      set the lineSize of _RingGraphic() to 1
   else
      lock screen
      set the lineSize of _RingGraphic() to 0
      set the opaque of _RingGraphic() to false
      unlock screen
   end if
   return true
end ring_ShowLines


--> Props
-
getprop show_Ring
   if _RingExists() is false then return false
   
   put the visible of _RingGraphic() into isShowing
   return isShowing
end show_Ring

setprop show_Ring isShowing
   if _RingExists() is false then return false
   set the visible of _RingGraphic() to isShowing
   return true
end show_Ring

getprop ring_IsOpaque
   if _RingExists() is false then return false
   put the opaque of _RingGraphic() into sBoolean
   return sBoolean
end ring_IsOpaque

setprop ring_IsOpaque sBoolean
   if _RingExists() is false then return false
   put _RingGraphic() into ringGraphic
   set the opaque of ringGraphic to sBoolean
   return ringGraphic
end ring_IsOpaque

getprop ring_Style
   if _RingExists() is false then return empty
   put _RingGraphic() into ringGraphic
   return the style of ringGraphic
end ring_Style

setprop ring_Style sStyle
   if _RingExists() is false then return empty
   put _RingGraphic() into ringGraphic
   set the style of ringGraphic to sStyle
end ring_Style

setprop ring_MarkerStyle [mWidth] mStyle
   if mWidth is empty then put 10 into mWidth
   --
   switch mStyle
      case "circle"
      default
         put circle_ListPoints (36, mWidth) into sMarkerPoints
   end switch
   --
   put _RingGraphic() into rGraphic
   set the markerPoints of rGraphic to sMarkerPoints
   set the markerdrawn of rGraphic to true
   return sMarkerPoints
end ring_MarkerStyle


--> Props | Rect
-
getprop inner_Radius [pRect]
   if pRect is empty then put the rect of me into pRect
   put _GetCircleRadius (pRect) into sRadius
   return sRadius
end inner_Radius

getprop mid_Radius
   put _RingGraphic() into ringGraphic
   if exissts (ringGraphic) is false then return empty
   
   put the width of _CircleGraphic() into circleWidth
   put the width of ringGraphic into innerWidth
   --
   put innerWidth + (circleWidth - innerWidth)/4 into midRadius
   return midRadius
end mid_Radius

getprop circle_Rect
   return the rect of _CircleGraphic()
end circle_Rect

setprop circle_Rect [pRingH] squareRect
   set the rect of _CircleGraphic() to squareRect
end circle_Rect


--> Geometry | Circle
-
function circle_ListPoints pointNum, sRadius, pCentreLoc, pStartAngle
   put 2 * pi / pointNum into stepAngle
   put item 1 of pCentreLoc into centreX
   put item 2 of pCentreLoc into centreY
   repeat with sI = 1 to pointNum
      put stepAngle * (sI - 1) into someAngle
      add pStartAngle to someAngle
      --
      put sRadius * sin (someAngle) into sXCoord
      put sRadius * cos (someAngle) into sYCoord
      put centreX + sXCoord into xCoord
      put centreY + sYCoord into yCoord
      put xCoord & "," & yCoord & CR after sPoints
   end repeat
   return sPoints
end circle_ListPoints

-- function circle_ListPoints pointNum, sRadius, pCentreLoc
put 2 * pi / pointNum into sAngle
put item 1 of pCentreLoc into centreX
put item 2 of pCentreLoc into centreY
repeat with sI = 1 to pointNum
   put sRadius * sin(sAngle * (sI - 1)) into sXCoord
   put sRadius * cos(sAngle * (sI - 1)) into sYCoord
   put centreX + sXCoord into xCoord
   put centreY + sYCoord into yCoord
   put xCoord & "," & yCoord & CR after sPoints
end repeat
return sPoints
end circle_ListPoints

function spiro_ListPoints pointNum, sRadius
   put 360 / pointNum into sAngle
   repeat with sI = 1 to pointNum
      put sRadius * sin (sAngle * (sI - 1)) into sXCoord
      put sRadius * cos (sAngle * (sI - 1)) into sYCoord
      put sXCoord & "," & sYCoord & CR after sPoints
   end repeat
   delete char -1 of sPoints
   return sPoints
end spiro_ListPoints


--> Private | Geometry
-
private function _CalculateRingGraphicPoints
   put the ring_GraphicPoints [true] of me into innerPoints
   return the number of lines of innerPoints
end _CalculateRingGraphicPoints

private function _GetCircleRadius squareRect
   put LocalArray ["ringWidth"] into ringWidth
   put item 3 of squareRect - item 1 of squareRect into circleWidth
   put circleWidth/2 - ringWidth into sRadius
   return sRadius
end _GetCircleRadius

private function _GetInnerCircleRect ringWidth, pRect
   if pRect is empty then put the rect of me into pRect
   --
   put rect_SimpleSubtract (pRect, ringWidth) into innerCircleRect
   return innerCircleRect
end _GetInnerCircleRect

private function _RealRingWidth
   if _RingExists() is false then return empty
   
   put the width of _RingGraphic() into innerWidth
   put the width of _CircleGraphic() into circleWidth
   --
   put (circleWidth - innerWidth)/2 into ringWidth
   return ringWidth
end _RealRingWidth

private command _CreateRingGraphic ringWidth, pRect
   put _RingGraphic() into ringGraphic
   if ringGraphic is empty then
      put _GetInnerCircleRect (ringWidth, pRect) into innerCircleRect
      --
      set the style of templategraphic to oval
      set the rect of templategraphic to innerCircleRect
      --
      create graphic "Inner Circle" in me
      put it into ringGraphic
   end if
   --
   return ringGraphic
end _CreateRingGraphic

command _ResizeRing squareRect
   if _RingExists() then
      put LocalArray ["numberOfPoints"] into numberOfPoints
      put LocalArray ["ring_Angle"] into pStartAngle
      put _CalculateRingPoints (squareRect, numberOfPoints, pStartAngle) into ringPoints
      --
      set the points of _RingGraphic() to ringPoints
   end if
   return ringPoints
end _ResizeRing

private function _CalculateRingPoints squareRect, numberOfPoints, pStartAngle
   put _GetCircleRadius (squareRect) into sRadius
   put rect_GetCentre (squareRect) into cCentre
   put circle_ListPoints (numberOfPoints, sRadius, cCentre, pStartAngle) into sPoints
   return sPoints
end _CalculateRingPoints

private function _InnerRingPoint pointNum
   put the ring_GraphicPoints [pointNum] of me into ringPoints
   put line pointNum of ringPoints into ringPoint
   return ringPoint
end _InnerRingPoint


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

function rect_LocWidthHeight someLoc, newW, pNewH
   if pNewH is empty then put newW into pNewH
   --
   put newW/2 into leftBit
   put newW - leftBit into rightBit
   put item 1 of someLoc into someX
   put someX - leftBit into item 1 of someRect
   put someX + rightBit into item 3 of someRect
   
   put pNewH/2 into upBit
   put pNewH - upBit into downBit
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

function rect_SimpleSubtract someRect, sNum
   add sNum to item 1 of someRect
   add sNum to item 2 of someRect
   subtract sNum from item 3 of someRect
   subtract sNum from item 4 of someRect
   --
   return someRect
end rect_SimpleSubtract

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
getprop circle_View
   return the long id of me
end circle_View

getprop circle_Graphic
   return _CircleGraphic()
end circle_Graphic

getprop ring_Graphic
   return _RingGraphic ("Inner Circle")
end ring_Graphic

getprop people_Group
   return _PeopleGroup()
end people_Group

getprop view_Object
   return the long id of me
end view_Object


--> Object | Utils
-
private function _RingExists
   return exists (graphic 2 of me)
   return exists (graphic "Inner Circle" of me)
end _RingExists

private function _RingGraphic pCircleName
   -- default no longer has to be called "Inner Circle"
   -- if pCircleName is empty then put 2 into pCircleName
   if pCircleName is empty then put "Inner Circle" into pCircleName
   if exists (graphic pCircleName of me) is false then return empty
   put the long id of graphic pCircleName of me into ringGraphic
   -- get the name of ringGraphic
   return ringGraphic
end _RingGraphic

private function _CircleGraphic
   -- put the long id of grc 1 of me into circleGraphic
   put the long id of grc "Circle" of me into circleGraphic
   return circleGraphic
end _CircleGraphic

private function _PeopleGroup
   if exists (group 1 of me) is false then
      create group "People" in me
      put it into markerGroup
   else 
      put the long id of group 1 of me into markerGroup
   end if
   return markerGroup
end _PeopleGroup

