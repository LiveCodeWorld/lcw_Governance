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
on menu_Workspaces
   display_AsanaWorkspaces
end menu_Workspaces

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


--> Global | Governance | Menu | Props
-

--> Global | Governance | Menu | Disabled
-
