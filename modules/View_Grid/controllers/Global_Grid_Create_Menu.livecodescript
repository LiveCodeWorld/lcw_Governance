script "Global | Grid | Create | Menu"
--> MetaData
-
copyright: David Bovill
license: GPLv3
name: Global | Grid | Create | Menu
type: controller
version: 0.1

/*Here you can describe this menu.
Full help text should be provided on the linked wiki.*/


--> Variables
-
local LocalArray

--> Menu | Props
-
getprop menu_Target [tObject]
   -- return display_MenuTarget(tObject)
   return the display_View of tObject
end menu_Target

getprop menu_Target [tObject]
   put the grid_View of tObject into gridView
   --
   put grid_ListShapeNames() into LocalArray ["MenuModelNames"]
   --
   return gridView
end menu_Target

getprop displayShapeData_Params [gridView]
   return LocalArray ["MenuModelNames"]
end displayShapeData_Params

function grid_ListShapeNames
   -- return "MVG,VSM,Right Bar,Bars,Cool,Block"
   put the hkey_CaseConditions ["F grid_ConstructShapeArray"] of me into shapeNames
   return shapeNames
end grid_ListShapeNames

function grid_ConstructShapeArray whichShape
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
end grid_ConstructShapeArray

private command _AddPropToNamedItem @shapeArray, someProp, someValue, pItemName
   put _FindItemNum (shapeArray, pItemName) into itemNum
   put someValue into shapeArray [itemNum][someProp]
end _AddPropToNamedItem

private command _AddShapeItem @shapeArray, someName, someColour, tileRect, pFontColour, pControlType
   put _ConstructItemArray (someName, someColour, tileRect, pFontColour, pControlType) into itemArray
   array_AddToNumbered shapeArray, itemArray
   put the result into lastItemNum
   return lastItemNum
end _AddShapeItem

private function _ConstructItemArray someName, someColour, tileRect, pFontColour, pControlType
   local itemArray
   
   put someName into itemArray ["name"]
   put 0 into itemArray ["linesize"]
   put someColour into itemArray ["backgroundcolor"]
   if pFontColour is not empty then
      put pFontColour into itemArray ["foregroundcolor"]
   end if
   --
   if tileRect is a rect then
      put tileRect into itemArray ["tile_Rect"]
   end if
   if pControlType is not empty then
      put pControlType into itemArray ["control_Type"]
   end if
   return itemArray
end _ConstructItemArray

private function _FindItemNum shapeArray, pItemName
   if pItemName is empty then
      return item 2 of the extents of shapeArray
   else
      repeat for each key testItemNum in shapeArray
         if shapeArray [testItemNum]["name"] = pItemName then
            return testItemNum
         end if
      end repeat
   end if
   return 0
end _FindItemNum

private function block_Shape
   local shapeArray
   --   
   _AddShapeItem shapeArray, "Guardians", "yellow", "1,1,7,3" 
   _AddShapeItem shapeArray, "Journals", "green", "1,4,7,6" 
   _AddShapeItem shapeArray, "Ecosystem", "light blue", "1,7,7,9" 
   
   # Platform
   _AddShapeItem shapeArray, "Platform", "dark gray", "7,1,9,9", "black"
   _AddPropToNamedItem shapeArray, "blendlevel", "0", "Platform"
   _AddPropToNamedItem shapeArray, "linesize", "0", "Platform"
   _AddPropToNamedItem shapeArray, "showname", "false", "Platform"
   
   # Platform Elements (need to be last)
   _AddShapeItem shapeArray, "Journal Platform", "dark green", "7.5,4.5,8.5,5.5"
   _AddPropToNamedItem shapeArray, "showname", "false", "Journal Platform"
   
   _AddShapeItem shapeArray, "Member Platform", "dark blue", "7.5,7.5,8.5,8.5"
   _AddPropToNamedItem shapeArray, "showname", "false", "Member Platform"
   
   _AddShapeItem shapeArray, "Money", "orange", "7.5,1.5,8.5,2.5"
   _AddPropToNamedItem shapeArray, "showname", "false", "Money"
   --
   put grid_ConstructShapeArray (shapeTitle) into shapeArray
end block_Shape

