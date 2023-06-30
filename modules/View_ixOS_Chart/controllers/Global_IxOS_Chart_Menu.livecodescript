script "Global | IxOS | Chart | Menu"
--> MetaData
-
copyright: David Bovill
license: GPLv3
name: Global | IxOS | Chart | Menu
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
   put the chart_Widget of tObject into chartWidget
   return chartWidget
end menu_Target

getprop chartType_Param [chartWidget]
   put the chartType of chartWidget into someType
   return someType
end chartType_Param

getprop chartType_Params
   return "pie,doughnut,radar"
end chartType_Params

getprop legendPosition_Param [chartWidget]
   put the legendPosition of chartWidget into sPosition
   return sPosition
end legendPosition_Param

getprop legendPosition_Params
   return "top,left,bottom,right"
end legendPosition_Params

getprop checked_ShowLegend [chartWidget]
   put the showLegend of chartWidget into sBoolean
   return sBoolean
end checked_ShowLegend

getprop checked_ShowScale [chartWidget]
   put the show_Scale of chartWidget into sBoolean
   return sBoolean
end checked_ShowScale

getprop checked_ShowTitle [chartWidget]
   put the showTitle of chartWidget into sBoolean
   return sBoolean
end checked_ShowTitle

getprop backgroundDataColors_Param [chartWidget]
   return the dataColor_Title of chartWidget
end backgroundDataColors_Param

getprop backgroundDataColors_Params
   return colour_ListPaletteNames()
end backgroundDataColors_Params

getprop checked_ShowChart [chartWidget]
   return the visible of chartWidget
end checked_ShowChart

getprop disabled_ShowChart [chartWidget]
   return exists (chartWidget) is false
end disabled_ShowChart


--> Global | IxOS | Chart | Menu
-
on menu_ShowChart chartWidget
   put the visible of chartWidget into isShowing
   set the visible of chartWidget to (isShowing is false)
end menu_ShowChart

private command ___
end ___

on menu_SetTitle chartWidget
   put the label of chartWidget into cTitle
   put lcw_Ask ("Set the chart title...", cTitle, "Chart", chartWidget) into cTitle
   set the label of chartWidget to cTitle
end menu_SetTitle

on menu_ShowTitle chartWidget
   put the showTitle of chartWidget into sBooean
   set the showTitle of chartWidget to (sBooean is false)
end menu_ShowTitle

private on _
end _

on menu_ChartType chartWidget, someType
   set the chartType of chartWidget to someType
end menu_ChartType

on menu_ShowScale chartWidget
   put the show_Scale of chartWidget into sBoolean
   set the show_Scale of chartWidget to (sBoolean is false)
end menu_ShowScale

on menu_ShowLegend chartWidget
   put the showLegend of chartWidget into sBoolean
   set the showLegend of chartWidget to (sBoolean is false)
end menu_ShowLegend

on menu_LegendPosition chartWidget, sPosition
   set the legendPosition of chartWidget to sPosition
end menu_LegendPosition

private on __
end __

on menu_BackgroundDataColors chartWidget, paletteTitle
   set the dataColor_Title of chartWidget to paletteTitle
   --
   put colour_GetPalette (paletteTitle) into colourPaletteData
   put colourPaletteData ["palette"] into paletteArray
   put colorMind_PaletteArrayToIndex (paletteArray) into rgbColours
   --
   put the backgroundDataColors of chartWidget into oColours
   put the number of lines of oColours into oMaxNum
   put the number of lines of rgbColours into rgbMaxNum
   if rgbMaxNum > oMaxNum then
      set the backgroundDataColors of chartWidget to line 1 to oMaxNum of rgbColours
   else
      put rgbColours into line 1 to rgbMaxNum of oColours
      set the backgroundDataColors of chartWidget to oColours
   end if
end menu_BackgroundDataColors

on menu_DisplayDataColors chartWidget
   put the backgroundDataColors of chartWidget into bColorData
   put the title of chartWidget into cTitle
   --
   display_Data bColorData, cTitle, "backgroundDataColors"
end menu_DisplayDataColors

private on ___
end ___

on menu_ChartData chartWidget
   put the chart_Data of chartWidget into cData
   put the title of chartWidget into cTitle
   --
   display_Data cData, cTitle, "chart_Data"
end menu_ChartData

on menu_ChartOptions chartWidget
   put the chart_OptionsData of chartWidget into cOptionsData
   put the title of chartWidget into cTitle
   --
   display_Data cOptionsData, cTitle, "chart_OptionsData"
end menu_ChartOptions
