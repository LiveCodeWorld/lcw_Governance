script "behavior_ViewGrid"
--> MetaData
-
copyright: David Bovill
license: GPLv3
name: behavior_ViewGrid
type: behavior
version: 0.2

local LocalArray


--> Working on
-
private command _ReizeGridTitles shapeData, frameRect
   put the childControlIDs of me into notGridIDs
   --
   put shapeData ["shape_Array"] into shapeArray
   --
   put shapeData ["grid_Dimensions"] into gridDimensions
   put shapeData ["title_Margins"] into titleMargins
   put item 1 of gridDimensions into tilesAcross
   put item 2 of gridDimensions into tilesDown
   
   lock screen
   set the wholematches to true
   repeat with itemNum = 1 to item 2 of the extents of shapeArray 
      put shapeArray [itemNum] into propArray
      put shapeArray [itemNum]["id"] into shortID
      --
      put lineOffset (shortID, notGridIDs) into foundLineNum
      delete line foundLineNum of notGridIDs
      --
      if exists (control id shortID of me) is false then
         next repeat
      else
         put the long id of control id shortID of me into tileObject
      end if
      
      put propArray ["tile_Points"] into tilePoints
      if tilePoints is empty then
         # Set the rect
         put propArray ["tile_Rect"] into tileRect
         put grid_GetRect (tileRect, frameRect, tilesAcross, tilesDown, titleMargins) into sRect
         set the rect of tileObject to sRect
      else
         # Set the points
         put tile_GetPoints (tilePoints, frameRect, tilesAcross, tilesDown) into sPoints
         set the points of tileObject to sPoints
      end if
   end repeat
   --
   put _ShouldShowText (shapeArray) into sBoolean
   _SetShowNames shapeArray, sBoolean
   --
   repeat for each line sID in notGridIDs
      dispatch "LayoutControl" to control id sID of me
   end repeat
   
   # Set group rect in case locked
   set lockmessages to true
   set the rect of me to frameRect
   set lockmessages to false
   --
   unlock screen
end _ReizeGridTitles

getprop layout_ObjectArray
   put the displayed_Data of me into dData
   put dData ["shape_Array"] into oArray
   return oArray
end layout_ObjectArray

getprop link_Names
   put the tile_Names of me into tNames
   return tNames
end link_Names

getprop tile_Names
   put the grid_View of the target into gridView
   --
   put the controlids of gridView into cIDs
   repeat for each line cID in cIDs
      put the short name of control id cID of gridView into tName
      put tName & CR after tNames
   end repeat
   delete char -1 of tNames
   return tNames
end tile_Names

getprop tile_Style
   put _TileObject() into tileObject
   --
   put the style of tileObject into tStyle
   switch tStyle
      case "text"
         return "rectangle" -- Livecode bug
      case "regular"
         put the polySides of tileObject into pNum
         switch pNum
            case 3
               return "triangle"
            case 4
               return "regular"
            case 5 
               return "pentagon"
            case 6
               return "hexagon"
            default
               return "regular"
         end switch
         break
      default
         return tStyle
   end switch
end tile_Style

getprop tile_Styles
   return "regular,-,triangle,rectangle,pentagon,hexagon,-,oval"
end tile_Styles

private function _TileObject
   return the long id of the target 
end _TileObject

setprop tile_Style tStyle
   put _TileObject() into tileObject
   lock screen
   switch tStyle
      case "Hexagon"
         set the style of tileObject to "regular"
         set the polySides of tileObject to 6
         set the angle of tileObject to 0
         break
      case "Pentagon"
         set the style of tileObject to "regular"
         set the polySides of tileObject to 5
         set the angle of tileObject to 53
         break
      case "Triangle"
         set the style of tileObject to "regular"
         set the polySides of tileObject to 3
         set the angle of tileObject to 30
         break
      case "regular"
         set the style of tileObject to "regular"
         set the polySides of tileObject to 4
         set the angle of tileObject to 45
         break
      case "rectangle"
      default
         set the style of tileObject to tStyle
         break
   end switch
   unlock screen
end tile_Style

getprop selected_Tile
   put _GetSelectedTileID() into sTileID
   put _TileObject (sTileID) into selectedTile
   return selectedTile
end selected_Tile

