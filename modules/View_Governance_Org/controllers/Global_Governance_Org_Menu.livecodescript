script "Global_Governance_Org_Menu"
--> MetaData
-
license: GPLv3
name: Global_Governance_Org_Menu
type: controller
version: 0.1

local LocalArray


--> Global | Governance | Org | Menu
-
on menu_Shape gridView, whichShape
   lock screen
   --
   put whichShape into LocalArray ["which_Shape"]
   switch whichShape
      case "VSM"
         set the element_Array [10] of gridView to vsm_Shape()
         break
      case "Right Bar"
         set the element_Array [10] of gridView to rightBar_Shape()
         break
      case "Bars"
         set the element_Array [10] of gridView to bar_Shape()
         break
      case "Cool"
         set the element_Array [10] of gridView to cool_Shape()
         break
      case "Block"
         set the element_Array [10] of gridView to block_Shape()
         break
   end switch
   
   -- set the show_Names of gridView to true
   unlock screen
end menu_Shape

on _
end _

on menu_ButtonView gridView, someBoolean
   set the button_View of gridView to someBoolean
end menu_ButtonView

on menu_TilesAcross gridView, tileNum
   set the tiles_Across of gridView to tileNum
end menu_TilesAcross

on menu_ShowNames gridView, someBoolean
   set the show_Names of gridView to someBoolean
end menu_ShowNames

on menu_ShowBorders gridView, someBoolean
   set the show_Borders of gridView to someBoolean
end menu_ShowBorders

on _
end _

on menu_DisplayGridArray gridView
   put the grid_Array of gridView into gridArray
   display_Array gridArray
end menu_DisplayGridArray

on menu_DisplayGridRectArray gridView
   put the grid_RectArray of gridView into gridRectArray
   display_Array gridRectArray
end menu_DisplayGridRectArray

on _
end _

on menu_FixedSquare gridView, someBoolean
   set the fixed_Square of gridView to someBoolean
end menu_FixedSquare

getprop fixed_Square [gridView]
   put the fixed_Square of gridView into someBoolean
   return someBoolean
end fixed_Square
   
on menu_Graphic gridView
   put the control_Type of btn "Platform" of gridView
   set the control_Type of btn "Platform" of gridView to "graphic"
end menu_Graphic


--> Global | Governance | Org | Menu | Props
-
getprop button_View [gridView]
   return the button_View of gridView
end button_View

getprop show_Borders [gridView]
   return the show_Borders of gridView
end show_Borders

getprop show_Names [gridView]
   return the show_Names of gridView
end show_Names

getprop tile_Num [gridView]
   return the tiles_Across of gridView
end tile_Num

getprop tile_Nums
   return "1,2,3,4,5,6,7,8,9,10"
end tile_Nums

getprop which_Shape
   return LocalArray ["which_Shape"]
end which_Shape


--> Global | Governance | Org | Menu | Disabled
-


--> Private
-
private function block_Shape
   local eArray
   --   
   _AddShapeItem eArray, "Guardians", "yellow", "1,1,7,3" 
   _AddShapeItem eArray, "Journals", "green", "1,4,7,6" 
   _AddShapeItem eArray, "Ecosystem", "light blue", "1,7,7,9" 
   
   _AddShapeItem eArray, "Money", "orange", "7.5,1.5,8.5,2.5"
   _AddPropToNamedItem eArray, "showname", "false", "Money"
   -- _AddShapeItem eArray, "Money", "red", "7,1,9,3"
   -- _AddPropToNamedItem eArray, "visible", "true", "Money"
   
   put "Journal Platform" into eName
   _AddShapeItem eArray, eName, "dark green", "7.5,4.5,8.5,5.5"
   _AddPropToNamedItem eArray, "showname", "false", eName
   
   put "Member Platform" into eName
   _AddShapeItem eArray, eName, "dark blue", "7.5,7.5,8.5,8.5"
   _AddPropToNamedItem eArray, "showname", "false", eName
   
   _AddShapeItem eArray, "Platform", "dark gray", "7,1,9,9", "black"
   _AddPropToNamedItem eArray, "blendlevel", "0", "Platform"
   _AddPropToNamedItem eArray, "linesize", "0", "Platform"
   _AddPropToNamedItem eArray, "showname", "false", "Platform"
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

