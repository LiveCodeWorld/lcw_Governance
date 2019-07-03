script "Global_Starling_Menu"
--> MetaData
-
license: GPLv3
name: Global_Starling_Menu
type: controller
version: 0.1


--> Global | Starling | Menu
-
on menu_TestPayment
   starling_PostPaymentArray
   put the result into paymentResultArray
   --
   display_Array paymentResultArray, "Payment,Starling"
end menu_TestPayment

on _
end _

on menu_DisplayBalance
   put starling_FetchBalance() into someArray
   --
   display_Array someArray, "Balance,Starling"
end menu_DisplayBalance

on menu_DisplayTranactions
   put starling_FetchTransactions() into someArray
   --
   display_Array someArray, "Transactions,Starling"
end menu_DisplayTranactions


on _
end _

on menu_DisplayAddresses
   put starling_FetchAddresses() into someArray
   --
   display_Array someArray, "Addresses,Starling"
end menu_DisplayAddresses

on menu_DisplayContacts
   put starling_FetchContacts() into someArray
   --
   display_Array someArray, "Contacts,Starling"
end menu_DisplayContacts


--> Global | Starling | Menu | Props
-

--> Global | Starling | Menu | Disabled
-
