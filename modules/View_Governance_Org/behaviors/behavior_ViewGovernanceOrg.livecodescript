script "behavior_ViewGovernanceOrg"
--> MetaData
-
license: GPLv3
name: behavior_ViewGovernanceOrg
type: behavior
version: 0.1


--> Variables
-
local LocalArray


--> Working on
-
private command _CreateControlObject someName, eRect, someColour, cType
   lock screen
   put the short id of me into groupID
   create_Placeholder someName, eRect, groupID, someColour
   put the result into someControl
   -- 
   if cType is not empty then
      set the control_Type of someControl to cType
      put the result into someControl
   else
      set the showname of someControl to false
      set the showborder of someControl to false
   end if
   unlock screen
   return someControl
end _CreateControlObject

setprop element_Array [tilesAcross] eArray
   lock screen
   put _AllElementViews() into allIDs
   repeat for each key itemNum in eArray 
      put eArray [itemNum] into cPropArray
      --
      put _ControlFromArray (cPropArray) into someControl
      if exists (someControl) is false then
         _CreateControlFromArray cPropArray
         put the result into someControl
      end if
      put the short id of someControl into usedID
      put usedID into eArray [itemNum]["element id"]
      put lineoffset (usedID, allIDs) into lineNum
      delete line lineNum of allIDs 
      --
      put cPropArray ["control_Type"] into cType
      if cType is not empty then
         -- need to do this first
         set the control_Type of someControl to cType
         put the result into someControl
         delete variable cPropArray ["control_Type"]
      end if
      --
      repeat for each key propName in cPropArray
         if the number of words of propName > 1 then
            -- "element id"
            next repeat
         end if
         
         put cPropArray [propName] into propValue
         set the propName of someControl to propValue
      end repeat
      -- _AutoSetShowName someControl
   end repeat
   --
   put tilesAcross into LocalArray ["tiles_Across"]
   put eArray into LocalArray ["eArray"]
   --
   repeat for each line badID in allIDs
      delete control id badID of me
   end repeat
   LayoutControl -- not sure why this is needed
   unlock screen
   return eArray
end element_Array

getprop square_Rect [sMargin]
   put the rect of me into someRect
   put rect_GetSquare (someRect, sMargin) into squareRect
   return squareRect
end square_Rect

setprop tile_Rect [tilesAcross] tileRect
   put the long id of the target into tObject
   if word 1 of tObject is not "graphic" then
      return empty
   end if
   
   put the square_Rect of me into squareRect
   put _ElementRect (tileRect, squareRect, tilesAcross) into someRect
   lock screen
   set the style of the target to rectangle
   set the rect of the target to someRect
   unlock screen
   return someRect
end tile_Rect

command _AutoSetShowNames
   put _CheckAllVisible() into someBoolean
   set the show_Names of me to someBoolean
end _AutoSetShowNames

getprop all_Visible
   return _CheckAllVisible()
end all_Visible

function _NoGraphicsVisible
   put the childControlIDs of me into allIDs
   repeat for each line cID in allIDs
      put the long id of control id cID of me into someControl
      put _CheckShowName (someControl) into someBoolean
      if someBoolean is false then
         return false 
      end if
   end repeat
   return true
end _NoGraphicsVisible

function _CheckAllVisible
   put _threeTitleViews() into buttonViews
   repeat for each line someControl in buttonViews
      put _CheckShowName (someControl) into someBoolean
      if someBoolean is false then
         return false 
      end if
   end repeat
   return true
end _CheckAllVisible

private function _CheckShowName someControl
   put 8 into someSpace
   --
   put the width of someControl into eWidth
   try
      put the formattedwidth of someControl into fWidth
      put eWidth > (fWidth + someSpace) into someBoolean
   catch e
      -- bug: when trying to get formattedwidth of a graphic
      put true into someBoolean
   end try
   --
   return someBoolean
end _CheckShowName

command _AutoSetShowName someControl
   put _CheckShowName (someControl) into someBoolean
   set the showname of someControl to someBoolean
end _AutoSetShowName

