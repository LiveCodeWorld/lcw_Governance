script "lib_Grid"
--> MetaData
-
copyright: David Bovill
license: GPLv3
name: lib_Grid
type: library
version: 0.1

/*Some help*/


--> Geometry | Arrows
-
getprop border_Loc [pItems]
   put the rect of the target into tRect
   --
   put item 1 of pItems into sBorder
   put item 2 of pItems into stepNum
   put item 3 of pItems into numOfSteps
   if stepNum is empty then
      put 1 into stepNum
      put 2 into numOfSteps
   end if
   --
   put 2 into yFiddle
   switch char 1 of sBorder
      case "t"
         put item 2 of tRect into tTop
         subtract yFiddle from tTop
         put tTop into item 2 of bLoc
         put _BLocX (tRect, stepNum, numOfSteps) into item 1 of bLoc
         return bLoc
      case "b"
         put item 4 of tRect into tBottom
         add yFiddle to tBottom
         put tBottom into item 2 of bLoc
         put _BLocX (tRect, stepNum, numOfSteps) into item 1 of bLoc
         return bLoc
      case "l"
         put item 1 of tRect into item 1 of bLoc
         put _BLocY (tRect, stepNum, numOfSteps) into item 2 of bLoc
         return bLoc
      case "r"
         put item 3 of tRect into item 1 of bLoc
         put _BLocY (tRect, stepNum, numOfSteps) into item 2 of bLoc
         return bLoc
      default
         return empty
   end switch
end border_Loc

private function _BLocY tRect, stepNum, numOfSteps
   put item 2 of tRect into tTop
   put item 4 of tRect - tTop into tHeight
   put tTop + stepNum * tHeight/numOfSteps into bLocY
   return bLocY
end _BLocY

private function _BLocX tRect, stepNum, numOfSteps
   put item 1 of tRect into tLeft
   put item 3 of tRect - tLeft into tWidth
   put tLeft + stepNum * tWidth/numOfSteps into bLocX
   return bLocX
end _BLocX


--> Working on
-
function tile_GetNumber shortID, shapeArray
   repeat for each key tileNum in shapeArray
      put shapeArray [tileNum]["id"] into testID
      if testID = shortID then
         return tileNum
      end if
   end repeat
   return 0
end tile_GetNumber

function tile_GetObject shortID, shapeArray
   repeat for each key titleNum in shapeArray
      put shapeArray [titleNum]["id"] into testID
      if testID = shortID then
         return the long id of me
      end if
   end repeat
   return empty
end tile_GetObject

function tile_GetPoints tilePoints, squareRect, tilesAcross, tilesDown
   replace "|" with CR in tilePoints
   --
   put item 1 of squareRect into startX
   put item 2 of squareRect into startY
   --
   put item 3 of squareRect - startX into sWidth
   put sWidth / tilesAcross into tWidth
   --
   put item 4 of squareRect - startY into sHeight
   put sHeight / tilesDown into tHeight
   --
   repeat for each line tilePoint in tilePoints
      put item 1 of tilePoint into pointX
      put item 2 of tilePoint into pointY
      put grid_GetLoc (pointX, pointY, startX, startY, tWidth, tHeight) into newPoint
      put newPoint & CR after newPoints
   end repeat
   delete char -1 of newPoints
   return newPoints
end tile_GetPoints

function grid_GetLoc x, y, startX, startY, tileWidth, pTileHeight
   if pTileHeight is not a number then
      put tileWidth into pTileHeight
   end if
   
   put startX + (x * tileWidth) into someX
   put startY + (y * pTileHeight) into someY
   return someX,someY
end grid_GetLoc

function grid_GetRect tileRect, frameRect, pTilesAcross, pTilesDown, pMargins
   if pTilesAcross is not a number then put 10 into pTilesAcross
   if pTilesDown is not a number then put pTilesAcross into pTilesDown
   --
   put item 1 of frameRect into startX
   put item 2 of frameRect into startY
   put (item 3 of frameRect - startX) / pTilesAcross into tileWidth
   put (item 4 of frameRect - startY) / pTilesDown into tileHeight
   --
   put item 1 of tileRect into tLeft
   put item 2 of tileRect into tBottom
   put item 3 of tileRect into tRight
   put item 4 of tileRect into tTop
   --
   put startX + (tLeft * tileWidth) into item 1 of sRect
   put startY + (tBottom * tileHeight) into item 2 of sRect
   --
   put startX + (tRight * tileWidth) into item 3 of sRect
   put startY + (tTop * tileHeight) into item 4 of sRect
   --
   rect_SubtractMargins sRect, pMargins
   --
   return sRect
end grid_GetRect


