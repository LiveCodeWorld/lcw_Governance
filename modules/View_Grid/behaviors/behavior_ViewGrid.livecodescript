script "behavior_ViewGrid"
--> MetaData
-
copyright: David Bovill
license: GPLv3
name: behavior_ViewGrid
type: behavior
version: 0.1

local LocalArray


--> Events
-
on mouseDoubleUp
   put the height of the target
   /*
   put the prop_Array of the target into propArray
   if propArray is an array then
      put propArray ["name"] into sName
      display_Data propArray, sName, "the prop_Array"
   end if
   */
end mouseDoubleUp

getprop prop_Array
   put the short id of the target into shortID
   --
   put the shape_Array of me into shapeArray
   repeat with itemNum = 1 to item 2 of the extents of shapeArray 
      put shapeArray [itemNum] into propArray
      if propArray  ["element id"] = shortID then
         return propArray
      end if
   end repeat
   return empty
end prop_Array

on resizeControl
   put the rect of me into frameRect
   --
   LayoutControl frameRect
end resizeControl

command LayoutControl frameRect
   if frameRect is not a rect then put the rect of me into frameRect
   put the long id of me into gridView
   put the shape_Array of gridView into shapeArray
   --
   if the keep_Square of me is true then
      put rect_GetSquare (frameRect, 0) into frameRect
   end if
   --
   put LocalArray ["tiles_Across"] into tilesAcross
   put LocalArray ["tiles_Down"] into tilesDown
   --
   _ReizeGridTitles shapeArray, frameRect, tilesAcross, tilesDown
end LayoutControl


--> Grid
-
private command _ReizeGridTitles shapeArray, frameRect, pTilesAcross, pTilesDown
   if pTilesAcross is empty then put 10 into pTilesAcross
   if pTilesDown is empty then put pTilesAcross into pTilesAcross
   
   lock screen
   set lockmessages to true
   set the rect of me to frameRect
   repeat with itemNum = 1 to item 2 of the extents of shapeArray 
      put shapeArray [itemNum] into propArray
      --
      put shapeArray [itemNum]["element id"] into shortID
      if exists (control id shortID of me) is false then
         next repeat
      end if
      
      put the long id of control id shortID of me into tileObject
      put propArray ["tile_Points"] into tilePoints
      if tilePoints is empty then
         put propArray ["tile_Rect"] into tileDimensions
         --
         put grid_GetRect (tileDimensions, frameRect, pTilesAcross, pTilesDown) into sRect
         set the rect of tileObject to sRect
         --
         /*
         put item 4 of sRect - item 2 of sRect into tileHeight 
         if tileHeight < 24 then
            set the showName of tileObject to false
         else
            put propArray ["showname"] is not false into sBoolean
            set the showName of tileObject to sBoolean
         end if
         */
      else
         -- put tile_GetPoints (tilePoints, frameRect, pTilesAcross) into sPoints
         -- set the points of tileObject to sPoints
      end if
   end repeat
   --
   set lockmessages to false
   --
   put _ShouldShowText (shapeArray) into sBoolean
   _SetShowNames shapeArray, sBoolean
   --
   unlock screen
   
   set the shape_Array of me to shapeArray
   --
   put pTilesAcross into LocalArray ["tiles_Across"]
   put pTilesDown into LocalArray ["tiles_Down"]
end _ReizeGridTitles

getprop show_Names
   return LocalArray ["show_Names"]
end show_Names
   
setprop show_Names sBoolean
   put the shape_Array of me into shapeArray
   --
   _SetShowNames shapeArray, sBoolean
end show_Names

private command _SetShowNames shapeArray, sBoolean
   lock screen
   repeat with itemNum = 1 to item 2 of the extents of shapeArray 
      put shapeArray [itemNum] into propArray
      put shapeArray [itemNum]["element id"] into shortID
      --
      if exists (control id shortID of me) is false then
         next repeat
      end if
      --
      put the long id of control id shortID of me into tileObject
      if sBoolean is false then
         set the showName of tileObject to false
      else
         put propArray ["showname"] is not false into sBoolean
         set the showName of tileObject to sBoolean
      end if
   end repeat
   unlock screen
   --
   put sBoolean into LocalArray ["show_Names"]
end _SetShowNames
   
private function _ShouldShowText shapeArray
   repeat with itemNum = 1 to item 2 of the extents of shapeArray 
      put shapeArray [itemNum] into propArray
      put propArray ["showname"] into shouldShow
      put shapeArray [itemNum]["element id"] into shortID
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

getprop grid_Dimensions
   put LocalArray ["tiles_Across"] into tilesAcross
   put LocalArray ["tiles_Down"] into tilesDown
   return tilesAcross,tilesDown
end grid_Dimensions

setprop grid_ShapeArray [gridDimensions] shapeArray
   local tilesAcross, tilesDown
   put the rect of me into frameRect
   --
   lock screen
   grid_DeleteTiles
   --
   if gridDimensions is not empty then
      put item 1 of gridDimensions into tilesAcross
      put item 2 of gridDimensions into tilesDown
      put tilesAcross into LocalArray ["tiles_Across"]
      put tilesDown into LocalArray ["tiles_Down"]
   end if
   --
   put the long id of me into gridView
   tile_Create shapeArray, gridView, frameRect, tilesAcross, tilesDown
   unlock screen
end grid_ShapeArray

setprop grid_Dimensions [shapeArray] gridDimensions
   put the rect of me into frameRect
   if shapeArray is not an array then
      put the shape_Array of me into shapeArray
   end if
   --
   put item 1 of gridDimensions into tilesAcross
   put item 2 of gridDimensions into tilesDown
   put tilesAcross into LocalArray ["tiles_Across"]
   put tilesDown into LocalArray ["tiles_Down"]
   -- comment   --
   _ReizeGridTitles shapeArray, frameRect, tilesAcross, tilesDown
end grid_Dimensions

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
getprop keep_Square
   return LocalArray ["keep_Square"] is true
end keep_Square

setprop keep_Square [someRect] sBoolean
   put sBoolean is true into LocalArray ["keep_Square"]
   LayoutControl someRect
end keep_Square
