

program define ctyfind 
syntax anything , [db(string) list]

local anything : subinstr local anything `"""' `""' , all
local db = lower("`db'")

if ~inlist("`db'","cty","cow","imf","wb","banks","hl","") {
di as error "`db' is not in the list of acceptable databases"
}


if "`db'"=="" & "`list'"=="" {
di as error "You must specify either list or a database"
exit
}



qui mata: loadcountry()

if "`list'"~="" {

if ~regexm("`anything'","[A-Za-z '.,]") {
di as error "You can search for a country name only"
exit 
}
mata: listcty("`anything'")
}



if "`db'"=="cty" {
local anything = proper("`anything'")
mata:  cdget_cty("`anything'")
}
if "`db'"=="cow" {
mata:  cdget_cow("`anything'")
}
if "`db'"=="imf" {
mata:  cdget_imf("`anything'")
}

if "`db'"=="wb" {
local anything = upper("`anything'")
mata:  cdget_wb("`anything'")
}
if "`db'"=="banks" {
mata:  cdget_banks("`anything'")
}



end
mata:

void function listcty(string scalar name) {

external cd_cty 
l = asarray_keys(cd_cty)
match = regexm(l,name)
match = selectindex(match)
ctys = J(rows(match),1,"")
for(i=1;i<=rows(match);++i) {
display("{stata ctyfind "+`"""'+l[match[i]]+`"""'+", db(cty):"+l[match[i]]+"}")
}
}


string matrix function cdget_cty(string scalar key) {
///loadcty()
external cd_cty
external rlab_cty
rlab_cty=("IMF"\"WB"\"COW"\"Banks"\"HL")
asarray_notfound(cd_cty,"0")
k=asarray(cd_cty,key)
if(k=="0") {
	   displayas("error")
	   display("Country "+key+" not found" )
	   exit(601)
	}
		k =rlab_cty,k
return(k)
}

string matrix function cdget_cow(string scalar key) {
///loadcty()
external cd_cow
external rlab_cow
rlab_cow=("Country"\"IMF"\"WB"\"Banks"\"HL")

asarray_notfound(cd_cow,"0")
k=asarray(cd_cow,key)
if(k=="0") {
	   displayas("error")
	   display("COW Code "+key+" not found" )
	   exit(601)
	}
		k =rlab_cow,k
return(k)
}

string matrix function cdget_imf(string scalar key) {
///loadcty()
external cd_imf
external rlab_imf
rlab_imf=("Country"\"WB"\"COW"\"Banks"\"HL")
asarray_notfound(cd_imf,"0")
k=asarray(cd_imf,key)
if(k=="0") {
	   displayas("error")
	   display("IMF Code "+key+" not found" )
	   exit(601)
	}
		k =rlab_imf,k
return(k)
}


string matrix function cdget_wb(string scalar key) {
///loadcty()
external cd_wb
external rlab_wb
rlab_wb=("Country"\"IMF"\"COW"\"Banks"\"HL")
asarray_notfound(cd_wb,"0")
k=asarray(cd_wb,key)
if(k=="0") {
	   displayas("error")
	   display("WB code "+key+" not found" )
	   exit(601)
	}
		k =rlab_wb,k
return(k)
}

string matrix function cdget_banks(string scalar key) {
///loadcty()
external cd_banks
external rlab_banks
rlab_banks=("Country"\"IMF"\"WB"\"COW"\"HL")

asarray_notfound(cd_banks,"0")
k=asarray(cd_banks,key)
if(k=="0") {
	   displayas("error")
	   display("Banks Code "+key+" not found" )
	   exit(601)
	}
		k =rlab_banks,k
return(k)
}





void function loadcountry() {
ctylist = ("Afghanistan|512|AFG|700|10|004"\
"Albania|914|ALB|339|20|008"\
"Algeria|612|DZA|615|30|012"\
"American Samoa|859|ASM|991|.|016"\
"Andorra|171|ADO|232|32|020"\
"Angola|614|AGO|540|35|024"\
"Antigua And Barbuda|311|ATG|58|37|028"\
"Argentina|213|ARG|160|40|032"\
"Armenia|911|ARM|371|45|051"\
"Aruba|314|ABW|1069|854|533"\
"Australia|193|AUS|900|50|036"\
"Austria|122|AUT|305|61|040"\
"Azerbaijan|912|AZE|373|64|031"\
"Bahamas|313|BHS|31|69|044"\
"Bahrain|419|BHR|692|65|048"\
"Bangladesh|513|BGD|771|901|050"\
"Barbados|316|BRB|53|70|052"\
"Bel Lux Ns|127| |.|.|."\
"Belarus|913|BLR|370|75|112"\
"Belgium|124|BEL|211|80|056"\
"Belgium-Luxembourg|126| |.|.|."\
"Belize|339|BLZ|80|90|084"\
"Benin|638|BEN|434|310|204"\
"Bermuda|319|BMU|30|.|060"\
"Bhutan|514|BTN|760|66|064"\
"Bolivia|218|BOL|145|100|068"\
"Bosnia And Herzegovina|963|BIH|346|107|070"\
"Botswana|616|BWA|571|110|072"\
"Brazil|223|BRA|140|120|076"\
"British West Indies|379| |.|.|."\
"Brunei|516|BRN|835|125|096"\
"Bulgaria|918|BGR|355|130|100"\
"Burkina Faso|748|BFA|439|1230|854"\
"Burundi|618|BDI|516|150|108"\
"Cambodia|522|KHM|811|160|116"\
"Cameroon|622|CMR|471|170|120"\
"Canada|156|CAN|20|180|124"\
"Cape Verde|624|CPV|402|185|132"\
"Cayman Islands|377|CYM|1033|.|136"\
"Central African Republic|626|CAF|482|190|140"\
"Chad|628|TCD|483|210|148"\
"Channel Islands| . |CHI|.|.|."\
"Chile|228|CHL|155|220|152"\
"China|924|CHN|710|230|156"\
"Colombia|233|COL|100|240|170"\
"Comoros|632|COM|581|245|174"\
"Congo, Dem. Republic|636|ZAR|490|260|180"\
"Congo, Republic|634|COG|484|250|178"\
"Costa Rica|238|CRI|94|270|188"\
"Cote D'Ivoire|662|CIV|437|580|384"\
"Croatia|960|HRV|344|275|191"\
"Cuba|928|CUB|40|280|192"\
"Cyprus|423|CYP|352|290|196"\
"Czech Republic|935|CZE|316|301|."\
"Czechoslovakia|934|CSK|315|300|200"\
"Czechoslovakia Ns|937| |.|.|."\
"Denmark|128|DNK|390|320|208"\
"Djibouti|611|DJI|522|325|262"\
"Dominica|321|DMA|54|327|212"\
"Dominican Republic|243|DOM|42|330|214"\
"East Germany|938|DDR|265|430|278"\
"Ecuador|248|ECU|130|340|218"\
"Egypt|469|EGY|651|1200|818"\
"El Salvador|253|SLV|92|350|222"\
"Equatorial Guinea|642|GNQ|411|355|226"\
"Eritrea|643|ERI|531|375|232"\
"Estonia|939|EST|366|360|233"\
"Ethiopia|644|ETH|530|370|231"\
"Falkland Islands|323|FLK|1163|.|238"\
"Faroe Islands|816|FRO|11|.|234"\
"Fiji|819|FJI|950|1216|242"\
"Finland|172|FIN|375|380|246"\
"France|132|FRA|220|390|250"\
"French Guiana|333|GUF|120|.|254"\
"French Polynesia|887|PYF|960|.|258"\
"French West Indies|383| |.|.|."\
"Gabon|646|GAB|481|400|266"\
"Gambia|648|GMB|420|410|270"\
"Georgia|915|GEO|372|415|268"\
"Germany|134|DEU|255|420|276"\
"Ghana|652|GHA|452|440|288"\
"Gibraltar|823|GIB|231|.|292"\
"Greece|174|GRC|350|450|300"\
"Greenland|326|GRL|10|.|304"\
"Grenada|328|GRD|55|455|308"\
"Guadeloupe|329|GLP|65|.|312"\
"Guam|829|GUM|985|.|316"\
"Guatemala|258|GTM|90|460|320"\
"Guinea|656|GIN|438|470|324"\
"Guinea-Bissau|654|GNB|404|475|624"\
"Guyana|336|GUY|110|480|328"\
"Haiti|263|HTI|41|490|332"\
"Honduras|268|HND|91|500|340"\
"Hong Kong|532|HKG|720|.|344"\
"Hungary|944|HUN|310|62|348"\
"Iceland|176|ISL|395|510|352"\
"India|534|IND|750|520|356"\
"Indonesia|536|IDN|850|530|360"\
"Iran|429|IRN|630|540|364"\
"Iraq|433|IRQ|645|550|368"\
"Ireland|178|IRL|205|1212|372"\
"Isle Of Man| . |IMY|.|.|833"\
"Israel|436|ISR|666|560|376"\
"Italy|136|ITA|325|570|380"\
"Jamaica|343|JAM|51|590|388"\
"Japan|158|JPN|740|600|392"\
"Jordan|439|JOR|663|610|400"\
"Kazakhstan|916|KAZ|705|615|398"\
"Kenya|664|KEN|501|620|404"\
"Kiribati|826|KIR|946|625|296"\
"Kuwait|443|KWT|690|640|414"\
"Kyrgyz Republic|917|KGZ|703|645|417"\
"Laos|544|LAO|812|650|418"\
"Latvia|941|LVA|367|660|428"\
"Lebanon|446|LBN|660|670|422"\
"Leeward Islands|346| |1063|.|."\
"Lesotho|666|LSO|570|680|426"\
"Liberia|668|LBR|450|690|430"\
"Libya|672|LBY|620|700|434"\
"Liechtenstein|147|LIE|223|705|438"\
"Lithuania|946|LTU|368|710|440"\
"Luxembourg|137|LUX|212|720|442"\
"Macao|546|MAC|721|.|446"\
"Macedonia|962|MKD|343|725|807"\
"Madagascar|674|MDG|580|730|450"\
"Malawi|676|MWI|553|740|454"\
"Malaysia|548|MYS|820|750|458"\
"Maldives|556|MDV|781|760|462"\
"Mali|678|MLI|432|770|466"\
"Malta|181|MLT|338|780|470"\
"Marshall Islands|867|MHL|983|785|584"\
"Martinique|349|MTQ|66|.|474"\
"Mauritania|682|MRT|435|790|478"\
"Mauritius|684|MUS|590|800|480"\
"Mayotte|920|MYT|5812|.|175"\
"Mexico|273|MEX|70|810|484"\
"Micronesia|868|FSM|987|812|583"\
"Moldova|921|MDA|359|813|498"\
"Monaco|183|MCO|221|815|492"\
"Mongolia|948|MNG|712|820|496"\
"Montserrat|351|MSR|59|.|500"\
"Morocco|686|MAR|600|830|504"\
"Mozambique|688|MOZ|541|835|508"\
"Myanmar|518|MMR|775|140|104"\
"Namibia|728|NAM|565|837|516"\
"Nauru|836|NRU|970|51|520"\
"Nepal|558|NPL|790|840|524"\
"Netherlands|138|NLD|210|850|528"\
"Netherlands Antilles|353|ANT|68|852|532"\
"New Caledonia|839|NCL|930|.|540"\
"New Zealand|196|NZL|920|860|554"\
"Nicaragua|278|NIC|93|870|558"\
"Niger|692|NER|436|880|562"\
"Nigeria|694|NGA|475|890|566"\
"North Korea|954|PRK|731|631|408"\
"Northern Mariana Islands| . |MNP|984|.|580"\
"Norway|142|NOR|385|1091|578"\
"Oman|449|OMN|698|895|512"\
"Pakistan|564|PAK|770|900|586"\
"Palau|565|PLW|986|905|585"\
"Panama|283|PAN|95|910|591"\
"Papua New Guinea|853|PNG|910|915|598"\
"Paraguay|288|PRY|150|920|600"\
"Peru|293|PER|135|930|604"\
"Philippines|566|PHL|840|940|608"\
"Poland|964|POL|290|950|616"\
"Portugal|182|PRT|235|960|620"\
"Puerto Rico| . |PRI|6|.|630"\
"Qatar|453|QAT|694|965|634"\
"Reunion|696|REU|585|.|638"\
"Romania|968|ROM|360|970|642"\
"Russia|922|RUS|365|975|643"\
"Rwanda|714|RWA|517|980|646"\
"Samoa|862|WSM|990|1270|882"\
"San Marino|135|SMR|331|982|674"\
"Sao Tome And Principe|716|STP|403|985|678"\
"Saudi Arabia|456|SAU|670|990|682"\
"Senegal|722|SEN|433|1000|686"\
"Serbia And Montenegro|965|SER|.|.|."\
"Seychelles|718|SYC|591|1005|690"\
"Sierra Leone|724|SLE|451|1010|694"\
"Singapore|576|SGP|830|1020|702"\
"Slovakia|936|SVK|317|302|703"\
"Slovenia|961|SVN|349|1023|705"\
"Solomon Islands|813|SLB|940|1025|090"\
"Somalia|726|SOM|520|1030|706"\
"South Africa|199|ZAF|560|1040|710"\
"South Korea|542|KOR|732|632|410"\
"Spain|184|ESP|230|1060|724"\
"Sri Lanka|524|LKA|780|200|144"\
"St. Helena|856| |4050|.|654"\
"St. Kitts And Nevis|361|KNA|60|1063|659"\
"St. Lucia|362|LCA|56|981|662"\
"St. Pierre And Miquelon|363|SPM|1029|.|666"\
"St. Vincent And The Grenadines|364|VCT|57|1065|670"\
"Sudan|732|SDN|625|1070|729"\
"Suriname|366|SUR|115|1075|740"\
"Swaziland|734|SWZ|572|1080|748"\
"Sweden|144|SWE|380|1092|752"\
"Switzerland|146|CHE|225|1100|756"\
"Syria|463|SYR|652|1110|760"\
"Taiwan|528|TWN|713|231|158"\
"Tajikistan|923|TJK|702|1115|762"\
"Tanzania|738|TZA|510|1120|834"\
"Thailand|578|THA|800|1130|764"\
"Timor-Leste|579|TMP|860|335|626"\
"Togo|742|TGO|461|1140|768"\
"Tonga|866|TON|955|1215|776"\
"Trinidad And Tobago|369|TTO|52|1150|780"\
"Tunisia|744|TUN|616|1160|788"\
"Turkey|186|TUR|640|1170|792"\
"Turkmenistan|925|TKM|701|1172|795"\
"Turks And Caicos|381|TCA|1032|.|796"\
"Tuvalu|869|TUV|947|1175|798"\
"Uganda|746|UGA|500|1180|800"\
"Ukraine|926|UKR|369|1183|804"\
"United Arab Emirates|466|ARE|696|1185|784"\
"United Kingdom|112|GBR|200|1210|826"\
"United States|111|USA|2|1220|840"\
"Uruguay|298|URY|165|1240|858"\
"Ussr|974|SUN|364|1190|810"\
"Uzbekistan|927|UZB|704|1241|860"\
"Vanuatu|846|VUT|935|1243|548"\
"Venezuela|299|VEN|101|1250|862"\
"Vietnam|582|VNM|816|1260|704"\
"Virgin Islands, British|372|VGB|1061|.|092"\
"Wallis And Futuna|857|WLF|9321|.|876"\
"West Bank And Gaza|487|WBG|665|.|275"\
"West Germany| . |FRG|260|431|280"\
"Windward Islands|376| |1055|.|."\
"Yemen, Arab Republic|473|YAR|678|1280|886"\
"Yemen, Pdr|459|YPR|680|1050|720"\
"Yemen, Republic|474|YEM|679|1285|887"\
"Yugoslavia|188|YUG|345|1290|890"\
"Yugoslavia Ns|966| |.|.|."\
"Zambia|754|ZMB|551|1300|894"\
"Zimbabwe|698|ZWE|552|1214|716"\
"Anguilla|312|AIA|1062|.|660"\
"Vatican| . |VAT|328|.|336"\
"Montenegro| . |MNE|348|.|499"\
"Cook Islands|815|COK|925|.|184"\
"Christmas Island| . |CXR|9001|.|162"\
"Cocos| . |CCK|9002|.|166"\
"Tokelau| . |TKL|9201|.|772"\
"Niue| . |NIU|9253|.|.|570"\
"Pitcairn| . |PCN|9620|.|612"\
"Virgin Islands, U.S.| . |VIR|5|.|850")
external cd_cty 
external cd_cow 
external cd_imf
external cd_wb
external cd_banks
z= tokeninit("|","","")
wcty = J(5,1,"")
cd_cty = asarray_create()
cd_cow = asarray_create()
cd_imf = asarray_create()
cd_wb = asarray_create()
cd_banks = asarray_create()

for(i=1; i<=rows(ctylist);++i) {
line = subinstr(ctylist[i],`"""',"",.)
line
tokenset(z,line)
t = tokengetall(z)
cty =t[1]
imf = t[2]
wb = t[3]
cow = t[4]
banks = t[5]
hl = t[6]
wcty = (t[2]\t[3]\t[4]\t[5]\t[6])
wimf = (t[1]\t[3]\t[4]\t[5]\t[6])
wcow = (t[1]\t[2]\t[3]\t[5]\t[6])
wwb = (t[1]\t[2]\t[4]\t[5]\t[6])
wbanks = (t[1]\t[2]\t[3]\t[4]\t[6])
asarray(cd_cty,cty,wcty)
asarray(cd_imf,imf,wimf)
asarray(cd_cow,cow,wcow)
asarray(cd_wb,wb,wwb)
asarray(cd_banks,banks,wbanks)


}
}


end
