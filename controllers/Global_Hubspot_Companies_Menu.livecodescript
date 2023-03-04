script "Global | Hubspot | Companies | Menu"
--> MetaData
-
copyright: Anonymous
license: GPLv3
name: Global | Hubspot | Companies | Menu
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
   -- called once for each menu
   return tObject
end menu_Target

getprop switchApiKey_Param [mTarget]
   return hubspot_GetApiKeyType()
end switchApiKey_Param

getprop switchApiKey_Params [mTarget]
   return hubspot_ListApiKeyTypes()
end switchApiKey_Params


--> Global | Hubspot | Companies | Menu
-
on menu_ListAssets
   put atopia_ListAssets ("festivalofmint.org", "2012/photos")
end menu_ListAssets

on menu_Refresh
   display_HubspotCompanies
end menu_Refresh

on _
end _

on submenu_Dev
   return "Dev | Menu"
end submenu_Dev


--> Dev | Menu
-
on menu_DisplayAustria
   display_IntentionalCountry "Austria"
end menu_DisplayAustria

on menu_SwitchApiKey displayView, apiKeyType
   hubspot_SetApiKeyType apiKeyType
end menu_SwitchApiKey


--> Deps
-
