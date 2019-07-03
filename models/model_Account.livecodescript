script "model_Account"
--> MetaData
-
license: GPLv3
name: model_Account
type: model
version: 0.1


--> Working on
-
function account_ListKeys
   put account_GetData() into accountData
   put keys (accountData) into accountKeys
   return accountKeys
end account_ListKeys

function account_GetArray someKey
   put account_GetData() into accountData
   put accountData [someKey] into accountArray
   return accountArray 
end account_GetArray

command account_SetArray someKey, someValue
   put account_GetData() into accountData
   put someValue into accountData [someKey]
   account_SetData accountData
   return accountData 
end account_SetArray

function account_GetData
   put the model_Array ["account.array"] of stack "lcw_Governance" into accountData
   return accountData 
end account_GetData

command account_SetData accountData
   set the model_Array ["account.array"] of stack "lcw_Governance" to accountData
   put the result into modelDataFile
   return modelDataFile
end account_SetData
