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

getprop local_Array
   return LocalArray
end local_Array


--> Working on

function tile_GetRect tileRect, frameRect, tilesAcross, pTilesDown
   if pTilesDown is empty then put tilesAcross into pTilesDown
   
   put item 1 of frameRect into startX
   put item 2 of frameRect into startY
   put (item 3 of frameRect - startX) / tilesAcross into tileWidth
   
   put item 1 of tileRect into tLeft
   put item 2 of tileRect into tBottom
   put item 3 of tileRect into tRight
   put item 4 of tileRect into tTop
   
   put grid_GetLoc (tLeft, tBottom, startX, startY, tileWidth) into eRect
   put grid_GetLoc (tRight, tTop, startX, startY, tileWidth) into item 3 of eRect
   --
   return eRect
end tile_GetRect

-- function tile_GetRect tileRect, frameRect, tilesAcross, pTilesDown
   -- has been updated?
   if pTilesDown is empty then put tilesAcross into pTilesDown
   put item 1 of frameRect into startX
   put item 2 of frameRect into startY
   
   put (item 3 of frameRect - startX) / pTilesAcross into tileWidth
   
   put item 1 of tileRect into tLeft
   put item 2 of tileRect into tBottom
   put grid_GetLoc (tLeft, tBottom, startX, startY, tileWidth, tileHeight) into sRect
   
   put item 3 of tileRect into tRight
   put item 4 of tileRect into tTop
   put grid_GetLoc (tRight, tTop, startX, startY, tileWidth, tileHeight) into item 3 of sRect
   --
   return sRect
end tile_GetRect

function tile_GetAcross
   return 10
   --
   put LocalArray ["tiles_Across"] into tilesAcross
   return tilesAcross
end tile_GetAcross

getprop show_Names
   return LocalArray ["show_Names"] is true
end show_Names

setprop show_Names someBoolean
   put someBoolean is true into someBoolean
   put someBoolean into LocalArray ["show_Names"]
   put _NamedViews() into buttonViews
   --
   lock screen
   repeat for each line someControl in buttonViews
      if exists (someControl) then
         set the showname of someControl to someBoolean
      end if
   end repeat
   unlock screen
end show_Names

getprop all_Visible
   return _CheckAllVisible()
end all_Visible

command _AutoSetShowNames
   put _CheckAllVisible() into someBoolean
   set the show_Names of me to someBoolean
end _AutoSetShowNames

function _CheckAllVisible
   put _NamedViews() into buttonViews
   repeat for each line someControl in buttonViews
      if exists (someControl) is false then next repeat
      --
      put _CheckShowName (someControl) into someBoolean
      if someBoolean is false then
         return false 
      end if
   end repeat
   return true
end _CheckAllVisible

private function _NamedViews
   if exists (control "Guardians" of me) then
      put the long id of control "Guardians" of me & CR after threeTitleViews
   end if
   --
   if exists (control "Journals" of me) then
      put the long id of control "Journals" of me & CR after threeTitleViews
   end if
   --
   if exists (control "Ecosystem" of me) then
      put the long id of control "Ecosystem" of me after threeTitleViews
   end if
   delete char -1 of threeTitleViews
   return threeTitleViews
end _NamedViews


--> Objects | All Views
-
getprop element_Views
   return _ElementViews()
end element_Views

private function _ButtonViews
   put _ElementViews() into allElementViews
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
end _ButtonViews

function _ElementViews
   put the childControlIDs of me into allIDs
   put _btnView() into btnView
   put the short id of btnView into btnID
   put lineoffset (btnID, allIDs) into lineNum
   delete line lineNum of allIDs 
   return allIDs
end _ElementViews

private function _ControlFromArray cPropArray
   put cPropArray ["id"] into elementID  
   if exists (control id elementID of me) is true then
      put the long id of control id elementID into cObject
      return cObject
   end if
   
   put cPropArray ["name"] into elementName
   put the top_Control [elementName] of me into cObject
   return cObject
end _ControlFromArray


