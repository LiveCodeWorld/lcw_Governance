script "lib_Account"
--> MetaData
-
license: GPLv3
name: lib_Account
type: library
version: 0.1


--> Display
-
command display_Account monthArray, pStackLabel
   display_ClonedView "View|Governance|Account", true
   put the result into clonedView
   --
   set the transactions_Array of clonedView to monthArray
   put the stack_Name of clonedView into stackName
   
   if pStackLabel is not empty then
      set the label of stack stackName to pStackLabel
   end if
   set the visible of stack stackName to true
   return clonedView
end display_Account


--> Working on
-
function account_GetTotal transactionsArray
   local paymentTotal
   --
   repeat for each key itemNum in transactionsArray
      put transactionsArray [itemNum] into tArray
      account_DeconstructEntry tArray, paymentAmount, paymentTime, pCategory, pRef
      add paymentAmount to paymentTotal
   end repeat
   return paymentTotal
end account_GetTotal

function account_GetTotalsTotal totalArray
   local runningTotal
   account_RecurseTotalArray totalArray, runningTotal
   return runningTotal
end account_GetTotalsTotal

command account_RecurseTotalArray totalArray, @runningTotal
   -- recursive
   repeat for each key someKey in totalArray
      get totalArray [someKey]
      if it is a number then
         add it to runningTotal
      else
         account_RecurseTotalArray it, runningTotal
      end if
   end repeat
end account_RecurseTotalArray

function account_GetTotalsArray transactionsArray, pDayNum
   -- careful as top-keys overwrite lower keys
   -- ensure there are no top-keys like "Personal expenses"
   -- as they will overwrite stuff like "Personal Expenses|Food"
   
   put account_ConstructYearsArray (transactionsArray, pDayNum) into yearData
   --
   repeat for each key someYear in yearData
      put yearData [someYear] into yearArray
      put account_ProcessYearArray (yearArray) into yearCategoryArray
      --
      repeat for each key monthNum in yearCategoryArray
         put yearCategoryArray [monthNum] into monthCatArray
         --
         repeat for each key pCategory in monthCatArray
            put monthCatArray [pCategory]["sum"] into paymentAmount
            --
            put pCategory into totalKey
            split totalKey with "|"
            
            -- no let's add it to the total which could come from other months or years
            put totalArray [totalKey] into oldTotal     
            put paymentAmount + oldTotal into totalArray [totalKey]      
         end repeat
      end repeat
   end repeat
   --
   account_CheckTotalsArray totalArray, transactionsArray
   --
   return totalArray
end account_GetTotalsArray

command account_CheckTotalsArray totalArray, transactionsArray
   put account_GetTotalsTotal (totalArray) into catTotals
   put account_GetTotal (transactionsArray) into accountTotal
   if accountTotal is not catTotals then
      put "Cat Total:" && catTotals & CR & "Account Total:" && accountTotal
      beep
      lcw_AnswerWarning "Totals don't match!"
      breakpoint
      return false
   else
      return true
   end if
end account_CheckTotalsArray

command account_SetMonthTotalArray monthCatArray, @transactionTotalArray, @totalArray, pPaymentTime
   /*
   transactionTotalArray is a dgData compatible table
   totalArray is pretty
   */
   
   repeat for each key pCategory in monthCatArray
      put monthCatArray [pCategory]["sum"] into paymentAmount
      put pCategory into pRef
      put pCategory into pRef
      --
      account_AddEntryArray transactionTotalArray, paymentAmount, pPaymentTime, "Total", pRef
      --
      put pCategory into totalKey
      split totalKey with "|"
      put paymentAmount into totalArray [totalKey]      
   end repeat
end account_SetMonthTotalArray


--> Account | Category
-
function account_GetGraphTableArray transactionsArray, someYear, pDayNum
   put account_ConstructYearsArray (transactionsArray, pDayNum) into yearData
   put yearData [someYear] into yearArray
   --
   put account_ProcessYearArray (yearArray) into yearCategoryArray
   put account_GetCatList (yearCategoryArray) into catList
   put account_ConstructGraph (yearCategoryArray, catList) into graphTable
   --
   put graphTable into graphTableArray ["graphTable"]
   put catList into graphTableArray ["catList"]
   put yearCategoryArray into graphTableArray ["yearCategoryArray"]
   return graphTableArray
