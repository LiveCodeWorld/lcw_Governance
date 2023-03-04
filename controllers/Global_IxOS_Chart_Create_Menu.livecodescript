script "Global | IxOS | Chart | Create | Menu"
--> MetaData
-
copyright: David Bovill
license: GPLv3
name: Global | IxOS | Chart | Create | Menu
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
   put the ix_View of tObject into ixView
   if exists (ixView) is false then
      put the display_View of tObject into dView
      put the displayed_Object of dView into ixView
   end if
   
   put _LinkedDisplayChartNames (ixView) into LinkedDisplayChartNames
   put LinkedDisplayChartNames into LocalArray ["LinkedDisplayChartNames"]
   --
   put ix_ListDisplayChartNames() into OpenDisplayChartNames
   put OpenDisplayChartNames into LocalArray ["OpenDisplayChartNames"]
   --
   put _ListCardCharts (ixView) into LocalArray ["AllCardChartNames"]
   return ixView
end menu_Target

private function _ListCardCharts ixView
   put the card_Object of ixView into cardObject 
   if exists (cardObject) is false then
      return empty
   end if
   
   return the top_ChartNames of cardObject
end _ListCardCharts

private function _LinkedDisplayChartNames ixView
   put the linked_Data of ixView into linkedData
   put the stack_Name of ixView into stackName
   -- put the card_Object of ixView into cObject
   if exists (stack stackName) is false then
      return empty
   end if
   put the name of stack stackName into ixStack -- to check if on this stack
   --
   repeat with itemNum = 1 to item 2 of the extents of linkedData
      put linkedData [itemNum]["chartObject"] into chartObject
      if exists (chartObject) is false then next repeat
      --
      if chartObject ends with ixStack then
         -- could be on another card
      else
         put the stack_Name of chartObject & CR after linkedChartDisplays
      end if
   end repeat
   delete char -1 of linkedChartDisplays
   return linkedChartDisplays
end _LinkedDisplayChartNames

private function _ChartWidget ixView
   put the card_Object of ixView into cardObject
   put the long id of widget "Chart" of cardObject into chartWidget
   return chartWidget
end _ChartWidget

private function _PieChart ixView
   put the card_Object of ixView into cardObject
   put the long id of widget "Pie Chart" of cardObject into pieChart
   return pieChart
end _PieChart

command display_IxChart ixView, someCSV, cTitle
   put the view_ModelName of ixView into cTitle
   --
   display_Clone "View|ixOS|Chart", "Chart", someCSV
   put the result into chartWidget
   set the title of chartWidget to cTitle
   return chartWidget
end display_IxChart

getprop disabled_LinkCardChart [ixView]
   return LocalArray ["AllCardChartNames"] is empty
end disabled_LinkCardChart

getprop linkCardChart_Param [ixView]
   put the linked_CardChartNames of ixView into linkedChartNames
   return linkedChartNames
end linkCardChart_Param

getprop linkCardChart_Params [ixView]
   return LocalArray ["AllCardChartNames"]
end linkCardChart_Params

getprop disabled_LinkChartDisplay [ixView]
   return LocalArray ["OpenDisplayChartNames"] is empty
end disabled_LinkChartDisplay

getprop linkChartDisplay_Param [ixView]
   return LocalArray ["LinkedDisplayChartNames"]
end linkChartDisplay_Param

getprop linkChartDisplay_Params [ixView]
   return LocalArray ["OpenDisplayChartNames"]
end linkChartDisplay_Params

getprop disabled_ClearLinkedCharts [ixView]
   put the linked_Data of ixView into linkedData
   return linkedData is not an array
end disabled_ClearLinkedCharts


--> Global | IxOS | Chart | Create | Menu
-
on menu_LinkCardChart ixView, chartName
   put the card_Object of ixView into cardObject
   --
   put the long id of widget chartName of cardObject into chartObject
   if mArray_GetChecked (the params, "Global | IxOS | Chart | Create | Menu") is true then
      set the linked_Chart [true] of ixView to chartObject
   else
      set the linked_Chart of ixView to chartObject
   end if
end menu_LinkCardChart

on menu_LinkChartDisplay ixView, stackName
   put the long id of control 1 of cd 1 of stack stackName into chartObject
   -- if stackName is among the lines of LocalArray ["LinkedDisplayChartNames"] then
   if mArray_GetChecked (the params, "Global | IxOS | Chart | Create | Menu") is true then
      set the linked_Chart [true] of ixView to chartObject
   else
      set the linked_Chart of ixView to chartObject
   end if
end menu_LinkChartDisplay

on menu_ClearLinkedCharts ixView
   -- set the linked_Data of ixView to empty
   -- set the custom_Delete of ixView to "linked_Data"
   dispatch "clear_LinkedData" to ixView
end menu_ClearLinkedCharts
   
private command _
end _

on menu_CreateLinkedChart ixView
   put the short name of ixView into ixName
   put the dg_Rect of ixView into cRect
   put the card_Object of ixView into cObject
   --
   view_Insert "View|ixOS|Chart", cObject, cRect, ixName
   -- view_InsertObject "View|ixOS|Chart", cObject, cRect
   put the result into newChart
   --
   set the linked_Chart of ixView to newChart
end menu_CreateLinkedChart

