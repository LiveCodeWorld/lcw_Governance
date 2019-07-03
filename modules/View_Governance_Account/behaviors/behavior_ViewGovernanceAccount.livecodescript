script "behavior_ViewGovernanceAccount"
--> MetaData
-
license: GPLv3
name: behavior_ViewGovernanceAccount
type: behavior
version: 0.1

local LocalArray


--> Events
-
on mouseDoubleUp
   _DoDoubleUp
end mouseDoubleUp

on arrowkey pKey
   switch pKey
      case "right"
         put _GetLineArray() into lineArray
         put account_RefToDescription (lineArray) into category
         if category is empty then
            beep
         else
            _LabelLine category
         end if
         break
      default
         pass arrowkey
   end switch
end arrowkey

private command _DoDoubleUp
   put _GetLineArray() into lineArray
   put account_RefToDescription (lineArray) into category
   if category is empty then
      put lineArray ["pRef"] into pRef
      put pRef & CR & lineArray ["pCategory"]
      beep
   else
      _LabelLine category
   end if   
end _DoDoubleUp

private function _GetLineArray
   put _dataView() into dataView
   put the dgHilitedLines of dataView into lineNum
   put the dgDataOfLine [lineNum] of dataView into lineArray
   return lineArray
end _GetLineArray

on resizecontrol
   LayoutControl
end resizecontrol

on deleteKey
   pass deleteKey
end deleteKey

on backspaceKey
   pass backspaceKey
end backspaceKey

on keydown pKeyName
   put _dataView() into dataView
   put the dgEditMode of dataView into canEdit
   if canEdit is false then
      switch pKeyName
         case "i" -- Income
            _LabelLine "Business Income|Contract"
            break
         case "t" -- Travel
            _LabelLine "Business Expenses|Travel"
            break
         case "l" -- Learning
            _LabelLine "Business Expenses|Training"
            break
         case "h" -- pHone
            _LabelLine "Business Expenses|Telephone"
            break
         case "p" -- Print
            _LabelLine "Business Expenses|Stationary"
            break
         case "s" -- Software
            _LabelLine "Business Expenses|Software"
            break
         case "r" -- Rent
            _LabelLine "Business Expenses|Rent"
            break
         case "c" -- Computer hardware
            _LabelLine "Business Expenses|Hardware"
            break
         case "c" -- Cash
            _LabelLine "Personal Expenses|Cash"
            break
         case "b" -- Bank
            _LabelLine "Business Expenses|Bank"
            break
         case "f"
            _LabelLine "Business Expenses|Freelancers"
            break
         case "o" -- Food
            _LabelLine "Personal Expenses|Food"
            break
         case "e" -- entertainment
            _LabelLine "Personal Expenses|Entertainment"
            break
         case "m"
            _LabelLine "Personal Expenses|Other"
            break
         default
            pass keydown
      end switch
   else
      pass keydown
   end if
end keydown

function account_RefToDescription lineArray
   put lineArray ["pRef"] into pRef
   put lineArray ["pCategory"] into pCategory
   --
   switch
      case word 1 to 3 of pRef = "NA894654D DWP UC" AND pCategory = "DIRECTDEP"
         return "Benefits|UC"
         
      case word 1 to 3 of pRef = "L B ISLINGTON" -- AND pCategory = "DIRECTDEP"
         return "Personal Expenses|Rent"
         
      case pCategory = "CASH"
      case word -1 of pRef = "ATM"
      case word 1 to 2 of pRef = "SAINSBURYS BANK"
         return "Personal Expenses|Cash"
         
      case word 1 to 2 of pRef = "BOVILL M.F." AND pCategory = "DIRECTDEP"
      case word 1 to 3 of pRef = "GREEN D E" AND pCategory = "DIRECTDEP"
      case word 1 to 3 of pRef = "NAIL SOU LTD"
         return "Business Income|Contract"
         
      case word 1 to 2 of pRef = "APPLE STORE"
         return "Business Expenses|Hardware"
         
      case word 1 to 4 of pRef = "FISH & COOK LTD"
      case word 1 to 3 of pRef = "AMZN Mktp UK"
         return "Business Expenses|Stationary"
         
      case word 1 to 3 of pRef = "DIGITAL LIFE COLLE"
      case word 1 to 4 of pRef = "ROYAL SOCIETY OF A"
         return "Business Expenses|Training"
         
      case word 1 of pRef = "AIRBNB"
      case word 1 of pRef = "ARRIVA"
         --
      case word 1 to 2 of pRef = "EUROSTAR INTERNET"
      case word 1 to 2 of pRef = "UBER TRIP"
      case word 1 to 2 of pRef = "HEATHROW EXPRESS"
      case word 1 of pRef = "TFL.GOV.UK/CP"
      case word 1 to 2 of pRef = "TFL TRAVEL"
         return "Business Expenses|Travel"
         
      case word 1 of pRef = "ASANA"
      case word 1 of pRef = "PROTONMAIL"
      case word 1 of pRef = "DYN*DYNADOT.COM"
      case word 1 to 2 of pRef = "GODADDY COM"
      case word 1 to 3 of pRef = "GOOGLE *Google Sto"
      case word 1 to 3 of pRef = "GOOGLE *Google Mus"
      case word 1 to 2 of pRef = "GANDI NET"
         return "Business Expenses|Software"
         
      case word 1 of pRef = "H3G"
      case word 1 of pRef = "ZOOM.GBP"
      case word 1 to 2 of pRef = "VIRGIN MOBILE"
      case word 1 to 3 of pRef = "VIRGIN MEDIA PYMTS"
         return "Business Expenses|Telephone"
         
      case word 1 to 2 of pRef = "Feature Store"
         --
      case word 1 of pRef = "CHARGES"
      case word 1 to 2 of pRef = "ARVATO LIMITED"
      case word 1 to 3 of pRef = "Tech Pack Fee"
      case word 1 to 3 of pRef = "Travel Pack Fee"
      case word 1 to 3 of pRef = "Blue Rewards Fee"
      case pRef contains "Pers OD Tier 1"
         return "Business Expenses|Bank"
         
      case word 1 of pRef = "LIDL"
      case word 1 of pRef = "SAINSBURYS"
      case word 1 of pRef = "IZ"
      case word 1 to 3 of pRef = "PRET A MANGER"
      case word 1 to 3 of pRef = "SALVATION IN NOODL"
      case word 1 to 4 of pRef = "THE FRONT ROOM CAF"
      case word 1 to 2 of pRef = "SAINSBURY S/MKTS"
      case word 1 to 2 of pRef = "TESCO STORE"
      case word 1 to 2 of pRef = "TESCO STORES"
      case word 1 to 2 of pRef = "N4 COFFEEFRUIT"
      case word 1 to 2 of pRef = "THE BLACKSTOCK"
      case word 1 to 2 of pRef = "Just Eat"
         return "Personal Expenses|Food"
         
      case word 1 to 2 of pRef = "WWW.BARBICAN .ORG."
      case word 1 to 2 of pRef = "PAYPAL *MATCH.COM"
      case word 1 to 2 of pRef = "Amazon Prime"
      case word 1 of pRef = "Amazon.co.uk"
      case word 1 to 3 of pRef = "TV LICENCE MBP"
      case word 1 of pRef = "Audible.co.uk"
      case word 1 of pRef = "NETFLIX.COM"
      case word 1 of pRef = "Spotify"
         return "Personal Expenses|Entertainment"
         
      default
         return empty
   end switch
