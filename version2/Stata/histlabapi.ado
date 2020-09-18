capture program drop date_parse
capture program drop histlabapi
mata mata clear
qui do ~/Documents\GitHub\APIpackages\Stata\utils/loadcty.do
mata loadcty()
** TO ADD:
*** text search returns 1 more hit than page_size up to maximum hits
*** check topics/countries to make sure that they are correct 
*** allow string searches of topics/countries 


** http://api.declassification-engine.org/declass/v0.4/text/?search=udeac&start_date=1950-01-01&end_date=2000-12-31&collections=statedeptcables
** http://api.declassification-engine.org/declass/v0.4/text/?search=UDEAC&start_date=1950-01-01&end_date=1990-01-01&collections=frus
** http://api.declassification-engine.org/declass/v0.4/text/?search=udeac&start_date=1950-1-1&end_date=2000-12-31&collections=frus

program drop histlabapi

program define histlabapi , rclass
syntax , option(string)  [ date(string) start(string) end(string) text(string) id(string) COLlection(string) fields(string) geog(string) topic(numlist integer) person(string) overview(string) LIMit(int 0) norun]

nois di "`topic'"

nois di "`: word count `topic''"

if ~regexm("`option'","^(id|date|random|text|entity|collections|fields|overview)$") {
nois di as error "`option' is not a valid option. Allowable options are id, date, text, entity, random, collections, fields, and overview."
exit
}
if regexm("`option'","(id)|(date)|(text)") & regexm("`option'","(random)") {
nois di as error "You cannot specify both random and id, date, or text."
exit
} 
if (("`start'"~="" & "`end'"=="")|("`start'"=="" & "`end'"~="")){
	nois di as error "Please specify both a start and end date."
	exit
}



if "`collection'"~="" {
local collection : subinstr local collection ", " ",", all
local collection : subinstr local collection " " "," , all
tokenize "`collection'", parse(",")
while "`1'"~="" {
if "`1'"~="," & ~regexm("`1'","^(cpdoc|clinton|kissinger|statedeptcables|frus|ddrs|cabinet|pdb)$") {
nois di as error "{p}`collection' is not a valid collection. Allowable collections are: cpdoc, clinton, kissinger, statedeptcables, frus, ddrs, cabinet, pdb{p_end}"
exit
}
macro shift
}
}

if "`fields'"~="" {
	local fields : subinstr local fields ", " ",", all
	local fields : subinstr local fields " " "," , all
		
	mata: check_fields("`fields'")
	if(scalar(ck)==0) {
		nois di as error  "At least one of the fields you entered is incorrect"
		exit
	}

}

** allowable options now: id, date, random, text, entity
if "`limit'"=="0" & regexm("`option'","^(random|date|text|entity)$") {
nois di "You did not specifiy a page limit. Defaulting to 25 results."
local limit="25"

}


if "`text'"~="" local text : subinstr local text " " "%20", all


if "`overview'"!="" {
    if ustrregexm("`overview'", ",|\s+"){
	    nois di "Only one overview option is allowed."
		exit
	}
	
    if !ustrregexm("`overview'", "^(countries|topics|persons)$"){
	    nois di "`overview' is not a valid overview option. Allowable options are countries, topics, or persons."
		exit
	}
	
}

** full text search
	if "`option'"=="text" {
		if "`fields'"~="" {
		    nois di "The fields option is not available with a full-text search. Ignoring the fields list."
		}
		if "`collection'"=="" |("`start'"=="" | "`end'"=="") {
			nois di as error "You must specify a collection and date range when using full-text search."
			exit
		}
		foreach _d in start end {
			if "``_d''"~="" {
				date_parse ``_d''
				if "`=r(d)'"=="." {
					exit
				}
				local `=substr("`_d'",1,1)' = "`=r(d)'"
				}
			}
		local search = "text/"+`search'+"search=`text'&collections=`collection'&start_date=`s'&end_date=`e'&page_size=`limit'"
		local limit=`limit'+1
	}

** search by ID
	if "`option'"=="id" {
		if "`id'"=="" {
			nois di as error "You selected the id option but provided no ids. Please list ids, separated by a comma."
			exit
			}
		local id : subinstr local id ", " ",", all
		local id : subinstr local id " " "," , all
		if "`id'"~=""&~regexm("`id'",",") local search = `search'+"id=`id'"
		if "`id'"~=""&regexm("`id'",",") local search = `search'+"ids=`id'"
		if "`fields'"~="" local search = "`search'"+"&fields=`fields'"
	}

