script "lib_Governance"
--> MetaData
-
copyright: David Bovill
license: GPLv3
name: lib_Governance
type: library
version: 0.2

/*
This is a work-in-progress library for usse while developing a suite of governance services.
*/


--> Working on | TileRect
-
function tile_GetRect tileRect, frameRect, tilesAcross, pTilesDown
   -- has been updated?
   if pTilesDown is empty then put tilesAcross into pTilesDown
   put item 1 of frameRect into startX
   put item 2 of frameRect into startY
   
   put (item 3 of frameRect - startX) / pTilesAcross into tileWidth
   
   put item 1 of tileDimensions into tLeft
   put item 2 of tileDimensions into tBottom
   put grid_GetLoc (tLeft, tBottom, startX, startY, tileWidth, tileHeight) into sRect
   
   put item 3 of tileRect into tRight
   put item 4 of tileRect into tTop
   put grid_GetLoc (tRight, tTop, startX, startY, tileWidth, tileHeight) into item 3 of sRect
   --
   return sRect
end tile_GetRect

function grid_GetRect tileDimensions, frameRect, pTilesAcross, pTilesDown
   if pTilesAcross is not a number then put 10 into pTilesAcross
   if pTilesDown is not a number then put pTilesAcross into pTilesDown
   --
   put item 1 of frameRect into startX
   put item 2 of frameRect into startY
   put (item 3 of frameRect - startX) / pTilesAcross into tileWidth
   put (item 4 of frameRect - startY) / pTilesDown into tileHeight
   --
   put item 1 of tileDimensions into tLeft
   put item 2 of tileDimensions into tBottom
   put item 3 of tileDimensions into tRight
   put item 4 of tileDimensions into tTop
   --
   put startX + (tLeft * tileWidth) into item 1 of sRect
   put startY + (tBottom * tileHeight) into item 2 of sRect
   --
   put startX + (tRight * tileWidth) into item 3 of sRect
   put startY + (tTop * tileHeight) into item 4 of sRect
   --
   return sRect
end grid_GetRect


--> Working on
-
function tile_GetSquare tLeft, tBottom, tRight, tTop, squareRect, pTilesAcross
   if pTilesAcross is empty then put 10 into pTilesAcross
   --
   put item 1 of squareRect into startX
   put item 2 of squareRect into startY
   put (item 3 of squareRect - startX) / pTilesAcross into tileWidth
   
   put item 1 of tileRect into tLeft
   put item 2 of tileRect into tBottom
   put grid_GetLoc (tLeft, tBottom, startX, startY, tileWidth) into sRect
   
   put item 3 of tileRect into tRight
   put item 4 of tileRect into tTop
   put grid_GetLoc (tRight, tTop, startX, startY, tileWidth) into item 3 of sRect
   
   -- put grid_GetRect (tLeft, tBottom, tRight, tTop, startX, startY, tileWidth) into sRect
   --
   return sRect
end tile_GetSquare

function tile_GetPoints tilePoints, squareRect, pTilesAcross
   replace "|" with CR in tilePoints
   _SetTileGeometry squareRect, tileWidth, startX, startY, pTilesAcross
   --
   repeat for each line tilePoint in tilePoints
      put item 1 of tilePoint into pointX
      put item 2 of tilePoint into pointY
      put grid_GetLoc (pointX, pointY, tileWidth, startX, startY) into newPoint
      put newPoint & CR after newPoints
   end repeat
   delete char -1 of newPoints
   return newPoints
end tile_GetPoints

function tile_GetAcross
   return 10
   --
   put LocalArray ["tiles_Across"] into tilesAcross
   return tilesAcross
end tile_GetAcross

command grid_ReizeTitles shapeArray, gridView, frameRect, pTilesAcross, pTilesDown
   if pTilesAcross is empty then put 10 into pTilesAcross
   put 10 into pTilesDown
   
   set the rect of gridView to frameRect
   --
   lock screen
   repeat with itemNum = 1 to item 2 of the extents of shapeArray 
      put shapeArray [itemNum] into propArray
      --
      put shapeArray [itemNum]["element id"] into shortID
      if exists (control id shortID of gridView) is false then
         next repeat
      end if
      
      put the long id of control id shortID of gridView into tileObject
      put propArray ["tile_Points"] into tilePoints
      if tilePoints is empty then
         put propArray ["tile_Rect"] into tileDimensions
         --
         put grid_GetRect (tileDimensions, frameRect, pTilesAcross, pTilesDown) into sRect
         set the rect of tileObject to sRect
      else
         -- put tile_GetPoints (tilePoints, frameRect, pTilesAcross) into sPoints
         -- set the points of tileObject to sPoints
      end if
   end repeat
   --
   set the shape_Array of gridView to shapeArray
   unlock screen
