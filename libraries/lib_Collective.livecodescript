script "lib_Collective"
--> MetaData
-
copyright: Anonymous
license: GPLv3
name: lib_Collective
type: library
version: 0.1

/*
This is a library to interface with the Open Collective API.

- https://docs.opencollective.com/help/contributing/development/api

Seems to be read only. Might be best to use new Webhooks.
*/


--> Working on
-


--> Collective
-
function collective_ListTransactions
   -- /v1/collectives/:collectiveSlug/transactions?type=:type&limit=:limit&offset=:offset&dateFrom=:dateFrom&dateTo=:dateTo&type=:includeVirtualCards
   /*
   curl "https://api.opencollective.com/v1/collectives/opencollective-company/transactions" \
         -H "Content-Type: application/json"\
         -H "Client-Id: ${ClientId}"
   */
end collective_ListTransactions

function collective_ListEvents collectiveSlug
   -- /:collectiveSlug/events.json
   -- E.g. https://opencollective.com/sustainoss/events.json?limit=10&offset=0
   
   put collective_ApiStem() into apiStem
   put url merge ("[[apiStem]][[collectiveSlug]]/events.json?limit=10&offset=0") into someJSON
   return someJSON
end collective_ListEvents

function collective_ListAttendees collectiveSlug, eventSlug
   -- /:collectiveSlug/events/:eventSlug/attendees.json
   -- Eg. https://opencollective.com/sustainoss/events/2017-442ev/attendees.json?limit=10&offset=0
   
   put collective_ApiStem() into apiStem
   put url merge ("[[apiStem]][[collectiveSlug]]/events/[[eventSlug]]/attendees.json?limit=10&offset=0") into someJSON
   return someJSON
end collective_ListAttendees

function collective_GetInfo collectiveSlug
   -- GET https://opencollective.com/:collective/members/[all|users|organizations].json
   
   put collective_ApiStem() into apiStem
   put url merge ("[[apiStem]][[collectiveSlug]].json") into someJSON
   return someJSON
end collective_GetInfo

function collective_ListMembers collectiveSlug
   -- GET https://opencollective.com/:collective/members/[all|users|organizations].json
   
   put collective_ApiStem() into apiStem
   put url merge ("[[apiStem]][[collectiveSlug]]/members/organizations.json") into someJSON
   return someJSON
end collective_ListMembers

function collective_GetMembers collectiveSlug
   -- /:collectiveSlug/members.:format(json|csv)
   
   put collective_ApiStem() into apiStem
   put url merge ("[[apiStem]][[collectiveSlug]]/members.json?limit=10&offset=0") into someJSON
   return someJSON
end collective_GetMembers

function collective_ApiStem
   return "https://opencollective.com/"
end collective_ApiStem


--> Deps
-