** search by date
	if "`option'"=="date" {
		if ("`date'"=="" & ("`start'"=="" & "`end'"=="")) {
			nois di as error "You selected the date option but provided no dates. Please list a date or a start and end date."
			exit
		}
		if (("`start'"~="" & "`end'"=="")|("`start'"=="" & "`end'"~="")){
			nois di as error "Please specify both a start and end date."
			exit
		}
		foreach _d in date start end {
			if "``_d''"~="" {
				date_parse ``_d''
				if "`=r(d)'"=="." {
					exit
				}
				local `=substr("`_d'",1,1)' = "`=r(d)'"
				}
			}
			if "`date'"~="" local search = `search'+"date=`d'&page_size=`limit'"
			if "`start'"~="" & "`end'"~="" local search = `search'+"start_date=`s'&end_date=`e'&page_size=`limit'"
			if "`collection'"~="" local search = "`search'"+"&collections=`collection'"
			if "`fields'"~="" local search = "`search'"+"&fields=`fields'"
			if "`limit'"~="" local search = "`search'"+"&page_size=`limit'"

			}



** entity search
	if "`option'"=="entity" {
	    if "`geog'"=="" & "`topic'"=="" & "`person'"=="" {
		    nois di as error "At least one of the geography, topic, or person options must be included with an entity search"
			exit
		}
* Check country list
	if "`geog'"~="" {
		local geog= "`=ustrregexra("`geog'", ",|and|&|\s+","AND")'"
		local geog= "`=ustrregexra("`geog'", "\||or","OR")'"
		if ustrregexm("`geog'","AND|OR"){
			nois di as error "Only one country ID is allowed now."
			exit
		}		
		local g = "`geog'"
		if(ustrregexm("`geog'","AND")) local g: subinstr local geog "AND" " " , all
		if(ustrregexm("`geog'","OR")) local g: subinstr local geog "OR" " " , all
		tokenize `g'
		while "`1'"!="" {
			nois di "`1'"
		if real("`1'")==. {
				mata: st_local("cty",get_cty("`1'"))
				*display "`cty'"
				local geog = "`cty'"
				}
			if real("`1'")!=.& length("`1'")>3 {
				nois di as error "Invalid value for countries."
				exit
			}
			*if length("`geog'")==2 local geog = "0"+"`geog'"
			*if length("`geog'")==1 local geog = "00"+"`geog'"
		macro shift
		}
	}

		if "`topic'"~="" {
		local topic= "`=ustrregexra("`topic'", ",|and|&|\s+","AND")'"
		local topic= "`=ustrregexra("`topic'", "\||or","OR")'"
		if ustrregexm("`topic'","AND|OR"){
			nois di as error "Only one topic ID is allowed now."
			exit
		}
		}

				if "`person'"~="" {
		local person= "`=ustrregexra("`person'", ",|and|&|\s+","AND")'"
		local person= "`=ustrregexra("`person'", "\||or","OR")'"
		if ustrregexm("`person'","AND|OR"){
			nois di as error "Only one person ID is allowed now."
			exit
		}
		}

		
		foreach _d in date start end {
			if "``_d''"~="" {
				date_parse ``_d''
				if "`=r(d)'"=="." {
					exit
				}
				local `=substr("`_d'",1,1)' = "`=r(d)'"
				}
			}
			if "`geog'"~="" local search = "`search'"+"?geo_ids=`geog'"
			if "`topic'"~="" & "`geog'"=="" local search = "`search'"+"?topic_ids=`topic'"
			if "`person'"~="" & "`topics'"=="" & "`geog'"=="" local search = "`search'"+"?person_ids=`person'"
			if "`topic'"~="" & "`geog'"~="" local search = "`search'"+"&topic_ids=`topic'"
			if "`person'"~="" & ("`topics'"~="" | "`geog'"~="") local search = "`search'"+"&person_ids=`person'"
			if "`date'"~="" local search = "`search'"+"&date=`d'"
			if "`start'"~="" & "`end'"~="" local search = "`search'"+"&start_date=`s'&end_date=`e'"
			if "`collection'"~="" local search = "`search'"+"&collections=`collection'"
			if "`fields'"~="" local search = "`search'"+"&fields=`fields'"
			if "`limit'"~="" local search = "`search'"+"&page_size=`limit'"
	}
	
	if "`option'"=="collections"|"`option'"=="fields" {
		if "`date'"!="" nois dis as error "Date is not allowed with a `option' search"
		if "`start'"!="" nois dis as error "A start date is not allowed with a `option' search"
		if "`end'"!="" nois dis as error "An end date is not allowed with a `option' search"
		if "`text'"!="" nois dis as error "Text string is not allowed with a `option' search"
		if "`id'"!="" nois dis as error "ID is not allowed with a `option' search"
		if "`collection'"!="" nois dis as error "Collection names are not allowed with a `option' search"
		if "`fields'"!="" nois dis as error "Field names are not allowed with a `option' search"
		if "`geog'"!="" nois dis as error "Countries are not allowed with a `option' search"
		if "`topic'"!="" nois dis as error "Topics are not allowed with a `option' search"
		if "`person'"!="" nois dis as error "Persons are not allowed with a `option' search"

		local search = "`option'"
	}
	
	if "`option'"=="overview" {
	    if "`collection'"=="" {
		    nois di as error"You must enter a collection name when using an overview search."
			exit 
		}
		if (("`start'"~="" & "`end'"=="")|("`start'"=="" & "`end'"~="")){
			nois di as error "Please specify both a start and end date."
			exit
		}
		if ("`start'"=="" & "`end'"=="") {
			if ("`overview'"=="") {
				local search = "entity_info/?collection="+"`collection'"
			}
			if("`overview'"!="") local search = "entity_info/?collection="+"`collection'"+"&entity=`overview'"
	    			}
		if ("`start'"!="" & "`end'"!="") {
		    foreach _d in start end {
			if "``_d''"~="" {
				date_parse ``_d''
				if "`=r(d)'"=="." {
					exit
				}
				local `=substr("`_d'",1,1)' = "`=r(d)'"
				}
			}
			if ("`overview'"=="") {
				nois di as error "For an overview search by date, you need to specify an entity as well."
				exit
			}
			local search = "overview/?collection="+"`collection'"+"&entity=`overview'&start_date=`s'&end_date=`e'"
		}
	}	