end account_RefToDescription
   
command _LabelLine category
   put _dataView() into dataView
   put the dgHilitedLines of dataView into lineNum
   --
   put the dgDataOfLine [lineNum] of dataView into lineArray
   put category into lineArray ["pCategory"]
   set the dgDataOfLine [lineNum] of dataView to lineArray
   --
   add 1 to lineNum
   set the dgHilitedLines of dataView to lineNum
end _LabelLine


--> Graph
-
getprop graph_Table
   put _graphObject() into graphObject
   put the graphData of graphObject into commaTable
   return commaTable
end graph_Table

setprop graph_Table commaTable
   if commaTable is empty then return false
   --
   put _graphObject() into graphObject
   set the graphData of graphObject to commaTable
   return true
end graph_Table

getprop graph_Visible
   put _graphObject() into graphObject
   put the visible of graphObject into someBoolean
   return someBoolean
end graph_Visible

setprop graph_Visible someBoolean
   put _graphObject() into graphObject
   put _tableField() into tableField
   put _dataView() into dataView
   --
   lock screen
   set the visible of graphObject to someBoolean
   set the visible of tableField to (not someBoolean)
   set the visible of dataView to (not someBoolean)
   unlock screen
   return graphObject
end graph_Visible


--> Data
-
getprop transactions_Array
   put LocalArray ["displayed_Data"] into accountData
   put accountData ["transactions"] into transactionsArray
   return transactionsArray
end transactions_Array

setprop transactions_Array transactionsArray
   put transactionsArray into LocalArray ["displayed_Data"]["transactions"]
   set the dg_Data of me to transactionsArray
   return LocalArray
end transactions_Array

getprop displayed_Data
   put LocalArray ["displayed_Data"] into someData
   return someData
end displayed_Data

setprop displayed_Data someData
   put someData into LocalArray ["displayed_Data"]
end displayed_Data


--> Datagrid
-
getprop dg_Data
   put _dataView() into revDataGrid
   put the dgData of revDataGrid into dataArray
   return dataArray
end dg_Data

setprop dg_Data dataArray
   put _dataView() into revDataGrid
   set the dgData of revDataGrid to dataArray
   return dgView
end dg_Data


--> Datagrid | Form
-
getprop record_View
   put _dataView() into revDataGrid
   if exists(revDataGrid) is false then return empty
   put the dgProps ["row template"] of revDataGrid into someObject
   return someObject
end record_View

setprop record_View someObject
   put _dataView() into revDataGrid
   if exists (revDataGrid) is false then return empty
   set the dgProps ["row template"] of revDataGrid to someObject
   return someView
end record_View

getprop record_ViewName
   put _dataView() into revDataGrid
   if exists (revDataGrid) is false then return empty
   return the view_Name of templateObject
end record_ViewName
 
setprop record_ViewName vName
   put _dataView() into revDataGrid
   
   put view_GetTemplateObject (vName) into templateObject
   if exists(templateObject) is false then return empty
   put the long id of templateObject into templateObject
   set the dgProps ["row template"] of revDataGrid to templateObject
   return templateObject
end record_ViewName


--> Geometry
-
command LayoutControl pRect
   if pRect is empty then put the rect of me into pRect
   put _tableField() into tableField
   put _graphObject() into graphObject
   put _dataView() into dataView
   --
   lock screen
   put the inner_Rect [pRect] of me into innerRect
   --
   set the rect of dataView to innerRect
   set the rect of tableField to innerRect
   set the rect of graphObject to innerRect
   unlock screen
end LayoutControl


--> Objects
-
getprop view_Object
   return the long id of me
end view_Object

getprop account_View
   return the long id of me
end account_View

function _dataView
   put the long id of grp 1 of me into dataView
   return dataView
end _dataView

function _tableField
   put the long id of fld 1 of me into tableField
   return tableField
end _tableField

function _graphObject
   put the long id of widget 1 of me into graphObject
   return graphObject
end _graphObject
