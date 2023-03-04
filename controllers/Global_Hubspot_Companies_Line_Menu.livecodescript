script "Global | Hubspot | Companies | Line | Menu"
--> MetaData
-
copyright: Anonymous
license: GPLv3
name: Global | Hubspot | Companies | Line | Menu
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

private function _GetCompanyArray displayView
   if the number of items of the selected_Path of displayView = 1 then
      return the selected_Array of displayView
   else
      return the top_Array of displayView
   end if 
end _GetCompanyArray


--> Global | Hubspot | Companies | Line | Menu
-
on menu_DisplayCompany displayView
   put _GetCompanyArray (displayView) into cArray
   put cArray ["id"] into companyID
   --
   put hubspot_FetchCompany (companyID) into companyData
   --
   -- put cArray ["properties"]["name"] into cName
   display_Data companyData, companyID, "Hubspot Company"
end menu_DisplayCompany

on _
end _

on menu_SearchForCompany displayView
   put _GetCompanyArray (displayView) into cArray
   put cArray ["properties"]["name"] into cName
   --
   put hubspot_FindCompany (cName) into resultArray
   display_Data resultArray, "hubspot_FindCompany", "Hubspot"
end menu_SearchForCompany

on menu_MatchCompany displayView
   put _GetCompanyArray (displayView) into cArray
   put cArray ["properties"]["name"] into cName
   --
   put hubspot_MatchCompany (cName) into resultArray
   display_Data resultArray, "hubspot_MatchCompany", "Hubspot"
end menu_MatchCompany

on _
end _
on menu_DeleteCompany displayView
   put _GetCompanyArray (displayView) into tArray
   put tArray ["id"] into companyID
   --
   hubspot_DeleteCompany companyID
   --
   display_HubspotCompanies
end menu_DeleteCompany

on _
end _

on submenu_Dev
   return "Dev | Menu"
end submenu_Dev


--> Dev | Menu
-
on menu_Experiment displayView
   put displayView
end menu_Experiment


--> Deps
-