end grid_ReizeTitles


--> Grid | Create
-
command tile_Create shapeArray, gridView, frameRect, pTilesAcross, pTilesDown
   if pTilesAcross is empty then put 10 into pTilesAcross
   if pTilesDown is empty then put pTilesAcross into pTilesAcross
   if exists (gridView) is false then return empty
   
   set the opaque of the templategraphic to true
   set the showName of the templategraphic to true
   --
   lock screen
   grid_DeleteTiles gridView
   --
   set lockmessages to true
   set the rect of gridView to frameRect
   set lockmessages to false
   
   repeat with itemNum = 1 to item 2 of the extents of shapeArray 
      put shapeArray [itemNum] into propArray
      --
      put propArray ["control_Type"] into tileType
      delete variable propArray  ["control_Type"]
      
      put propArray ["tile_Points"] into tilePoints
      if tilePoints is empty then
         put propArray ["tile_Rect"] into tileDimensions
         delete variable propArray  ["tile_Rect"]
         --
         put grid_GetRect (tileDimensions, frameRect, pTilesAcross, pTilesDown) into sRect
         put sRect into propArray ["rect"]
      else
         delete variable propArray  ["tile_Points"]
         put tile_GetPoints (tilePoints, frameRect, pTilesAcross, pTilesDown) into sPoints
      end if
      
      put propArray ["name"] into tileName
      set the itemdelimiter to "|"
      switch
         case tilePoints is not empty
            break
         case tileType = empty
            -- create button tileName in gridView
            create graphic tileName in gridView
            put it into tileObject
            -- set the rect of tileObject to propArray ["rect"]
            break
         case item 1 of tileType = "View"
            break
         default
            --
      end switch
      
      set the properties of tileObject to propArray
      --
      put the short id of tileObject into shapeArray [itemNum]["element id"]      
   end repeat
   --
   set the shape_Array of gridView to shapeArray
   unlock screen
end tile_Create

command grid_DeleteTiles gridView
   lock screen
   put the controlids of gridView into cIDs
   repeat for each line cID in cIDs
      set the cursor to busy
      delete control id cID of gridView
   end repeat
   unlock screen
end grid_DeleteTiles

command _SetProps
   repeat for each key propName in cPropArray
      if the number of words of propName > 1 then
         next repeat -- "element id"
      end if
      
      put cPropArray [propName] into propValue
      set the propName of someControl to propValue
   end repeat
end _SetProps


--> Tile | Geometry
-
function grid_GetLoc x, y, startX, startY, tileWidth, pTileHeight
   if pTileHeight is not a number then
      put tileWidth into pTileHeight
   end if
   
   put startX + (x * tileWidth) into someX
   put startY + (y * pTileHeight) into someY
   return someX,someY
end grid_GetLoc


--> Governance
-
function grid_ListShapeNames
   return "MVG,VSM,Right Bar,Bars,Cool,Block"
end grid_ListShapeNames

function tile_GetShapeArray whichShape
   switch whichShape
      case "MVG"
         put mvg_Shape() into shapeArray
         break
      case "VSM"
         put vsm_Shape() into shapeArray
         break
      case "Right Bar"
         put rightBar_Shape() into shapeArray
         break
      case "Bars"
         put bar_Shape() into shapeArray
         break
      case "Cool"
         put cool_Shape() into shapeArray
         break
      case "Block"
         put block_Shape() into shapeArray
         break
   end switch
   return shapeArray
end tile_GetShapeArray


--> Deps | Geometry
-
function rect_GetSquare sRect
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


--> Private
-
private command _SetTileGeometry squareRect, @tileWidth, @startX, @startY, pTilesAcross
   if pTilesAcross is empty then
      -- put tile_GetAcross() into pTilesAcross
      put _DefaultTilesAcross() into pTilesAcross
   end if
   put item 1 of squareRect into startX
   put item 2 of squareRect into startY
   put item 3 of squareRect - startX into sWidth
   put sWidth / pTilesAcross into tileWidth
   return tileWidth
