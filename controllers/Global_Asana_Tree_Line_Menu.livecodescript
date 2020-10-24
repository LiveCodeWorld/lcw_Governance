script "Global_Asana_Tree_Line_Menu"
--> MetaData
-
license: GPLv3
name: Global_Asana_Tree_Line_Menu
type: controller
version: 0.1


--> Global | Asana | Tree | Line | Menu
-
on menu_Teams indexView
   _SetWorkspaceInfo indexView, workspaceName, workspaceID
   -- 
   display_AsanaTeams workspaceID, workspaceName
end menu_Teams

on _
end _

on menu_WorkspaceMembers indexView
   _SetWorkspaceInfo indexView, workspaceName, workspaceID
   -- 
   display_AsanaWorkspaceMembers workspaceID, workspaceName
   put the result into dispayView
end menu_WorkspaceMembers

on menu_WorkspaceProjects indexView
   put the selected_Value of indexView into workspaceID
   put asana_FetchWorkspaceProjectsArray (workspaceID) into projectsArray
   put the selected_Index of indexView into workspaceName
   --
   display_Lines projectsArray, workspaceName, "mDoubleUp_AsanaProject", "Asana Project", true
   put the result into displayView
end menu_WorkspaceProjects


--> Global | Asana | Tree | Line | Menu | Props
-

--> Global | Asana | Tree | Line | Menu | Disabled
-
getprop disabled_Teams [indexView]
   _SetWorkspaceInfo indexView, workspaceName, workspaceID
   -- 
   put asana_IsOrg (workspaceID) into isOrg
   if isOrg is true then
      return false
   else
      return true
   end if
end disabled_Teams


--> Private
-
private command _SetWorkspaceInfo indexView, @workspaceName, @workspaceID
   put the selected_Value of indexView into workspaceID
   if workspaceID is empty then
      breakpoint -- debug
      put the selected_Value of indexView into workspaceID
   end if
   put the selected_Index of indexView into workspaceName
end _SetWorkspaceInfo
