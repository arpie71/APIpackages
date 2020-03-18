{smcl}
{* 30jan2018}{...}
{hline}
help for {hi:hlapi}
{hline}

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

{p}There are 8 collections available to query. The API and the help file will be updated as more collections are added.{p_end}
{p 4 4 2}{cmd: cpdoc} {p_end}
{p 4 4 2}{cmd: clinton} {p_end}
{p 4 4 2}{cmd: kissinger} {p_end}
{p 4 4 2}{cmd: statedeptcables} {p_end}
{p 4 4 2}{cmd: frus} {p_end}
{p 4 4 2}{cmd: ddrs} {p_end}
{p 4 4 2}{cmd: cabinet} {p_end}
{p 4 4 2}{cmd: pdb} {p_end}

{p}Multiple collections are allowed and names of collections can be separated with either a space or a comma.{p_end}

There are a lot of different options avaiable. The help command will walk through them.
{p}The {it:random} option will return a list of random IDs from the History Lab's collections. It cannot be used in conjunction with any other options except {it:limit}{p_end}



{p}The {it:date} option will return a list of documents either from a given date {it: date()} or within a range of dates {it: start()} and {it: end()}. Dates should be in numeric format and use either ".","-", or "/" as separators between month, day, and year. The function works best with a "MDY" or a "YMD" format but it will recognize a "DMY" format for days greater than 12.{p_end} 


{p}The {it:geog} suboption can be used with a specific {it:collection} or across collections. It can also be used with the {it:date} option but not with the {it:ID} option. The History Lab API uses the ISO 3166-1 3-digit country code to index countries. This program will take either the country name used by History Lab or the ISO 3166 code. We also provide a utility function (ctyfind) to find ISO 3166-1 codes from an existing code such as COW, IMF, World Bank, or Banks or by country name. 
{p_end}


{p}The {it:text} option will search the full-text of document bodies. Searches can be performed on either words or phrases. To use this option you will also need to specify the {it:collection} suboption and the {it:date} option. If both are not specified, the command will not work. The {it:fields()} option does not work with the full-text search and will be ignored if specified.{p_end}


{title:Options}
{p 4 4 2}{it:country_var} is the name of the exising variable that contains the country code{p_end}
{p 4 4 2}{cmd:from} is the name of the country code {it:country_var} is in{p_end}
{p 4 4 2}{cmd:to} is the name of the country code {it:newvar} will be in{p_end}
{p 4 4 2}{it:newvar} is the name of the new variable to be created{p_end}

{title:Supported databases}

{title:Notes}
