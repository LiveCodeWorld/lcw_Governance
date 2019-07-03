script "Global_Governance_Menu"
--> MetaData
-
license: GPLv3
name: Global_Governance_Menu
type: controller
version: 0.2


--> Global | Governance | Menu
-
on menu_Workspaces
   display_AsanaWorkspaces
end menu_Workspaces

on _
end _

on menu_Display indexView, displayWhat
   switch displayWhat
      case "Task"
         put asana_FetchTask (843450062880453) into someArray
         break
      case "Projects"
         put asana_FetchProjectTaskArray ("841158745720522") into someArray
         break
      case "MyTasks"
         put asana_FetchMyTaskArray (14716922790568) into someArray
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

on menu_ApiHelp
   launch url "afsd"
end menu_ApiHelp


--> Global | Governance | Menu | Props
-

--> Global | Governance | Menu | Disabled
-