function grid_ConstructRectArray squareRect, nWidth, gridNum
   put item 1 of squareRect into squareLeft
   put item 2 of squareRect into squareTop
   put 1 into nNum
   put gridNum ^ 0.5 into rowNum
   repeat with yNum = 1 to rowNum
      put nWidth * yNum into nBottom
      put squareTop + nBottom into item 4 of nRect
      put squareTop + nBottom - nWidth into item 2 of nRect
      repeat with xNum = 1 to rowNum
         put nWidth * xNum into nRight
         put squareLeft + nRight into item 3 of nRect
         put squareLeft + nRight - nWidth into item 1 of nRect
         
         put nRect into rectArray [nNum]
         add 1 to nNum
      end repeat
   end repeat
   return rectArray
end grid_ConstructRectArray

getprop grid_Array
   put the tiles_Across of me into tilesAcross
   put the group_InnerRect of me into innerRect
   put item 3 of innerRect - item 1 of innerRect into sWidth
   put trunc (sWidth / tilesAcross) into tileWidth
   
   put 0 into x
   put 0 into y
   put item 1 of innerRect into startX
   put item 2 of innerRect into startY
   
   put startX,startY into gridArray [x,y]
   put item 3 to 4 of innerRect into gridArray [tilesAcross,tilesAcross]
   repeat tilesAcross
      add 1 to x
      repeat tilesAcross
         add 1 to y
         --
         put grid_GetLoc (x, y, tileWidth, startX, startY) into someLoc
         put someLoc into gridArray [x,y]
      end repeat
   end repeat
   
   return gridArray
end grid_Array

getprop grid_RectArray
   put the grid_Num of me into gridNum
   
   put the square_Rect of me into squareRect
   
   /*
   put the group_InnerRect of me into innerRect
   calculate_SquareRect innerRect, squareRect, squareCentre, squareWidth, halfSquareWidth
   */
   
   -- here we seem to tweak the square rect ???
   put gridNum ^ 0.5 into rowNum
   put squareWidth/rowNum into nWidth
   
   -- put trunc (nWidth) into nWidth
   -- put nWidth * rowNum into squareWidth
   -- put rect_LocWidthHeight (squareCentre, squareWidth, squareWidth) into squareRect
   
   
   put grid_ConstructRectArray (squareRect, nWidth, gridNum) into rectArray
   return rectArray
end grid_RectArray


--> Props
-
getprop fixed_Square
   return LocalArray ["fixed_Square"] is true
end fixed_Square

setprop fixed_Square someBoolean
   put someBoolean is true into someBoolean
   put someBoolean into LocalArray ["fixed_Square"]
   LayoutControl
end fixed_Square

getprop show_Names
   return LocalArray ["show_Names"] is true
end show_Names

setprop show_Names someBoolean
   put someBoolean is true into someBoolean
   put someBoolean into LocalArray ["show_Names"]
   put _threeTitleViews() into buttonViews
   --
   lock screen
   repeat for each line someControl in buttonViews
      set the showname of someControl to someBoolean
   end repeat
   unlock screen
end show_Names

getprop show_Borders
   return LocalArray ["show_Borders"] is true
end show_Borders

setprop show_Borders someBoolean
   put someBoolean is true into someBoolean
   put someBoolean into LocalArray ["show_Borders"]
   put _AllElementViews() into allIDs
   lock screen
   repeat for each line childID in allIDs
      set the showborder of control id childID of me to someBoolean
   end repeat
   unlock screen
end show_Borders

getprop group_InnerRect [rectBounds]
   put the long id of the target into targetGroup
   if rectBounds is empty then put the rect of targetGroup into rectBounds
   
   put the margins of targetGroup into someMargins
   if the showborder of targetGroup is true then
      put the borderwidth of targetGroup into bWidth
      repeat with itemNum = 1 to the number of items of someMargins
         add bWidth to item itemNum of someMargins
      end repeat
   end if
   rect_SubtractMargins rectBounds, someMargins
   return rectBounds
end group_InnerRect

getprop grid_OuterMargin
   return the margins of me
end grid_OuterMargin

