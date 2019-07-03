script "Global_Asana_Team_Tree_Line_Menu"
--> MetaData
-
license: GPLv3
name: Global_Asana_Team_Tree_Line_Menu
type: controller
version: 0.1


--> Global | Asana | Team | Tree | Line | Menu
-
on menu_DisplayTeamInfo displayView
   put the meta_Data ["workspaceID"] of displayView into workspaceID
   put the meta_Data ["workspaceName"] of displayView into workspaceName
   --
   put the selected_Index of displayView into teamName
   put the selected_Value of displayView into teamID
   --
   put teamID
end menu_DisplayTeamInfo

on menu_CreateProject displayView
   put the meta_Data ["workspaceID"] of displayView into workspaceID
   put the meta_Data ["workspaceName"] of displayView into workspaceName
   --
   put the selected_Index of displayView into teamName
   put the selected_Value of displayView into teamID
   --
   if teamID is empty then
      breakpoint
   end if
   
   asana_CreateTeamProject teamID
   put the result into responseArray
   --
   display_Array responseArray
end menu_CreateProject

on menu_CreateMeeting indexView, someName
   put asana_GetTemplateArray (someName) into projectTaskData
   breakpoint
   --
   asana_CreateTeamProject teamID, projectTaskData
   put the result into responseArray
   --
   display_Array responseArray
end menu_CreateMeeting

on _
end _

on menu_TeamMembers displayView
   put the meta_Data ["workspaceID"] of displayView into workspaceID
   put the meta_Data ["workspaceName"] of displayView into workspaceName
   --
   put the selected_Index of displayView into teamName
   put the selected_Value of displayView into teamID
   --
   if teamID is empty then
      breakpoint
   end if
   
   put asana_FetchTeamUserArray (teamID) into teamUserArray
   --
   display_Lines teamUserArray, teamName, mDoubleUp_AsanaUser, "workspaceName", true
   put the result into displayView
end menu_TeamMembers


--> Global | Asana | Team | Tree | Line | Menu | Props
-
getprop some_Names
   put asana_ListTemplateNames() into arrayKeys
   return arrayKeys
end some_Names


--> Global | Asana | Team | Tree | Line | Menu | Disabled
-
