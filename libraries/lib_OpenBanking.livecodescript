script "lib_OpenBanking"
--> MetaData
-
license: GPLv3
name: lib_OpenBanking
type: library
version: 0.2


--> Stats
-
function stats_PolarBoxMuller pLength, pMean, pStd
   -- rough guassian distribution
   -- thanks to Mark Smith lists@futilism.com
   -- https://en.wikipedia.org/wiki/Box%E2%80%93Muller_transform#Polar_form
   put 2 ^ 32 -1 into tMax
   repeat plength div 2
      repeat
         put (random(tMax) / tMax) * 2 - 1 into x
         put (random(tMax) / tMax) * 2 - 1 into y
         put x * x + y * y into r
         if r <> 0 and r <= 1 then exit repeat
      end repeat
      
      put sqrt( -2 * ln(r) / r) into d
      put pMean + (x * d) * pStd & comma after tList
      put pMean + (y * d) * pStd & comma after tList
   end repeat
   return char 1 to -2 of tList
end stats_PolarBoxMuller


--> Starling
-
function starling_ConstructPaymentArray paymentAmount, accountID, paymentRef
   /*
   {
   "payment": {
   "currency": "GBP",
   "amount": 10.24
   },
   "destinationAccountUid": "7f03a23a-bafc-4479-8d4d-abb6a9119d27",
   "reference": "Dinner"
   }
   */
   
   put "1.00" into paymentAmount
   put "API test" into paymentRef
   put "b422e3a0-781e-4726-b049-067604ce7855" into accountID -- Barclays contact
   --
   put paymentAmount into postArray ["payment"]["amount"]
   put "GBP" into postArray ["payment"]["currency"]
   put accountID into postArray ["destinationAccountUid"]
   put paymentRef into postArray ["reference"]
   --
   return postArray
end starling_ConstructPaymentArray

command starling_PostPaymentArray paymentAmount, accountID, paymentRef
   put starling_ConstructPaymentArray (paymentAmount, accountID, paymentRef) into postArray
   --
   starling_PostArray "payments/local", postArray
   --
   put the result into paymentResultArray
   return paymentResultArray
end starling_PostPaymentArray


--> Starling | REST | POST
-
command starling_PostArray restPath, postArray
   put json_FromArray (postArray) into someJSON
   starling_PostJSON restPath, someJSON
   put the result into someJSON
   put json_ToArray (someJSON) into responseArray
   return responseArray
end starling_PostArray

command starling_PostJSON restPath, someJSON
   put "api/v1/" & restPath into someLink
   put "https://api.starlingbank.com/" & someLink into restURL
   --
   put startling_GetAuthenticationToken() into oAuthToken
   put jsonrpc_POST (someJSON, restUrl, oAuthToken) into someJSON
   return someJSON
end starling_PostJSON


--> Starling
-
function startling_FetchSchedulePayments
   -- payments/scheduled
   put starling_FetchArray ("payments", "scheduled") into someArray
   return someArray
end startling_FetchSchedulePayments

function starling_FetchContactAccount contactID
   -- contacts/{id}/accounts
   put contactID & "/accounts" into pathBit
   put starling_FetchArray ("contacts", pathBit) into someArray
   return someArray
end starling_FetchContactAccount

function starling_FetchContact contactID
   put starling_FetchArray ("contacts", contactID) into someArray
   return someArray
end starling_FetchContact

function starling_FetchContacts
   put starling_FetchArray ("contacts") into someArray
   return someArray
end starling_FetchContacts

function starling_FetchAddresses
   put starling_FetchArray ("addresses") into someArray
   return someArray
end starling_FetchAddresses

function starling_FetchBalance
   -- accounts/balance
   put starling_FetchArray ("accounts", "balance") into someArray
   return someArray
end starling_FetchBalance

function starling_FetchTransactions
   put starling_FetchArray ("transactions") into someArray
   return someArray
end starling_FetchTransactions


--> Starling | REST
-
function starling_FetchArray pathStem, pPathID
   put pathStem into restPath
   if pPathID is not empty then
      put "/" & pPathID after restPath
   end if
   put starling_FetchJSON (restPath) into someJSON
   put json_ToArray (someJSON) into someArray
   return someArray
end starling_FetchArray

function starling_FetchJSON restPath
   put "api/v1/" & restPath into someLink
   put startling_FetchLinkJson (someLink) into someJSON
   return someJSON
end starling_FetchJSON

function startling_FetchLinkJson someLink
   -- put "api/v1/contacts/b422e3a0-781e-4726-b049-067604ce7855/photo" into someLink
   put "https://api.starlingbank.com/" & someLink into restURL
   put startling_GetAuthenticationToken() into oAuthToken
   put jsonrpc_GET (restURL, oAuthToken) into someJSON
   return someJSON
end startling_FetchLinkJson


--> Startling | Authentication
-
function startling_GetAuthenticationToken
   put secret_GetCached ("StarlingAuthenticationToken", "starling") into oAuthToken
   return oAuthToken
end startling_GetAuthenticationToken


--> Starling | Authentication | Set
-
command starling_SetAuthenticationToken oAuthToken
   secret_Set "StarlingAuthenticationToken", "starling", oAuthToken
   put the result into modelDataFile
   return modelDataFile
end starling_SetAuthenticationToken
