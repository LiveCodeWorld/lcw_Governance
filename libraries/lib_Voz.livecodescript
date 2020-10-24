script "lib_Voz"
--> MetaData
-
copyright: Anonymous
license: GPLv3
name: lib_Voz
type: library
version: 0.1

/*Some help*/


--> Working on
-


--> Voz | Display
-
command voz_LaunchInvoice authorName, toName, pDate
   put voz_ConstructInvoiceTitle (authorName, toName, pDate) into invoiceTitle
   put voz_ConstructAuthorDomain (authorName) into wikiDomain
   --
   fedwiki_Launch wikiDomain, invoiceTitle
   --
   put the result into wikiURL
   return wikiURL
end voz_LaunchInvoice


--> Voz
-
command voz_CreateInvoice authorName, toName, pSincePeriod
   set the cursor to watch
   if pSincePeriod is empty then put "1 week" into pSincePeriod
   --
   put voz_FetchInvoiceTemplate() into pageArray
   put voz_ConstructInvoiceTitle (authorName, toName) into invoiceTitle
   pageArray_Rename pageArray, invoiceTitle
   --
   put voz_FetchEditedPageArray (authorName, pSincePeriod) into editedPageArray
   
   -- unecessarily slow due to repeating above steps?
   put author_ConstructStatText (authorName, authorDomains, editedPageArray, pSincePeriod) into authorStatText -- blocks (domain) in last step?
   --
   pageArray_SetItemText pageArray, "988ad6e34d9ba4c8", authorStatText
   --
   voz_StoreInvoice  authorName, toName, pageArray
   --
   put the result into shellResult
   return shellResult
end voz_CreateInvoice

function voz_FetchEditedPageMarkDown authorName, pSincePeriod
   put voz_FetchEditedPageArray (authorName, pSincePeriod) into editedPageArray
   --
   put keys (editedPageArray) into domainNames
   url_SortDomainIndex domainNames
   --
   repeat for each line wikiDomain in domainNames
      put "- [[" & wikiDomain & "]]" & CR after markDownSection
      
      put editedPageArray [wikiDomain] into domainArray
      --
      put keys (domainArray) into pageSlugs
      sort pageSlugs -- could do by date
      --
      repeat for each line pageSlug in pageSlugs
         put domainArray [pageSlug]["title"] into pageTitle
         put " - [[" & pageTitle & "]]" & CR after markDownSection
      end repeat
   end repeat
   delete char -1 of markDownSection
   return markDownSection
end voz_FetchEditedPageMarkDown

function voz_FetchEditedPageArray authorName, pSincePeriod
   put atopia_FetchAuthorDomains (authorName) into authorDomains
   put fedwiki_FetchRecentDomainPageArray (authorDomains, pSincePeriod) into editedPageArray
   return editedPageArray
end voz_FetchEditedPageArray

function voz_ConstructAuthorDomain authorName
   put fedwiki_ConstructSlug (authorName) into wikiDomain
   put ".voz.money" after wikiDomain
   return wikiDomain
end voz_ConstructAuthorDomain


--> Voz | Invoice | Model
-
function voz_FetchInvoice authorName, toName, pDate
   _SetDomainSlug authorName, toName, wikiDomain, pageSlug, pDate
   --
   put pageArray_Fetch (wikiDomain, pageSlug) into pageArray
   return pageArray
end voz_FetchInvoice

command voz_StoreInvoice authorName, toName, pageArray, pDate
   _SetDomainSlug authorName, toName, wikiDomain, pageSlug, pDate
   --
   pageArray_Store wikiDomain, pageSlug, pageArray
   put the result into shellResult
   return shellResult
end voz_StoreInvoice

function voz_FetchInvoiceTemplate authorName, toName, pDate
   put voz_ConstructInvoiceTitle (authorName, toName, pDate) into invoiceTitle
   put voz_ConstructAuthorDomain (authorName) into wikiDomain
   put fedwiki_ConstructSlug (invoiceTitle) into pageSlug
   --
   put pageArray_Fetch (wikiDomain, pageSlug) into tempateArray
   return tempateArray
end voz_FetchInvoiceTemplate


--> Deps
-
function voz_ConstructInvoiceTitle fromName, toName, pDate
   -- Invoice 034 (db-mg)
   put voz_GetEarthWeekNum (pDate) into earthWeekNum
   --
   put "Invoice" && earthWeekNum && "(" into invoiceTitle
   put _FirstLetters(fromName) after invoiceTitle
   put "-" after invoiceTitle
   put _FirstLetters(toName) after invoiceTitle
   put ")"  after invoiceTitle
   --
   return invoiceTitle
end voz_ConstructInvoiceTitle

function voz_GetEarthWeekNum pDate
   if pDate is empty then put the date into pDate
   -- convert pDate to seconds
   --
   put "2020,4,25,0,0,0,0" into earthDayStart
   convert earthDayStart from dateitems to seconds
   --
   put date_GetWeeksBetween (earthDayStart, pDate) into weekNum
   put weekNum div 52 into yearNum
   
   put trunc (weekNum mod 52) into weekLeftNum
   put yearNum & format ("%02d", weekLeftNum) into earthWeekNum
   --
   return earthWeekNum
end voz_GetEarthWeekNum


--> Private
-
private command _SetDomainSlug authorName, toName, @wikiDomain, @pageSlug, pDate
   put voz_ConstructInvoiceTitle (authorName, toName, pDate) into invoiceTitle
   put voz_ConstructAuthorDomain (authorName) into wikiDomain
   put fedwiki_ConstructSlug (invoiceTitle) into pageSlug
   --
   return invoiceTitle
end _SetDomainSlug

private function _FirstLetters someName
   repeat for each word someWord in someName
      put char 1 of someWord after firstLetters
   end repeat
   return toLower (firstLetters)
end _FirstLetters