private function _GetNextIndexID shortID, shapeArray, pStepNum
   if pStepNum is empty then put 1 into pStepNum
   --
   put tile_GetNumber (shortID, shapeArray) into indexNum
   add pStepNum to indexNum
   put shapeArray [indexNum]["id"] into nextID
   --
   return nextID
end _GetNextIndexID

setprop selected_Tile tNameOrID
   put _GetSelectedTileID() into oldTileID
   -- put the selected_Tile of me into oldSelectedTile
   put _TileObject (oldTileID) into oldSelectedTile
   --
   switch tNameOrID
      case "previous"
         put _GetNextIndexID (oldTileID, shapeArray, -1) into nextID
         put _TileObject (nextID) into newSelectedTile
         break
      case "next"
         put _GetNextIndexID (oldTileID, shapeArray, 1) into nextID
         put _TileObject (nextID) into newSelectedTile
         break
      default
         put _TileObject (tNameOrID) into newSelectedTile
   end switch
   
   --
   lock screen
   if exists (newSelectedTile) then
      set the tile_Framed of newSelectedTile to true
      put the short id of newSelectedTile into sTileID
      _SetSelectedTileID sTileID
   end if
   if exists (oldSelectedTile) then
      set the tile_Framed of oldSelectedTile to false
   end if
   unlock screen
   --
   return newSelectedTile
end selected_Tile

private function _GetSelectedTileID
   return LocalArray ["selected_TileID"]
end _GetSelectedTileID

private command _SetSelectedTileID sTileID
   put sTileID into LocalArray ["selected_TileID"]
end _SetSelectedTileID

function tile_FromNumber indexNumber, shapeArray 
   switch tNameOrID
      case "previous"
         put _GetNextIndexID (oldTileID, shapeArray, -1) into nextID
         put _TileObject (nextID) into newSelectedTile
         break
      case "next"
         put _GetNextIndexID (oldTileID, shapeArray, 1) into nextID
         put _TileObject (nextID) into newSelectedTile
         break
      default
         put _TileObject (tNameOrID) into newSelectedTile
   end switch
end tile_FromNumber
   
private function _TileObject tNameOrID
   if tNameOrID is a number then
      if exists (control id tNameOrID of me) then
         return the long id of control id tNameOrID of me
      else
         return empty
      end if
   else
      if exists (control tNameOrID of me) then
         return the long id of control tNameOrID of me
      else
         return empty
      end if
   end if
end _TileObject

getprop tile_Framed
   put the long id of the target into tControl
   return the linesize of tControl is not 0
end tile_Framed

setprop tile_Framed sBoolean
   put the long id of the target into tControl
   if sBoolean is true then
      set the linesize of tControl to 8
   else
      set the linesize of tControl to 0
   end if
end tile_Framed

getprop tile_Faded
   put the long id of the target into tControl
   return the blendlevel of tControl is not 0
end tile_Faded

setprop tile_Faded sBoolean
   put the long id of the target into tControl
   if sBoolean is true then
      set the blendlevel of tControl to 90
   else
      set the blendlevel of tControl to 0
   end if
end tile_Faded


--> Events
-
on mouseUp
   put the tile_Framed of the target into sBoolean
   set the tile_Framed of the target to (sBoolean is false)
end mouseUp

on mouseDown pButtonNumber
   switch pButtonNumber
      case 3
         menu_PopUp "Global | Grid | Tile | Menu"
         break
      default
         --
   end switch
end mouseDown

on mouseDoubleUp
   put the tile_Faded of the target into sBoolean
   set the tile_Faded of the target to (sBoolean is false)
   
   /*
   put the tile_Rect of the target into testRect
   set the rect of the target to testRect
   */
end mouseDoubleUp

-- on preOpenCard
view_Init
pass preOpenCard
end preOpenCard

on resizeControl
   put the rect of me into frameRect
   LayoutControl frameRect
end resizeControl