--> Grid
-
function grid_ConstructShapeData shapeArray, shapeTitle, gridDimensions
   put shapeTitle into shapeData ["title"]
   put gridDimensions into shapeData ["grid_Dimensions"]
   put shapeArray into shapeData ["shape_Array"]
   return shapeData
end grid_ConstructShapeData

command grid_ReizeTitles shapeArray, gridView, frameRect, pTilesAcross, pTilesDown
   if pTilesAcross is empty then put 10 into pTilesAcross
   put 10 into pTilesDown
   
   set the rect of gridView to frameRect
   --
   lock screen
   repeat with itemNum = 1 to item 2 of the extents of shapeArray 
      put shapeArray [itemNum] into propArray
      --
      put shapeArray [itemNum]["id"] into shortID
      if exists (control id shortID of gridView) is false then
         next repeat
      end if
      
      put the long id of control id shortID of gridView into tileObject
      put propArray ["tile_Points"] into tilePoints
      if tilePoints is empty then
         put propArray ["tile_Rect"] into tileRect
         --
         put grid_GetRect (tileRect, frameRect, pTilesAcross, pTilesDown) into sRect
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
command grid_Create shapeArray, gridView, frameRect, pTilesAcross, pTilesDown
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
      put shapeArray [itemNum] into cArray
      tile_Create cArray, frameRect, pTilesAcross, pTilesDown, gridView
      put the result into tileObject
      put cArray into shapeArray [itemNum]
      --
      if exists (tileObject) then
         put the short id of tileObject into shapeArray [itemNum]["id"]
      else
         breakpoint
      end if
   end repeat
   
   -- # Update the shape_Data with new shapeArray which includes created short ids
   -- set the shape_Array of gridView to shapeArray
   unlock screen
   return shapeArray
end grid_Create

command tile_Create @cArray, frameRect, pTilesAcross, pTilesDown, gridView
   put cArray ["control_Type"] into tileType
   --
   put cArray ["tile_Points"] into tilePoints
   if tilePoints is empty then
      put cArray ["tile_Rect"] into tileRect
      --
      put grid_GetRect (tileRect, frameRect, pTilesAcross, pTilesDown) into sRect
      put sRect into cArray ["rect"]
   else
      put tile_GetPoints (tilePoints, frameRect, pTilesAcross, pTilesDown) into sPoints
      put sPoints into cArray  ["points"]
   end if
   
   put cArray ["name"] into tileName
   -- set the itemdelimiter to "|"
   switch
      case tileType contains "|"
         put view_GetTemplateObject (tileType) into templateObject
         view_InsertFromPath tileType, gridView
         put the result into tileObject
         break
      case tileType is among the items of "button,btn"
         create button tileName in gridView
         put it into tileObject
         break
      case tileType is among the items of "image,img"
         create image tileName in gridView
         put it into tileObject
         break
      case item 1 of tileType = "View"
         break
      case tileType is among the items of "graphic,grc"
      case tileType = empty
      default
         _SetDefaultStyle cArray, tilePoints
         --
         create graphic tileName in gridView
         put it into tileObject
   end switch
   --
   if exists (tileObject) then
      _SetProps cArray, tileObject
   end if
   --
   return tileObject
end tile_Create

private command _SetDefaultStyle @cArray, tilePoints
   if cArray  ["style"] is not empty then return false
   
   if tilePoints is not empty then
      put "polygon" into cArray  ["style"]
   else
      put "rectangle" into cArray  ["style"]
   end if
   return true
end _SetDefaultStyle

private command _SetProps cArray, tileObject
   -- put _CleanPropArray (cArray) into propArray
   _DeleteCustom cArray
   put the result into customArray
   set the properties of tileObject to cArray
   --
   repeat for each key cProp in customArray
      -- if cProp = "control_Type" then next repeat
      put customArray [cProp] into cValue
      set the cProp of tileObject to cValue
   end repeat
end _SetProps

private function _CleanPropArray propArray
   _DeleteCustom propArray
   return propArray
end _CleanPropArray

private command _DeleteCustom @propArray
   local customArray
   
   delete variable propArray ["tile_Points"]
   delete variable propArray ["tile_Rect"]
   delete variable propArray ["control_Type"]
   --
   repeat for each key propName in propArray
      if propName contains "_" then
         put propArray [propName] into customArray [propName]
         delete variable propArray [propName]
      end if
   end repeat
   return customArray
end _DeleteCustom

command grid_DeleteTiles gridView
   lock screen
   --  put the controlids of gridView into cIDs
   put the childControlIDs of gridView into cIDs
   repeat for each line cID in cIDs
      set the cursor to busy
      delete control id cID of gridView
   end repeat
   unlock screen
end grid_DeleteTiles