end _SetTileGeometry

private function mvg_Shape
   local eArray
   --   
   _AddShapeItem eArray, "Guardians", "yellow", "1,1,11,3.5" 
   _AddShapeItem eArray, "Journals", "green", "1,4,11,6" 
   _AddShapeItem eArray, "Ecosystem", "light blue", "1,6.5,11,8.5" 
   _AddShapeItem eArray, "Members", "light yellow", "1,9,11,13" 
   
   # Platform
   _AddShapeItem eArray, "Platform", "dark gray", "11,1,13,13", "black"
   _AddPropToNamedItem eArray, "blendlevel", "0", "Platform"
   _AddPropToNamedItem eArray, "linesize", "0", "Platform"
   _AddPropToNamedItem eArray, "showname", "false", "Platform"
   
   # Platform Elements (need to be last)
   _AddShapeItem eArray, "Money Platform", "orange", "11.5,2,12.5,3"
   _AddPropToNamedItem eArray, "showname", "false", "Money Platform"
   
   _AddShapeItem eArray, "Journal Platform", "dark green", "11.5,4.5,12.5,5.5"
   _AddPropToNamedItem eArray, "showname", "false", "Journal Platform"
   
   _AddShapeItem eArray, "Jester Platform", "dark blue", "11.5,7,12.5,8"
   _AddPropToNamedItem eArray, "showname", "false", "Jester Platform"
   
   _AddShapeItem eArray, "Member Platform", "yellow", "11.5,9.5,12.5,12.5"
   _AddPropToNamedItem eArray, "showname", "false", "Member Platform"
   --
   return eArray
end mvg_Shape

private function block_Shape
   local eArray
   --   
   _AddShapeItem eArray, "Guardians", "yellow", "1,1,7,3" 
   _AddShapeItem eArray, "Journals", "green", "1,4,7,6" 
   _AddShapeItem eArray, "Ecosystem", "light blue", "1,7,7,9" 
   
   # Platform
   _AddShapeItem eArray, "Platform", "dark gray", "7,1,9,9", "black"
   _AddPropToNamedItem eArray, "blendlevel", "0", "Platform"
   _AddPropToNamedItem eArray, "linesize", "0", "Platform"
   _AddPropToNamedItem eArray, "showname", "false", "Platform"
   
   # Platform Elements (need to be last)
   _AddShapeItem eArray, "Journal Platform", "dark green", "7.5,4.5,8.5,5.5"
   _AddPropToNamedItem eArray, "showname", "false", "Journal Platform"
   
   _AddShapeItem eArray, "Member Platform", "dark blue", "7.5,7.5,8.5,8.5"
   _AddPropToNamedItem eArray, "showname", "false", "Member Platform"
   
   _AddShapeItem eArray, "Money", "orange", "7.5,1.5,8.5,2.5"
   _AddPropToNamedItem eArray, "showname", "false", "Money"
   --
   return eArray
end block_Shape

private function cool_Shape
   local eArray
   --   
   _AddShapeItem eArray, "Guardians", "yellow", "1,1,7,3" 
   _AddShapeItem eArray, "Journals", "green", "1,4,7,6" 
   _AddShapeItem eArray, "Ecosystem", "light blue", "1,7,7,9" 
   
   _AddShapeItem eArray, "Money", "orange", "7.5,1.5,8.5,2.5", empty, "View|Button|SVG"
   _AddPropToNamedItem eArray, "icon_Name", "money", "Money"
   
   _AddShapeItem eArray, "Journal Platform", "dark green", "7.5,4.5,8.5,5.5", empty, "View|Button|SVG"
   _AddPropToNamedItem eArray, "icon_Name", "beaker", "Money"
   
   _AddShapeItem eArray, "Member Platform", "blue", "7.5,7.5,8.5,8.5", empty, "View|Button|SVG"
   _AddPropToNamedItem eArray, "icon_Name", "sitemap", "Money"
   
   _AddShapeItem eArray, "Platform", "black", "7,3,9,9", "white"
   _AddPropToNamedItem eArray, "blendlevel", "70", "Platform"
   _AddPropToNamedItem eArray, "linesize", "0", "Platform"
   --
   put "8,1" into startPoint
   put startPoint into tilePoints
   put CR & "9,1|9,9|8,9" after tilePoints
   put CR & "8,8.2|7,8.2|7,7.8|8,7.8" after tilePoints
   put CR & "8,5.2|7,5.2|7,4.8|8,4.8" after tilePoints
   put CR & "8,2.2|7,2.2|7,1.8|8,1.8" after tilePoints
   put CR & startPoint after tilePoints
   --
   _AddPropToNamedItem eArray, "tile_Points", tilePoints, "Platform"
   _AddPropToNamedItem eArray, "showname", "false", "Platform"
   --
   return eArray
