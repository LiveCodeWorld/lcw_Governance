script "Global_Asana_Workspace_Tree_Menu"
--> MetaData
-
license: GPLv3
name: Global_Asana_Workspace_Tree_Menu
type: controller
version: 0.1


--> Global | Asana | Workspace | Tree | Menu
-
on menu_NewProject indexView, templateName
   -- put the meta_Data ["projectName"] of displayView into projectName
   -- asana_AskCreateGist teamName, workspaceName, projectName
   put asana_GetTeamID (teamName, workspaceName) into teamID
   --
   asana_AskCreateProject templateName, teamID, pProjectName, true
   put the result into resultArray
   --
   lcw_Notify "Created GIST!"
end menu_NewProject

on menu_WorkspaceUsers displayView
   put the meta_Data ["workspaceID"] of displayView into workspaceID
   put the meta_Data ["workspaceName"] of displayView into workspaceName
   --
   display_AsanaWorkspaceMembers workspaceID, workspaceName
end menu_WorkspaceUsers

on _
end _

on menu_NewTeamMeeting indexView, teamName
   put the meta_Data ["workspaceID"] of indexView into workspaceID
   put asana_GetTeamID (teamName, workspaceID) into teamID
   --
   asana_AskCreateProject "Meeting", teamID, pProjectName, true
   put the result into resultArray
   --
   lcw_Notify "Created meeting!"
end menu_NewTeamMeeting

on menu_NewOrgGist indexView, teamName
   put the meta_Data ["workspaceID"] of indexView into workspaceID
   put asana_GetTeamID (teamName, workspaceID) into teamID
   --
   asana_AskCreateProject "Org GIST", teamID, empty, true
   put the result into resultArray
   --
   lcw_Notify "Created GIST!"
end menu_NewOrgGist

on menu_Teams displayView
   put the meta_Data ["workspaceID"] of displayView into workspaceID
   put the meta_Data ["workspaceName"] of displayView into workspaceName
   --
   display_AsanaTeams workspaceID, workspaceName
end menu_Teams


--> Global | Asana | Workspace | Tree | Menu | Props
-
getprop team_Names [indexView]
   put the meta_Data ["workspaceID"] of indexView into workspaceID
   return asana_ListTeamNames (workspaceID)
end team_Names

getprop template_Names [indexView]
   return asana_ListTemplateNames()
end template_Names


--> Global | Asana | Workspace | Tree | Menu | Disabled
-
getprop disabled_NewTeamMeeting [indexView]
   return _NotTeam (indexView)
end disabled_NewTeamMeeting

getprop disabled_Teams [indexView]
   return _NotTeam (indexView)
end disabled_Teams


--> Private
-
private function _NotTeam indexView
   put the meta_Data ["workspaceID"] of indexView into workspaceID
   put asana_IsOrg (workspaceID) into isOrg
   if isOrg is true then
      return false
   else
      return true
   end if
end _NotTeam

