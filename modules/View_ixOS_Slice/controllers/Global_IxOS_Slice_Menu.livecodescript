script "Global | IxOS | Slice | Menu"
--> MetaData
-
copyright: David Bovill
license: GPLv3
name: Global | IxOS | Slice | Menu
type: controller
version: 0.2


--> Variables
-
local LocalArray

--> Menu | Props
-
getprop menu_Target [tObject]
   -- called once for each menu
   return the display_View of tObject
end menu_Target

getprop colourPalette_Param [colourRecord]
   return the title_Text of colourRecord
end colourPalette_Param

getprop colourPalette_Params
   return colour_ListPaletteNames()
end colourPalette_Params

getprop checked_SideBySide [sliceView]
   put the side_BySide of sliceView into sideBySide
   return sideBySide
end checked_SideBySide

getprop innerMargin_Param [sliceView]
   return the inner_Margin of sliceView
end innerMargin_Param

getprop innerMargin_Params
   return "0,-,10,20,30,40"
end innerMargin_Params

getprop sliceData_Param [sliceView]
   put the displayed_Data of sliceView into displayedData
   put displayedData ["modelName"] into modelName
   if modelName is empty then
      put the view_ModelName of sliceView into modelName
   end if
   return modelName
end sliceData_Param

getprop sliceData_Params [ixView]
   put the module_ModelNames of ixView into modelNames
   return modelNames
end sliceData_Params

getprop display_Param [sliceView]
   put the ix_View of sliceView into ixView
   return the displayed_Column of ixView
end display_Param

getprop display_Params [sliceView]
   -- "Budget,Income,Shards,-,All"
   put the column_Names of sliceView into cNames
   line_Delete "Title", cNames
   replace CR with comma in cNames
   return cNames & ",-,All" 
end display_Params


--> Global | IxOS | Slice | Menu
-
on menu_SliceData sliceView, modelName
   put the module_Model [modelName] of sliceView into sTableData
   set the displayed_Data of sliceView to sTableData
end menu_SliceData

on menu_Display sliceView, cName
   set the displayed_Column of sliceView to cName
end menu_Display

on menu_SideBySide sliceView
   put the side_BySide of sliceView into sideBySide
   set the side_BySide of sliceView to (sideBySide is false)
end menu_SideBySide

private on _
end _

on menu_InnerMargin sliceView, sMargin
   set the inner_Margin of sliceView to sMargin
end menu_InnerMargin
   
on menu_ColourPalette sliceView, paletteTitle
   put colour_GetPalette (paletteTitle) into cPaletteData
   set the colour_PaletteData of sliceView to cPaletteData
end menu_ColourPalette


private on __
end __

on submenu_Chart
   return "Global | IxOS | Chart | Menu"
end submenu_Chart

on submenu_IxView
   return "Global | IxOS | Menu"
end submenu_IxView

private on ___
end ___

on menu_LayoutControl sliceView
   dispatch "LayoutControl" to sliceView
end menu_LayoutControl

on menu_UpdateViews sliceView
   put the ix_View of sliceView into ixView
   view_Update ixView, false
end menu_UpdateViews

private on ____
end ____

on menu_EditBehavior sliceView
   put the behavior of sliceView into bObject
   edit the script of bObject
end menu_EditBehavior

on menu_ChartBehavior sliceView
   put the chart_Widget of sliceView into chartWidget
   put the behavior of chartWidget into bObject
   edit the script of bObject
end menu_ChartBehavior

/*
on menu_IxChartData sliceView
   put the ix_View of sliceView into ixView
   put the chart_Widget of sliceView into chartWidget
   --
   put the chart_Data of ixView into cData
   set the displayed_Data of chartWidget to cData
   --
   display_Data cData, "ixView", "chart_Data"
end menu_IxChartData

on menu_ChartData sliceView
   put the chart_Widget of sliceView into chartWidget
   --
   put the chart_Data of chartWidget into cData
   put the title of chartWidget into cTitle
   --
   display_Data cData, cTitle, "chart_Data"
end menu_ChartData
*/
