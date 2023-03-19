script "Global | Grid | Model | Line | Menu"
--> MetaData
-
copyright: David Bovill
license: GPLv3
name: Global | Grid | Model | Line | Menu
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

command _SetArrays displayView @shapeData, @propArray
   put the displayed_Data of displayView into shapeData
   --
   put the selected_Path of displayView into commaItems
   if item 1 of commaItems is not "shape_Array" then return empty
   --
   put item 1 to 2 of commaItems into arrayKey
   split arrayKey with comma
   put shapeData [arrayKey] into propArray
   --
   return commaItems
end _SetArrays

getprop moveTo_Param [displayView]
   put the selected_Path of displayView into commaItems
   put item 2 of commaItems into fromNum
   return fromNum
end moveTo_Param

getprop moveTo_Params
   return "1,2,3,4,5,6,7"
end moveTo_Params

getprop tileStyle_Param [displayView]
   put _TileObject (displayView) into tileObject
   return the tile_Style of tileObject
end tileStyle_Param

getprop tileStyle_Params [displayView]
   put _TileObject (displayView) into tileObject
   return the tile_Styles of tileObject
end tileStyle_Params

private function _TileObject displayView
   put the displayed_Object of displayView into gridView
   _SetArrays displayView, shapeData, propArray
   --
   put propArray ["id"] into shortID
   if exists (control id shortID of gridView) then
      put the long id of control id shortID of gridView into tileObject
      return tileObject
   else
      return empty
   end if
end _TileObject

private command _SetSelectedItemArray displayView, sValue, pName
   put the displayed_Object of displayView into gridView
   put the selected_Path of displayView into arrayKey
   if pName is not empty then
      put pName into item 3 of arrayKey
   end if
   split arrayKey with comma
   
   put the displayed_Data of displayView into shapeData
   put sValue into shapeData [arrayKey]
   set the displayed_Data of displayView to shapeData  
end _SetSelectedItemArray

private command _DeleteSelectedItemArray displayView, pName
   put the displayed_Object of displayView into gridView
   put the selected_Path of displayView into arrayKey
   if pName is not empty then
      put pName into item 3 of arrayKey
   end if
   split arrayKey with comma
   
   put the displayed_Data of displayView into shapeData
   delete variable shapeData [arrayKey]
   set the displayed_Data of displayView to shapeData  
end _DeleteSelectedItemArray


--> Global | Grid | Model | Line | Menu
-
on menu_SetControlType displayView
   put the displayed_Object of displayView into gridView
   --
   put "control_Type" into sKey
   put the selected_Value of displayView into someLine
   put lcw_Ask ("What type of control...", someLine) into newValue
   
   put the selected_Path of displayView into commaItems
   put sKey into item -1 of commaItems
   put commaItems into arrayKey
   
   put the displayed_Data of displayView into shapeData
   put the parent_Array of displayView into pArray
   put pArray ["id"] into shortID
   --
   split arrayKey with comma
   put newValue into shapeData [arrayKey]
   --
   breakpoint
   if exists (control id shortID of gridView) then
      set the sKey of control id shortID of gridView to newValue
      set the shape_Data of gridView to shapeData
   end if
   --
   set the displayed_Data of displayView to shapeData
end menu_SetControlType

on menu_TileStyle displayView, tStyle
   put _TileObject (displayView) into tileObject
   set the tile_Style of tileObject to tStyle
   --
   _DeleteSelectedItemArray displayView, "style"
   _SetSelectedItemArray displayView, tStyle, "tile_Style"
end menu_TileStyle

on menu_MoveTo displayView, toNum
   put the displayed_Data of displayView into shapeData
   put shapeData ["shape_Array"] into shapeArray
   put the selected_Path of displayView into commaItems
   put item 2 of commaItems into fromNum
   --
   array_IndexMove shapeArray, fromNum, toNum
   put shapeArray into shapeData ["shape_Array"]
   --
   set the displayed_Data of displayView to shapeData
end menu_MoveTo

private command _
end _

private command __
end __

on menu_AddProperty displayView
   put the displayed_Object of displayView into gridView
   put the selected_Path of displayView into commaItems
   put item 3 of commaItems into pName
   if pName is emty then put "icon_Name" into pName
   --
   put item 1 to 2 of commaItems into arrayKey
   put pName into item 3 of arrayKey
   split arrayKey with comma
   --
   put lcw_Ask ("Property name...", pName) into pName
   put lcw_Ask ("Property value...", "sitemap") into pValue
   
   # Set Displayed Data
   put the displayed_Data of displayView into shapeData
   put pValue into shapeData [arrayKey]
   set the displayed_Data of displayView to shapeData
   --
   
   # Set control props
   put "id" into arrayKey [3]
   put shapeData [arrayKey] into shortID
   if exists (control id shortID of gridView) then
      set the pName of control id shortID of gridView to pValue
      set the shape_Data of gridView to shapeData
   end if
end menu_AddProperty

on menu_DeleteProperty displayView
   put the selected_Path of displayView into arrayKey
   put item -1 of arrayKey into propName
   lcw_Answer "Delete value '[[propName]]'?", displayView, propName
   --
   put the displayed_Object of displayView into gridView
   split arrayKey with comma
   --
   put the displayed_Data of displayView into shapeData
   delete variable shapeData [arrayKey]
   set the displayed_Data of displayView to shapeData
   --
   set the shape_Data of gridView to shapeData
end menu_DeleteProperty

on menu_EditLine displayView
   grid_EditDisplayLine displayView
end menu_EditLine

private command ___
end ___

on menu_TestRect displayView
   _SetArrays displayView, shapeData, propArray
   --
   put shapeData ["grid_Dimensions"] into gridDimensions
   put item 1 of gridDimensions into tilesAcross
   put item 2 of gridDimensions into tilesDown
   --
   put propArray ["id"] into shortID
   --
   put the displayed_Object of displayView into gridView
   if exists (control id shortID of gridView) then
      put the rect of gridView into frameRect
      put the long id of control id shortID of gridView into tileObject
      --
      put propArray ["tile_Rect"] into tileRect
      put propArray ["tile_Points"] into tilePoints
      --
      switch
         case tilePoints is not empty
            put the tile_Rect of tileObject into sPoints
            put tile_GetPoints (tilePoints, frameRect, tilesAcross) into sPoints
            put sPoints
            set the points of tileObject to sPoints
            break
         case tileRect is not empty
            put grid_GetRect (tileRect, frameRect, tilesAcross, tilesDown) into sRect
            put the rect of tileObject
            set the rect of tileObject to sRect
            break
         default
            breakpoint
      end switch
   end if
end menu_TestRect