private function cool_Shape
   local shapeArray
   --   
   _AddShapeItem shapeArray, "Guardians", "yellow", "1,1,7,3" 
   _AddShapeItem shapeArray, "Journals", "green", "1,4,7,6" 
   _AddShapeItem shapeArray, "Ecosystem", "light blue", "1,7,7,9" 
   
   _AddShapeItem shapeArray, "Money", "orange", "7.5,1.5,8.5,2.5", empty, "View|Button|SVG"
   _AddPropToNamedItem shapeArray, "icon_Name", "money", "Money"
   
   _AddShapeItem shapeArray, "Journal Platform", "dark green", "7.5,4.5,8.5,5.5", empty, "View|Button|SVG"
   _AddPropToNamedItem shapeArray, "icon_Name", "beaker", "Money"
   
   _AddShapeItem shapeArray, "Member Platform", "blue", "7.5,7.5,8.5,8.5", empty, "View|Button|SVG"
   _AddPropToNamedItem shapeArray, "icon_Name", "sitemap", "Money"
   
   _AddShapeItem shapeArray, "Platform", "black", "7,3,9,9", "white"
   _AddPropToNamedItem shapeArray, "blendlevel", "70", "Platform"
   _AddPropToNamedItem shapeArray, "linesize", "0", "Platform"
   --
   put "8,1" into startPoint
   put startPoint into tilePoints
   put CR & "9,1|9,9|8,9" after tilePoints
   put CR & "8,8.2|7,8.2|7,7.8|8,7.8" after tilePoints
   put CR & "8,5.2|7,5.2|7,4.8|8,4.8" after tilePoints
   put CR & "8,2.2|7,2.2|7,1.8|8,1.8" after tilePoints
   put CR & startPoint after tilePoints
   --
   _AddPropToNamedItem shapeArray, "tile_Points", tilePoints, "Platform"
   _AddPropToNamedItem shapeArray, "showname", "false", "Platform"
   --
   return shapeArray
end cool_Shape

private function bar_Shape
   local shapeArray
   --   
   _AddShapeItem shapeArray, "Guardians", "yellow", "1,1,7,3" 
   _AddShapeItem shapeArray, "Journals", "green", "1,4,7,6" 
   _AddShapeItem shapeArray, "Ecosystem", "blue", "1,7,7,9" 
   
   _AddShapeItem shapeArray, "Money", "orange", "7,1,9,3", empty, "button"
   _AddPropToNamedItem shapeArray, "showname", "false", "Money"
   -- _AddPropToNamedItem shapeArray, "icon_Name", "money", "Money"
   
   _AddShapeItem shapeArray, "Platform", "black", "7,3,9,9", "white"
   _AddPropToNamedItem shapeArray, "blendlevel", "70", "Platform"
   _AddPropToNamedItem shapeArray, "linesize", "1", "Platform"
   _AddPropToNamedItem shapeArray, "tile_Points", "8,3|9,3|9,9|8,9|8,8|7,8|8,8|8,5|7,5|8,5|8,3", "Platform"
   _AddPropToNamedItem shapeArray, "showname", "false", "Platform"
   --
   return shapeArray
end bar_Shape

private function rightBar_Shape
   local shapeArray
   --   
   _AddShapeItem shapeArray, "Money", "red", "7,1,9,3" 
   _AddShapeItem shapeArray, "Guardians", "yellow", "1,1,6,3" 
   _AddShapeItem shapeArray, "Journals", "green", "1,4,6,6" 
   _AddShapeItem shapeArray, "Ecosystem", "blue", "1,7,6,9" 
   _AddShapeItem shapeArray, "Platform", "gray"
   --
   _AddPropToNamedItem shapeArray, "tile_Points", "8,4|9,4|9,9|8,9|8,4", "Platform"
   _AddPropToNamedItem shapeArray, "showname", "false", "Platform"
   --
   return shapeArray
end rightBar_Shape

function _GridShapeData xNum, yNum
   local shapeArray
   repeat with x= 0 to xNum
      repeat with y= 0 to yNum
         -- put "Tile" && x,y into sName
         put x,y into sName
         put colour_GetRandom() into rColour
         --
         put x into item 1 of tileRect
         put y into item 2 of tileRect
         put x+1 into item 3 of tileRect
         put y+1 into item 4 of tileRect
         --
         _AddShapeItem shapeArray, sName, rColour, tileRect
      end repeat
   end repeat
   --
   put grid_ConstructShapeData (shapeArray, "Grid Shape", "10,10") into shapeData
   return shapeData
end _GridShapeData

