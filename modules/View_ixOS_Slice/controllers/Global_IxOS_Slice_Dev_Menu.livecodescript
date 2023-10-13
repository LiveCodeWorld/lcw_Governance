script "Global | IxOS | Slice | Dev | Menu"
--> MetaData
-
license: GPLv3
name: Global | IxOS | Slice | Dev | Menu
type: controller
author: David Bovill
version: 0.1

/*
Here you can describe this menu.
Full help text should be provided on the linked wiki.
*/

--> Variables
-
local LocalArray

--> Menu | Props
-
getprop menu_Target [tObject]
   return the slice_View of tObject
end menu_Target


--> Global | IxOS | Slice | Dev | Menu
-
on menu_Formatted sliceView
   put the ix_View of sliceView into ixView
   put the data_Grid of ixView into dGrid
   --
   put the dgFormattedWidth of dGrid && the width of dGrid into someInfo
   put CR & the dgFormattedHeight of dGrid && the height of dGrid after someInfo
   put someInfo
end menu_Formatted

on menu_TidyTabStops ixView
   put the data_Grid of ixView into dGrid
   --
   put the width of dGrid &CR& the dgFormattedWidth of dGrid
   put the dgProp["column widths"] of dGrid into cWidths
   --
   -- put the dgProp["allow column resizing"] of group "Data Grid"
   -- put the dgProp["column labels"] of group "Data Grid"
   -- put the dgProp["columns"] of group "Data Grid"
   -- put the dgColumnIsResizable["col1"] of group "Data Grid"
     -- put the dgProp["scrollbar width"] of group "Data Grid"
   -- put the dgProp["visible columns"] of group "Data Grid"
end menu_TidyTabStops

on menu_SliceModuleFolder sliceView
   put the module_ModelFolder of sliceView into modelDataFolder
   finder_Reveal modelDataFolder
end menu_SliceModuleFolder

private on _
end _

on menu_UpdateLinked sliceView
   put the ix_View of sliceView into ixView
   dispatch "slice_UpdateLinked" to ixView
end menu_UpdateLinked

on menu_UpdateLinkedCharts sliceView
   put the ix_View of sliceView into ixView
   dispatch "ix_UpdateLinkedCharts" to ixView
end menu_UpdateLinkedCharts

private on __
end __

on menu_DatagridProperties sliceView
   put the ix_View of sliceView into ixView
   put the data_Grid of ixView into dgView
   display_ObjectProperties dgView
end menu_DatagridProperties

on menu_IxosProperties sliceView
   put the ix_View of sliceView into ixView
   display_ObjectProperties ixView
end menu_IxosProperties

private on ___
end ___

on menu_LayoutControl sliceView
   dispatch "LayoutControl" to sliceView
end menu_LayoutControl

on menu_LayoutArrows sliceView
   dispatch "LayoutArrows" to sliceView
end menu_LayoutArrows

on menu_ResizeControl sliceView
   dispatch "resizeControl" to sliceView
end menu_ResizeControl

private on ____
end ____

on menu_IxosBehaviors sliceView
   put the ix_View of sliceView into ixView
   display_ModuleBehaviors mView
end menu_IxosBehaviors

on menu_SliceBehavior sliceView
   put the behavior of sliceView into bObject
   edit the script of bObject
end menu_SliceBehavior

on menu_ChartBehavior sliceView
   put the chart_Widget of sliceView into chartWidget
   put the behavior of chartWidget into bObject
   edit the script of bObject
end menu_ChartBehavior

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

private on ______
end ______

on menu_ReplaceSubViews sliceView
   put the ix_View of sliceView into ixView
   view_Update ixView, false
end menu_ReplaceSubViews
