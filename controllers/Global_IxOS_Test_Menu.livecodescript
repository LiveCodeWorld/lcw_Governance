script "Global | IxOS | Test | Menu"
--> MetaData
-
copyright: Anonymous
license: GPLv3
name: Global | IxOS | Test | Menu
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
   --
   put the displayed_Data of ixView into vData
   put vData into LocalArray ["displayed_Data"]
   --
   put the displayed_AbbreviatedData of ixView into aData
   put aData into LocalArray ["displayed_AbbreviatedData"]
   --
   put the view_ModelName of ixView into vName
   put the saved_Data [vName] of ixView into savedData
   put savedData into LocalArray ["saved_Data"]
   --
   put the module_ModelNames of ixView into modelNames
   put modelNames into LocalArray ["module_ModelNames"]
   --
   return ixView
end menu_Target

private function _Formats
   return "short,abbreviated,number"
end _Formats

getprop checked_ShowTable [ixView]
   put the show_Table of ixView into sBoolean
   return sBoolean
end checked_ShowTable

getprop displaySaved_Param [ixView]
   return the display_Format of ixView
end displaySaved_Param

getprop displaySaved_Params
   return _Formats()
end displaySaved_Params

getprop displayed_Param [ixView]
   return the display_Format of ixView
end displayed_Param

getprop displayed_Params
   return _Formats()
end displayed_Params


--> Global | IxOS | Test | Menu
-
on menu_IxInspector ixView
   display_ObjectProperties ixView
end menu_IxInspector

on menu_GridInspector ixView
   put the data_Grid of ixView into dView
   display_ObjectProperties dView
end menu_GridInspector

private on _
end _

on menu_IxBehavior ixView
   put the behavior of ixView into bObject
   edit the script of bObject
end menu_IxBehavior

on menu_DataGridBehavior ixView
   put the data_Grid of ixView into dView
   put the behavior of dView into bObject
   edit the script of bObject
end menu_DataGridBehavior

private on _
end _

on menu_DisplayLinkedFrom fromView
   put the ix_LinkArray of fromView into ixLinkArray
   put linkArray_Reverse (ixLinkArray) into reverseLinkArray
   --
   display_LinkArrayGraph reverseLinkArray, "fast undirected spring"
   display_LinkArray reverseLinkArray
end menu_DisplayLinkedFrom

on menu_DisplayFindLinks fromView
   put the ix_LinkArray of fromView into ixLinkArray
   --
   display_LinkArrayGraph ixLinkArray
   display_Data ixLinkArray, "ix_LinkArray"
end menu_DisplayFindLinks

private on _______
end _______

on menu_UpdateLinked fromView
   put the short name of fromView into fromName
   put the ix_LinkArray of fromView into ixLinkArray
   put the total_Budget of fromView into totalBudget
   --
   put ixLinkArray [fromName] into toArray
   repeat for each key toName in toArray
      put toArray [toName]["indexNum"] into indexNum
      put toArray [toName]["toView"] into toView
      --
      -- put toName && indexNum
      set the cash_Value [indexNum] of toView to totalBudget
   end repeat
end menu_UpdateLinked

on menu_LayoutLinked fromView
   dispatch "ix_LayoutLinked" to fromView
end menu_LayoutLinked

private on ______
end ______

on menu_DisplaySaved ixView, someHow
   set the display_Format ["Saved"] of ixView to someHow
end menu_DisplaySaved

on menu_Displayed ixView, someHow
   set the display_Format ["Displayed"] of ixView to someHow
end menu_Displayed

private on _____
end _____

on menu_DisplayViewData ixView
   put the displayed_Data of ixView into vData
   put the view_Text of ixView
   --
   put the view_ModelName of ixView into vName
   display_Data vData, vName, "displayed_Data"
end menu_DisplayViewData

on menu_DisplaySavedData ixView
   put the displayed_Data [true] of ixView into vData
   --
   put the view_ModelName of ixView into vName
   display_Data vData, vName, "saved_Data"
end menu_DisplaySavedData

on menu_DisplaySavedTableData ixView
   put the saved_TableData of ixView into vData
   --
   put the view_ModelName of ixView into vName
   display_Data vData, vName, "saved_TableData"
end menu_DisplaySavedTableData

on menu_ClearOldData ixView
   dispatch "clear_OldData" to ixView
   put the result
   --
   dispatch "save_Data" to ixView
   get the result
end menu_ClearOldData

private on __
end __

on menu_ShowName ixView
   put the height of ixView into oHeight
   put the showname of ixView into sBoolean
   set the showname of ixView to (sBoolean is false)
   put the height of ixView - oHeight into someY
   -- put someY
end menu_ShowName

-- on menu_ShowTable ixView
put the show_Table of ixView into sBoolean
set the show_Table of ixView to (sBoolean is false)
end menu_ShowTable

on menu_TestShardTotals ixView
   put the displayed_ShardTotal of ixView into displayedShardTotal
   put the saved_ShardTotal of ixView into savedShardTotal
   --
   if (savedShardTotal = 100) AND (displayedShardTotal = 100) then
      lcw_Answer "Shard totals are good!", ixView
   else
      put "Displayed:" && displayedShardTotal & CR & "Saved:" && savedShardTotal
      lcw_AnswerWarning "Shard totals error!", ixView
   end if
end menu_TestShardTotals

on menu_TestIncomeTotal ixView
   put the saved_TableIncome of ixView -- the total_Budget of ixView
end menu_TestIncomeTotal

private on ___
end ___

on menu_TestInnerRect ixView
   put the inner_Rect of ixView into innerRect
   set the rect_Test of ixView to innerRect
   put the result into testButton
   put the rect of testButton & CR & the rect of the data_Grid of ixView
end menu_TestInnerRect

on menu_TestOuterRect ixView
   put the dg_Rect of ixView into oRect
   set the dg_Rect of ixView to oRect
end menu_TestOuterRect

on menu_LayoutControl ixView
   dispatch "LayoutControl" to ixView
end menu_LayoutControl

private on ____
end ____

on menu_ClearShards ixView
   put the displayed_Data of ixView into vData
   --
   repeat with lineNum = 1 to item 2 of the extents of vData
      put empty into vData [lineNum]["Shards"]
   end repeat
   --
   set the displayed_Data of ixView to vData
end menu_ClearShards

on menu_DisplayNestr
   display_Nestr
end menu_DisplayNestr

-- on menu_CreateChart ixView
put the inner_Rect of ixView into innerRect
put the shard_CsvData of ixView into sCsvData
--
lock screen
create widget as "com.livecode.widget.chart" in ixView
put it into chartWidget
set the csvData of chartWidget to sCsvData
set the rect of chartWidget to innerRect
unlock screen
end menu_CreateChart

--  on menu_DisplayPieChart ixView
put _PieChart (ixView) into pieChart
lock screen
set the sectorValues of pieChart to sValues
set the sectorLabels of pieChart to sLabels
dispatch "preOpenControl" to pieChart
unlock screen
end menu_DisplayPieChart
