script "Global_Governance_Menu"
--> MetaData
-
license: GPLv3
name: Global_Governance_Menu
type: controller
version: 0.2


--> Menu | Props
-
getprop display_Params
   return "Task,Projects,MyTasks,-,Unlimited,DEIP,-,Project,Project Sections"
end display_Params


--> Global | Governance | Menu
-
on menu_GovernanceIcons
   icon_LoadFamily "Governance", true
end menu_GovernanceIcons

on menu_Workspaces
   display_AsanaWorkspaces
end menu_Workspaces

on _
end _

on menu_HubspotContacts
   display_HubContacts
end menu_HubspotContacts

on menu_HubspotCompanies
   display_HubspotCompanies
end menu_HubspotCompanies

on _
end _

on menu_TestHubspotContact
   display_Data hubspot_FetchContact(1)
   display_Data hubspot_FetchContact(51)
end menu_TestHubspotContact

on _
end _

on menu_Display indexView, displayWhat
   switch displayWhat
      case "Task"
         put asana_FetchTaskArray (843450062880453) into someArray
         break
      case "Projects"
         put asana_FetchProjectTaskArray ("841158745720522") into someArray
         break
      case "-"
      case "Unlimited"
         put asana_FetchWorkspaceProjectsArray ("14716922790568") into someArray
         break
      case "DEIP"
         put asana_FetchWorkspaceProjectsArray ("745529977066407") into someArray
         break
      case "-"
      case "Project"
         put asana_FetchProjectInfo (841158745720522) into someArray
         break
      case "Project Sections"
         put asana_FetchSectionArray ("841158745720522") into someArray
         break
   end switch
   --
   display_Array someArray, displayWhat
end menu_Display

on _
end _

on menu_AsanaApiHelp
   launch url "https://asana.com/developers/documentation/getting-started/errors"
end menu_AsanaApiHelp

on submenu_Dev
   return "Dev | Menu"
end submenu_Dev


--> Dev | mmenu
-
on menu_TestHubspotCreateContact
   put hubspot_ConstructCreateContactData ("David", "Bovill", "Thought Garden", "david@mediagarden.org", "(+44) 07490 196 595", "thought.garden") into postData
   --
   hubspot_CreateContact postData
   put the result into resultArray
   display_Data resultArray, "hubspot_CreateContact"
end menu_TestHubspotCreateContact


--> Deps
-
function hubspot_ConstructCreateContactData fName, lName, cName, uEmail, tNum, wSite
   put cName into postData ["properties"]["company"]
   put uEmail into postData ["properties"]["email"]
   put fName into postData ["properties"]["firstname"]
   put lName into postData ["properties"]["lastname"]
   put tNum into postData ["properties"]["phone"]
   put wSite into postData ["properties"]["website"]
   --
   return postData
end hubspot_ConstructCreateContactData