qui{
clear
local url ="http://api.declassification-engine.org/declass/v0.4/"
local url = "`url'`search'"
nois display "`url'"

if "`run'"=="" {

jsonio kv , file("`url'") w(all)
split key, parse("/") gen(t)

scalar hl_count = `=value if key=="/count"'
scalar hl_pagesize = `=value if key=="/page_size"'

levelsof t3, local(b) clean
levelsof key, local(k) clean
if `=ustrregexm("`k'","element")' {
drop key t1 t2
drop if t4==""
levelsof value, local(result) clean
forval i = 1/`: word count `result'' {
noisily display as text "`: word `i' of `result''"
}
return local results = "`result'"
} 
else if `=ustrregexm("`b'","results")' {
drop key t1 t2
drop if t4==""
reshape wide value , i(t3) j(t4) str
rename (value*) (*)
drop t3
}

return scalar hl_count = hl_count
return scalar hl_pagesize = hl_pagesize 


qui compress
}

}

end


program define date_parse , rclass
syntax anything
			if !ustrregexm("`anything'","^\d+(\.|\-|/)\d+(\.|\-|/)\d+$") {
			    nois di as error "Please format the date in numeric format with .,\, or - separators between each part."
				exit
			}
local d = ustrregexra("`anything'","(\.|\-|/)"," ",.)
tokenize `d'
local yr = ""
local mo = ""
local day = ""
if length("`3'")==4 {
    local yr = `3'
	if `1' >12 {
	    local day = `1'
		local mo = `2'
	}
	else if `1'<13 {
	    local mo = `1'
		local day = `2'
	}
}
else if length("`1'")==4 {
    local yr = `1'
		if `3' >12 {
	    local day = `3'
		local mo = `2'
	}
	else if `2'<13 {
	    local mo = `2'
		local day = `3'
	}
}
else if length("`2'")==4 {
local yr = `2'
		if `1' >12 {
	    local day = `1'
		local mo = `3'
	}
	else if `1'<13 {
	    local mo = `1'
		local day = `3'
	}

}
if "`yr'"=="" {
	nois di as error "Please provide a 4-digit year value."
	exit
} 

if `=date("`yr'-`mo'-`day'", "YMD")'==. {
    nois di as error "`anything' is not a valid date"
	exit
}
if length("`mo'")<2 local mo = "0"+"`mo'"
if length("`day'")<2 local day = "0"+"`day'"
return local d =  "`yr'-`mo'-`day'"
end


mata

string scalar function get_cty(string scalar key) {
///loadcty()
external hl_cty
asarray_notfound(hl_cty,"0")
k=asarray(hl_cty,key)
if(k=="0") {
	   displayas("error")
	   display("Country "+key+" not found" )
	   exit(601)
	}
return(k)
}


void function check_fields(string scalar f) {
tok = tokens(f,",")
fields3 ="body, body_html, body_summary, chapt_title, countries, collection, date, date_year, date_month, from_field, id, location, nuclear, persons, topics, classification, refs, cable_references, source, source_path, cable_type, subject, title, to_field, tags, description, category, pdf, title_docview, orighand, concepts, type, office, readability,"
ck =all(regexm(fields3,tok))
st_numscalar("ck", ck)

}
end

