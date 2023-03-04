script "lib_Hubspot"
--> MetaData
-
copyright: David Bovill
license: GPLv3
name: lib_Hubspot
type: library
version: 0.1

/*Some help*/

constant ApiStem = "https://api.hubapi.com/crm/v3/"


--> Working on
-
command display_HubspotCompanies 
   put hubspot_FetchCompanyListData() into contactListData
   put contactListData ["results"] into listingData
   --
   put hubspot_ConstructNamedData (listingData) into namedData
   put the keys of namedData into cNames
   sort cNames
   --
   display_Data cNames, "Companies", "Hubspot"
   put the result into displayView
   --
   set the named_Data of displayView to namedData
   set the listing_Data of displayView to listingData
   --
   display_SetInteractions displayView, "Hubspot | Companies", "display_HubspotCompany"
   return displayView
end display_HubspotCompanies

function hubspot_FindNamedData
   put display_FindView ("Hubspot", "Companies") into displayView
   if exists (displayView) is false then
      display_HubspotCompanies
      put the result into displayView
   end if
   --
   put the named_Data of displayView into namedData
   return namedData
end hubspot_FindNamedData

on display_HubspotCompany fieldObject, cName
   put the display_View of fieldObject into displayView
   put the name_Data of displayView into nameData
   --
   put nameData [cName] into itemArray
   --
   display_Data itemArray, cName
end display_HubspotCompany

on display_HubContacts
   put hubspot_FetchContactListData() into contactListData
   put contactListData ["results"] into listingData
   display_Data listingData, "Contacts", "Hubspot"
   put the result into displayView
   --
   display_SetInteractions displayView, "Hubspot | Contacts", "display_HubspotContact"
   return displayView
end display_HubContacts

on display_HubspotContact fieldObject, someContact
   put the params
end display_HubspotContact


--> Hubspot
-
function hubspot_ConstructNamedData listingData
   repeat with itemNum = 1 to item 2 of the extents of listingData
      put listingData [itemNum] into itemArray
      put itemArray ["properties"]["name"] into someName
      put itemArray into nameData [someName]
   end repeat
   return nameData
end hubspot_ConstructNamedData

function hubspot_MatchCompany cName
   put hubspot_FetchMatchCompanyData (cName) into resultArray
   put resultArray ["total"] > 0 into isMatched
   return isMatched
end hubspot_MatchCompany

function hubspot_FetchMatchCompanyData cName
   put cName into postArray ["filterGroups"][1]["filters"][1]["value"]
   put "name" into postArray ["filterGroups"][1]["filters"][1]["propertyName"]
   put "EQ" into postArray ["filterGroups"][1]["filters"][1]["operator"]
   --
   put _RestPostObjectsArray ("objects/companies/search", postArray) into resultArray
   return resultArray
end hubspot_FetchMatchCompanyData

function hubspot_FindCompany searchTerm
   put searchTerm into postArray ["query"]
   put _RestPostObjectsArray ("objects/companies/search", postArray) into resultArray
   return resultArray
end hubspot_FindCompany

function hubspot_MatchContact firstName, lastName
   put hubspot_FetchMatchContactData (firstName, lastName) into resultArray
   put resultArray ["total"] > 0 into isMatched
   return isMatched
end hubspot_MatchContact

function hubspot_FetchMatchContactData firstName, lastName
   if firstName is not empty then
      put firstName into postArray ["filterGroups"][1]["filters"][1]["value"]
      put "firstname" into postArray ["filterGroups"][1]["filters"][1]["propertyName"]
      put "EQ" into postArray ["filterGroups"][1]["filters"][1]["operator"]
   end if
   if lastName is not empty then
      if postArray is an array then
         put 2 into filterNum
      else
         put 1 into filterNum
      end if
      put lastName into postArray ["filterGroups"][1]["filters"][filterNum]["value"]
      put "lastname" into postArray ["filterGroups"][1]["filters"][filterNum]["propertyName"]
      put "EQ" into postArray ["filterGroups"][1]["filters"][filterNum]["operator"]
   end if
   --
   put _RestPostObjectsArray ("objects/contacts/search", postArray) into resultArray
   return resultArray
end hubspot_FetchMatchContactData

function hubspot_FindContact searchTerm
   put searchTerm into postArray ["query"]
   put _RestPostObjectsArray ("objects/contacts/search", postArray) into resultArray
   return resultArray
end hubspot_FindContact


--> Hubspot | Company | Create
-
command hubspot_CreateCompany postData
   put _RestPostObjectsArray ("objects/companies", postData) into resultArray
   return resultArray
end hubspot_CreateCompany

command hubspot_CreateContact postData
   put _RestPostObjectsArray ("objects/contacts", postData) into resultArray
   return resultArray
end hubspot_CreateContact


--> Hubspot | Contact | Create
-
command hubspot_CreateContact postData
   put _RestPostObjectsArray ("objects/contacts", postData) into resultArray
   return resultArray
end hubspot_CreateContact


