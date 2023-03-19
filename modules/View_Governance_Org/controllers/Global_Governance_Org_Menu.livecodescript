script "Global_Governance_Org_Menu"
--> MetaData
-
license: GPLv3
name: Global_Governance_Org_Menu
type: controller
version: 0.1

local LocalArray


--> Menu | Props
-
getprop menu_Target [tObject]
   return the org_View of tObject
   -- return display_MenuTarget(tObject)
   -- return the display_View of tObject
end menu_Target

getprop shape_Param
   return LocalArray ["which_Shape"]
end shape_Param

getprop shape_Params
   return "VSM,Right Bar,Bars,Cool,Block"
end shape_Params

getprop buttonView_Param [gridView]
   put the button_View of gridView into btnView
   return true
end buttonView_Param

getprop buttonView_Params [gridView]
   return "true,false"
end buttonView_Params

getprop fixedSquare_Param [gridView]
   put the fixed_Square of gridView into someBoolean
   return someBoolean
end fixedSquare_Param

getprop fixedSquare_Params
   return "true,false"
end fixedSquare_Params

getprop showBorders_Param [gridView]
   return the show_Borders of gridView
end showBorders_Param

getprop showBorders_Params
   return "true,false"
end showBorders_Params

getprop showNames_Param [gridView]
   return the show_Names of gridView
end showNames_Param

getprop showNames_Params
   return "true,false"
end showNames_Params

getprop tilesAcross_Param [gridView]
   return the tiles_Across of gridView
end tilesAcross_Param

getprop tilesAcross_Params
   return "1,2,3,4,5,6,7,8,9,10"
end tilesAcross_Params


--> Global | Governance | Org | Menu
-
on menu_Shape gridView, whichShape
   lock screen
   --
   put tile_GetShapeArray (whichShape) into shapeArray
   put whichShape into LocalArray ["which_Shape"]
   set the element_Array [10] of gridView to shapeArray
   -- set the show_Names of gridView to true
   --
   unlock screen
end menu_Shape

on menu_FixedSquare gridView, someBoolean
   set the fixed_Square of gridView to someBoolean
end menu_FixedSquare

private command __
end __

on menu_TilesAcross gridView, tileNum
   set the tiles_Across of gridView to tileNum
end menu_TilesAcross

on menu_ButtonView gridView, someBoolean
   set the button_View of gridView to someBoolean
end menu_ButtonView

on menu_ShowNames gridView, someBoolean
   set the show_Names of gridView to someBoolean
end menu_ShowNames

on menu_ShowBorders gridView, someBoolean
   set the show_Borders of gridView to someBoolean
end menu_ShowBorders

private command ___
end ___

on submenu_Test
   return "Global | Governance | Org | Test | Menu"
end submenu_Test
