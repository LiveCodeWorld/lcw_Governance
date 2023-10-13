script "behavior_ViewixOS"
--> MetaData
-
copyright: David Bovill
license: GPLv3
name: behavior_ViewixOS
type: behavior
version: 0.3

/*
getprop chart_CSV [pFormatString]
   put the saved_TableData of me into tableData
   put tableData ["vData"] into vData
   --
   repeat with sectorNum = 1 to item 2 of the extents of vData
      put vData [sectorNum]["Title"] into sLabel
      
      put vData [sectorNum]["Budget"] into aValue
      put vData [sectorNum]["Income"] into iValue
      put vData [sectorNum]["Shards"] into sValue
      --
      put sLabel & comma after sLabels
      put sValue & comma after sValues
      --
      put sLabel & Comma & ix_AbbreviatedToShort (sValue, pFormatString) & CR after shardCSV
      put sLabel & Comma & ix_AbbreviatedToShort (aValue, pFormatString) & CR after budgetCSV
      put sLabel & Comma & num_Round (iValue, pFormatString) & CR after incomeCSV
   end repeat
   delete char -1 of sLabels
   delete char -1 of sValues
   delete char -1 of shardCSV
   delete char -1 of budgetCSV
   --
   put sLabels into chartData ["sLabels"]
   put sValues into chartData ["sValues"]
   put shardCSV into chartData ["Shards"]
   put budgetCSV into chartData ["Budget"]
   put incomeCSV into chartData ["Income"]
   --
   return chartData
end chart_CSV
*/

--> Variables
-

--> Working on
-
getprop title_Index [useVisible]
   if useVisible is true then
      put _GetVisibleData() into vData
   else
      put _GetSavedVisibleData() into vData
   end if
   --
   repeat with lineNum = 1 to item 2 of the extents of vData
      put vData [lineNum]["Title"] & CR after titleIndex
   end repeat
   delete char -1 of titleIndex
   return titleIndex
end title_Index

getprop formatted_Height
   put _Datagrid() into dGrid
   put the dgFormattedHeight of dGrid into fHeight
   
   ## Add header Height
   put the dgProp["header height"] of dGrid into hHeight
   add hHeight to fHeight
   
   put the inner_Margin of me into iMargin
   add 2 * iMargin to fHeight
   --
   if the visible of _MenuWidget() is true then
      add 6 to fHeight
   end if
   
   if _BottomShowing() is true then
      add iMargin/2 to fHeight
      
      put 27 into totalHeight
      -- put 32 into totalHeight
      add totalHeight to fHeight
   end if
   
   -- put _MenuRect (gridRect, pRect, iMargin) into mRect
   add 4 to fHeight
   return fHeight
end formatted_Height


--> Budget
-
getprop total_Budget
   -- rename to "fair_Value" ?
   put the total_Budget of me into totalBudget
   return totalBudget
end total_Budget

setprop total_Budget totalBudget
   -- rename to "fair_Value" ?
   put the currency_Symbol of me into currencySymbol
   set the total_Budget of me to totalBudget
   --
   put _GetSavedVisibleData() into vData
   _ConstructShardsAndIncome vData, currencySymbol, totalBudget
   _SetSavedVisibleData vData
   return vData
end total_Budget

getprop total_BudgetFromSaved
   put the saved_TableData of me into tableData
   put tableData ["vData"] into vData
   put ix_SumIncome (vData) into sTotal
   return sTotal 
end total_BudgetFromSaved

setprop budget_Value [sTitle] longNum
   put the currency_Symbol of me into currencySymbol
   put _LongToAbbreviated (longNum, currencySymbol) into aNum
   --
   put _GetSavedVisibleData() into aData
   repeat with lineNum = 1 to item 2 of the extents of aData
      if aData [lineNum]["Title"] = sTitle then
         put aNum into aData [lineNum]["Budget"]
      end if
   end repeat
   --
   _SetSavedVisibleData aData
   --
   set the display_Format of me to "abbreviated"
   -- set the displayed_Data of me to aData 
   return aData
end budget_Value


--> Budget | Increment
-
setprop budget_Increment [sTitle] aValue
   put _GetSavedVisibleData() into vData
   put indexArray_Find (vData, "Title", sTitle) into indexNum
   --
   if indexNum = 0 then
      -- insert (could ignore)
      put item 2 of the extents of vData into indexNum
      add 1 to indexNum
      put aValue into vData [indexNum]["Budget"]
      put sTitle into vData [indexNum]["Title"]
   else
      _DuckNormalize aValue
      put vData [indexNum]["Budget"] into bValue
      add aValue to bValue
      --
      put bValue into vData [indexNum]["Budget"]
   end if
   _CloseUpdate vData
   --
   return indexNum
end budget_Increment

getprop budget_Value [sTitle]
   put the data_Grid of me into dgView
   --
   put the title_IndexNum [sTitle] of me into indexNum
   --
   put the dgData of dgView into sData
   put sData [indexNum]["budget"] into bValue
   --
   return bValue
end budget_Value

setprop budget_Value [sTitle] bValue
   put _GetSavedVisibleData() into vData
   put indexArray_Find (vData, "Title", sTitle) into indexNum
   --
   _DuckNormalize bValue
   put bValue into vData [indexNum]["budget"]
   if indexNum = 0 then
      put sTitle into vData [indexNum]["name"]
   end if
   _CloseUpdate vData
   --
   return indexNum
end budget_Value

getprop title_IndexNum [sTitle]
   put the data_Grid of me into dgView
   dispatch "FindIndex" to dgView with "Title", sTitle
   return the result
end title_IndexNum

private command _CloseUpdate vData
   lock screen	
   put _ConstructTableData (vData) into sTableData
   put sTableData ["vData"] into vData
   --
   _SetSavedVisibleData vData
   ix_UpdateTable vData
   dispatch "slice_UpdateLinked" to the owner of me
   --
   unlock screen
end _CloseUpdate

on ix_UpdateTable pVisibleData
   if pVisibleData is empty then
      put _GetSavedVisibleData() into pVisibleData
   end if
   _DisplayVisibleData pVisibleData
end ix_UpdateTable

on ix_UpdateCardCharts cObject
   if cObject is empty then
      put the card_Object of the target into cObject
   end if
   --
   put the ix_Views of cObject into ixViews
   repeat for each line ixView in ixViews
      dispatch "ix_UpdateLinkedCharts" to ixView
   end repeat
end ix_UpdateCardCharts


--> Update | Linked
-
on ix_UpdateLinkedCharts
   -- put the view_ModelName of me into cTitle
   put the chart_Data of me into sData
   put sData ["chart_Data"] into chartData
   --
   ## Add Chart Title
   put the chart_Title of me into cTitle
   -- put cTitle into chartData ["label"]
   
   put the linked_Charts of me into linkedCharts
   repeat for each line chartWidget in linkedCharts
      if exists (chartWidget) is false then next repeat
      --
      lock screen
      set the chart_Data of chartWidget to chartData
      set the title of chartWidget to cTitle
      unlock screen
   end repeat
