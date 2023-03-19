script "behavior_ViewixOS"
--> MetaData
-
copyright: David Bovill
license: GPLv3
name: behavior_ViewixOS
type: behavior
version: 0.2

/*
*/

--> Variables
-
local LocalArray


--> Working on
-

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


--> Model
-
/*
The saved_Data [vName] is stored as a group custom property.
This can be trapped with a getprop at a higher (card) level, and processes intelligently.
But the default works and stores it as a custom property.
Remember to save the stack, if you  want the value to perrsist
*/

getprop saved_TableData
   put the currency_Symbol of me into currencySymbol
   --
   put _GetSavedData() into aData
   put _ConstructTableData (aData) into sTableData
   
   put the total_Budget of me into totalBudget
   _AddShardDataTable sTableData, currencySymbol, totalBudget
   --
   put totalBudget into sTableData ["total_Budget"]
   put the currency_Symbol of me into sTableData ["cSymbol"]
   return sTableData
end saved_TableData

setprop saved_TableData [pDisplayFormat] sTableData   
   set the currency_Symbol of me to sTableData ["cSymbol"]
   put sTableData ["vData"] into vData
   _AddShardViewData vData, currencySymbol, totalBudget
   _SetSavedData vData
   --
   set lockmessages to true
   set the total_Budget of me to sTableData ["total_Budget"]
   set lockmessages to false
   --
   if pDisplayFormat is not empty then
      set the display_Format of me to pDisplayFormat
   end if
   return sTableData
end saved_TableData

getprop displayed_Data
   put the saved_TableData of me into sData
   return sData
end displayed_Data

setprop displayed_Data
   set the saved_TableData of me to sData
   return the result
end displayed_Data


--> Displayed
-
getprop displayed_AbbreviatedData
   put the display_Format of me into sFormat
   put the currency_Symbol of me into currencySymbol
   put the displayed_Data of me into vData
   --
   switch sFormat
      case "abbreviated"
         return vData
      case "short"
         _ShortToAbbreviated vData, currencySymbol
         return vData
      default
         _LongToAbbreviated vData, currencySymbol
         return vData
   end switch
end displayed_AbbreviatedData

getprop displayed_ShardTotal
   put the displayed_Data of me into vData
   put ix_SumShards (vData) into sTotal
   return sTotal
end displayed_ShardTotal


--> Props
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

-- getprop show_Table
return the visible of _TableField()
end show_Table

-- setprop show_Table sBoolean
lock screen
set the visible of _TableField() to sBoolean
set the visible of _DataGrid() to (sBoolean is false)
unlock screen
end show_Table


--> Events
-
on nameChanged pOldName, pNewName
   _SetNamedObjects pOldName, graphicObject, chartWidget
   if the result is true then
      _SetNames pNewName, graphicName, chartName
      --
      set the lockmessages to true
      set the name of graphicObject to graphicName
      set the name of chartWidget to chartName
      set the lockmessages to false
   end if
end namechanged

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

on mouseUp
   if word 1 of the target = "button" then
      ix_CalculateShards
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

on mouseDown pButtonNumber
   switch pButtonNumber
      case 3
         menu_PopUp "Global | IxOS | Menu"
         break
      default
         _MaybeGrab
         pass mouseDown
   end switch
end mouseDown

on mouseMove pNewMouseH, pNewMouseV
   if the mouse is "Down" then
      -- being grabbed
      try
         lock screen
         -- could use rect like handlers in graphic "View|ixOS|Slice"
         put pNewMouseH - LocalArray ["oMouseX"] into xVector
         put pNewMouseV - LocalArray ["oMouseY"] into yVector
         --
         put LocalArray ["oViewLoc"] into oViewLoc
         --
         _SetNamedObjects empty, graphicObject, chartWidget
         put the result into nameLinked
         if nameLinked is true then
            put LocalArray ["oChartLoc"] into oChartLoc
            put loc_TranslateByVector (oChartLoc, xVector, yVector) into newChartLoc
            set the loc of chartWidget to newChartLoc
            --
            put LocalArray ["oGraphicLoc"] into oGraphicLoc
            put loc_TranslateByVector (oGraphicLoc, xVector, yVector) into newGraphicLoc
            set the loc of graphicObject to newGraphicLoc
            -- put newChartLoc & CR & newGraphicLoc
         else
            put the linked_Chart of me into chartObject
            if exists (chartObject) then
               put loc_TranslateByVector (oViewLoc, xVector, yVector) into nViewLoc
               set the loc of chartObject to nViewLoc
            end if
         end if
         --
         ix_LayoutLinked
         unlock screen
      end try
   end if
