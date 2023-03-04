script "Global_Governance_Account_Menu"
--> MetaData
-
license: GPLv3
name: Global_Governance_Account_Menu
type: controller
version: 0.1


-- Variables
-
local LocalArray


-- Menu | Props
-
on menu_Init tObject
   put the account_View of tObject into accountView
   put the dg_Data of accountView into transactionsArray
   --
   put account_GetMonthsPresentArray (transactionsArray) into monthsPresentArray
   put account_GetPresentMonthNames (monthsPresentArray) into someMonths
   --
   put transactionsArray into LocalArray ["transactionsArray"]
   put monthsPresentArray into LocalArray ["monthsPresentArray"]
   put someMonths into LocalArray ["someMonths"]
end menu_Init

getprop displayCategorized_Params [accountView]
   -- account_Names
   put account_ListKeys() into accountKeys
   return accountKeys
end displayCategorized_Params

getprop displayMonth_Params [accountView]
   -- some_Months
   put LocalArray ["someMonths"] into someMonths
   return someMonths
end displayMonth_Params

getprop checked_ShowGraph [accountView]
   put the graph_Visible of accountView into someBoolean
   return someBoolean
end checked_ShowGraph


--> Global | Governance | Account | Menu
-
on menu_FilterForBusiness accountView
   put the dg_Data of accountView into transactionsArray
   put account_GetTotalsArray (transactionsArray, 5) into totalArray -- totals checked using "account_CheckTotalsArray"
   --
   delete variable totalArray ["Personal Expenses"]
   delete variable totalArray ["Benefits"]
   --
   display_Array totalArray, "account_GetTotalsArray()"
   --
   put totalArray ["Business Expenses"] into businessExpenses
   put account_GetTotalsTotal (businessExpenses) into catTotals
   --
   put "Totals Total:" && catTotals
end menu_FilterForBusiness

on menu_DisplayCategorized accountView, accountName
   put account_GetArray (accountName) into accountArray
   --
   display_Array accountArray, "account_GetArray()"
   --
   lock screen
   set the transactions_Array of accountView to accountArray ["raw"]
   set the dg_Data of accountView to accountArray ["categorized"]
   unlock screen
end menu_DisplayCategorized

on menu_SaveCategorized accountView
   put the displayed_MonthNum of accountView into monthNum
   put the displayed_MonthName of accountView into monthName
   --
   put the transactions_Array of accountView into accountArray ["raw"]
   put the dg_Data of accountView into accountArray ["categorized"]
   
   put lcw_Ask ("What do you want to save this array as?", monthName) into someKey
   account_SetArray someKey, accountArray
end menu_SaveCategorized

on _
end _

on menu_DisplayMonth accountView, someMonth
   put "2018" into someYear
   --
   put LocalArray ["monthsPresentArray"] into monthsPresentArray
   put account_GetMonthNum (someMonth, monthsPresentArray) into monthNum
   
   put the dg_Data of accountView into transactionsArray
   put account_ConstructYearsArray (transactionsArray, 5) into yearData
   --
   put yearData [someYear][monthNum] into monthArray
   --
   display_Account monthArray, someMonth
   put the result into displayView
   --
   set the displayed_MonthNum of displayView to monthNum
   set the displayed_MonthName of displayView to someMonth
   set the displayed_year of displayView to someYear
end menu_DisplayMonth

on menu_ImportBarclays accountView
   answer file "Select CSV file"
   put it into someFile
   if someFile is empty then exit to top
   
   put url ("file:" & someFile) into someCSV
   put account_ProcessBarclays (someCSV) into transactionsArray
   --
   -- display_Array transactionsArray
   --
   set the transactions_Array of accountView to transactionsArray
   set the graph_Visible of accountView to false
end menu_ImportBarclays

on _
end _

on menu_DisplayGraph accountView
   -- put the transactions_Array of accountView into transactionsArray
   put the dg_Data of accountView into transactionsArray -- it's been updated
   put account_GetGraphTableArray (transactionsArray, "2018") into graphTableArray
   put graphTableArray ["graphTable"] into graphTable
   set the graph_Table of accountView to graphTable
   set the graph_Visible of accountView to true
end menu_DisplayGraph

on menu_DisplayCatMonth accountView
   local accountArray, totalArray
   
   put the displayed_MonthNum of accountView into monthNum
   put the displayed_MonthName of accountView into monthName
   --
   put the dg_Data of accountView into transactionsArray -- it's been updated
   put account_GetGraphTableArray (transactionsArray, "2018", 5) into graphTableArray
   put graphTableArray ["yearCategoryArray"] into yearCategoryArray
   --
   put yearCategoryArray [monthNum] into monthCatArray
   --
   account_SetMonthTotalArray monthCatArray, transactionTotalArray, totalArray
   --
   display_Array totalArray, "totalArray"
   display_Account accountArray, "Category Array"
   --
   -- set the graph_Table of accountView to graphTable
   -- set the graph_Visible of accountView to true
end menu_DisplayCatMonth

on menu_DisplayCatTotals accountView
   put the dg_Data of accountView into transactionsArray
   --
   put account_GetTotalsArray (transactionsArray, 5) into totalArray
   --
   display_Array totalArray, "totalArray"
 end menu_DisplayCatTotals

on _
end _

on menu_GenerateRandomData accountView
   -- put the dg_Data of accountView into accountArray
   put "David A, David B, Trevor, Dil, Chris Cook" into catList
   --
   put account_GenerateRandom (100, catList, accountArray) into accountArray
   put accountArray ["transactions"] into transactionsArray
   set the transactions_Array of accountView to transactionsArray
   -- display_Array accountArray
   
   put account_GetGraphTableArray (transactionsArray, "2017") into graphTableArray
   put graphTableArray ["catTable"] into catTable
   set the graph_Table of accountView to catTable
end menu_GenerateRandomData

on _
end _

on menu_ShowGraph accountView
   put the graph_Visible of accountView into sBoolean
   set the graph_Visible of accountView to (sBoolean is false)
end menu_ShowGraph

on submenu_Dev
   return "Dev | Menu"
end submenu_Dev


--> Dev | Menu
-
on menu_EditBehavior accountView
   put the behavior of accountView into bObject
   edit the script of bObject
end menu_EditBehavior

on _
end _

on menu_ConvertSeconds accountView
   put the dg_Data of accountView into transactionsArray
   put the transactions_Array of accountView into transactionsArray
   --
   set the useSystemDate to true
   repeat for each key itemNum in transactionsArray
      put transactionsArray [itemNum]["pTime"] into someTime
      convert someTime to short date
      put someTime into transactionsArray [itemNum]["pTime"]
   end repeat
   --
   set the transactions_Array of accountView to transactionsArray
end menu_ConvertSeconds

on menu_ProcessAccountData accountView
   put the dg_Data of accountView into transactionsArray
   put account_GetGraphTableArray (transactionsArray, "2017") into graphTableArray
   put graphTableArray ["catTable"] into catTable
   --
   set the graph_Table of accountView to catTable
end menu_ProcessAccountData

on menu_DisplayAccountData accountView
   put the dg_Data of accountView into someData
   display_Array someData
end menu_DisplayAccountData
