script "lib_Coda"
--> MetaData
-
copyright: David Bovill
license: GPLv3
name: lib_Coda
type: library
version: 0.1

/*Some help*/


--> Working on
-
function coda_GetApiKey
   return secret_Get("Coda Api Key" )
end coda_GetApiKey

command coda_SetApiKey apitoken
   secret_Set "Coda Api Key", apiToken
end coda_SetApiKey


--> Coda
-
function coda_ListDocs
   /*
   https://coda.io/apis/v1/docs' |
   jq .items[0].name
   # => "New Document"
   */
   put coda_GetApiKey() into apiKey
   put "https://coda.io/apis/v1/docs" into restURL
   
   put jsonrpc_GetArray (restURL, apiKey) into sArray
   display_Data sArray, "List Docs"
   return sArray
end coda_ListDocs


--> Deps
-