end mouseMove

on resizeControl 
   if the long id of target is _Datagrid() then
      -- unfortunately datagrid dispatches "resizecontrol"
      pass resizeControl
   end if
   put the rect of me into viewRect
   LayoutControl viewRect
end resizeControl

command _MaybeGrab
   put the mouseLoc into mLoc
   put item 1 of mLoc into LocalArray ["oMouseX"]
   put item 2 of mLoc into LocalArray ["oMouseY"]
   put the loc of me into LocalArray ["oViewLoc"]
   --
   put the loc of me into LocalArray ["oViewLoc"]
   --
   _SetNamedObjects empty, graphicObject, chartWidget
   put the result into nameLinked
   if nameLinked is true then
      put the loc of graphicObject into LocalArray ["oGraphicLoc"]
      put the loc of chartWidget into LocalArray ["oChartLoc"]
   end if
   
   put the short id of _BackgroundGraphic() into backID
   if the short id of the target = backID then
      grab me
   end if
end _MaybeGrab


--> Events | Custom
-
command LayoutControl pRect
   if pRect is empty then put the rect of me into pRect
   put _MenuWidget() into mWidget
   --
   -- put the inner_Rect [pRect] of me into innerRect
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
   lock screen
   set the bottomright of _ButtonObject() to bRight
   set the topRight of mWidget to tRight
   --
   set the rect of _TableField() to gridRect
   set the rect of _Datagrid() to gridRect
   --
   set the rect of _BackgroundGraphic() to pRect
   unlock screen
end LayoutControl


--> Objects | Linked
-
getprop chart_Widget
   -- use naming convention
   return _NameLinkedChart()
end chart_Widget

getprop linked_Chart
   -- first link
   return _LinkedChart()
end linked_Chart

setprop linked_Chart [pDelete] chartObject
   if exists (chartObject) is false then return empty 
   put the rugged_ID of chartObject into chartObject
   if pDelete is true then
      linked_DeleteChart chartObject
      return the result
   end if
   
   put the linked_Data of me into linkData
   if array_IndexFind (linkData, "chartObject", chartObject) > 0 then
      return empty
   end if
   --
   put item 2 of the extents of linkData into maxNum
   put maxNum + 1 into newNum
   put chartObject into linkData [newNum]["chartObject"]
   put the short name of chartObject into linkData [newNum]["name"]
   --
   set the linked_Data of me to linkData
   return linkData
end linked_Chart

getprop linked_Charts
   put the linked_Data of me into linkData
   put item 2 of the extents of linkData into maxNum
   repeat with itemNum = 1 to maxNum
      put linkData [itemNum]["chartObject"] into chartObject
      put chartObject & CR after chartObjects
   end repeat
   delete char -1 of chartObjects
   return chartObjects
end linked_Charts


--> NameLinked
-
getprop name_Linked
   _SetNamedObjects empty, graphicObject, chartWidget
   return the result
end name_Linked

private command _SetNames pIxName, @graphicName, @chartName
   if pIxName is empty then
      put the short name of me into pIxName -- "View|ixOS"
   end if
   --
   set the itemDelimiter to "|"
   put pIxName & "|Slice" into graphicName
   put pIxName & "|Chart" into chartName
   --
   return pIxName
end _SetNames

private command _SetNamedObjects ixName, @graphicObject, @chartWidget
   _SetNames ixName, graphicName, chartName
   --
   put the card_Object of me into myCard
   if exists (graphic graphicName of myCard) then
      put the long id of graphic graphicName of myCard into graphicObject
   else
      put empty into graphicObject
   end if
   
   if exists (widget chartName of myCard) then
      put the long id of widget chartName of myCard into chartWidget
   else
      put empty into chartWidget
   end if
   return (graphicObject is not empty) AND (chartWidget is not empty)
end _SetNamedObjects

private function _LinkedChart
   put the linked_Data of me into linkData
   put linkData [1]["chartObject"] into chartObject
   return chartObject
end _LinkedChart