command LayoutControl frameRect
   if frameRect is not a rect then put the rect of me into frameRect
   put the long id of me into gridView
   if the long id of the target is not gridView then
      return false
      -- pass LayoutControl
   end if
   --
   if the constrain_Grid of me is true then
      -- put rect_GetSquare (frameRect, 0) into frameRect
      put the tile_Proportions of me into tileProportions
      put item 1 of tileProportions into fWidth
      put item 2 of tileProportions into fHeight
      put rect_FitInside (fWidth, fHeight, frameRect) into frameRect
   end if
   
   # Get locally stored data
   put the shape_Data of me into shapeData
   --
   _ReizeGridTitles shapeData, frameRect
   return true
end LayoutControl


--> Props
-
getprop constrain_Grid
   return _GridValue ("constrain_Grid") is true
end constrain_Grid

setprop constrain_Grid [someRect] sBoolean
   _SetGridValue "constrain_Grid", sBoolean
   --
   put the result into shapeData
   LayoutControl someRect
   return shapeData
end constrain_Grid

getprop tile_Faded
   put the long id of the target into tControl
   return the blendlevel of tControl is not 0
end tile_Faded

setprop tile_Faded sBoolean
   put the long id of the target into tControl
   if sBoolean is true then
      set the blendlevel of tControl to 90
   else
      set the blendlevel of tControl to 0
   end if
end tile_Faded

getprop title_Margins
   return _GridValue ("title_Margins")
end title_Margins

setprop title_Margins tMargins
   _SetGridValue "title_Margins", tMargins
   --
   put the result into shapeData
   LayoutControl someRect
   return shapeData
end title_Margins

getprop tile_Proportions
   return _GridValue ("tile_Proportions")
end tile_Proportions

setprop tile_Proportions tProportions
   put the rect of me into oRect
   lock screen
   --
   switch tProportions
      case "Square"
      case "Square Tile"
         put the grid_Dimensions of me into tProportions
         break
      case "TV"
         put "4,3" into tProportions
         break
      case "Square Grid"
         put "1,1" into tProportions
         break
      case "cinema"
         put "16,9" into tProportions
         break
   end switch
   _SetGridValue "tile_Proportions", tProportions
   --
   put the result into shapeData
   LayoutControl oRect
   unlock screen
   return shapeData
end tile_Proportions

getprop grid_Dimensions
   return _GridValue ("grid_Dimensions")
end grid_Dimensions

setprop grid_Dimensions gridDimensions
   put the rect of me into frameRect
   _ReizeGridTitles shapeData, frameRect
   return the result
end grid_Dimensions

private function _GridValue pName
   put the shape_Data of me into shapeData
   put shapeData [pName] into gridValue
   return gridValue
end _GridValue

private command _SetGridValue pName, pValue
   put the shape_Data of me into shapeData
   put pValue into shapeData [pName]
   set the shape_Data of me to shapeData
   return shapeData
end _SetGridValue

getprop show_Names
   return LocalArray ["show_Names"]
end show_Names

setprop show_Names sBoolean
   put the shape_Array of me into shapeArray
   --
   _SetShowNames shapeArray, sBoolean
end show_Names

getprop shape_Array
   put the shape_Data of me into shapeData
   put shapeData ["shape_Array"] into shapeArray
   return shapeArray
end shape_Array

setprop shape_Array shapeArray
   put the shape_Data of me into shapeData
   put shapeArray into shapeData ["shape_Array"]
   set the shape_Data of me to shapeData
   return shapeData
end shape_Array

private command _SetShowNames shapeArray, sBoolean
   lock screen
   repeat with itemNum = 1 to item 2 of the extents of shapeArray 
      put shapeArray [itemNum] into propArray
      put shapeArray [itemNum]["id"] into shortID
      if exists (control id shortID of me) is false then next repeat
      put the long id of control id shortID of me into tileObject
      
      # Check control has showName property
      if word 1 of tileObject is among the items of "button,graphic" then
         if sBoolean is false then
            set the showName of tileObject to false
         else
            put propArray ["showname"] is not false into sBoolean
            set the showName of tileObject to sBoolean
         end if
      end if
   end repeat
   unlock screen
   --
   put sBoolean into LocalArray ["show_Names"]
end _SetShowNames

command view_Init
   LayoutControl frameRect 
end view_Init