end account_GetGraphTableArray

function account_ProcessYearArray yearArray
   repeat for each key monthNum in yearArray
      put yearArray [monthNum] into monthArray
      repeat for each key itemNum in monthArray
         put monthArray [itemNum] into tArray
         --
         account_DeconstructEntry tArray, paymentAmount, paymentTime, pCategory, pRef
         put categoryArray [pCategory]["sum"] into lastTotal
         add paymentAmount to lastTotal
         account_RoundCash lastTotal
         put lastTotal into categoryArray [pCategory]["sum"]
      end repeat
      put categoryArray into yearCategoryArray [monthNum]
   end repeat
   return yearCategoryArray
end account_ProcessYearArray

function account_GetCatList yearCategoryArray
   local bigCatArray
   repeat for each key itemNum in yearCategoryArray
      get yearCategoryArray [itemNum]
      union bigCatArray with it
   end repeat
   put keys(bigCatArray) into catList
   replace CR with comma in catList
   return catList
end account_GetCatList

function account_ConstructGraph yearCategoryArray, catList
   put the number of items of catList into catNum
   put "Jan,Feb,Mar,Apr,May,Jun,Jul,Aug,Sep,Oct,Nov,Dec" into monthLabels
   --
   repeat with monthNum = 1 to 12
      put item monthNum of monthLabels into mLabel
      put mLabel into line monthNum of catTable
      --
      repeat with itemNum = 1 to catNum
         put word 1 to -1 of item itemNum of catList into catName
         put yearCategoryArray [monthNum][catName]["sum"] into monthSum
         put monthSum into item (itemNum + 1) of line monthNum of catTable
      end repeat
   end repeat
   return catTable
end account_ConstructGraph


--> Account | Months
-
function account_ConstructYearsArray transactionsArray, pDayNum
   /*
   Logic of subtracting months and years with dates less than pDayNum is not fuly tested
   */
   
   if pDayNum is empty then put 1 into pDayNum
   set the useSystemDate to true
   --
   repeat for each key itemNum in transactionsArray
      put transactionsArray [itemNum] into tArray
      account_DeconstructEntry tArray, paymentAmount, paymentTime, pCategory, pRef
      convert paymentTime to dateItems
      put item 1 of paymentTime into someYear
      put item 2 of paymentTime into monthNum
      put item 3 of paymentTime into dayNum
      --
      if dayNum < pDayNum then
         if monthNum = 1 then
            breakpoint
            put 12 into monthNum
            subtract 1 from someYear 
         else
            subtract 1 from monthNum 
         end if
      end if
      
      put yearData [someYear][monthNum] into monthArray
      put item 2 of the extents of monthArray + 1 into newIndexNum
      put tArray into monthArray [newIndexNum]
      put monthArray into yearData [someYear][monthNum]
   end repeat
   return yearData
end account_ConstructYearsArray

function account_GetPresentMonths transactionsArray
   put account_GetMonthsPresentArray (transactionsArray) into monthsPresentArray
   put account_GetPresentMonthNames (monthsPresentArray) into someMonths
   return someMonths
end account_GetPresentMonths

function account_GetMonthNum mName, monthsPresentArray
   repeat for each key monthNum in monthsPresentArray
      if monthsPresentArray [monthNum] = mName then
         return monthNum
      end if
   end repeat
   return 0
end account_GetMonthNum

function account_GetPresentMonthNames monthsPresentArray
   put keys (monthsPresentArray) into monthNums
   sort numeric monthNums
   repeat for each line monthNum in monthNums
      put monthsPresentArray [monthNum] into mName
      put mName & CR after someMonths
   end repeat
   delete char -1 of someMonths
   return someMonths
end account_GetPresentMonthNames

function account_GetMonthsPresentArray transactionsArray
   set the useSystemDate to true
   repeat for each key itemNum in transactionsArray
      put transactionsArray [itemNum] into tArray
      account_DeconstructEntry tArray, paymentAmount, paymentTime, pCategory, pRef
      convert paymentTime to dateItems
      put item 2 of paymentTime into monthNum
      
      convert paymentTime to long date
      put word 2 of item 2 of paymentTime into monthName
      put monthName into monthsPresentArray [monthNum]
   end repeat
   return monthsPresentArray
end account_GetMonthsPresentArray