setprop grid_OuterMargin someMargins
   lock screen
   put the rect of me into oRect
   set the margins of me to someMargins
   LayoutControl oRect
   unlock screen
end grid_OuterMargin


--> Button View
-
getprop button_View
   put _btnView() into btnView
   return btnView
end button_View
   
setprop button_View someBoolean
   put _btnView() into btnView
   set the visible of btnView to someBoolean
end button_View

function _btnView
   put "Button View" into btnName
   --
   if exists (btn btnName of me) is true then
      put the long id of btn btnName of me into btnView
   else
      put the inner_Rect of me into innerRect
      set the rect of the templatebutton to innerRect
      set the style of the templatebutton to transparent
      set the borderwidth of the templatebutton to 1
      set the threeD of the templatebutton to false
      set the showFocusBorder of the templatebutton to false
      set the showborder of the templatebutton to false
      set the showname of the templatebutton to false
      --
      create button btnName in me
      put it into btnView
   end if
   return btnView
end _btnView


--> All Views
-
function _threeTitleViews
   put the long id of control "Guardians" of me into threeTitleViews
   put CR & the long id of control "Journals" of me after threeTitleViews
   put CR & the long id of control "Ecosystem" of me after threeTitleViews
   return threeTitleViews
end _threeTitleViews

function _AllButtonViews
   put _AllElementViews() into allElementViews
   repeat for each line childID in allElementViews
      put the long id of control id childID into someControl
      switch word 1 of someControl
         case "graphic"
            next repeat
         default
            put someControl & CR after buttonViews
      end switch
   end repeat
   delete char -1 of buttonViews
   return buttonViews
end _AllButtonViews

function _AllElementViews
   put the childControlIDs of me into allIDs
   put _btnView() into btnView
   put the short id of btnView into btnID
   put lineoffset (btnID, allIDs) into lineNum
   delete line lineNum of allIDs 
   return allIDs
end _AllElementViews


--> Controls
-
getprop grid_View
   return the long id of me
end grid_View

getprop layout_View
   return the long id of me
end layout_View

getprop view_Object
   return the long id of me
end view_Object


--> Children
-
getprop grid_Control [gridNum]
   put _getGridControl (gridNum) into gridControl
   return gridControl
end grid_Control

getprop tile_View [gridNum]
   put _getGridControl (gridNum) into gridControl
   put the view_Name of gridControl into vName
   return vName
end tile_View

setprop tile_View [gridNum] vName
   put _getGridControl (gridNum) into gridControl
   set the control_Type of gridControl to vName
end tile_View


--> Private | Objects
-
private function _ControlFromArray cPropArray
   put cPropArray ["element id"] into elementID  
   if exists (control id elementID of me) is true then
      put the long id of control id elementID into cObject
      return cObject
   end if
   
   put cPropArray ["name"] into elementName
   put the top_Control [elementName] of me into cObject
   return cObject
   
   /*
   -- this also detects named objects deeper in hierarchy
   if exists (control elementName of me) is true then
      put the long id of control elementName of me into cObject
      return cObject
   end if
   return empty
   */
end _ControlFromArray

private function _GetControlObject someName, eRect, someColour
   -- don't create if a control of that name already exists
   if exists (control someName of me) then
      put the long id of control someName of me into someControl
   else
      _CreateControlObject someName, eRect, someColour
      put the result into someControl
   end if
   return someControl
end _GetControlObject

private command _CreateControlFromArray cPropArray, pTilesAcross
   put cPropArray ["name"] into someName
   put cPropArray ["backgroundcolor"] into someColour
   put cPropArray ["tile_Rect"] into tileRect
   put cPropArray ["control_Type"] into cType
   --
   put the square_Rect of me into squareRect
   put _ElementRect (tileRect, squareRect, pTilesAcross) into eRect
   --
   _CreateControlObject someName, eRect, someColour, cType
   put the result into someControl
   return someControl
end _CreateControlFromArray
   

