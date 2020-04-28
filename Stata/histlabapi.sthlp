{smcl}
{* 30jan2018}{...}
{hline}
help for {hi:hlapi}
{hline}

*syntax , option(string)  [ date(string) start(string) end(string) text(string) id(string) COLlection(string) fields(string) geog(string) topic(numlist integer) person(string) overview(string) LIMit(int 0) norun]

{title:Program to get data from History Lab's API.}

{p 8 14 2}
   {cmd: hlapi}
   {cmd:,}
   {cmd: options}{it:(string)}
   {cmd:[}
   {cmd: date}{it:(string)}{cmd: start}{it:(string)}{cmd: end}{it:(string)}
   {cmd: limit}{it:(integer 25)}
   {cmd:]}
{p_end}

{title:Description}

{p 4 4 2}
This command will talk to and download data from History Lab's API.

{p}There are 9 collections available to query. The API and the help file will be updated as more collections are added.{p_end}
{p 4 4 2}{cmd: cpdoc} {p_end}
{p 4 4 2}{cmd: clinton} {p_end}
{p 4 4 2}{cmd: kissinger} {p_end}
{p 4 4 2}{cmd: statedeptcables} {p_end}
{p 4 4 2}{cmd: frus} {p_end}
{p 4 4 2}{cmd: ddrs} {p_end}
{p 4 4 2}{cmd: cabinet} {p_end}
{p 4 4 2}{cmd: pdb} {p_end}
{p 4 4 2}{cmd: worldbank} {p_end}

{p}Multiple collections are allowed and names of collections can be separated with either a space or a comma.{p_end}


There are 8 broad types of queries allowed using the {cmd:options} parameter. Only one option can be specified at a time. For some of the query options, other parameters are available to filter the search.

{p 4 4 2}{it: random} - Returns a list of random IDs. The only parameter allowed is {cmd:limit()}.{p_end}

{p 4 4 2}{it: collections} - Displays a list of the collections available through the History Lab API and stores the list as r(results). No other parameter is allowed and any given will be ignored.{p_end}

{p 4 4 2}{it: fields} - Displays a list of the fields available through the History Lab API and stores the list as r(results). No other parameter is allowed and any given will be ignored.{p_end}

{p 4 4 2}{it: id} - Searches the History Lab collections for a given document ID or list of document IDs. The {cmd:id} parameter is required to give an ID or list of IDs to search and the {cmd:fields} parameter is the only optional parameter allowed.{p_end}

{p 4 4 2}{it: overview} - Returns an overview of entities for a given collection. The {cmd:collection} parameter is required and only a single collection can be specified. If the {cmd:overview} parameter is not included, the query will return a list of the entities available for the collection. If {cmd:overview} is specified, the query will return a selection of the count and IDs of that type of entity from the collection. If both the {cmd:overview} and the {cmd:start/end} parameters are included, the search will return the top entity counts and values in the collection for the specified date range.{p_end}

{p 4 4 2}{it: date} - Searches the History Lab collections for all documents on a given date ({cmd: date()}) or within a range of dates ({cmd: start()} and {cmd: end()}).{p_end}

{p 4 4 2}{it: entity} - Searches the History Lab collections for all documents that contain a given entity ID. With this option, at least one of the {cmd:geog}, {cmd:topic}, or {cmd:person} parameters must be used to specify the type and value(s) of the entities to be searched. Multiple types of entities and multiple values of entities are allowed. The {cmd:collection}, {cmd:date/start/end}, and the {cmd:fields} parameters can also be used with this query. {p_end}

{p 4 4 2}{it: text} - Searches the full-text of documents in the History Lab collections. Searches can be performed on either words or phrases. To use this option you will also need to specify the {cmd:collection} parameter and the {cmd:start} and {cmd:end} parameters. If both are not specified, the command will return an error. The {cmd:fields()} option does not work with the full-text search and will be ignored if specified.{p_end}


{title:Parameters}

{p}The {cmd:geog} parameter is used with the {it:entity} option to search for all documents containing a specific country or a list of countries. Lists of countries must be separated by a comma, space, &, or |. Unless | is used for an "OR" search, the program will assume an "AND" search is requested. The History Lab API uses the ISO 3166-1 3-digit country code to index countries. This program will take either the country name used by History Lab or the ISO 3166 code. If the name is not specified exactly as stored, though, the program will return an error. We also provide a utility function (ctyfind) to find ISO 3166-1 codes from an existing code such as COW, IMF, World Bank, or Banks or by country name. {p_end}

{p}The {cmd:topic} parameter is used with the {it:entity} option to search for all documents containing a given topic ID or list of topic IDs. The History Lab has run topic models on each collection and they have their own topic IDs.  {p_end}

{p}The {cmd:person} parameter is used with the {it:entity} option to search for all documents containing a given person ID or list of person IDs. The History Lab has run Named Entity Recognition on all the collections and identify each individual with their own ID. ({it: under development}).

{p}The {cmd:date} and {cmd:start/end} parameters can used with the {it:date} option, with the {it:entity} option, or with the {it:text} option in order to restrict the dates of the documents retrieved to a given day or to a range of dates.  Dates should be in numeric format and use either ".","-", or "/" as separators between month, day, and year. The function first lookds for a "MDY" or a "YMD" format but it will recognize a "DMY" format for days greater than 12.

{p}The {cmd:text} parameter provides a word or phrase that will be used to search the History Lab collections. It can only be used with the {it:text} option.{p_end}

{p}The {cmd:collection} parameter restricts a {it:date}, {it:entity}, or {it:text} search to a specified collection or list of collections. Multiple collections should be separated with a comma or a space. The list of collections allowed is given above and can also be obtained with the {it:collections} option. {p_end}

{p}The {cmd:field} parameter restricts a {it:date}, {it:id}, or {it:entity} search to a specified field or list of fields. Multiple fields should be separated with a comma or a space. A list of allowable fields can be obtained with the {it:fields} option.{p_end}

{p}The {cmd:id} parameter is used only with the {it:id} option to provide the ID or list of IDs to search. As with the {cmd:collection} and {cmd:field} parameters, a list of IDs should be separated with a comma or a space. If an invalid ID is entered, the command will not return an error. Instead, the command simply will not return any results for that ID. {p_end} 

{p}The {cmd:overview} parameter is used with the {it:overview} option to specify the entity to return for an overview search. Acceptable values are countries, topics, or persons and only one may be specified with this option. {p_end}

{p}The {cmd:limit} parameter tells the API how many results to return. The default value is 25 and there is a system maximum of 10,000.{p_end}


{title:Examples}

{p 4 4 4}Random IDs: {p_end}

{p 4 4 4}List of available collections: {p_end}
{p 8 8 12}histlabapi , option(collections){p_end}

{p 4 4 4}List of available fields: {p_end}
{p 8 8 12}histlabapi , option(fields) {p_end}

{p 4 4 4}ID search: {p_end}
{p 8 8 12}histlabapi , option(id) id(1973LIMA07564){p_end}
{p 8 8 12}histlabapi , option(id) id(1973LIMA07564,P760191-2216,1973LIMA01001){p_end}


{p 4 4 4}Overview search: {p_end}
{p 8 8 12}histlabapi , option(overview) collection(frus){p_end}
{p 8 8 12}histlabapi , option(overview) collection(frus) overview(countries){p_end}
{p 8 8 12}histlabapi , option(overview) collection(frus) overview(persons) start("1973-01-01") end(12/31/1979){p_end}

{p 4 4 4}Date search: {p_end}
{p 8 8 12}histlabapi , option(date)  start(01/01/1947) end(12/01/1948)  limit(100){p_end}
{p 8 8 12}histlabapi , option(date) collection(cpdoc kissinger) start(01/1/1975) end(12/01/1975)  limit(100){p_end}

{p 4 4 4}Entity search: {p_end}
{p 8 8 12}histlabapi , option(entity) geog(100) fields(subject,title){p_end}
{p 8 8 12}histlabapi , option(entity) geog(100) topic(0) fields(subject,title) limit(50){p_end}
{p 8 8 12}histlabapi , option(entity) topic(0) fields(subject,title) start(1/1/1975) end(12/31/1980){p_end}


{p 4 4 4}Full-text search: {p_end}
{p 8 8 12}histlabapi , option(text) collection(frus) start(01/01/1950) end(12/31/2000) text(udeac){p_end}
{p 8 8 12}histlabapi , option(text) collection(frus,statedeptcables) start(1/1/1950) end(12/31/2000) text(udeac) limit(200){p_end}
{p 8 8 12}histlabapi , option(text) collection(frus,statedeptcables) start(1/1/1950) end(12/31/2000) text(united nations) limit(200){p_end}



{title:Notes}

{p}We also provide a command ({cmd:ctyfind}) to look up countries by name, IMF code, World Bank code, COW (Correlates of War), Banks, or ISO 3166-1 code and return the other codes. It can be used to find the ISO 3166-1 code for the {cmd:histlabpi} command. More information on how to use the {cmd:ctyfind} command can be found by typing 'help ctyfind'.{p_end}

{p}Currently, the full-text search will {cmd:not} return the full-text of documents.{p_end}