private function _NameLinkedChart
   _SetNames empty, graphicName, chartName
   --
   put the card_Object of me into myCard
   if exists (widget chartName of myCard) then
      put the long id of widget chartName of myCard into chartObject
      return chartObject
   else
      return empty
   end if
end _NameLinkedChart

getprop cash_Value [lineNum]
   put the view_Text of the target into vText
   put item 2 of line lineNum of vText into sCash
   return sCash
end cash_Value

setprop cash_Value [titleOrNum] cashTotal
   put _GetSavedData() into vData
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
   -- _SetSavedData vData
   set the displayed_Data [true] of me to vData
   --
   return vData
end cash_Value


--> Total
-
getprop total_BudgetFromSaved
   put the saved_TableData of me into tableData
   put tableData ["vData"] into vData
   put ix_SumIncome (vData) into sTotal
   return sTotal 
end total_BudgetFromSaved

getprop total_Budget
   put the total_Budget of me into totalBudget
   return totalBudget
end total_Budget

setprop total_Budget totalBudget
   put the currency_Symbol of me into currencySymbol
   set the total_Budget of me to totalBudget
   --
   put _GetSavedData() into vData
   _AddShardViewData vData, currencySymbol, totalBudget
   _SetSavedData vData
   return vData
end total_Budget

setprop budget_Value [sTitle] longNum
   put the currency_Symbol of me into currencySymbol
   put ix_LongToAbbreviated (longNum, currencySymbol) into aNum
   --
   put _GetSavedData() into aData
   repeat with lineNum = 1 to item 2 of the extents of aData
      if aData [lineNum]["Title"] = sTitle then
         put aNum into aData [lineNum]["Budget"]
      end if
   end repeat
   --
   _SetSavedData aData
   set the display_Format of me to "abbreviated"
   -- set the displayed_Data of me to aData 
   return aData
end budget_Value

getprop displayed_BudgetValue [sTitle]
   put the displayed_Data of the target into vData
   repeat with lineNum = 1 to item 2 of the extents of vData
      if vData [lineNum]["Title"] = sTitle then
         return vData [lineNum]["Budget"]
      end if
   end repeat
   return empty
end displayed_BudgetValue

setprop displayed_BudgetValue [sTitle] sValue
   put the displayed_Data of me into vData
   repeat with lineNum = 1 to item 2 of the extents of vData
      if vData [lineNum]["Title"] = sTitle then
         put sValue into vData [lineNum]["Budget"]
      end if
   end repeat
   set the displayed_Data of me to vData 
   return vData
end displayed_BudgetValue

getprop view_Text
   return the displayed_Text of me
end view_Text

setprop view_Text [whichText] vText
   set the displayed_Text of me to vText
end view_Text

getprop displayed_Text [whichText]
   switch whichText
      case "Table"
         put word 1 to -1 of the text of _TableField() into vText
         break
      default
         put word 1 to -1 of the dgText of _Datagrid() into vText
   end switch
   return vText
end displayed_Text

setprop displayed_Text [whichText] vText
   switch whichText
      case "Table"
         set the text of _TableField() to vText
         break
      default
         set the dgText of _Datagrid() to vText
   end switch
end displayed_Text

getprop displayed_Data [pSaved]
   if pSaved is true then
      return _GetSavedData()
   else 
      return the dgData of _Datagrid()
   end if
   return vData
end displayed_Data

setprop displayed_Data [pSaved] vData
   if pSaved is true then
      _SetSavedData vData
      set the display_Format of me to "abbreviated"
   else
      set the dgData of _Datagrid() to vData
   end if
   return dgView
end displayed_Data


--> Save
-
on save_Data
   put the displayed_AbbreviatedData of me into aData
   set the displayed_Data [true] of me to aData
   return aData
end save_Data

on clear_Data
   -- set the saved_Data [modelID] of me to empty
   put the customPropertySets of me into cSets
   line_Delete "saved_Data", cSets
   set the customPropertySets of me to cSets
   
   -- set lockmessages to true
   -- set the total_Budget of me to empty
   -- set the linked_Data of me to empty
   set the custom_Delete of me to "total_Budget"
   clear_LinkedData
end clear_Data

on clear_LinkedData
   set the custom_Delete of me to "linked_Data"
end clear_LinkedData

on clear_OldData
   set the custom_Delete of me to "total_Income"
   --
   put the customPropertySets of me into cSets
   line_Delete "saved_Data", cSets
   set the customPropertySets of me to cSets
   --
   return cSets
