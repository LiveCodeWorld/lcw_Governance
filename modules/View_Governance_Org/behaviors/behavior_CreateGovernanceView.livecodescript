script "behavior_CreateGovernanceView" with behavior "behavior_ViewGovernanceOrg"
--> MetaData
-
copyright: David Bovill
license: GPLv3
name: behavior_CreateGovernanceView
type: behavior
version: 0.1

/*
These handlers are for creating new layouts for the goverenance view.
They are removed here as authoring tools that have a lot of dependencies.
These handlers are not requird to use the module once it has been created.

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
*/

local LocalArray


--> Working On
-
function tile_GetAcross
   return 10
   --
   put LocalArray ["tiles_Across"] into tilesAcross
   return tilesAcross
end tile_GetAcross

private command _SetProps someControl, cPropArray
   repeat for each key propName in cPropArray
      if the number of words of propName > 1 then
         next repeat -- "id"
      end if
      --
      put cPropArray [propName] into propValue
      set the propName of someControl to propValue
   end repeat
end _SetProps

setprop element_Array [tilesAcross] eArray
   lock screen
   put the element_Views of me into allIDs
   repeat for each key itemNum in eArray 
      put eArray [itemNum] into cPropArray
      --
      put _ControlFromArray (cPropArray) into someControl
      if exists (someControl) is false then
         _CreateControlFromArray cPropArray, tilesAcross
         put the result into someControl
         --
         _SetProps someControl, cPropArray
         next repeat
      end if
      --
      put the short id of someControl into usedID
      put usedID into eArray [itemNum]["id"]
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
      _SetProps someControl, cPropArray
      -- _AutoSetShowName someControl
   end repeat
   --
   init_LocalArray eArray
   --
   repeat for each line badID in allIDs
      delete control id badID of me
   end repeat
   LayoutControl -- not sure why this is needed
   unlock screen
   return eArray
end element_Array


--> Create
-
private command _CreateControlFromArray cPropArray, pTilesAcross
   put cPropArray ["name"] into someName
   put cPropArray ["backgroundcolor"] into someColour
   put cPropArray ["tile_Rect"] into tileRect
   put cPropArray ["control_Type"] into cType
   --
   put the square_Rect of me into squareRect
   put tile_GetRect (tileRect, squareRect, pTilesAcross) into eRect
   --
   _CreateControlObject someName, eRect, someColour, cType
   put the result into someControl
   return someControl
end _CreateControlFromArray

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


--> Props
-

setprop tiles_Across tilesAcross
   put tilesAcross ^ 2 into gridNum
   _SetGridNum gridNum
end tiles_Across

getprop grid_Num   
   put tile_GetAcross() into tilesAcross
   return tilesAcross ^ 2
end grid_Num

setprop grid_Num gridNum
   _SetGridNum gridNum
end grid_Num

getprop grid_Array
   put tile_GetAcross() into tilesAcross
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
         put grid_GetLoc (x, y, startX, startY, tileWidth) into someLoc
         put someLoc into gridArray [x,y]
      end repeat
   end repeat
   
   return gridArray
end grid_Array

getprop grid_RectArray
   put the grid_Num of me into gridNum
   
   put the square_Rect of me into squareRect
   put item 3 of squareRect - item 1 of squareRect into squareWidth
   put gridNum ^ 0.5 into rowNum
   put squareWidth/rowNum into nWidth
   
   put grid_ConstructRectArray (squareRect, nWidth, gridNum) into rectArray
   return rectArray
end grid_RectArray

getprop grid_Control [gridNum]
   put _GetGridControl (gridNum) into gridControl
   return gridControl
end grid_Control

getprop tile_View [gridNum]
   put _GetGridControl (gridNum) into gridControl
   put the view_Name of gridControl into vName
   return vName
end tile_View

setprop tile_View [gridNum] vName
   put _getGridControl (gridNum) into gridControl
   set the control_Type of gridControl to vName
end tile_View


--> Functions
-
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


--> Private
-
private function _GetGridControl gridNum
   put the childControlIDs of me into childIDs
   put line gridNum of childIDs into childID
   if childID is empty then return empty
   put the long id of control id childID of me into gridControl
   return gridControl
end _GetGridControl

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

private command _SetGridNum gridNum
   put the element_Views of me into childIDs
   --
   lock screen
   put gridNum ^ 0.5 into tilesAcross
   if tilesAcross is not an integer then return empty
   
   put tilesAcross into LocalArray ["tiles_Across"]
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
end _SetGridNum

