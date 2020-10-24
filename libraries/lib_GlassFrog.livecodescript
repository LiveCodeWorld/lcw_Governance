script "lib_GlassFrog"

--> MetaData
-
copyright: Anonymous
license: GPLv3
name: lib_GlassFrog
type: library
version: 0.1

/*Some help*/


--> Working on
-
command display_GlassFrogOrganisation
   get glassfrog_ListAssignments()
   display_Data it, "Media Garden", "Organisation"
   put the result into dView
   --
   set the title_Menu of dView to "Global | Organisation | Tree | Menu"
   set the line_Menu of dView to "Global | Organisation | Tree | Line | Menu"
end display_GlassFrogOrganisation


--> GlassFrog
-

--> GlassFrog | Roles
-
function glassfrog_ListRoles
   put glassfrog_RestGetArray ("roles") into someArray
   return someArray
end glassfrog_ListRoles


--> GlassFrog | People
-
command glassfrog_RemovePerson personID
   put glassfrog_GetApiRoot() & "people/" & personID into restURL
   --
   put glassfrog_GetAuthToken() into xAuthToken
   rest_SetXauthHeaders xAuthToken
   --
   delete url restUrl
   --
   -- Returns 204 No Content on success.
   put libURLLastRHHeaders() into rHeaders
   if word -3 to -1 of line 1 of rHeaders = "204 No Content" then
      return empty
   else
      return rHeaders
   end if
end glassfrog_RemovePerson

command glassfrog_CreatePerson sName, sEmail, sExternalID
   put sName into pArray ["people"][1]["name"]
   put sEmail into pArray ["people"][1]["email"]
   put sExternalID into pArray ["people"][1]["external_id"]
   --
   glassfrog_RestPostArray "people", pArray
   put the result into resultArray
   --
   display_Data resultArray
   return resultArray
end glassfrog_CreatePerson

function glassfrog_FetchPeople
   put glassfrog_RestGetArray ("people") into someArray
   return someArray
end glassfrog_FetchPeople


--> GlassFrog | Circles
-
function glassfrog_FetchPeopleInCircle cID
   put "circles/" & cID & "/people" into rPath
   put glassfrog_RestGetArray (rPath) into someArray
   return someArray
end glassfrog_FetchPeopleInCircle

function glassfrog_FetchCircle cID
   put "circles/" & cID into rPath
   put glassfrog_RestGetArray (rPath) into someArray
   return someArray
end glassfrog_FetchCircle

function glassfrog_ListCircles
   put glassfrog_RestGetArray ("circles") into someArray
   return someArray
end glassfrog_ListCircles


--> GlassFrog | Assignments
-
function glassfrog_ListAssignments
   put glassfrog_RestGetArray ("assignments") into someArray
   return someArray
end glassfrog_ListAssignments


--> GlassFrog | REST
-
function glassfrog_RestGetArray apiCommand
   put glassfrog_RestGet(apiCommand) into someJson
   put json_ToArray (someJson) into someArray
   return someArray
end glassfrog_RestGetArray

command glassfrog_RestPostArray apiCommand, someArray
   put json_FromArray (someArray) into someJSON
   --
   glassfrog_RestPost apiCommand, someJSON
   put the result into resultJSON
   --
   put json_ToArray (resultJSON) into resultArray
   return resultArray
end glassfrog_RestPostArray

command glassfrog_RestPost apiCommand, someJSON
   put glassfrog_GetApiRoot() & apiCommand into restURL
   --
   put glassfrog_GetAuthToken() into xAuthToken
   rest_SetXauthHeaders xAuthToken
   --
   post someJSON to url restUrl
   put it into jsonResult
   --
   return jsonResult
end glassfrog_RestPost

function glassfrog_RestGet apiCommand
   put glassfrog_GetApiRoot() & apiCommand into restURL
   --
   put glassfrog_GetAuthToken() into xAuthToken
   rest_SetXauthHeaders xAuthToken
   put url restURL into someJson
   --
   return someJson
end glassfrog_RestGet

function glassfrog_GetApiRoot
   put "https://api.glassfrog.com" into apiRoot
   put merge ("[[apiRoot]]/api/v3/") into apiRoot
   return apiRoot
end glassfrog_GetApiRoot


--> Secrets
-
function glassfrog_GetAuthToken
   put secret_Get ("glassfrog") into xAuthToken
   return xAuthToken
end glassfrog_GetAuthToken

command glassfrog_SetAuthToken xAuthToken
   secret_Set "glassfrog", xAuthToken
   return the result
end glassfrog_SetAuthToken


--> Deps
-
command rest_SetXauthHeaders xAuthToken
   put "Content-type: application/json" into someHeader
   put CR & "Accept: application/json" after someHeader
   put CR & "Accept-Charset: utf-8" after someHeader
   --
   put CR & "X-Auth-Token:" && xAuthToken after someHeader
   --
   set the httpHeaders to someHeader
   return someHeader
end rest_SetXauthHeaders
