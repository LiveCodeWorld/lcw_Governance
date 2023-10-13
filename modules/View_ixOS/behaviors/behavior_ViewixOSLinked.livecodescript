script "behavior_ViewixOSLinked"
--> MetaData
-
copyright: David Bovill
license: GPLv3
name: behavior_ViewixOSLinked
type: behavior
version: 0.1

/*
This behavior is experimentsl and not used currently.
It was used to create arbitrary linked charts
Either by naming them appropriately or by linking them with a lookup table

It also includes script for grabbing and moving linked objects.
This was a hack when grouping a chart caused a crash.
*/

/*
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

on clear_OldData
   set the custom_Delete of me to "total_Income"
   --
   put the customPropertySets of me into cSets
   line_Delete "saved_Data", cSets
   set the customPropertySets of me to cSets
   --
   return cSets
end clear_OldData

on clear_Data
   put the customPropertySets of me into cSets
   line_Delete "saved_Data", cSets
   set the customPropertySets of me to cSets
   
   set the custom_Delete of me to "total_Budget"
   clear_LinkedData
end clear_Data

on clear_LinkedData
   set the custom_Delete of me to "linked_Data"
end clear_LinkedData

getprop table_Array
   put the view_Text of me into vText
   put _GetTableData (vText) into tableArray
   return tableArray
end table_Array

on ix_CalculateShards
   put the saved_TableData of me into sTableData
   put sTableData ["vData"] into vData
   --
 [true] of me to vData
   --
   dispatch "ix_Update" with sTableData
   return shardData
end ix_CalculateShards

command ix_Update sTableData
   display_Data sTableData, "Field Array"
end ix_Update

getprop shard_Data
   put the view_Text of me into vText
   --
   put _GetTableData (vText) into sTableData
   _SetText vText, sTableData
   put the result into shardData
   return shardData
end shard_Data

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
      put _AbbreviatedToLong (budgetNum) into budgetNum
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
*/

--> Variables
-
local LocalArray


--> Working on
-
-- getprop linked_Charts
   put the linked_Data of me into linkData
   put item 2 of the extents of linkData into maxNum
   repeat with itemNum = 1 to maxNum
      put linkData [itemNum]["chartObject"] into chartObject
      put chartObject & CR after chartObjects
   end repeat
   delete char -1 of chartObjects
   return chartObjects
end linked_Charts


--> More | Conversion
-
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

private function _AbbreviatedToLong aNum
   get ix_StripCurrency (aNum)
   --
   replace "k" with "000" in it
   replace "m" with "000000" in it
   return it
end _AbbreviatedToLong

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


--> NameLinked
-
getprop name_Linked
   _SetNamedObjects empty, graphicObject, chartWidget
   return the result
end name_Linked


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

command linked_DeleteChart chartObject
   put the linked_Data of me into linkData
   put _GetChartNum (chartObject, linkData) into itemNum
   array_IndexDelete linkData, itemNum
   put the result into deletedItemArray
   set the linked_Data of me to linkData
   return deletedItemArray
end linked_DeleteChart


--> Private
-
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