private command _CreateShapesAndSetData @shapeData, pFrameRect
   if pFrameRect is empty then put the rect of me into pFrameRect
   put the long id of me into gridView
   --
   put shapeData ["shape_Array"] into shapeArray
   put shapeData ["grid_Dimensions"] into gridDimensions
   put item 1 of gridDimensions into tilesAcross
   put item 2 of gridDimensions into tilesDown
   --
   lock screen
   grid_Create shapeArray, gridView, pFrameRect, tilesAcross, tilesDown
   put the result into shapeArray
   unlock screen
   --
   put shapeArray into shapeData ["shape_Array"]
   set the shape_Data of me to shapeData
   return shapeArray
end _CreateShapesAndSetData

getprop tile_Num
   put the short id of the target into shortID
   put the shape_Array of me into shapeArray
   return tile_GetNumber (shortID, shapeArray)
end tile_Num

getprop tile_Rect
   put the tile_Num of the target into tileNum
   
   put the rect of me into frameRect
   put the shape_Data of me into shapeData
   
   put shapeData ["shape_Array"] into shapeArray
   put shapeData ["grid_Dimensions"] into gridDimensions
   put item 1 of gridDimensions into tilesAcross
   put item 2 of gridDimensions into tilesDown
   --
   put shapeArray [tileNum] into propArray
   put propArray ["tile_Rect"] into tileRect
   --
   put grid_GetRect (tileRect, frameRect, tilesAcross, tilesDown) into sRect
   return sRect
end tile_Rect


--> Grid | Model | Import
-
getprop grid_ShapeTitle
   put the shape_Data of me into shapeData
   put shapeData ["title"] into shapeTitle
   return shapeTitle
end grid_ShapeTitle

setprop grid_ShapeTitle [gridDimensions] shapeTitle
   # Get from stored model
   put grid_GetShapeData (shapeTitle) into shapeData
   if gridDimensions is not empty then
      put gridDimensions into shapeData ["grid_Dimensions"]
   end if
   
   # Create shapes and set shapeData
   _CreateShapesAndSetData shapeData
   return shapeData
end grid_ShapeTitle


--> Grid | Model | Local
-
getprop displayed_Data
   put the shape_Data of me into shapeData
   return shapeData
end displayed_Data

setprop displayed_Data shapeData
   put the rect of me into frameRect
   lock screen
   _CreateShapesAndSetData shapeData
   LayoutControl frameRect
   unlock screen
   return shapeData -- shapeData has ids set
end displayed_Data

command grid_DeleteTiles
   lock screen
   put the controlids of me into cIDs
   repeat for each line cID in cIDs
      set the cursor to busy
      delete control id cID of me
   end repeat
   unlock screen
end grid_DeleteTiles


--> Props
-
getprop prop_Array
   put the short id of the target into shortID
   --
   put the shape_Array of me into shapeArray
   repeat with itemNum = 1 to item 2 of the extents of shapeArray 
      put shapeArray [itemNum] into propArray
      if propArray  ["id"] = shortID then
         return propArray
      end if
   end repeat
   return empty
end prop_Array


--> Objects
-
getprop tile_Object
   put the short id of the target into shortID
   put the shape_Array of me into shapeArray
   return tile_GetObject (shortID, shapeArray)
end tile_Object

getprop grid_View
   return the long id of me
end grid_View

getprop layout_View
   return the long id of me
end layout_View

getprop view_Object
   return the long id of me
end view_Object


--> Private
-
private function _ShouldShowText shapeArray
   repeat with itemNum = 1 to item 2 of the extents of shapeArray 
      put shapeArray [itemNum] into propArray
      put propArray ["showname"] into shouldShow
      put shapeArray [itemNum]["id"] into shortID
      --
      if exists (control id shortID of me) is false then
         next repeat
      end if
      --
      put the height of the long id of control id shortID of me into tileHeight
      if tileHeight < 24 and shouldShow is not false then
         return false
      end if
   end repeat
   return true
end _ShouldShowText


--> Deps
-
function rect_GetProportioned sRect, xProportion, yProportion
   put item 3 of pRect - item 1 of pRect into sWidth
   put item 4 of pRect - item 2 of pRect into sHeight
   
   put rect_GetCentre (pRect) into rectCentre
   put rect_LocWidthHeight (rectCentre, rectWidth, rectHeight) into sRect
   put rect_FitInside (sWidth, sHeight, sRect) into newRect
   --
   return sRect
end rect_GetProportioned

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
   --
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