end ix_UpdateLinkedCharts

on ix_UpdateLinkedFields
   put the short name of me into fromName
   put the ix_LinkArray of me into ixLinkArray
   put the total_Budget of me into totalBudget
   --
   put ixLinkArray [fromName] into toArray
   repeat for each key toName in toArray
      put toArray [toName]["indexNum"] into indexNum
      put toArray [toName]["toView"] into toView
      --
      set the cash_Value [indexNum] of toView to totalBudget
   end repeat
end ix_UpdateLinkedFields


--> Names | Use
-
getprop column_Names
   put _DataGrid() into dGrid
   put the dgProp["columns"] of dGrid into cNames
   return cNames
end column_Names

setprop column_NamesFromData longVisibleData
   put _Datagrid() into dGrid
   _SetColumnNames longVisibleData, dGrid
   put the result into cNames
   return cNames
end column_NamesFromData

private command _SetColumnNames longVisibleData, dGrid
   put _GetColumnNames (longVisibleData) into cNames
   set the dgProp["columns"] of dGrid to cNames -- to reset column names if needed
   return cNames
end _SetColumnNames


--> Events  | Update
-
on CloseFieldEditor pFieldEditor
   put the dgColumn of the target into sTitle
   put the text of pFieldEditor into sValue
   put the dgIndex of the target into lineNum
   put _GetSavedVisibleData() into vData
   --
   switch sTitle
      case "Budget"
         _DuckNormalize sValue
         put sValue into vData [lineNum][sTitle]
         break
      case "Title"
         put sValue into vData [lineNum][sTitle]
         break
      default
         beep
         put vData [lineNum][sTitle] into longValue
         put longValue into vData [lineNum][sTitle]
   end switch
   --
   _CloseUpdate vData
end CloseFieldEditor


--> Names
-
private function _GetColumnNames longVisibleData
   put "Title,Budget,Shards" into cNames
   replace comma with CR in cNames
   
   get longVisibleData [1]
   delete variable it ["Title"]
   delete variable it ["Budget"]
   delete variable it ["Shards"]
   
   put CR & keys (it) after cNames
   return cNames
end _GetColumnNames

on update_Totals
   put _GetSavedVisibleData() into pLongVisibleData
   --
   repeat with itemNum = 1 to item 2 of the extents of pLongVisibleData
      put pLongVisibleData [itemNum]["Budget"] into bNum
      if bNum is a number then
         add bNum to bTotal
      end if
      --
      put pLongVisibleData [itemNum]["Shards"] into sNum
      if sNum is a number then
         add sNum to sTotal
      end if
      
      --
      put pLongVisibleData [itemNum]["Income"] into iNum
      if iNum is a number then
         add iNum to iTotal
      end if
   end repeat
   
   ## Display Totals
   put "Totals" into tData [1]["Title"]
   --
   _NormalizeNumber bTotal
   put bTotal into tData [1]["Budget"]
   --
   put sTotal into tData [1]["Shards"]
   --
   if iTotal is a number then
      _NormalizeNumber iTotal
      put iTotal into tData [1]["Income"]
   end if
   --
   set the total_Data of me to tData
end update_Totals


--> Model | Displayed
-
/*
The displayed_Data is the data we store for the module.
That is not just the dgData of the datagrid (vData), but all the data (aData).

The saved_Data [modelID] is stored as a group custom property.
This can be trapped with a getprop at a higher (card) level, and processes intelligently.
But the default works and stores it as a custom property.
Remember to save the stack, if you  want the value to perrsist
*/

getprop displayed_Data
   -- put the saved_TableData of me into sTableData
   put _GetVisibleData() into vData
   put _ConstructTableData (vData) into sTableData
   
   ## Get Default ModelName
   put sTableData ["modelName"] into modelName
   if modelName is not empty then
      put the model_Name of me into sTableData ["modelName"]
   end if
   --
   return sTableData
end displayed_Data

setprop displayed_Data [cName] sTableData   
   lock screen
   set the saved_TableData of me to sTableData
   put the result into recalculatedTableData
   set the displayed_Column of me to cName
   --
   dispatch "slice_UpdateChart" to the owner of me
   unlock screen
   --
   return recalculatedTableData
end displayed_Data


--> Columns
-
getprop displayed_Column
   put _Datagrid() into dGrid
   put the dgProp["column visibility"] of dGrid into allVisible
   --
   switch
      case allVisible is "true,true,true,true"
         return "all"
      case the dgColumnIsVisible["Shards"] of dGrid is true
         return "Shards"
      case the dgColumnIsVisible["Budget"] of dGrid is true
         return "Budget"
      case the dgColumnIsVisible["Income"] of dGrid is true
         return "Income"
   end switch
   return empty
end displayed_Column

setprop displayed_Column cName
   put _Datagrid() into dGrid
   put the dgProp["columns"] of dGrid into cNames
   --
   lock screen
   switch cName
      case "None"
         _ShowSingleColumn dGrid, cNames
         break
      case "all"
         repeat for each line testName in cNames
            set the dgColumnIsVisible[testName] of dGrid to true
         end repeat
         break
      default
         _ShowSingleColumn dGrid, cNames, cName
   end switch
   --
   _SetFirstColumnWidth
   dispatch "slice_UpdateChart" to the owner of me
   unlock screen
   --
   return dGrid
end displayed_Column


--> Private | Columns
-
private command _ShowSingleColumn dGrid, cNames, cName
   delete line 1 of cNames
   repeat for each line testName in cNames
      put testName = cName into sBoolean
      set the dgColumnIsVisible[testName] of dGrid to sBoolean
   end repeat
end _ShowSingleColumn

private function _FirstColumnWidth
   put the data_Grid of me into dGrid
   --
   put the dgProp["visible columns"] of dGrid into vNames
   delete line 1 of vNames -- "Title"
   --
   repeat for each line cName in vNames
      -- if cName = "Title" then next repeat
      put the dgColumnWidth [cName] of dGrid into cWidth
      add cWidth to otherWidth
   end repeat
   put the width of dGrid - otherWidth into titleColumnWidth
   --
   -- subtract the scrollbarwidth of dGrid from titleColumnWidth
   
   subtract 2 from titleColumnWidth
   return titleColumnWidth
end _FirstColumnWidth

private function _FirstComumnName dGrid
   -- put "Title" into firstColumnName
   put the dgProp["visible columns"] of dGrid into vNames
   put line 1 of vNames into firstColumnName -- "Title"
   return firstColumnName
end _FirstComumnName

private command _SetFirstColumnWidth
   put the data_Grid of me into dGrid
   put _FirstComumnName(dGrid) into firstColumnName
   --
   put _FirstColumnWidth() into titleColumnWidth
   lock screen
   set the dgProp["show vscrollbar"] of dGrid to false
   set the dgColumnWidth [firstColumnName] of dGrid to titleColumnWidth
   --
   _MirrorTotalColumns dGrid
   unlock screen
end _SetFirstColumnWidth

