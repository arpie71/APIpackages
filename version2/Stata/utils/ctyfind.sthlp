
{smcl}
{* 30jan2018}{...}
{hline}
help for {hi:ctyfind}
{hline}

{title:Program to lookup country information.}

{p 8 14 2}
   {cmd: ctyfind}
   {cmd: anything}
   {cmd:,}
   {cmd:[}
   {cmd: db}{it:(string)}
   {cmd: list}
   {cmd:]}
{p_end}

{title:Description}

{p 4 4 2}
This command will return country identifying information. You can look up a country name, COW code, IMF code, etc. and get other country information. 

{p}There are 6 classification systems.{p_end}
{p 4 4 2}{cmd: cty} The name of the country {p_end}
{p 4 4 2}{cmd: IMF} The IMF country code{p_end}
{p 4 4 2}{cmd: WB} The World Bank country code{p_end}
{p 4 4 2}{cmd: COW} Correlates of War country code {p_end}
{p 4 4 2}{cmd: banks} Banks country code {p_end}
{p 4 4 2}{cmd: ISO3166} ISO 3166-1 3-digit code {p_end}


{p} The {cmd: list} option will provide a list of country names if you are not sure 
what is the correct name to look up. The regular expression functions work with the search. If you would like to see all 
countries starting with "Bo" type: ctyfind ^Bo , list
Unless there is a comma in the country name, quotations around the name are not necessary, even if there is a space (e.g., United States).

{title: Examples}
{cmd: ctyfind 2 , db(cow)}
{cmd: ctyfind Cong, list}
{cmd: ctyfind Argentina, db(cty)}