end clear_OldData


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

getprop chart_Data [pFormatString]
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
end chart_Data


--> Display
-
getprop display_Format
   put the display_Format of me into someHow
   if someHow is empty then return "short"
   return someHow
end display_Format

setprop display_Format [pSavedOrDisplayed] someHow
   switch pSavedOrDisplayed
      case "Saved"
         put the saved_TableData of me into tableData
         put tableData ["vData"] into aData
         break
      case "Displayed"
         put the displayed_AbbreviatedData of me into aData
         break
      default -- saved_Data
         put _GetSavedData() into aData
   end switch
   put the currency_Symbol of me into currencySymbol
   --
   switch someHow
      case "abbreviated"
         -- assume it is in "abbreviated form"
         break
      case "short"
         _AbbreviatedToShort aData
         break
      case "long"
      case "numb"
      case "number"
         _AbbreviatedToLong aData
         break
   end switch
   --
   set the display_Format of me to someHow
   set the displayed_Data of me to aData
   return aData
end display_Format


--> Shard
-
getprop shard_Data
   put the view_Text of me into vText
   --
   put _GetTableData (vText) into sTableData
   _SetText vText, sTableData
   put the result into shardData
   return shardData
end shard_Data

getprop saved_ShardTotal
   put the saved_TableData of me into sData
   put sData ["vData"] into vData
   --
   put ix_SumShards (vData) into sTotal
   return sTotal
end saved_ShardTotal


--> Income
-
getprop currency_Symbol
   put the currency_Symbol of me into currencySymbol
   if currencySymbol is empty then put "€" into currencySymbol
   return currencySymbol
end currency_Symbol

setprop currency_Symbol currencySymbol
   set the currency_Symbol of me to currencySymbol
end currency_Symbol


--> Props
-
getprop table_Array
   put the view_Text of me into vText
   put _GetTableData (vText) into tableArray
   return tableArray
end table_Array


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


--> Events  | Update
-
on CloseFieldEditor pFieldEditor
   ## An example that saves 
   put the dgColumn of the target into sTitle
   put the text of pFieldEditor into sValue
   if sTitle = "Budget" then
      _ConvertAbbreviated sValue
   end if
   put the dgIndex of the target into lineNum
   
   lock screen	
   put _GetSavedData() into aData
   put sValue into aData [lineNum][sTitle]
   _SetSavedData aData
   
   ## After update  saving
   --  ix_CalculateShards
   ix_UpdateLinkedFields
   -- ix_UpdateLinkedCharts
   ix_UpdateCardCharts
   --
   unlock screen
end CloseFieldEditor


--> Ix
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


--> Linked
-
command linked_DeleteChart chartObject
   put the linked_Data of me into linkData
   put _GetChartNum (chartObject, linkData) into itemNum
   array_IndexDelete linkData, itemNum
   put the result into deletedItemArray
   set the linked_Data of me to linkData
   return deletedItemArray
end linked_DeleteChart

getprop linked_CardChartNames
   put the card_Object of me into cardObject
   --
   put the linked_Data of me into linkData
   put item 2 of the extents of linkData into maxNum
   repeat with itemNum = 1 to maxNum
      put linkData [itemNum]["chartObject"] into chartObject
      if exists (chartObject) is false then next repeat
      --
      get the long id of chartObject
      if it contains the long id of cardObject then
         put the short name of chartObject & CR after chartNames
      end if
   end repeat
   delete char -1 of chartNames
   return chartNames
end linked_CardChartNames

getprop linked_ChartNames
   put the linked_Data of me into linkData
   put item 2 of the extents of linkData into maxNum
   repeat with itemNum = 1 to maxNum
      put linkData [itemNum]["chartObject"] into chartObject
      if exists (chartObject) then
         put the short name of chartObject & CR after chartNames
      end if
   end repeat
   delete char -1 of chartNames
   return chartNames
end linked_ChartNames


--> Update
-
on ix_CalculateShards
   put the saved_TableData of me into sTableData
   put sTableData ["vData"] into pAdata
   --
   set the displayed_Data [true] of me to pAdata
   --
   dispatch "ix_Update" with sTableData
   return shardData
end ix_CalculateShards

command ix_Update sTableData
   display_Data sTableData, "Field Array"
end ix_Update

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