private command _MirrorTotalColumns dGrid
   -- put the data_Grid of me into dGrid
   put _TotalGrid() into tGrid
   --
   put the dgProp["visible columns"] of dGrid into vNames
   put the dgProp["column widths"] of dGrid into cWidths
   --
   set the dgProp["column widths"] of tGrid to cWidths
end _MirrorTotalColumns

private function _CalculateTabStops
   put the data_Grid of me into dGrid
   --
   put the dgProp["column widths"] of dGrid into cWidths
   put 0 into lastItem
   repeat for each item sWidth in cWidths
      add sWidth to lastItem 
      put lastItem & comma after tStops
   end repeat
   delete char -1 of tStops
   return tStops
end _CalculateTabStops

private function _CalculateTabStops
   put the data_Grid of me into dGrid
   --
   put the dgProp["column widths"] of dGrid into cWidths
   put 0 into lastItem
   repeat for each item sWidth in cWidths
      add sWidth to lastItem 
      put lastItem & comma after tStops
   end repeat
   delete char -1 of tStops
   return tStops
end _CalculateTabStops


--> Model
-
getprop model_Name
   put the model_Name of me into modelName
   if modelName is empty then
      put the view_ModelName of me into modelName
   end if
   return modelName
end model_Name

setprop model_Name modelName
   set the model_Name of me to modelName
end model_Name


--> Model | Chart
-
getprop chart_Data [cName]
   put the column_Names of me into cNames
   switch cName
      case "all"
      case empty
         put "all" into cName
         break
      case cName is among the lines of cNames
         break
      default
         put empty into cName
   end switch
   
   put the saved_TableData of me into tableData
   put tableData ["vData"] into vData
   --
   repeat with sectorNum = 1 to item 2 of the extents of vData
      put vData [sectorNum]["Title"] into sLabel
      if sLabel is empty then next repeat
      --
      put sLabel into sData ["chart_Data"]["labels"][sectorNum]
      --
      switch cName
         case "all"
            _AllChartData sData, sectorNum, vData, sLabel
            break
         case empty
            put false into sData ["chart_Data"]["datasets"][1]["hidden"]
            put sLabel into sData ["chart_Data"]["datasets"][1]["label"]
            --
            put vData [sectorNum]["Shards"] into sValue
            put sValue into sData ["chart_Data"]["datasets"][1]["data"][sectorNum]
            break
         default
            put false into sData ["chart_Data"]["datasets"][1]["hidden"]
            put sLabel into sData ["chart_Data"]["datasets"][1]["label"]
            --
            put vData [sectorNum][cName] into sValue
            put sValue into sData ["chart_Data"]["datasets"][1]["data"][sectorNum]
      end switch     
   end repeat
   return sData
end chart_Data

private command _AllChartData @sData, sectorNum, vData, sLabel
   put the column_Names of me into cNames
   put 1 into dSetNum
   repeat for each line cName in cNames
      if cName is "Title" then next repeat
      --
      put false into sData ["chart_Data"]["datasets"][dSetNum]["hidden"]
      put sLabel into sData ["chart_Data"]["datasets"][dSetNum]["label"]
      --
      get vData [sectorNum][cName]
      put round (it, 2) into sData ["chart_Data"]["datasets"][dSetNum]["data"][sectorNum]
      --
      add 1 to dSetNum
   end repeat
end _AllChartData

on update_ShardsAndIncome
   put the displayed_Data of me into sTableData
   set the displayed_Data of me to sTableData
   return sTableData
end update_ShardsAndIncome

getprop total_Data
   put the dgData of _TotalGrid() into tData
   return tData
end total_Data

setprop total_Data tData
   set the dgData of _TotalGrid() to tData
end total_Data

private command _StripEmptyData @sData
   -- only needed for export?
   put 1 into cleanItemNum
   repeat with itemNum = 1 to item 2 of the extents of sData
      put sData [itemNum] into itemArray
      if itemArray ["Title"] is not empty then
         put itemArray into cleanArray [cleanItemNum]
         add 1 to cleanItemNum
      end if
   end repeat
   --
   put cleanArray into sData
   return sData
end _StripEmptyData

private function _GetVisibleData
   put the dgData of _Datagrid() into vData
   _StripEmptyData vData
   _DuckNormalizeVisibleData vData
   return vData
end _GetVisibleData

private command _DisplayVisibleData longVisibleData, pDisplayFormat
   ## Format longVisibleData
   if pDisplayFormat is empty then put the display_Format of me into pDisplayFormat
   switch pDisplayFormat
      case "abbreviated"
         _LongDataToAbbreviated longVisibleData
         break
      case "short"
         _LongDataToShort longVisibleData
         break
      case "long"
      case "numb"
      case "number"
         break
   end switch
   
   ## Display 
   lock screen
   put _Datagrid() into dGrid
   _SetColumnNames longVisibleData, dGrid
   set the dgData of dGrid to longVisibleData
   -- dispatch "ResetControl" to dGrid -- does not reset column names
   dispatch "RefreshList" to dGrid
   --
   update_Totals longVisibleData
   --
   unlock screen
   --
   return longVisibleData
end _DisplayVisibleData

private function _ConstructTableData longVisibleData
   put _NormalizeVisibledata (longVisibleData, "number") into longVisibleData
   --
   put the display_Format of me into someHow
   put the total_Income of me into totalIncome
   put the currency_Symbol of me into currencySymbol
   
   ## Nomalize vData
   put _ConstructSimpleTable (longVisibleData) into sTableData -- not sure needed?
   put sTableData ["vData"] into vData
   
   ## Re-calculate
   put sTableData ["total_Budget"] into budgetTotal
   put sTableData ["percentLeft"] into percentLeft
   
   ## Now update shards, and calculate income given totalIncome
   _FixShardsAndIncome longVisibleData, budgetTotal, currencySymbol, percentLeft, totalIncome
   
   ## Replace vData and add totalIncome
   put longVisibleData into sTableData ["vData"]
   put totalIncome into sTableData ["total_Income"]
   put currencySymbol into sTableData ["cSymbol"]
   put the model_Name of me into sTableData ["modelName"]
   -- put percentLeft into sTableData ["percentLeft"]
   
   return sTableData
end _ConstructTableData

private function _ConstructSimpleTable longVisibleData
   -- Simple table from budget and shards
   -- no income
   
   put item 2 of the extents of longVisibleData into maxNum
   put 100 into percentLeft
   put 0 into budgetTotal
   --
   repeat with lineNum = 1 to maxNum
      put longVisibleData [lineNum]["Budget"] into budgetNum
      if budgetNum is empty then
         put longVisibleData [lineNum]["Shards"] into sShard
         if sShard is empty then
            -- breakpoint
         else
            put longVisibleData [lineNum]["Title"] into sTitle
            put sTitle into sTableData ["vData"][lineNum]["Title"]
            --
            subtract sShard from percentLeft
            put sShard into sTableData ["vData"][lineNum]["Shards"]
         end if
         next repeat
      end if
      --
      put longVisibleData [lineNum]["Title"] into sTitle
      put sTitle into sTableData ["vData"][lineNum]["Title"]
      
      if budgetNum is a number then
         add budgetNum to budgetTotal
         put budgetNum into sTableData ["vData"][lineNum]["Budget"]
         next repeat
      end if
      
      replace "%" with empty in budgetNum
      if budgetNum is a number then
         subtract budgetNum from percentLeft
         put budgetNum into sTableData ["vData"][lineNum]["Shards"]
         next repeat
      end if
   end repeat
   --
   _AddShardsToTableData sTableData, budgetTotal, percentLeft, maxNum
   put budgetTotal into sTableData ["total_Budget"]
   put percentLeft into sTableData ["percentLeft"]
   --
   return sTableData