--> Hubspot | Company
-
command hubspot_DeleteCompany companyID
   --url 'https://api.hubapi.com/crm/v3/objects/companies/companyId?hapikey=YOUR_HUBSPOT_API_KEY'
   
   put ApiStem & "objects/companies/" & companyID & "?hapikey=" & hubspot_GetApiKey() after restURL
   delete url restURL
   get the result
   return it
end hubspot_DeleteCompany

function hubspot_FetchCompany companyID
   /*
   https://api.hubapi.com/crm/v3/objects/companies/6041619263
   ?properties=phone%2Ccity%2Cdescription%2Cindustry
   &archived=false
   &hapikey=a361ea29-dc3e-45f8-b902-bd044325652a'
   */
   
   put "objects/companies/" & companyID into apiBit
   put hubspot_ListCompanyProps (true) into pArray ["properties"]
   --
   put _RestGetObjectsArray (apiBit, pArray) into resultArray
   return resultArray
end hubspot_FetchCompany

function hubspot_FetchCompanyListData
   -- properties=phone%2Ccity%2Cdescription%2Cindustry
   -- limit=10&archived=false
   -- put "description,phone,city,state,country,industry" into pArray ["properties"]
   put hubspot_ListCompanyProps (true) into pArray ["properties"]
   put 25 into pArray ["limit"]
   put false into pArray ["archived"]
   --
   put _RestGetObjectsArray ("objects/companies", pArray) into resultArray
   return resultArray
end hubspot_FetchCompanyListData

function hubspot_ListContactProps pImportant
   if pImportant is true then
      -- return "description,phone,city,state,country,industry"
      get "firstname,lastname,photo,salutation,industry,job_function,jobtitle,"
      put "email,work_email,mobilephone,phone,website,webinareventlastupdated," after it
      put "date_of_birth,gender,marital_status," after it
      put "address,city,state,country,zip," after it
      put "twitterhandle,twitterbio,followercount,twitterprofilephoto," after it
      put "linkedinbio,linkedinconnections," after it
      put "company,associatedcompanyid,associatedcompanylastupdated," after it
      put "createdate,lastmodifieddate," after it
      put "school,field_of_study,degree," after it
      put "notes_last_contacted,notes_last_updated,notes_next_activity_date," after it
      put "owneremail,ownername," after it
      delete char -1 of it
      return it
   end if
   
   put hubspot_FetchContactPropertyData() into resultArray
   repeat with itemNum = 1 to item 2 of the extents of resultArray
      put resultArray [itemNum]["name"] & CR after cProps
   end repeat
   delete char -1 of cProps
   
   sort cProps
   --
   if pImportant is false then
      filter cProps without "num_*"
      filter cProps without "recent_*"
      filter cProps without "hs_*"
      filter cProps without "first_*"
      filter cProps without "engagements_*"
      filter cProps without "hubspot_*"
      filter cProps without "closedate*"
      filter cProps without "total_*"
      filter cProps without "ip_*"
   end if
   --
   -- replace CR with comma in cProps
   return cProps
end hubspot_ListContactProps

function hubspot_ListCompanyProps pImportant
   if pImportant is true then
      -- return "description,phone,city,state,country,industry"
      get "about_us,createdate,description,industry,is_public,name,phone,type"
      put ",address,address2,city,state,country,zip,timezone" after it
      put ",domain,website,facebook_company_page,facebookfans" after it
      put ",twitterbio,twitterfollowers,twitterhandle" after it
      put ",linkedin_company_page,linkedinbio" after it
      put ",num_contacted_notes,num_notes,notes_last_contacted,notes_last_updated,notes_next_activity_date" after it
      put ",founded_year,numberofemployees,owneremail,ownername" after it
      return it
   end if
   
   put hubspot_FetchCompanyPropertyData() into resultArray
   repeat with itemNum = 1 to item 2 of the extents of resultArray
      put resultArray [itemNum]["name"] & CR after cProps
   end repeat
   delete char -1 of cProps
   sort cProps
   --
   if pImportant is false then
      filter cProps without "num_*"
      filter cProps without "recent_*"
      filter cProps without "hs_*"
      filter cProps without "first_*"
      filter cProps without "engagements_*"
      filter cProps without "hubspot_*"
      filter cProps without "closedate*"
      filter cProps without "total_*"
   end if
   --
   replace CR with comma in cProps
   return cProps
end hubspot_ListCompanyProps

function hubspot_FetchCompanyPropertyData
   put hubspot_FetchObjectTypePropertyData ("company") into resultData
   put resultData ["results"] into propertyData
   return propertyData
end hubspot_FetchCompanyPropertyData


--> Hubspot | Contact
-
function hubspot_FetchContactPropertyData
   put hubspot_FetchObjectTypePropertyData ("contact") into resultData
   put resultData ["results"] into propertyData
   return propertyData
end hubspot_FetchContactPropertyData

function hubspot_ListContactObjectTypes
   put hubspot_FetchContactObjectTypeData() into resultArray
   --
   repeat with itemNum = 1 to item 2 of the extents of resultArray
      put resultArray [itemNum]["name"] & CR after cProps
   end repeat
   delete char -1 of cProps
   return cProps
end hubspot_ListContactObjectTypes