function _StepData
   local shapeArray
   --
   put 5 into maxX
   put 3 into maxY
   --
   repeat with y= 0 to maxY
      repeat with x= 0 to maxX
         -- put "Tile" && x,y into sName
         -- put x,y into sName
         put y * (maxX + 1) + x + 1 into stepNum
         put colour_GetRandom() into rColour
         --
         put x into item 1 of tileRect
         put y into item 2 of tileRect
         put x+1 into item 3 of tileRect
         put y+1 into item 4 of tileRect
         --
         put _ConstructItemArray (stepNum, rColour, tileRect) into itemArray
         put "oval" into itemArray ["style"]
         -- put "oval" into itemArray ["tile_Style"]
         --
         array_AddToNumbered shapeArray, itemArray
         put the result into lastItemNum
      end repeat
   end repeat
   --
   put grid_ConstructShapeData (shapeArray, "24 Steps", "6,4") into shapeData
   return shapeData
end _StepData


--> Global | Grid | Create | Menu
-
on menu_CreateGridShape
   put _GridShapeData (9,9) into shapeData
   display_GridShapeData shapeData
end menu_CreateGridShape

on menu_StepShape
   put _StepData() into shapeData
   display_GridShapeData shapeData
end menu_StepShape

private command _
end _

on menu_CreateBarShape
   put bar_Shape() into shapeArray
   --
   put grid_ConstructShapeData (shapeArray, "Bar Shape", "10,10") into shapeData
   display_GridShapeData shapeData
end menu_CreateBarShape

on menu_CreateCoolShape
   put cool_Shape() into shapeArray
   --
   put grid_ConstructShapeData (shapeArray, "Cool Shape", "10,10") into shapeData
   display_GridShapeData shapeData
end menu_CreateCoolShape

on menu_CreateRightBarShape
   put rightBar_Shape() into shapeArray
   --
   put grid_ConstructShapeData (shapeArray, "Right Bar Shape", "10,10") into shapeData
   display_GridShapeData shapeData
end menu_CreateRightBarShape

on menu_CreateMvg displayView
   local shapeArray
   --   
   _AddShapeItem shapeArray, "Guardians", "yellow", "1,1,11,3.5" 
   _AddShapeItem shapeArray, "Journals", "green", "1,4,11,6" 
   _AddShapeItem shapeArray, "Ecosystem", "light blue", "1,6.5,11,8.5" 
   _AddShapeItem shapeArray, "Members", "light yellow", "1,9,11,13" 
   
   # Platform
   _AddShapeItem shapeArray, "Platform", "dark gray", "11,1,13,13", "black"
   _AddPropToNamedItem shapeArray, "blendlevel", "0", "Platform"
   _AddPropToNamedItem shapeArray, "linesize", "0", "Platform"
   _AddPropToNamedItem shapeArray, "showname", "false", "Platform"
   
   # Platform Elements (need to be last)
   _AddShapeItem shapeArray, "Money Platform", "orange", "11.5,2,12.5,3"
   _AddPropToNamedItem shapeArray, "showname", "false", "Money Platform"
   
   _AddShapeItem shapeArray, "Journal Platform", "dark green", "11.5,4.5,12.5,5.5"
   _AddPropToNamedItem shapeArray, "showname", "false", "Journal Platform"
   
   _AddShapeItem shapeArray, "Jester Platform", "dark blue", "11.5,7,12.5,8"
   _AddPropToNamedItem shapeArray, "showname", "false", "Jester Platform"
   
   _AddShapeItem shapeArray, "Member Platform", "yellow", "11.5,9.5,12.5,12.5"
   _AddPropToNamedItem shapeArray, "showname", "false", "Member Platform"
   --
   put grid_ConstructShapeData (shapeArray, "MVG", "10,10") into shapeData
   display_GridShapeData shapeData
end menu_CreateMvg

on menu_CreateVsm
   local shapeArray
   --   
   _AddShapeItem shapeArray, "Guardians", "yellow", "1,1,7,3" 
   _AddShapeItem shapeArray, "Journals", "green", "1,4,6,6" 
   _AddShapeItem shapeArray, "Ecosystem", "light blue", "1,7,6,9" 
   
   _AddShapeItem shapeArray, "Money", "red", "7,1,9,3", empty, "View|Button|SVG"
   _AddPropToNamedItem shapeArray, "icon_Name", "money", "Money"
   
   _AddShapeItem shapeArray, "Platform", "black", "7,4,9,9", "white"
   _AddPropToNamedItem shapeArray, "tile_Points", "7,4|9,4|9,9|7,9|7,4", "Platform"
   _AddPropToNamedItem shapeArray, "showname", "false", "Platform"
   --
   --
   put grid_ConstructShapeData (shapeArray, "VSM", "10,10") into shapeData
   display_GridShapeData shapeData
end menu_CreateVsm