end _ConstructSimpleTable


--> Display
-
getprop display_Format
   put the display_Format of me into someHow
   if someHow is empty then return "short"
   return someHow
end display_Format

setprop display_Format displayFormat
   put _GetSavedVisibleData() into longVisibleData
   --
   set the display_Format of me to displayFormat
   _DisplayVisibleData longVisibleData, displayFormat
   return aData
end display_Format


--> Model | Displayed | Props
-
getprop displayed_BudgetValue [sTitle]
   put _GetVisibleData() into vData
   repeat with lineNum = 1 to item 2 of the extents of vData
      if vData [lineNum]["Title"] = sTitle then
         return vData [lineNum]["Budget"]
      end if
   end repeat
   return empty
end displayed_BudgetValue

setprop displayed_BudgetValue [sTitle] sValue
   put _GetVisibleData() into vData
   repeat with lineNum = 1 to item 2 of the extents of vData
      if vData [lineNum]["Title"] = sTitle then
         put sValue into vData [lineNum]["Budget"]
      end if
   end repeat
   _DisplayVisibleData vData
   return vData
end displayed_BudgetValue

getprop displayed_ShardTotal
   put _GetVisibleData() into vData
   put ix_SumShards (vData) into sTotal
   return sTotal
end displayed_ShardTotal

getprop displayed_AbbreviatedData
   put the display_Format of me into sFormat
   put the currency_Symbol of me into currencySymbol
   put _GetVisibleData() into vData
   --
   switch sFormat
      case "abbreviated"
         return vData
      case "short"
         _ShortToAbbreviated vData, currencySymbol
         return vData
      default
         _LongDataToAbbreviated vData, currencySymbol
         return vData
   end switch
end displayed_AbbreviatedData


--> Model | Saved
-
/*
We use a custom property "saved_Data [modelID]" to store data
This can be over-ridden higher up as it is not defined in script
--
We don't want to be storing data locally dependent of the name as we often change this name.
But if this is trapped at higher (card) level - we want to store many views data by name
*/

getprop saved_VisibleData
   put _GetSavedVisibleData() into vData
   return vData
end saved_VisibleData

setprop saved_VisibleData vData
   _SetSavedVisibleData vData
   put the result into sTableData
   --
   set the display_Format of me to "abbreviated"
   return sTableData
end saved_VisibleData

getprop saved_TableData
   put the currency_Symbol of me into currencySymbol
   --
   put _GetSavedVisibleData() into vData
   put _ConstructTableData (vData) into sTableData
   
   put the total_Budget of me into totalBudget
   _AddShardDataTable sTableData, currencySymbol, totalBudget
   --
   put totalBudget into sTableData ["total_Budget"]
   put currencySymbol into sTableData ["cSymbol"]
   put the model_Name of me into sTableData ["modelName"]
   return sTableData
end saved_TableData

setprop saved_TableData [pDisplayFormat] sTableData   
   _ReconstructTableData sTableData
   --
   set the table_Data [pDisplayFormat] of me to sTableData
   return sTableData
end saved_TableData

private command _ReconstructTableData @sTableData
   put sTableData ["cSymbol"] into currencySymbol
   put sTableData ["vData"] into vData
   put the total_Income of me into totalIncome
   _ConstructShardsAndIncome vData, currencySymbol, totalIncome
   put vData into sTableData ["vData"]
end _ReconstructTableData

setprop table_Data [pDisplayFormat] sTableData
   ## Save vData
   put sTableData ["vData"] into vData
   _SetSavedVisibleData vData
   
   ## Save Table Metadata
   _SaveTableMetaData sTableData, pDisplayFormat
   
   ## Display vData
   _DisplayVisibleData vData
   
   return sTableData
end table_Data

private command _SaveTableMetaData sTableData, pDisplayFormat
   set lockmessages to true
   set the model_Name of me to sTableData ["modelName"]
   set the currency_Symbol of me to sTableData ["cSymbol"]
   set the total_Budget of me to sTableData ["total_Budget"]
   if pDisplayFormat is empty then
      set the display_Format of me to "abbreviated"
   else
      set the display_Format of me to pDisplayFormat
   end if
   set lockmessages to false
end _SaveTableMetaData

on save_Data
   put the displayed_AbbreviatedData of me into vData
   _SetSavedVisibleData vData
   return vData
end save_Data

private function _GetSavedVisibleData
   put the short id of me into modelID
   put the saved_Data [modelID] of me into vData
   return vData
end _GetSavedVisibleData

private command _SetSavedVisibleData vData
   put the short id of me into modelID
   set the saved_Data [modelID] of me to vData
   
   ## Calculate new Total Budget
   put the currency_Symbol of me into currencySymbol
   _ConstructShardsAndIncome vData, currencySymbol
   put the result into sTableData
   put sTableData ["total_Budget"] into totalBudget
   
   ## Update Total Budget
   set lockmessages to true
   set the total_Budget of me to totalBudget
   set lockmessages to false
   --
   return sTableData
end _SetSavedVisibleData


--> Private | Calculate | Shards
-
/*
Not all of these are used, some early work in progress?
*/

private command _AddShardDataTable @sTableData, currencySymbol, pTotalIncome
   put sTableData ["vData"] into vData
   _ConstructShardsAndIncome vData, currencySymbol, pTotalIncome
   put the result into sTableData
   --
   return sTableData
end _AddShardDataTable

private command _ConstructShardsAndIncome @vData, currencySymbol, pTotalIncome
   ## First calculate budget total
   put _ConstructTableData (vData) into sTableData
   put sTableData ["total_Budget"] into budgetTotal
   put sTableData ["percentLeft"] into percentLeft
   
   ## Now update shards, and calculate income given pTotalIncome
   _FixShardsAndIncome vData, budgetTotal, currencySymbol, percentLeft, pTotalIncome
   --
   put vData into sTableData ["vData"]
   return sTableData
end _ConstructShardsAndIncome

private command _FixShardsAndIncome @vData, budgetTotal, currencySymbol, percentLeft, pTotalIncome
   ## Use budget value to work out shards
   put item 2 of the extents of vData into maxNum
   repeat with lineNum = 1 to maxNum
      put vData [lineNum]["Budget"] into aNum
      put ix_AbbreviatedToLong (aNum) into budgetNum
      --
      if budgetNum is a number then
         try
            put budgetNum/budgetTotal * percentLeft into shardValue
            put shardValue into vData [lineNum]["Shards"]
         catch sError
            put empty into vData [lineNum]["Shards"]
         end try
         if pTotalIncome is a number then
            put pTotalIncome * shardValue/100 into vData [lineNum]["Income"]
         end if
      else
         if pTotalIncome is a number then
            put vData [lineNum]["Shards"] into shardValue
            put pTotalIncome * shardValue/100 into vData [lineNum]["Income"]
         end if
      end if
   end repeat