function hubspot_FetchContactObjectTypeData
   put hubspot_FetchPropertyGroupData ("contact") into resultData
   put resultData ["results"] into resultArray
   return resultArray
end hubspot_FetchContactObjectTypeData

function hubspot_FetchContact contactID
   -- /crm/v3/objects/contacts/{contactId}
   
   put hubspot_ListContactProps (true) into pArray ["properties"]
   put "objects/contacts/" & contactID into apiBit
   put _RestGetObjectsArray (apiBit, pArray) into resultArray
   return resultArray
end hubspot_FetchContact

function hubspot_ListContacts
   put hubspot_FetchContactListData() into contactListData
   return contactListData
end hubspot_ListContacts

function hubspot_FetchContactListData
   -- ?limit=10&archived=false
   put _RestGetObjectsArray ("objects/contacts") into resultArray
   return resultArray
end hubspot_FetchContactListData


--> Hubspot | Properties
-
function hubspot_ListObjectTypes
   -- custom types can be created with an enterprise account
   return "contact,product,company,deal,ticket,marketing_event,quote"
end hubspot_ListObjectTypes

-- function hubspot_ListContactGroupTypes
-- default for "hubspot_ListContactObjectTypes()"
return "contact_activity,deal_information,sales_properties,contactinformation,socialmediainformation,emailinformation,analyticsinformation,conversioninformation,facebook_ads_properties"
end hubspot_ListContactGroupTypes

function hubspot_FetchObjectTypePropertyData objectType
   -- /crm/v3/properties/{objectType}
   
   put "properties/" & objectType into apiBit
   put _RestGetObjectsArray (apiBit) into resultData
   return resultData
end hubspot_FetchObjectTypePropertyData

function hubspot_FetchPropertyGroupData objectType
   -- Documentation - https://developers.hubspot.com/docs/api/crm/properties
   -- GET /crm/v3/properties/{objectType}/groups
   
   put "properties/" & objectType & "/groups" into apiBit
   put _RestGetObjectsArray (apiBit) into resultData
   return resultData
end hubspot_FetchPropertyGroupData


--> Hubspot | Rest
-
private function _RestGetObjectsArray apiBit, pArray
   put _RestConstructObjectsURL (apiBit, pArray) into restURL
   put url restURL into resultJSON
   --
   put json_ToArray (resultJSON) into resultArray
   return resultArray
end _RestGetObjectsArray

private function _RestConstructObjectsURL apiBit, pArray
   /*
   https://api.hubapi.com/crm/v3/objects/companies/6041619263
   ?properties=phone%2Ccity%2Cdescription%2Cindustry
   &archived=false
   &hapikey=a361ea29-dc3e-45f8-b902-bd044325652a'
   */
   
   put ApiStem & apiBit into restURL
   put "?hapikey=" & hubspot_GetApiKey() after restURL
   --
   repeat for each key someKey in pArray
      get pArray [someKey]
      put URLEncode(it) into someValue
      put "&" & someKey & "=" & someValue after restURL
   end repeat
   --
   return restURL   
end _RestConstructObjectsURL

private function _RestPostObjectsArray apiBit, postArray
   /*
   curl --request POST \
   --url 'https://api.hubapi.com/crm/v3/objects/contacts?hapikey=a361ea29-dc3e-45f8-b902-bd044325652a' \
   --header 'content-type: application/json'
   */
   
   put json_FromArray (postArray) into someJSON
   put ApiStem & apiBit & "?hapikey=" & hubspot_GetApiKey() after restURL -- "?" instead of "&"
   --
   rest_SetJsonHeaders
   post someJSON to restURL 
   put it into jsonResult
   --
   put json_ToArray (jsonResult) into resultArray
   return resultArray
end _RestPostObjectsArray


--> Hubspot | Authentication
-
function hubspot_GetApiKeyType
   -- return "dev"
   
   put secret_GetLocalArray ("hubspot") into secretArray
   put secretArray ["HubspotApiKey"] into apiKey
   delete variable secretArray ["HubspotApiKey"]
   repeat for each key apiKeyType in secretArray
      get secretArray [apiKeyType]
      if it = apiKey then
         return apiKeyType
      end if
   end repeat
   return empty
end hubspot_GetApiKeyType

function hubspot_ListApiKeyTypes
   put secret_GetLocalArray ("hubspot") into secretArray
   delete variable secretArray ["HubspotApiKey"]
   put the keys of secretArray into apiKeyTypes
   sort apiKeyTypes
   return apiKeyTypes
end hubspot_ListApiKeyTypes

command hubspot_SetApiKeyType apiKeyType
   put secret_Get (apiKeyType, "hubspot") into apiKey
   hubspot_SetApiKey apiKey
   return apiKey
end hubspot_SetApiKeyType

function hubspot_GetApiKey
   put secret_Get ("HubspotApiKey", "hubspot") into apiKey
   return apiKey
end hubspot_GetApiKey

command hubspot_SetApiKey apiKey
   secret_Set "HubspotApiKey", apiKey, "hubspot"
   put the result into modelDataFile
   return modelDataFile
end hubspot_SetApiKey


--> Deps
-
