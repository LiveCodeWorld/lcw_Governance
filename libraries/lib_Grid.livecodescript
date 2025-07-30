script "lib_Grid"
--> MetaData
-
copyright: David Bovill
license: GPLv3
name: lib_Grid
type: library
version: 0.1

/*Some help*/


--> Steps
-
function steps_GetSnakeNum tileNumber, gridDimensions
   put item 1 of gridDimensions into xDimension
   put item 2 of gridDimensions into yDimension
   --
   put (tileNumber - 1) div xDimension into rowNum
   add 1 to rowNum
   --
   put (tileNumber - 1) mod (xDimension - 0) into leftOverX
   --
   put rowNum mod 2 = 1 into isOddLine
   if isOddLine is true then
      put tileNumber into snakeNumber
   else
      put (rowNum -1) * xDimension + (xDimension - leftOverX) into snakeNumber 
   end if
   return snakeNumber
end steps_GetSnakeNum


--> Grid | Arrows
-
command grid_Create shapeData, gridView, pFrameRect
   if exists (gridView) is false then return empty
   if pFrameRect is empty then put the rect of gridView into pFrameRect
   --
   put shapeData ["shape_Array"] into shapeArray
   put shapeData ["grid_Dimensions"] into gridDimensions
   put item 1 of gridDimensions into tilesAcross
   put item 2 of gridDimensions into tilesDown
   --
   lock screen
   --
   set the opaque of the templategraphic to true
   set the showName of the templategraphic to true
   grid_DeleteTiles gridView
   --
   set lockmessages to true
   set the rect of gridView to pFrameRect
   set lockmessages to false
   
   repeat with itemNum = 1 to item 2 of the extents of shapeArray 
      put shapeArray [itemNum] into cArray
      tile_Create cArray, pFrameRect, tilesAcross, tilesDown, gridView
      put the result into tileObject
      put cArray into shapeArray [itemNum]
      --
      if exists (tileObject) then
         # Add or update "id" entry in shapeData with newly created tile id
         put the short id of tileObject into shapeData ["shape_Array"][itemNum]["id"]
      else
         breakpoint
      end if
   end repeat
   
   # Create Arrows
   grid_CreateArrows shapeData, gridView
   
   # Layout Grid (just in case geometries were not set right)
   set the shape_Data of gridView to shapeData
   dispatch "LayoutControl" to gridView
   unlock screen
   --
   return shapeData
end grid_Create

command grid_CreateArrows shapeData, gridView
   lock screen
   put shapeData ["grid_ArrowData"] into arrowData
   repeat with indexNum = 1 to item 2 of the extents of arrowData
      grid_CreateArrow shapeData, gridView, indexNum
   end repeat
   unlock screen
end grid_CreateArrows

command grid_CreateArrow shapeData, gridView, indexNum
   put shapeData ["grid_ArrowData"][indexNum] into propArray
   if propArray is not an array then return false
   --
   put propArray ["from_Name"] into fromName
   put propArray ["to_Name"] into toName
   --
   put propArray ["from_Number"] into fromNumber
   put propArray ["to_Number"] into toNumber
   --
   put shapeData ["shape_Array"][fromNumber]["id"] into fromID
   if exists (control id fromID of gridView) is false then
      breakpoint
      exit to top
   end if
   put shapeData ["shape_Array"][toNumber]["id"] into toID
   if exists (control id toID of gridView) is false then
      breakpoint
      exit to top
   end if
   
   put the long id of control id fromID of gridView into fromObject
   put the long id of control id toID of gridView into toObject
   -- 
   grid_CreateArrowLink fromObject, toObject, gridView, propArray
   put the result into arrowView
   --
   put "Arrow" && fromNumber,toNumber into aName
   set the name of arrowView to aName
   
   /*
   # Fix names
   set the name of fromObject to fromName
   set the label of fromObject to fromNumber
   set the tooltip of fromObject to fromName
   --
   set the name of toObject to toName
   set the label of toObject to toNumber
   set the tooltip of toObject to toName
   */
   return arrowView
end grid_CreateArrow

command grid_CreateArrowLink fromTile, toTile, gridView, propArray
   if exists (gridView) is false then
      return empty
   end if
   
   lock screen
   view_InsertFromPath "View|ixOS|Arc", gridView
   put the result into aView
   --
   set the lineSize of aView to 4
   set the startArrow of aView to false
   set the endArrow of aView to false
   --
   set the from_Object of aView to fromTile
   set the to_Object of aView to toTile
   --
   put propArray ["from_Side"] into fromSide
   put propArray ["from_StepNum"] into fromStepNum
   put propArray ["from_SliceNum"] into fromSliceNum
   put _ConstructArrowItems (fromSide, fromStepNum, fromSliceNum) into fromItems
   set the from_Items of aView to fromItems
   --
   put propArray ["to_Side"] into toSide
   put propArray ["to_StepNum"] into toStepNum
   put propArray ["to_SliceNum"] into toSliceNum
   put _ConstructArrowItems (toSide, toStepNum, toSliceNum) into toItems
   set the to_Items of aView to toItems
   --
   dispatch "LayoutControl" to aView
   unlock screen
   --
   return aView
end grid_CreateArrowLink

private function _ConstructArrowItems sSide, sStepNum, sSliceNum
   if sStepNum is empty then put 1 into sStepNum
   if sSliceNum is empty then put 2 into sStepNum
   return sSide,sStepNum,sSliceNum
end _ConstructArrowItems


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
   if sBorder is empty then
      put "top" into sBorder
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


--> Grid | Delete
-
command grid_DeleteArrows gridView
   put the grid_ArrowIDs of gridView into cIDs
   --
   _DeleteControls cIDs, gridView
end grid_DeleteArrows

command grid_DeleteTiles gridView
   --  put the controlids of gridView into cIDs
   put the childControlIDs of gridView into cIDs
   --
   _DeleteControls cIDs, gridView
end grid_DeleteTiles


--> Grid | Geometry
-
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


--> Tiles | Create
-
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
         put default_FirstStackControl (tileType) into templateObject
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

private command _DeleteControls cIDs, gridView
   lock screen
   repeat for each line cID in cIDs
      delete control id cID of gridView
   end repeat
   unlock screen
end _DeleteControls
