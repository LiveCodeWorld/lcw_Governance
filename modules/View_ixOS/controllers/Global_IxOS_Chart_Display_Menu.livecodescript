script "Global | IxOS | Chart | Display | Menu"
--> MetaData
-
copyright: David Bovill
license: GPLv3
name: Global | IxOS | Chart | Display | Menu
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
   return ixView
end menu_Target


--> Global | IxOS | Chart | Display | Menu
-
on menu_DisplayShardChart ixView
   put the shard_CsvData of ixView into someCSV
   --
   display_IxChart ixView, someCSV
end menu_DisplayShardChart

on menu_DisplayIncomeChart ixView
   put the income_CsvData of ixView into someCSV
   --
   display_IxChart ixView, someCSV
end menu_DisplayIncomeChart

on menu_DisplayBudgetChart ixView
   put the budget_CsvData of ixView into someCSV
   --
   display_IxChart ixView, someCSV
end menu_DisplayBudgetChart

on menu_DisplayLinkedData ixView
   put the linked_Data of ixView into linkedData
   display_Data linkedData, "linked_Data", the short name of ixView
end menu_DisplayLinkedData

private command __
end __

on menu_UpdateLinkedCharts ixView
   dispatch "ix_UpdateLinkedCharts" to ixView
end menu_UpdateLinkedCharts