end _FixShardsAndIncome

private command _AddShardsToTableData @sTableData, budgetTotal, percentLeft, maxNum
   repeat with lineNum = 1 to maxNum
      put sTableData ["vData"][lineNum]["Budget"] into budgetNum
      if budgetNum is a number then -- skip percent
         try
            put budgetNum/budgetTotal * percentLeft into sTableData ["vData"][lineNum]["Shards"]
         catch sError
            -- put sError into sTableData ["vData"][lineNum]["Shards"]
            put empty into sTableData ["vData"][lineNum]["Shards"]
         end try
      end if
   end repeat
end _AddShardsToTableData


--> Events | Custom
-
getprop mouse_Up
   put the uOPN ["mouse_Up"] of me into mDoubleUp
   return mDoubleUp
end mouse_Up

setprop mouse_Up mDoubleUp
   set the uOPN ["mouse_Up"] of me to mDoubleUp
end mouse_Up

getprop mouse_DoubleUp
   put the uOPN ["mouse_DoubleUp"] of me into mDoubleUp
   return mDoubleUp
end mouse_DoubleUp

setprop mouse_DoubleUp mDoubleUp
   set the uOPN ["mouse_DoubleUp"] of me to mDoubleUp
end mouse_DoubleUp


--> Events | Custom
-
command LayoutControl pRect
   if pRect is empty then put the rect of me into pRect
   put _MenuWidget() into mWidget
   put _TotalGrid() into totalGrid
   --
   put the inner_Margin of me into iMargin
   put _GetInner (pRect, iMargin) into innerRect
   put _GridRect (innerRect) into gridRect
   --
   put item 3 to 4 of innerRect into bRight
   put item 3 of innerRect into item 1 of tRight
   put item 2 of pRect into item 2 of tRight
   --
   add iMargin/4 to item 2 of tRight
   if the visible of mWidget is true then
      add 6 to item 2 of gridRect
   end if
   --
   put _MenuRect (gridRect, pRect, iMargin) into mRect
   --
   lock screen
   set the bottomright of _ButtonObject() to bRight
   set the rect of mWidget to mRect
   --
   set the rect of _Datagrid() to gridRect
   put _TotalRect (gridRect, iMargin, rHeight) into totalRect
   set the rect of totalGrid to totalRect
   set the rect of _BackgroundGraphic() to pRect
   --
   _SetFirstColumnWidth
   unlock screen
end LayoutControl


--> Events
-
on selectionChanged pHilitedIndexes, pPreviouslyHilitedIndexes
   put the data_Grid of me into dGrid
   --
   -- put the vscrollbar of dGrid
   -- put the dgProp["show vscrollbar"] of dGrid
   
   -- put the dgProp["scrollbar width"] of dGrid
   
   -- put the dgProp["column widths"] of dGrid
   -- put the dgProp["columns"] of dGrid
   -- put the dgProp["visible columns"] of dGrid
   
   -- put the dgHeaderAlignment["Shards"] of dGrid -- doesnt work?
   -- put _CalculateTabStops() & CR & the dgFormattedWidth of dGrid 
   
   
   -- put the width of dGrid 
   -- put the dgProp["scrollbar width"] of dGrid
   --
   -- put the dgProp["allow column resizing"] of dGrid
   -- put the dgProp["column labels"] of dGrid
   -- put the dgColumnIsResizable["col1"] of dGrid
   -- put the dgColumnWidth["col1"] of dGrid
   -- put the dgFormattedWidth of dGrid
   -- put the dgFormattedHeight of dGrid
   -- put the dgProp["scrollbar width"] of dGrid
   -- put the dgProp["visible columns"] of dGrid
   -- put the dgProp["header height"] of dGrid
   
   pass selectionChanged
end selectionChanged

on mouseDown pButtonNumber
   switch pButtonNumber
      case 3
         if the dgControl of the target is empty then
            menu_PopUp "Global | IxOS | Menu"
         else
            menu_PopUp "Global | ixOS | Row | Menu"
         end if
         break
      default
         pass mouseDown
   end switch
end mouseDown

on mouseUp
   if word 1 of the target = "button" then
      -- ix_CalculateShards
   else
      put the mouse_Up of me into mUp
      if mUp is not empty then
         put the clickText into sLine
         dispatch mUp with sLine
      else
         pass mouseUp
      end if
   end if
end mouseUp

on mouseDoubleUp
   switch the short name of the target
      case "Background"
         put the show_Chart of me into sBoolean
         set the show_Chart [false] of me to (sBoolean is false)
         break
      default
         put the mouse_DoubleUp of me into mDoubleUp
         if mDoubleUp is not empty then
            put the clickText into sLine
            dispatch mDoubleUp with sLine
         else
            pass mouseDoubleUp 
         end if
   end switch
end mouseDoubleUp

on resizeControl 
   if the long id of target is _Datagrid() then
      -- unfortunately datagrid dispatches "resizecontrol"
      pass resizeControl
   end if
   put the rect of me into viewRect
   LayoutControl viewRect
end resizeControl


--> Working on
-
getprop background_Colour
   return the backgroundcolor of _BackgroundGraphic()
end background_Colour

setprop background_Colour sColour
   set the backgroundcolor of _BackgroundGraphic() to sColour
end background_Colour


--> Normalize
-
private command _NormalizeNumber @longNum, pDisplayFormat
   if pDisplayFormat is empty then put the display_Format of me into pDisplayFormat
   switch pDisplayFormat
      case "abbreviated"
         _MakeAbbreviated longNum
         break
      case "short"
         _MakeShort longNum
         break
      case "long"
      case "numb"
      case "number"
         break
   end switch
end _NormalizeNumber

private command _DuckNormalize @sValue
   -- ugly hack for now
   put the display_Format of me into someHow
   switch
      case char 1 of sValue is not a number
      case someHow = "abbreviated"
         put ix_AbbreviatedToLong (sValue) into sValue
         return "abbreviated"
      case someHow = "short"
         put 1000 * sValue into sValue
         return "short"
      case someHow = "long"
      case someHow = "numb"
      case someHow = "number"
         return "long"
   end switch
end _DuckNormalize

private command _DuckNormalizeVisibleData @vData
   -- ugly hack for now
   put the display_Format of me into someHow
   put vData [1]["Budget"] into testBudget
   switch
      case char 1 of testBudget is not a number
      case someHow = "abbreviated"
         _AbbreviatedToLong vData
         return "abbreviated"
      case someHow = "short"
         _ShortToLong vData
         return "short"
      case someHow = "long"
      case someHow = "numb"
      case someHow = "number"
         return "long"
   end switch