on ix_UpdateLinkedCharts
   put the view_ModelName of me into cTitle
   put the shard_CsvData of me into someCSV
   put the linked_Charts of me into linkedCharts
   repeat for each line chartWidget in linkedCharts
      if exists (chartWidget) is false then next repeat
      --
      lock screen
      set the displayed_Data of chartWidget to someCSV
      set the title of chartWidget to cTitle
      unlock screen
   end repeat
end ix_UpdateLinkedCharts


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

function ix_AbbreviatedToLong aNum
   get ix_StripCurrency (aNum)
   --
   replace "k" with "000" in it
   replace "m" with "000000" in it
   return it
end ix_AbbreviatedToLong

function ix_LongToShort longNum
   if longNum is not a number then return longNum
   --
   put replaceText (longNum, "000000$", empty) into shortNum
   put replaceText (shortNum, "000$", empty) into shortNum
   return shortNum
end ix_LongToShort

function ix_ShortToAbbreviated shortNum, currencySymbol
   if shortNum is not a number then return shortNum
   --
   put shortNum * 1000 into longNum
   put ix_LongToAbbreviated (longNum, currencySymbol) into aNum
   return aNum
end ix_ShortToAbbreviated

function ix_LongToAbbreviated longNum, currencySymbol
   if longNum is not a number then return longNum
   --
   put replaceText (longNum, "000000$", "m") into shortNum
   put replaceText (shortNum, "000$", "k") into shortNum
   put currencySymbol & shortNum into aNum
   return aNum
end ix_LongToAbbreviated

function ix_AbbreviatedToShort aNum, pNumberFormat
   get ix_StripCurrency (aNum)
   replace "k" with empty in it
   replace "m" with "000" in it
   --  
   put num_Round (it, pNumberFormat) into fNum
   return fNum
end ix_AbbreviatedToShort


--> Private
-
private command _SetSavedData vData
   put the short id of me into modelID
   put the currency_Symbol of me into currencySymbol
   --
   set the saved_Data [modelID] of me to vData
   
   ## Calculate new Total Budget
   _AddShardViewData vData, currencySymbol
   put the result into sTableData
   put sTableData ["total_Budget"] into totalBudget
   
   ## Update Total Budget
   set lockmessages to true
   set the total_Budget of me to totalBudget
   set lockmessages to false
   --
   return modelID
end _SetSavedData

private function _GetSavedData
   /*
   We don't want to be storing data locally dependent of the name as we often change this name.
   But if this is trapped at higher (card) level - we want to store many views data by name
   */
   
   put the short id of me into modelID
   put the saved_Data [modelID] of me into aData
   return aData
end _GetSavedData

private function _ConstructTableData aData
   put item 2 of the extents of aData into maxNum
   put 100 into percentLeft
   put 0 into budgetTotal
   --
   repeat with lineNum = 1 to maxNum
      put aData [lineNum]["Budget"] into aBudgetValue
      put ix_AbbreviatedToLong (aBudgetValue) into budgetNum
      if budgetNum is empty then
         put aData [lineNum]["Shards"] into sShard
         if sShard is empty then
            -- breakpoint
         else
            put aData [lineNum]["Title"] into sTitle
            put sTitle into sTableData ["vData"][lineNum]["Title"]
            --
            subtract sShard from percentLeft
            put sShard into sTableData ["vData"][lineNum]["Shards"]
         end if
         next repeat
      end if
      --
      put aData [lineNum]["Title"] into sTitle
      put sTitle into sTableData ["vData"][lineNum]["Title"]
      
      if budgetNum is a number then
         add budgetNum to budgetTotal
         put aBudgetValue into sTableData ["vData"][lineNum]["Budget"]
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
end _ConstructTableData

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

private function _GridRect innerRect
   put innerRect into gridRect
   if the show_Button of me is true then
      subtract 40 from item 4 of gridRect
   end if
   return gridRect
end _GridRect

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

private command _AbbreviatedToLong @aData
   repeat with lineNum = 1 to item 2 of the extents of aData
      put aData [lineNum]["Budget"] into aNum
      put ix_AbbreviatedToLong (aNum, currencySymbol) into longNum
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

command _ShortToAbbreviated @vData, currencySymbol
   repeat with lineNum = 1 to item 2 of the extents of vData
      put vData [lineNum]["Budget"] into shortNum
      put ix_ShortToAbbreviated (shortNum, currencySymbol) into aNum
      put aNum into vData [lineNum]["Budget"]
   end repeat