--> Events
-
on preOpenControl
   init_LocalArray
   LayoutControl
end preOpenControl

on resizeControl
   put the rect of me into pRect
   LayoutControl pRect
end resizeControl


--> Init
-
command init_LocalArray pArray
   delete variable LocalArray
   if pArray is an array then
      put pArray into LocalArray ["eArray"]
      -- set the uLCW ["eArray"] of me to eArray
   else
      put the uLCW ["eArray"] of me into LocalArray ["eArray"]
   end if
   --
   put 10 into LocalArray ["tiles_Across"]
   put true into LocalArray ["fixed_Square"]
end init_LocalArray


--> Functions for both create and view
-
getprop element_Array
   put LocalArray ["eArray"] into eArray
   if eArray is not an array then
      put the uLCW ["eArray"] of me into eArray
   end if
   return eArray
end element_Array


--> Geometry
-
getprop square_Rect [sMargin]
   put the rect of me into someRect
   put rect_GetSquare (someRect, sMargin) into squareRect
   return squareRect
end square_Rect

setprop grow_Rect gFactor
   put the rect_Grow [gFactor] of the target into grownRect
   set the rect of the target to grownRect
   return grownRect
end grow_Rect

getprop rect_Grow [gFactor]
   if gFactor is empty then put 2 into gFactor
   put the long id of the target into myGroup
   --
   put the loc of myGroup into someLoc
   put the width of myGroup * gFactor into newW
   put rect_LocWidthHeight (someLoc, newW, newW) into grownRect
   return grownRect
end rect_Grow

getprop tiles_Across
   put LocalArray ["tiles_Across"] into tilesAcross
   if tilesAcross is not a number then
      init_LocalArray
      put LocalArray ["tiles_Across"] into tilesAcross
      breakpoint
   end if
   return tilesAcross
end tiles_Across

setprop tile_Points [tilesAcross] tilePoints
   replace "|" with CR in tilePoints
   put the long id of the target into graphicObject
   if word 1 of graphicObject is not "graphic" then
      return empty -- could convert
   end if
   --
   set the style of graphicObject to polygon
   --
   put the square_Rect of me into squareRect
   put tile_GetPoints (tilePoints, squareRect, tilesAcross) into newPoints
   set the points of graphicObject to newPoints
   return newPoints
end tile_Points


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

getprop show_Borders
   return LocalArray ["show_Borders"] is true
end show_Borders

setprop show_Borders someBoolean
   put someBoolean is true into someBoolean
   put someBoolean into LocalArray ["show_Borders"]
   put _ElementViews() into allIDs
   lock screen
   repeat for each line childID in allIDs
      set the showborder of control id childID of me to someBoolean
   end repeat
   unlock screen
end show_Borders

setprop tile_Rect [tilesAcross] tileRect
   put the long id of the target into tObject
   if word 1 of tObject is not "graphic" then
      return empty
   end if
   
   put the square_Rect of me into squareRect
   put tile_GetRect (tileRect, squareRect, tilesAcross) into someRect
   lock screen
   set the style of the target to rectangle
   set the rect of the target to someRect
   unlock screen
   return someRect
end tile_Rect

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


--> Layout
-
on LayoutControl pRect
   lock screen
   local squareRect, squareCentre, squareWidth, halfSquareWidth, pSquareMargin
   if pRect is empty then put the rect of me into pRect
   
   put LocalArray ["eArray"] into eArray
   put tile_GetAcross() into tilesAcross
   put _GetGridNum() into gridNum
   
   put rect_GetSquare (pRect, 0) into squareRect
   -- put the square_Rect of me into squareRect
   
   if the fixed_Square of me is true then
      set the lockmessages to true
      -- set the rect of me to squareRect -- this now another resizeControl event
      set the rect of me to squareRect
      set the lockmessages to false
   end if
   
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
            -- set the tile_Points of someControl to tilePoints
            if word 1 of the long id of someControl = "graphic" then
               put tile_GetPoints (tilePoints, squareRect, tilesAcross) into newPoints
               set the points of someControl to newPoints
            else
               breakpoint
            end if
            break
         case tileRect is a rectangle -- quick check
            put tile_GetRect (tileRect, squareRect, tilesAcross) into childRect
            set the rect of someControl to childRect
            break
         default
            -- do nothing
      end switch
   end repeat
   
   put _btnView() into btnView
   put _InnerRect() into innerRect
   --
   get the name of btnView
   set the rect of btnView to innerRect
   --
   _AutoSetShowNames
   --
   unlock screen