end _DuckNormalizeVisibleData

private function _NormalizeVisibledata longVisibleData, pDisplayFormat
   switch pDisplayFormat
      case "abbreviated"
         -- assume it is in "abbreviated form"
         break
      case "short"
         _LongDataToShort longVisibleData
         break
      case "long"
      case "numb"
      case "number"
         _AbbreviatedToLong longVisibleData
         break
   end switch
   return longVisibleData
end _NormalizeVisibledata

private command _NormalizeCashTotal @longNum, pCurrencySymbol
   -- cash totals are always long numbers
   if pCurrencySymbol is empty then
      put the currency_Symbol of me into pCurrencySymbol
   end if
   put _LongToAbbreviated (longNum, pCurrencySymbol) into longNum
   return pCurrencySymbol
end _NormalizeCashTotal


--> Show
-
getprop show_Chart
   put the linked_Chart of me into chartObject
   if exists (chartObject) is false then return empty
   --
   put the visible of chartObject into sBoolean
   return sBoolean
end show_Chart

setprop show_Chart [useNamed] sBoolean
   if sBoolean is not a boolean then return empty
   
   lock screen
   put the dg_Rect of me into dgRect
   --
   if useNamed is true then
      put _NameLinkedChart() into chartObject
      put dgRect into chartRect
   else
      put the linked_Chart of me into chartObject
      put dgRect into chartRect
   end if
   if exists (chartObject) is false then return empty
   
   set the rect of chartObject to chartRect
   set the visible of chartObject to sBoolean
   unlock screen
   return  chartObject
end show_Chart


--> Show
-
private function _BottomShowing
   switch
      case the show_Button of me is true
      case the show_Total of me is true
         return true
      default
         return false
   end switch
end _BottomShowing

getprop show_Total
   put the visible of _TotalGrid() into sBoolean
   return sBoolean
end show_Total

setprop show_Total sBoolean
   lock screen
   put the rect of me into oRect
   set the visible of _TotalGrid() to sBoolean
   LayoutControl oRect
   unlock screen
end show_Total

getprop show_Button
   put the visible of _ButtonObject() into sBoolean
   return sBoolean
end show_Button

setprop show_Button sBoolean
   lock screen
   put the rect of me into oRect
   set the visible of _ButtonObject() to sBoolean
   LayoutControl oRect
   unlock screen
end show_Button

getprop show_Menu
   return the visible of _MenuWidget()
end show_Menu

setprop show_Menu sBoolean
   put _MenuWidget() into mWidget
   put the rect of me into oRect
   --
   lock screen
   set the visible of mWidget to sBoolean
   LayoutControl oRect
   unlock screen
end show_Menu

getprop currency_Symbol
   put the currency_Symbol of me into currencySymbol
   if currencySymbol is empty then put "€" into currencySymbol
   return currencySymbol
end currency_Symbol

setprop currency_Symbol currencySymbol
   set the currency_Symbol of me to currencySymbol
   --
   put the display_Format of me into displayFormat
   if displayFormat = "abbreviated" then
      put _GetSavedVisibleData() into longVisibleData
      _DisplayVisibleData longVisibleData, displayFormat
   end if
end currency_Symbol


--> Events | Layout | Arrow
-
on ix_LayoutLinked pTotalBudget
   ix_LayoutTo pTotalBudget
   put the result into ixLinkArray
   ix_LayoutFrom ixLinkArray
end ix_LayoutLinked

on ix_LayoutFrom ixLinkArray
   put linkArray_Reverse (ixLinkArray) into reverseLinkArray
   put the short name of me into toName
   put reverseLinkArray [toName] into fromArray
   repeat for each key fromName in fromArray
      put fromArray [fromName]["toView"] into fromView
      put fromArray [fromName]["arrowView"] into fromArrow
      --
      -- dispatch "LayoutControl" to fromView
      if exists (fromArrow) then
         dispatch "LayoutControl" to fromArrow
      end if
   end repeat
end ix_LayoutFrom

on ix_LayoutTo pTotalBudget
   put the short name of me into fromName
   put the ix_LinkArray of me into ixLinkArray
   put ixLinkArray [fromName] into toArray
   repeat for each key toName in toArray
      put toArray [toName]["toView"] into toView
      put toArray [toName]["arrowView"] into arrowView
      --
      -- dispatch "LayoutControl" to toView
      dispatch "LayoutControl" to arrowView
      --
      if pTotalBudget is not empty then
         put toArray [toName]["indexNum"] into indexNum
         set the cash_Value [indexNum] of toView to totalBudget
      end if
   end repeat
   return ixLinkArray
end ix_LayoutTo

--> Geometry | Arrows
-
getprop border_Loc [pItems]
   put item 1 of pItems into sBorder
   put item 2 of pItems into stepNum
   put item 3 of pItems into numOfSteps
   if stepNum is empty then
      put 1 into stepNum
      put 2 into numOfSteps
   end if
   
   put the rect of me into myRect
   put 2 into yFiddle
   switch char 1 of sBorder
      case "t"
         put item 2 of myRect into myTop
         subtract yFiddle from myTop
         put myTop into item 2 of bLoc
         put _BLocX (myRect, stepNum, numOfSteps) into item 1 of bLoc
         return bLoc
      case "b"
         put item 4 of myRect into myBottom
         add yFiddle to myBottom
         put myBottom into item 2 of bLoc
         put _BLocX (myRect, stepNum, numOfSteps) into item 1 of bLoc
         return bLoc
      case "l"
         put item 1 of myRect into item 1 of bLoc
         put _BLocY (myRect, stepNum, numOfSteps) into item 2 of bLoc
         return bLoc
      case "r"
         put item 3 of myRect into item 1 of bLoc
         put _BLocY (myRect, stepNum, numOfSteps) into item 2 of bLoc
         return bLoc
      default
         return empty
   end switch
end border_Loc


--> Cash
-
getprop cash_Value [lineNum]
   put the view_Text of the target into vText
   put item 2 of line lineNum of vText into sCash
   return sCash
end cash_Value

setprop cash_Value [titleOrNum] cashTotal
   put _GetSavedVisibleData() into vData
   switch
      case titleOrNum is empty
         return empty
      case titleOrNum is a number
         put titleOrNum into lineNum
         break
      default
         put array_IndexFind (vData, titleOrNum, "Title") into lineNum
         if lineNum = 0 then
            return empty
         end if
   end switch
   _NormalizeCashTotal cashTotal
   --
   put cashTotal into vData [lineNum]["Budget"]
   _SetSavedVisibleData vData
   _DisplayVisibleData vData
   --
   return vData
end cash_Value


--> Data | CSV
-
getprop income_CsvData
   put the csv_Data ["Income,2"] of me into budgetData
   return budgetData
end income_CsvData

getprop shard_CsvData
   put the csv_Data ["Shards,round"] of me into shardData
   return shardData
end shard_CsvData

getprop budget_CsvData
   put the csv_Data ["Budget,2"] of me into budgetData
   return budgetData
end budget_CsvData