--> Props
-
getprop tiles_Across
   put LocalArray ["tiles_Across"] into tilesAcross
   if tilesAcross is not a number then
      put _defaultTilesAcross() into tilesAcross
      put tilesAcross into LocalArray ["tiles_Across"]
   end if
   return tilesAcross
end tiles_Across

setprop tiles_Across tilesAcross
   put tilesAcross ^ 2 into gridNum
   _setGridNum gridNum
end tiles_Across

getprop grid_Num   
   put the tiles_Across of me into tilesAcross
   return tilesAcross ^ 2
end grid_Num

setprop grid_Num gridNum
   _setGridNum gridNum
end grid_Num

private command _setGridNum gridNum
   lock screen
   --
   put gridNum ^ 0.5 into tilesAcross
   if tilesAcross is not an integer then return empty
   
   put tilesAcross into LocalArray ["tiles_Across"]
   put _AllElementViews() into childIDs
   put the number of lines of childIDs into oldGridNum -- more robust
   
   put the rect of me into oRect
   switch
      case oldGridNum > gridNum
         -- delete the ones at the end
         repeat with lineNum = (gridNum + 1) to oldGridNum
            put line lineNum of childIDs into childID
            delete control id childID
         end repeat
         break
      case gridNum > oldGridNum
         -- add new ones to the end
         put the short id of me into groupID
         put the rect of me into someRect
         repeat with childNum = (oldGridNum + 1) to gridNum
            put "n" & childNum into someName
            create_PlaceHolder someName, someRect, groupID
            put the result into someControl
            --
            set the showborder of someControl to false
            set the showname of someControl to false
         end repeat
         break
      default -- oldGridNum = gridNum
         -- do nothing
   end switch
   LayoutControl oRect
   --
   unlock screen
   return gridNum
end _setGridNum


--> Events
-
on resizeControl
   put the rect of me into pRect
   LayoutControl pRect
end resizeControl

on LayoutControl pRect
   lock screen
   local squareRect, squareCentre, squareWidth, halfSquareWidth, pSquareMargin
   if pRect is empty then put the rect of me into pRect
   -- test_Rect pRect, "pRect"
   
   -- put the group_InnerRect [pRect] of me into innerRect
   -- test_Rect innerRect, "innerRect"
   
   put the grid_Num of me into gridNum
   put the square_Rect of me into squareRect
   -- calculate_SquareRect pRect, squareRect, squareCentre, squareWidth, halfSquareWidth, pSquareMargin
   -- test_Rect squareRect, "squareRect"
   
   if the fixed_Square of me is true then
      set the rect of me to squareRect -- this now another resizeControl event
   end if
   -- put LocalArray ["total"] + 1 into LocalArray ["total"]
   
   put LocalArray ["eArray"] into eArray
   put LocalArray ["tiles_Across"] into tilesAcross
   
   repeat for each key childNum in eArray
      put eArray [childNum] into cPropArray
      put _ControlFromArray (cPropArray) into someControl
      if exists (someControl) is false then
         next repeat
      end if
      
      put cPropArray ["tile_Rect"] into tileRect
      put cPropArray ["tile_Points"] into tilePoints
      switch
         case tilePoints is not empty
            set the tile_Points of someControl to tilePoints
            break
         case tileRect is a rectangle -- quick check
            put _ElementRect (tileRect, squareRect, tilesAcross) into childRect
            set the rect of someControl to childRect
            -- if cPropArray ["showname"] is empty then _AutoSetShowName someControl
            break
         default
            -- do nothing
      end switch
   end repeat
   
   put _btnView() into btnView
   put the inner_Rect of me into innerRect
   set the rect of btnView to innerRect
   --
   _AutoSetShowNames
   --
   unlock screen
   -- return LocalArray ["total"]
end LayoutControl


--> Geometry
-
setprop tile_Points [tilesAcross] tilePoints
   replace "|" with CR in tilePoints
   put the long id of the target into graphicObject
   if word 1 of graphicObject is not "graphic" then
      -- could convert
      return empty
   end if
   --
   set the style of graphicObject to polygon
   --
   put the square_Rect of me into squareRect
   put _ConvertTilePoints (tilePoints, squareRect, tilesAcross) into newPoints
   set the points of graphicObject to newPoints
   return newPoints