end _ShortToAbbreviated

command _LongToAbbreviated @vData, currencySymbol
   repeat with lineNum = 1 to item 2 of the extents of vData
      put vData [lineNum]["Budget"] into longNum
      put ix_LongToAbbreviated (longNum, currencySymbol) into aNum
      put aNum into vData [lineNum]["Budget"]
   end repeat
end _LongToAbbreviated


--> Private
-
/*
Not all of these are used, some early work in progress?
*/

private command _AddShardDataTable @sTableData, currencySymbol, pTotalIncome
   put sTableData ["vData"] into vData
   _AddShardViewData vData, currencySymbol, pTotalIncome
   put the result into sTableData
   --
   return sTableData
end _AddShardDataTable

private command _AddShardViewData @vData, currencySymbol, pTotalIncome
   ## First calculate budgget total
   put _ConstructTableData (vData) into sTableData
   put sTableData ["total_Budget"] into budgetTotal
   put sTableData ["percentLeft"] into percentLeft
   
   ## Now update shards, and calculate income given pTotalIncome
   _FixShards vData, budgetTotal, currencySymbol, percentLeft, pTotalIncome
   --
   put vData into sTableData ["vData"]
   return sTableData
end _AddShardViewData

private command _FixShards @vData, budgetTotal, currencySymbol, percentLeft, pTotalIncome
   ## Use budget value to work out shards
   put item 2 of the extents of vData into maxNum
   repeat with lineNum = 1 to maxNum
      put vData [lineNum]["Budget"] into aNum
      put ix_AbbreviatedToLong (aNum) into budgetNum
      --
      if budgetNum is a number then
         put budgetNum/budgetTotal * percentLeft into shardValue
         put shardValue into vData [lineNum]["Shards"]
         
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
end _FixShards

private command _SetText @vText, sTableData
   -- see _AddShardDataTable
   set the numberformat to "#.00"
   --
   put sTableData ["vData"] into vData
   put item 2 of the extents of vData into maxNum
   set the itemdelimiter to tab
   repeat with lineNum = 1 to maxNum
      put vData [lineNum]["Shards"] into shardValue
      breakpoint
      put shardValue into vData [lineNum]["Shards"]
      put shardValue & "%" into item 3 of line lineNum of vText
   end repeat
   return vData
end _SetText

private function _GetTableData vText
   put word 1 to -1 of vText into vText
   --
   put the number of lines of vText into maxNum
   put 100 into percentLeft
   put 0 into budgetTotal
   set the itemdelimiter to tab
   --
   repeat with lineNum = 1 to maxNum
      put line lineNum of vText into sLine
      --
      put item 2 of sLine into budgetNum
      put ix_AbbreviatedToLong (budgetNum) into budgetNum
      if budgetNum is empty then next repeat
      --
      put item 1 of sLine into sTitle
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
   put budgetTotal into sTableData ["total_Budget"]
   put percentLeft into sTableData ["percentLeft"]
   --
   _AddShardsToTableData sTableData, budgetTotal, percentLeft, maxNum
   --
   return sTableData
end _GetTableData

private command _AddShardsToTableData @sTableData, budgetTotal, percentLeft, maxNum
   repeat with lineNum = 1 to maxNum
      put sTableData ["vData"][lineNum]["Budget"] into budgetNum
      if budgetNum is a number then -- skip percent
         put budgetNum/budgetTotal * percentLeft into sTableData ["vData"][lineNum]["Shards"]
      end if
   end repeat
end _AddShardsToTableData

private command _NormalizeCashTotal @longNum, pCurrencySymbol
   -- cash totals are always long numbers
   if pCurrencySymbol is empty then
      put the currency_Symbol of me into pCurrencySymbol
   end if
   put ix_LongToAbbreviated (longNum, pCurrencySymbol) into longNum
   return pCurrencySymbol
end _NormalizeCashTotal

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
         put ix_LongToAbbreviated (sValue, pCurrencySymbol) into sValue
   end switch
   return displayFormat
end _ConvertAbbreviated


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

private function _TableField
   -- "Investment Grid"
   return the long id of fld "Table Field" of me
end _TableField

getprop data_Grid
   return _Datagrid()
end data_Grid

getprop ix_View
   return the long id of me
end ix_View

getprop view_Object
   return the long id of me
end view_Object


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