getprop csv_Data [whichItems]
   put item 1 of whichItems into whichValue
   put item 2 of whichItems into fString
   put the chart_Data [fString] of me into chartData
   switch whichValue
      case empty -- default
         return chartData ["Shards"]
      default
         return chartData [whichValue]
   end switch
end csv_Data


--> Shard
-
getprop saved_ShardTotal
   put the saved_TableData of me into sData
   put sData ["vData"] into vData
   --
   put ix_SumShards (vData) into sTotal
   return sTotal
end saved_ShardTotal


--> Geometry | Inner
-
getprop dg_Rect
   put the rect of _Datagrid() into sRect
   return sRect
end dg_Rect

setprop dg_Rect gridRect
   put the outer_Rect [gridRect] of me into outerRect
   LayoutControl outerRect
   return outerRect
end dg_Rect

getprop centre_Loc
   put the loc of _Datagrid() into cLoc
   return cLoc
end centre_Loc

setprop centre_Loc cLoc
   local xVector, yVector
   --
   put the loc of _Datagrid() into oLoc
   loc_SetTranslationVector oLoc, cLoc, xVector, yVector
   put the loc of me into myLoc
   put loc_TranslateByVector (myLoc, xVector, yVector) into newLoc
   set the loc of me to newLoc
end centre_Loc


--> Props
-
getprop inner_Margin
   put the inner_Margin of me into iMargin
   if iMargin is a number then
      return iMargin
   else
      return 24
   end if
end inner_Margin

setprop inner_Margin iMargin
   set the inner_Margin of me to iMargin
   LayoutControl
end inner_Margin


--> Ix | Sum
-
function ix_SumShards vData
   put 0 into sTotal
   repeat with lineNum = 1 to item 2 of the extents of vData
      put vData [lineNum]["Shards"] into sValue
      if sValue is a number then
         add sValue to sTotal
      end if
   end repeat
   return sTotal
end ix_SumShards

function ix_SumIncome vData
   put 0 into sTotal
   repeat with lineNum = 1 to item 2 of the extents of vData
      put vData [lineNum]["Income"] into sIncome
      if sIncome is a number then
         add sIncome to sTotal
      end if
   end repeat
   return sTotal
end ix_SumIncome


--> Ix | Formmat
-
function ix_StripCurrency aNum
   if char -1 of aNum = "%" then return aNum
   --
   replace "£" with empty in aNum
   replace "$" with empty in aNum
   replace "€" with empty in aNum
   --
   return aNum
end ix_StripCurrency


--> Private
-
command _LongDataToShort @longData
   -- vData renamed longData
   set the numberformat to "#.00"
   repeat with lineNum = 1 to item 2 of the extents of longData
      put longData [lineNum]["Budget"] into longNum
      if longNum is a number then
         put _LongToShort (longNum) into shortNum
         put shortNum into longData [lineNum]["Budget"]
      end if
      --
      put longData [lineNum]["Income"] into longNum
      if longNum is a number then
         put _LongToShort (longNum) into shortNum
         put shortNum into longData [lineNum]["Income"]
      end if
   end repeat
   set the numberformat to "0.######"
end _LongDataToShort

private function _LongToShort longNum
   _MakeShort longNum
   return longNum
end _LongToShort

private command _MakeShort @longNum
   -- set the numberformat to "#.00"
   -- put replaceText (longNum, "000000$", empty) into shortNum
   -- put replaceText (shortNum, "000$", empty) into shortNum
   
   if longNum is not a number then
      put empty into longNum
      return empty
   end if
   --
   get longNum / 1000
   put round (it, 2) into longNum
   return it
end _MakeShort

private function _LongToAbbreviated longNum, pCurrencySymbol
   _MakeAbbreviated longNum, pCurrencySymbol
   return longNum
end _LongToAbbreviated

private command _MakeAbbreviated @longNum, pCurrencySymbol
   -- put replaceText (longNum, "000000$", "m") into shortNum
   -- put replaceText (shortNum, "000$", "k") into shortNum 
   -- put currencySymbol & shortNum into aNum
   
   if longNum is not a number then
      put empty into longNum
      return empty
   end if
   if pCurrencySymbol is empty then
      put the currency_Symbol of me into pCurrencySymbol
   end if
   --
   set the numberformat to "#.00"
   get pCurrencySymbol & longNum/1000 & "k"
   put replaceText (it, ".00k", "k") into longNum  
   return aNum
end _MakeAbbreviated

private command _LongDataToAbbreviated @vData, pCurrencySymbol
   if pCurrencySymbol is empty then
      put the currency_Symbol of me into pCurrencySymbol
   end if
   --
   repeat with lineNum = 1 to item 2 of the extents of vData
      put vData [lineNum]["Budget"] into longNum
      if longNum is a number then
         put _LongToAbbreviated (longNum, pCurrencySymbol) into aNum
         put aNum into vData [lineNum]["Budget"]
      end if
      --
      put vData [lineNum]["Income"] into longNum
      if longNum is a number then
         put _LongToAbbreviated (longNum, pCurrencySymbol) into aNum
         put aNum into vData [lineNum]["Income"]
      end if
   end repeat
end _LongDataToAbbreviated

private command _ConvertAbbreviated @sValue, pCurrencySymbol
   if pCurrencySymbol is empty then
      put the currency_Symbol of me into pCurrencySymbol
   end if
   --
   put the display_Format of me into displayFormat
   switch displayFormat
      case "abbreviated"
         break
      case "short"
         put ix_ShortToAbbreviated (sValue, pCurrencySymbol) into sValue
         break
      default
         put _LongToAbbreviated (sValue, pCurrencySymbol) into sValue
   end switch
   return displayFormat
end _ConvertAbbreviated

--> More | Conversion
-
private command _AbbreviatedToLong @aData
   repeat with lineNum = 1 to item 2 of the extents of aData
      put aData [lineNum]["Budget"] into aNum
      put ix_AbbreviatedToLong (aNum) into longNum
      put longNum into aData [lineNum]["Budget"]
   end repeat
end _AbbreviatedToLong

private command _AbbreviatedToShort @aData
   repeat with lineNum = 1 to item 2 of the extents of aData
      put aData [lineNum]["Budget"] into aNum
      put ix_AbbreviatedToShort (aNum) into shortNum
      put shortNum into aData [lineNum]["Budget"]
   end repeat
end _AbbreviatedToShort

command _ShortToAbbreviated @vData, pCurrencySymbol
   if pCurrencySymbol is empty then
      put the currency_Symbol of me into pCurrencySymbol
   end if
   --
   repeat with lineNum = 1 to item 2 of the extents of vData
      put vData [lineNum]["Budget"] into shortNum
      put ix_ShortToAbbreviated (shortNum, pCurrencySymbol) into aNum
      put aNum into vData [lineNum]["Budget"]
   end repeat
end _ShortToAbbreviated

command _ShortToLong @vData
   repeat with lineNum = 1 to item 2 of the extents of vData
      put vData [lineNum]["Budget"] into shortNum
      put 1000 * shortNum into longNum
      put longNum into vData [lineNum]["Budget"]
   end repeat