end LayoutControl

function _GetGridNum
   -- put the grid_Num of me into gridNum
   put tile_GetAcross() into tilesAcross
   return tilesAcross ^ 2
end _GetGridNum

function _DefaultTilesAcross
   -- let's get a sensible default
   put the childControlIDs of me into childIDs
   put the number of lines of childIDs into gridNum
   
   put gridNum ^ 0.5 into tilesAcross
   if tilesAcross is not an integer then return 8
   return tilesAcross
end _DefaultTilesAcross

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

private function _CheckShowName someControl
   try
      put the width of someControl into eWidth
      put the formattedwidth of someControl into fWidth
      add 8 to fWidth
      put eWidth > fWidth into someBoolean
   catch e
      -- bug: when trying to get formattedwidth of a graphic
      put true into someBoolean
   end try
   return someBoolean
end _CheckShowName

command _AutoSetShowName someControl
   put _CheckShowName (someControl) into someBoolean
   set the showname of someControl to someBoolean
end _AutoSetShowName

private function _InnerRect
   put the long id of the target into someGroup
   put the rect of someGroup into groupRect
   
   if word 1 of someGroup is not "group" then return groupRect
   put the margins of someGroup into someMargin
   put the scrollbarwidth of someGroup into scrollBarMargin
   if the vscrollbar of someGroup is true then subtract scrollBarMargin from item 3 of groupRect
   if the hscrollbar of someGroup is true then subtract scrollBarMargin from item 4 of groupRect
   
   if the showborder of someGroup is true then
      put the borderwidth of someGroup into bWidth
      
      if the showname of someGroup is true then
         put the effective textheight of someGroup - bWidth - 1 into someBit
         add someBit to item 2 of someMargin
      end if
      
      rect_SubtractMargins groupRect, bWidth
   end if
   
   rect_SubtractMargins groupRect, someMargin
   return groupRect
end _InnerRect


--> Objects
-
getprop top_Control [topName]
   put the long id of the target into targetObject
   
   -- finds or returns the top control
   put the childcontrolids of targetObject into topIDs
   if topIDs is empty then return empty
   if topName is empty then
      put line 1 of topIDs into topID
      put the long id of control id topID into topControl
      return topControl
   end if
   
   -- let's find a top control with the name "topName"
   repeat for each line someID in topIDs
      put the long id of control id someID into someControl
      put the short name of someControl into testName
      if testName = topName then
         return someControl
      end if
   end repeat
   return empty
end top_Control


--> Objects | Button View
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
      put _InnerRect() into innerRect
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


--> Objects
-
getprop org_View
   return the long id of me
end org_View

getprop grid_View
   return the long id of me
end grid_View

getprop layout_View
   return the long id of me
end layout_View

getprop view_Object
   return the long id of me
end view_Object


--> Deps
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

--- function rect_GetSquare sRect
put item 1 of sRect into sLeft
put item 2 of sRect into sTop
put item 3 of sRect into sRight
put item 4 of sRect into sBottom

put (sLeft + sRight) / 2 into sCenterX
put (sTop + sBottom) / 2 into sCenterY
put min (sRight - sLeft, sBottom - sTop) / 2 into sSize

put sCenterX - sSize into sNewLeft
put sCenterY - sSize into sNewTop
put sCenterX + sSize into sNewRight
put sCenterY + sSize into sNewBottom
--
return sNewLeft & "," & sNewTop & "," & sNewRight & "," & sNewBottom
end rect_GetSquare

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

