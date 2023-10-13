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
   put the slice_View of tObject into sliceView
   if exists (sliceView) is false then put _DisplayedSlice(tObject) into sliceView
   
   put the link_Names of sliceView into linkNames
   put the short name of sliceView into myName
   line_Delete myName, linkNames
   put linkNames into LocalArray ["Other linkNames"]
   --
   return sliceView
end menu_Target

private function _DisplayedSlice tObject
   put the display_View of tObject into displayView
   put the displayed_Object of displayView into viewObject
   if exists (viewObject) then
      return viewObject
   else
      return displayView
   end if 
end _DisplayedSlice

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

getprop checked_ShowBackground [sliceView]
   put the show_Background of sliceView into sBoolean
   return sBoolean
end checked_ShowBackground

getprop checked_ShowChartOnly [sliceView]
   put the show_ChartOnly of sliceView into sBoolean
   return sBoolean
end checked_ShowChartOnly

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

getprop linkTo_Param [fromSlice]
   put the to_Arrows of fromSlice into toArrows
   repeat for each line toArrow in toArrows
      if exists (toArrow) is true then
         put the to_Name of toArrow into tName
         put tName & comma after tNames
      end if
   end repeat
   delete char -1 of tNames
   return tNames
end linkTo_Param

getprop linkTo_Params [fromSlice]
   return LocalArray ["Other linkNames"]
end linkTo_Params

getprop linkFrom_Param [fromSlice]
   put LocalArray ["Other linkNames"] into linkNames
   repeat for each line someLine in linkNames
      if word -1 of someLine = "Slice" then delete word-1 of someLine
      put someLine & CR after fromNames
   end repeat
   delete char -1 of fromNames
   return fromNames
end linkFrom_Param

getprop linkFrom_Params [fromSlice]
   return the slice_Titles of fromSlice
   return LocalArray ["Other linkNames"]
end linkFrom_Params

getprop checked_Iconify [sliceView]
   put the original_Rect of sliceView into oRect
   put the rect of sliceView into sRect
   return sRect is oRect
end checked_Iconify


--> Global | IxOS | Slice | Menu
-
on menu_FormattedHeight sliceView
   put the formatted_Height of sliceView into fHeight
   --
   put the rect of sliceView into someRect
   rect_SetHeight someRect, fHeight
   set the rect of sliceView to someRect
end menu_FormattedHeight

on menu_Iconify sliceView
   put the rect of sliceView into sRect
   put the loc of sliceView into sLoc
   put the original_Rect of sliceView into oRect
   --
   if sLoc = oRect then
      set the rect of sliceView to oRect
   else
      put rect_LocWidthHeight (sLoc, 100, 100) into zRect
      set the rect of sliceView to zRect
      set the original_Rect of sliceView to sRect
   end if
end menu_Iconify

on menu_TrelloPalette
   display_TrelloOrganisations
end menu_TrelloPalette

on menu_LinkFrom toSlice, fromName
   dispatch "create_FromArrow" to toSlice with fromName
end menu_LinkFrom

on menu_LinkTo fromSlice, toName
   dispatch "create_ToArrow" to fromSlice with toName
end menu_LinkTo

private on ____
end ____

on menu_SliceData sliceView, modelName
   put the module_Model [modelName] of sliceView into sTableData
   set the displayed_Data of sliceView to sTableData
end menu_SliceData

-- on menu_ExportSliceData sliceView
end menu_ExportSliceData

on menu_Display sliceView, cName
   set the displayed_Column of sliceView to cName
end menu_Display

on menu_SideBySide sliceView
   put the side_BySide of sliceView into sideBySide
   set the side_BySide of sliceView to (sideBySide is false)
end menu_SideBySide

on menu_ShowChartOnly sliceView
   put the show_ChartOnly of sliceView into sBoolean
   set the show_ChartOnly of sliceView to (sBoolean is false)
end menu_ShowChartOnly

on menu_ShowBackground sliceView
   put the show_Background of sliceView into sBoolean
   set the show_Background of sliceView to (sBoolean is false)
end menu_ShowBackground

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

on submenu_Dev
   return menu_DevTitle()
end submenu_Dev