--> Account | Barclays
-
function account_ProcessBarclays someCSV, pConvertToSeconds
   /*
   Number,Date,Account,Amount,Subcategory,Memo
   ,06/09/2018,20-81-21 13224996,-15.86,PAYMENT,LIDL UK LONDON        ON 05 SEP          CLP
   */
   
   put line 1 of someCSV into itemHeaders
   put the number of items of itemHeaders into maxItemNum
   delete line 1 of someCSV
   put 1 into lineNum
   set the useSystemDate to true
   repeat for each line someLine in someCSV
      put item 2 of someLine into paymentTime
      if pConvertToSeconds is true then
         convert paymentTime to seconds
      end if
      put item 4 of someLine into paymentAmount
      put item 5 of someLine into pCategory
      put item 6 of someLine into pRef
      
      put paymentAmount into transactionsArray [lineNum]["pAmount"]
      put paymentTime into transactionsArray [lineNum]["pTime"]
      put pCategory into transactionsArray [lineNum]["pCategory"]
      put pRef into transactionsArray [lineNum]["pRef"]
      --
      add 1 to lineNum
   end repeat
   return transactionsArray
end account_ProcessBarclays

function account_ProcessCSV someCSV 
   put line 1 of someCSV into itemHeaders
   put the number of items of itemHeaders into maxItemNum
   delete line 1 of someCSV
   put 1 into lineNum
   repeat for each line someLine in someCSV
      repeat with itemNum = 1 to maxItemNum
         put item itemNum of someLine into someValue
         put item itemNum of itemHeaders into someKey
         put someValue into accountArray [lineNum][someKey] 
      end repeat
      add 1 to lineNum
   end repeat
end account_ProcessCSV


--> Account | Test
-
function account_GenerateRandom howMany, catList, accountArray, pUseShortDate
   put 1 into itemNum
   set the useSystemDate to true
   repeat for each item pName in catList
      put word 1 to -1 of pName into pName
      put 5 + random (95) into pMean
      put trunc (pMean * 0.2) into pStdSeed
      put random (pStdSeed) into pStd
      --
      put stats_PolarBoxMuller (howMany, pMean, pStd) into amountList
      repeat for each item paymentAmount in amountList
         put date_GetRandomSeconds ("1/1/2017", "31/12/2017") into paymentTime
         if pUseShortDate is not false then
            convert someDate to short date
         end if
         put "Randomly generated payment number" && format("%02d", itemNum) into pRef
         --
         account_AddEntryArray accountArray, paymentAmount, paymentTime, pName, pRef
         --
         add 1 to itemNum
      end repeat
   end repeat
   --
   return accountArray
end account_GenerateRandom


--> Account | Utils
-
command account_DeconstructEntry tArray, @paymentAmount, @paymentTime, @pCategory, @pRef
   put tArray ["pAmount"] into paymentAmount
   put tArray ["pTime"] into paymentTime
   put tArray ["pCategory"] into pCategory
   put tArray ["pRef"] into pRef
end account_DeconstructEntry

command account_AddEntryArray @accountArray, paymentAmount, paymentTime, pCategory, pRef
   -- accountID and paymentCurrency metadata
   put accountArray ["transactions"] into transactionsArray
   put item 2 of the extents of transactionsArray into maxItemNum
   add 1 to maxItemNum
   --
   account_RoundCash paymentAmount
   put paymentAmount into accountArray ["transactions"][maxItemNum]["pAmount"]
   put paymentTime into accountArray ["transactions"][maxItemNum]["pTime"]
   if pCategory is not empty then put pCategory into accountArray ["transactions"][maxItemNum]["pCategory"]
   if pRef is not empty then put pRef into accountArray ["transactions"][maxItemNum]["pRef"]
   --
   return maxItemNum
end account_AddEntryArray

command account_RoundCash @paymentAmount
   put format ("%.2f", paymentAmount) into paymentAmount
   
   /*
   set the numberformat to "0.00"
   -- put paymentAmount + 0 into paymentAmount
   -- add 0 to paymentAmount
   put trunc (100 * paymentAmount) / 100 into paymentAmount -- bug:  numberformat not working for some reason
   set the numberformat to "0.######"
   */
   
   /*
   -- bug:  numberformat not working for some reason
   set the numberformat to "#.00"
   put paymentAmount + 0 into paymentAmount
   set the numberformat to "0.######"
   */
end account_RoundCash