end cool_Shape

private function bar_Shape
   local eArray
   --   
   _AddShapeItem eArray, "Guardians", "yellow", "1,1,7,3" 
   _AddShapeItem eArray, "Journals", "green", "1,4,7,6" 
   _AddShapeItem eArray, "Ecosystem", "blue", "1,7,7,9" 
   
   _AddShapeItem eArray, "Money", "orange", "7,1,9,3", empty, "button"
   _AddPropToNamedItem eArray, "showname", "false", "Money"
   -- _AddPropToNamedItem eArray, "icon_Name", "money", "Money"
   
   _AddShapeItem eArray, "Platform", "black", "7,3,9,9", "white"
   _AddPropToNamedItem eArray, "blendlevel", "70", "Platform"
   _AddPropToNamedItem eArray, "linesize", "1", "Platform"
   _AddPropToNamedItem eArray, "tile_Points", "8,3|9,3|9,9|8,9|8,8|7,8|8,8|8,5|7,5|8,5|8,3", "Platform"
   _AddPropToNamedItem eArray, "showname", "false", "Platform"
   --
   return eArray
end bar_Shape

private function rightBar_Shape
   local eArray
   --   
   _AddShapeItem eArray, "Money", "red", "7,1,9,3" 
   _AddShapeItem eArray, "Guardians", "yellow", "1,1,6,3" 
   _AddShapeItem eArray, "Journals", "green", "1,4,6,6" 
   _AddShapeItem eArray, "Ecosystem", "blue", "1,7,6,9" 
   _AddShapeItem eArray, "Platform", "gray"
   --
   _AddPropToNamedItem eArray, "tile_Points", "8,4|9,4|9,9|8,9|8,4", "Platform"
   _AddPropToNamedItem eArray, "showname", "false", "Platform"
   --
   return eArray
end rightBar_Shape

private function vsm_Shape
   local eArray
   --   
   _AddShapeItem eArray, "Guardians", "yellow", "1,1,7,3" 
   _AddShapeItem eArray, "Journals", "green", "1,4,6,6" 
   _AddShapeItem eArray, "Ecosystem", "light blue", "1,7,6,9" 
   
   _AddShapeItem eArray, "Money", "red", "7,1,9,3", empty, "View|Button|SVG"
   _AddPropToNamedItem eArray, "icon_Name", "money", "Money"
   
   _AddShapeItem eArray, "Platform", "black", "7,4,9,9", "white"
   _AddPropToNamedItem eArray, "tile_Points", "7,4|9,4|9,9|7,9|7,4", "Platform"
   _AddPropToNamedItem eArray, "showname", "false", "Platform"
   return eArray
end vsm_Shape

private command _AddPropToNamedItem @eArray, someProp, someValue, pItemName
   put _FindItemNum (eArray, pItemName) into itemNum
   put someValue into eArray [itemNum][someProp]
end _AddPropToNamedItem

private function _FindItemNum eArray, pItemName
   if pItemName is empty then
      return item 2 of the extents of eArray
   else
      repeat for each key testItemNum in eArray
         if eArray [testItemNum]["name"] = pItemName then
            return testItemNum
         end if
      end repeat
   end if
   return 0
end _FindItemNum

private command _AddShapeItem @eArray, someName, someColour, tileRect, pFontColour, pControlType
   put someName into itemArray ["name"]
   put 0 into itemArray ["linesize"]
   put someColour into itemArray ["backgroundcolor"]
   if tileRect is a rect then
      put tileRect into itemArray ["tile_Rect"]
   end if
   if pFontColour is not empyt then
      put pFontColour into itemArray ["foregroundcolor"]
   end if
   if pControlType is not empty then
      put pControlType into itemArray ["control_Type"]
   end if
   --
   array_AddToNumbered eArray, itemArray
   put the result into lastItemNum
   return lastItemNum
end _AddShapeItem
