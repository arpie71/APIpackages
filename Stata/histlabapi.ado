capture program drop date_parse
capture program drop histlabapi
mata mata clear
** TO ADD:
** Search: Multiple collections 
*** text search returns 1 more hit than page_size up to maximum hits

** http://api.declassification-engine.org/declass/v0.4/text/?search=udeac&start_date=1950-01-01&end_date=2000-12-31&collections=statedeptcables
** http://api.declassification-engine.org/declass/v0.4/text/?search=UDEAC&start_date=1950-01-01&end_date=1990-01-01&collections=frus
** http://api.declassification-engine.org/declass/v0.4/text/?search=udeac&start_date=1950-1-1&end_date=2000-12-31&collections=frus
*mata mata drop hl_api()
*f = fopen("http://api.declassification-engine.org/declass/v0.4/?start_date=1947-01-01&end_date=1948-12-01", "r")

*** fields, collections, 

*** id, ids, date, start_date&end_date,random (no ?), random with limit (random/?limit=#),
***http://api.declassification-engine.org/declass/v0.4/?start_date=1947-01-01&end_date=1947-1-4&page_size=60
*** f = fopen(url+"?id=1974STATE085546", "r")

*program drop histlabapi


program define histlabapi 
syntax , options(string)  [ date(string) start(string) end(string) LIMit(int 25) text(string) id(string) geog(string) COLlection(string) fields(string)]

** allowable options now: id, date, random, text
if "`limit'"=="" & ~regexm("`options'","`random'") {
nois di "You did not specifiy a page limit. Defaulting to 25 results."
local `limit'="25"

}
if ~regexm("`options'","(id)|(date)|(random)|(text)") {
nois di as error "`option' is not a valid option. Allowable options are id, date, text, and random."
exit
}
if regexm("`options'","(id)|(date)|(text)") & regexm("`options'","(random)") {
nois di as error "You cannot specify both random and id, date, or text."
exit
} 

if ~regexm("`options'","random") {
local search  `""?""'
}


if "`collection'"~="" {
if ~regexm("`collection'","(cpdoc)|(clinton)|(kissinger)|(statedeptcables)|(frus)|(ddrs)|(cabinet)|(pdb)") {
nois di as error "{p}`collection' is not a valid collection. Allowable collections are: cpdoc, clinton, kissinger, statedeptcables, frus, ddrs, cabinet, pdb{p_end}"
}
}




if "`geog'"~="" {
mata: st_local("cty",get_cty("`geog'"))
}
if "`fields'"~="" {
mata: check_fields("`fields'")
}

tokenize "`options'" , parse(" ")
while "`1'" ~= "" {

	if "`1'"=="text" {
		*
			if "`collection'"=="" |("`start'"=="" | "`end'"=="") {
			nois di as error "You must specify a collection and date range when using full-text search."
			exit
			}
		foreach _d in start end {
			if !ustrregexm("``_d''","^\d+(\.|\-|/)\d+(\.|\-|/)\d+$") {
			    nois di as error "Please format the date in numeric format with .,\, or - separators between each part."
				exit
			}

			if "``_d''"~="" {
					if regexm("``_d''","\.") {
						local `=substr("`_d'",1,1)' = subinstr("``_d''","."," ",.)
					}
					if regexm("``_d''","/") {
						local `=substr("`_d'",1,1)' = subinstr("``_d''","/"," ",.)
					}

					if regexm("``_d''","-") {
						local `=substr("`_d'",1,1)' = subinstr("``_d''","-"," ",.)
					}
				tokenize ``=substr(`"`_d'"',1,1)''
				local `=substr("`_d'",1,1)' = "`3'-`1'-`2'"
				}
			}
		local search = "text/"+`search'+"search=`text'&collections=`collection'&start_date=`s'&end_date=`e'&page_size=`limit'"
		local limit=`limit'+1
	}

	if "`1'"=="id" {
		if "`id'"=="" {
			nois di as error "You selected the id option but provided no ids. Please list ids, separated by a comma."
			exit
			}
		if "`id'"~=""&~regexm("`id'",",") local search = `search'+"id=`id'"
		if "`id'"~=""&regexm("`id'",",") local search = `search'+"ids=`id'"
	}

	if "`1'"=="date" {
		if ("`date'"=="" & ("`start'"=="" & "`end'"=="")) {
			nois di as error "You selected the date option but provided no dates. Please list a date or a start and end date."
			exit
		}
		if (("`start'"~="" & "`end'"=="")|("`start'"=="" & "`end'"~="")){
			nois di as error "Please specify both a start and end date."
			exit
		}
** check dates - month, day, and year in numeric format, separated by "-/."
		foreach _d in date start end {
			if "``_d''"~="" {
			if !ustrregexm("``_d''","^\d+(\.|\-|/)\d+(\.|\-|/)\d+$") {
			    nois di as error "Please format the date in numeric format with .,\, or - separators between each part."
				exit
			}
			}
		}
		
			foreach _d in date start end {
				if "``_d''"~="" {
					if regexm("``_d''","\.") {
						local `=substr("`_d'",1,1)' = subinstr("``_d''","."," ",.)
					}
					if regexm("``_d''","/") {
						local `=substr("`_d'",1,1)' = subinstr("``_d''","/"," ",.)
					}

					if regexm("``_d''","-") {
						local `=substr("`_d'",1,1)' = subinstr("``_d''","-"," ",.)
					}
				tokenize ``=substr(`"`_d'"',1,1)''
				local `=substr("`_d'",1,1)' = "`3'-`1'-`2'"
				}
			}
			
			if "`date'"~="" local search = `search'+"date=`d'&page_size=`limit'"
			if "`start'"~="" & "`end'"~="" local search = `search'+"start_date=`s'&end_date=`e'&page_size=`limit'"
	}

	if "`1'"=="random" {
		if "`limit'"=="" {
			nois di "You selected the random option but no limit. Defaulting to 25 results."
			local search "random/?limit=25"
		}
		if "`limit'"~="" local search "random/?limit=`limit'"
	}
macro shift
}
clear
mata: hl_api("`search'", "`limit'")

qui compress
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
return local d =  "`yr'-`mo'-`day'"
end

mata

void hl_api(string scalar search, string scalar lim) {
	ct=""
	search = st_local("search")
	url ="http://api.declassification-engine.org/declass/v0.4/"
	f = fopen(url+search, "r")

		maindataset = ""
		while ((part_maindataset=fget(f))!=J(0,0,"")) {
			maindataset = maindataset + part_maindataset
		}
		
	fclose(f)
	if(regexm(maindataset,(`"({"count": )(0)"'))) {
	   displayas("error")
	   display("No output returned",f)
	   exit(601)
	}
	if(regexm(maindataset,(`"({"count": )([0-9]+)"'))) ct =regexs(2)
	if(strtoreal(ct)>25&strtoreal(lim)>=25&strtoreal(ct)>strtoreal(lim)) ct=lim
	if(strtoreal(ct)<=25&strtoreal(lim)<=strtoreal(ct)) ct = lim
	if(strtoreal(ct)>25&strtoreal(lim)<=25) ct = lim
	if(strtoreal(ct)>25) data =substr(maindataset,strpos(maindataset,"results")+11,strrpos(maindataset,"],")-strpos(maindataset,"results")-10)
	if(strtoreal(ct)<=25) data =substr(maindataset,strpos(maindataset,"results")+11,strrpos(maindataset,"]")-strpos(maindataset,"results")-10)
	header=J(1,0,"")
	body = J(strtoreal(ct),0,"")
	z= tokeninit(",:","",(`""""'))
	for(i=1;i<=strtoreal(ct);i++) {
		if(i<strtoreal(ct)) d=substr(data, 1,strpos(data,"},"))
		else if(i==strtoreal(ct)) d=substr(data, 1,strpos(data,"}]"))
		data = subinstr(data,d,"")
		d = usubinstr(d,"null",".",.)
		d = usubinstr(d,"{","",.)
		d = usubinstr(d,"}","",.)
		d = usubinstr(d,"]","",.)
		d = usubinstr(d,`"\""',"\'",.)
		tokenset(z,d)
		j = 1
		text =J(1,0,"")

		while((token = tokenget(z)) != "") {

		if (token==" ") continue
			else if(mod(j,2)==1&i==1) header=header,token
			else if(mod(j,2)==0) text=text,token
			j=j+1
		}
		
		if(i==1) body=text
		else if(i>1) body = body\text
		
	}
	header = subinstr(header,`"""',"")
	body = subinstr(body,`"""',"")
	st_addobs(strtoreal(ct))
	a = st_addvar("strL",header)
	st_sstore(.,a,body)

}

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
tok = tokens(f)
fields3 ="body, body_html, body_summary, chapt_title, countries, collection, date, date_year, date_month, from_field, id, location, nuclear, persons, topics, classification, refs, cable_references, source, source_path, cable_type, subject, title, to_field, tags, description, category, pdf, title_docview, orighand, concepts, type, office, readability,"
ck =all(regexm(fields3,tok))
if(ck==0) {
displayas("error")
display("At least one of the fields you entered is incorrect")
exit()
}

}
end


/// end



/**if(strtoreal(ct)>25) ct="25"