end _ShortToLong

function ix_AbbreviatedToLong aNum
   get ix_StripCurrency (aNum)
   --
   replace "k" with "000" in it
   replace "m" with "000000" in it
   return it
end ix_AbbreviatedToLong

function ix_ShortToAbbreviated shortNum, currencySymbol
   if shortNum is not a number then return shortNum
   --
   put shortNum * 1000 into longNum
   put _LongToAbbreviated (longNum, currencySymbol) into aNum
   return aNum
end ix_ShortToAbbreviated

function ix_AbbreviatedToShort aNum, pNumberFormat
   get ix_StripCurrency (aNum)
   replace "k" with empty in it
   replace "m" with "000" in it
   --  
   put num_Round (it, pNumberFormat) into fNum
   return fNum
end ix_AbbreviatedToShort

--> Not needed
-
/*
private function _GetChartNum chartObject, linkData
   if exists (chartObject) is false then return empty 
   put the rugged_ID of chartObject into chartObject
   
   put item 2 of the extents of linkData into maxNum
   repeat with itemNum = 1 to maxNum
      put linkData [itemNum]["chartObject"] into testChartObject
      if chartObject = testChartObject then
         return itemNum
      end if
   end repeat
   return 0
end _GetChartNum
*/

--> Objects
-
private function _BackgroundGraphic
   return the long id of grc "Background" of me
end _BackgroundGraphic

function _MenuWidget
   return the long id of widget "Menu" of me
end _MenuWidget

function _ButtonObject
   return the long id of btn "Calculate" of me
end _ButtonObject

private function _Datagrid
   -- "Investment Grid"
   return the long id of group 1 of me
end _Datagrid

private function _TotalGrid
   return the long id of group "Totals" of me
end _TotalGrid


--> Private | Geometry
-
private function _TotalRect gridRect, iMargin, rHeight
   put gridRect into totalRect
   -- put the row height of _TotalGrid() into rHeight
   -- put rHeight + 6 into totalHeight
   put 27 into totalHeight
   
   if _BottomShowing() is true then
      put item 4 of gridRect into totalTop
      add iMargin/2 to totalTop
      put totalTop + totalHeight into totalBottom
   else
      put item 4 of gridRect into totalBottom
      put totalBottom - totalHeight into totalTop
   end if
   
   put totalTop into item 2 of totalRect
   put totalBottom into item 4 of totalRect
   --
   return totalRect
end _TotalRect

private function _GridRect innerRect
   put innerRect into gridRect
   if _BottomShowing() is true then
      subtract 32 from item 4 of gridRect
   end if
   return gridRect
end _GridRect

private function _MenuRect gridRect, pRect, iMargin   
   put item 3 of gridRect into mRight
   put mRight into item 3 of mRect
   put mRight - iMargin into item 1 of mRect
   --
   put item 2 of pRect into item 2 of mRect
   put item 2 of gridRect into item 4 of mRect
   --
   rect_SubtractMargins mRect, 1
   return mRect
end _MenuRect

function _GetInner pRect, pMargin
   rect_SubtractMargins pRect, pMargin
   put the result into nMargins
   --
   if the showborder of me is true then
      put the borderwidth of me into bWidth
      rect_SubtractMargins pRect, bWidth
   end if
   
   if the showname of me is true then
      put the effective textheight of me - bWidth into someBit
      subtract 2 from someBit
      add someBit to item 2 of pRect
   end if
   return pRect
end _GetInner

private function _BLocY myRect, stepNum, numOfSteps
   put item 2 of myRect into myTop
   put item 4 of myRect - myTop into myHeight
   put myTop + stepNum * myHeight/numOfSteps into bLocY
   return bLocY
end _BLocY

private function _BLocX myRect, stepNum, numOfSteps
   put item 1 of myRect into myLeft
   put item 3 of myRect - myLeft into myWidth
   put myLeft + stepNum * myWidth/numOfSteps into bLocX
   return bLocX
end _BLocX


--> Objects
-
getprop data_Grid
   return _Datagrid()
end data_Grid

getprop ix_View
   return the long id of me
end ix_View

getprop view_Object
   return the long id of me
end view_Object

getprop template_Object
   -- in case it is nested as template card script is crude
   return view_GetTemplateObject ("View|IxOs")
end template_Object


--> Deps
-
function num_Round sNum, pRoundHow
   if sNum is not a number then
      -- breakpoint -- a bug
      return empty
   end if
   
   switch
      case pRoundHow is empty
         return sNum
      case pRoundHow = "round"
         return round (sNum)
      case pRoundHow = "trunc"
         return trunc (sNum)
      case pRoundHow is a number
         return round (sNum, pRoundHow)
      default
         -- assume it is a format string for numberformat
         -- this does not work
         set the numberformat to pRoundHow
         add 0 to sNum
         set the numberformat to "0.######"
   end switch
end num_Round


--> Deps | Geometry
-
getprop inner_Rect [groupRect]
   put the long id of the target into someGroup
   if word 1 of someGroup is not "group" then return empty -- only for groups
   if groupRect is empty then put the rect of someGroup into groupRect
   
   put rect_GetInner (groupRect, someGroup) into innerRect
   return innerRect
end inner_Rect

getprop outer_Rect [innerRect]
   if innerRect is empty then return empty
   put the long id of the target into someGroup
   if word 1 of someGroup is not "group" then return empty -- only for groups
   put the margins of someGroup into pMargin
   put 0 into bWidth
   
   -- put rect_GetOuter (innerRect, someGroup) into innerRect
   put innerRect into outerRect
   if the showborder of someGroup is true then
      put the borderwidth of someGroup into bWidth
      rect_AddMargins outerRect, bWidth -- is this the borderwidth?
   end if
   
   if the showname of someGroup is true then
      put the effective textheight of someGroup - bWidth into someBit
      subtract 2 from someBit
      subtract someBit from item 2 of outerRect
   end if
   
   rect_AddMargins outerRect, pMargin
   put the result into nMargins
   
   ## Scrollbars (not done)
   
   return outerRect
end outer_Rect

function rect_GetInner groupRect, someGroup, pMargin
   if exists (someGroup) is false then return empty
   if pMargin is empty then
      put the margins of someGroup into pMargin
   end if
   rect_SubtractMargins groupRect, pMargin
   put the result into nMargins
   --
   if the showborder of someGroup is true then
      put the borderwidth of someGroup into bWidth
      rect_SubtractMargins groupRect, bWidth
   end if
   
   if the showname of someGroup is true then
      put the effective textheight of someGroup - bWidth into someBit
      subtract 2 from someBit
      add someBit to item 2 of groupRect
   end if
   
   put the scrollbarwidth of someGroup into scrollBarMargin
   if the vscrollbar of someGroup is true then 
      subtract scrollBarMargin from item 3 of groupRect
   end if
   if the hscrollbar of someGroup is true then
      subtract scrollBarMargin from item 4 of groupRect
   end if
   --
   return groupRect
end rect_GetInner