end tile_Points

private function _ConvertTilePoints tilePoints, squareRect, pTilesAcross
   _SetTileGeometry squareRect, tileWidth, startX, startY, pTilesAcross
   repeat for each line tilePoint in tilePoints
      put item 1 of tilePoint into pointX
      put item 2 of tilePoint into pointY
      put grid_GetLoc (pointX, pointY, tileWidth, startX, startY) into newPoint
      put newPoint & CR after newPoints
   end repeat
   delete char -1 of newPoints
   return newPoints
end _ConvertTilePoints

private function _ElementRect tileRect, squareRect, pTilesAcross
   _SetTileGeometry squareRect, tileWidth, startX, startY, pTilesAcross
   
   put item 1 of tileRect into tLeft
   put item 2 of tileRect into tBottom
   put grid_GetLoc (tLeft, tBottom, tileWidth, startX, startY) into eRect
   
   put item 3 of tileRect into tRight
   put item 4 of tileRect into tTop
   put grid_GetLoc (tRight, tTop, tileWidth, startX, startY) into item 3 of eRect
   --
   return eRect
end _ElementRect

private command _SetTileGeometry squareRect, @tileWidth, @startX, @startY, pTilesAcross
   if pTilesAcross is empty then
      put the tiles_Across of me into pTilesAcross
   end if
   put item 1 of squareRect into startX
   put item 2 of squareRect into startY
   put item 3 of squareRect - startX into sWidth
   put sWidth / pTilesAcross into tileWidth
   return tileWidth
end _SetTileGeometry

function grid_GetLoc x, y, tileWidth, startX, startY
   put startX + (x * tileWidth) into someX
   put startY + (y * tileWidth) into someY
   return someX,someY
end grid_GetLoc

function rect_GetSquare someRect, pSquareMargin
   local squareRect, squareCentre, squareWidth, halfSquareWidth
   calculate_SquareRect someRect, squareRect, squareCentre, squareWidth, halfSquareWidth, pSquareMargin
   return squareRect
end rect_GetSquare

command calculate_SquareRect pRect, @squareRect, @squareCentre, @squareWidth, @halfSquareWidth, pSquareMargin
   rect_ExtractDimensions pRect, someX, someY
   put min (someX, someY) into squareWidth
   put round ( squareWidth / 2 ) into halfSquareWidth
   put 2 * halfSquareWidth into squareWidth
   
   put rect_GetCentre (pRect) into squareCentre
   put rect_LocWidthHeight (squareCentre, squareWidth, squareWidth) into squareRect
   
   rect_SubtractMargins squareRect, pSquareMargin
   return squareRect
end calculate_SquareRect


--> Private
-
private function _defaultTilesAcross
   -- let's get a sensible default
   put the childControlIDs of me into childIDs
   put the number of lines of childIDs into gridNum
   
   put gridNum ^ 0.5 into tilesAcross
   if tilesAcross is not an integer then return 8
   return tilesAcross
end _defaultTilesAcross

private function _getGridControl gridNum
   put the childControlIDs of me into childIDs
   put line gridNum of childIDs into childID
   if childID is empty then return empty
   put the long id of control id childID of me into gridControl
   return gridControl
end _getGridControl


--> Deps
-
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

command rect_ExtractDimensions someRect, @someW, @someH
   put item 3 of someRect - item 1 of someRect into someW
   put item 4 of someRect - item 2 of someRect into someH
end rect_ExtractDimensions

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

function rect_LocWidthHeight someLoc, newW, newH
   put round(newW/2) into leftBit
   put newW - leftBit into rightBit
   put item 1 of someLoc into someX
   put someX - leftBit into item 1 of someRect
   put someX + rightBit into item 3 of someRect
   
   put round(newH/2) into upBit
   put newH - upBit into downBit
   put item 2 of someLoc into someY
   put someY - upBit into item 2 of someRect
   put someY + downBit into item 4 of someRect
   
   return someRect
end rect_LocWidthHeight


