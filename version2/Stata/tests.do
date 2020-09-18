
** histlabapi tests

** random IDs
histlabapi, options(random)


histlabapi, options(random) lim(100)

** works 

histlabapi , options(text) collection(frus) start(01/01/1950) end(12/31/2000) text(udeac)
** should return one result
histlabapi , options(text) collection(statedeptcables) start(1/1/1950) end(12/31/2000) text(udeac)
** should return 26 results

histlabapi , options(text) collection(frus,statedeptcables) start(1/1/1950) end(12/31/2000) text(udeac) limit(200)
** 152 results total
http://api.declassification-engine.org/declass/v0.4/text/?search=udeac&collections=statedeptcables,frus&start_date=1950-01-01&end_date=2000-12-31&page_size=25
http://api.declassification-engine.org/declass/v0.4/text/?search=udeac&collections=frus,statedeptcables&start_date=1950-01-01&end_date=2000-12-31&page_size=25

histlabapi , options(text) collection(frus,statedeptcables) start(1/1/1950) end(12/31/2000) text("united nations") limit(200)
histlabapi , options(text) collection(frus,statedeptcables) start(1/1/1950) end(12/31/2000) text(united nations) limit(200)


histlabapi , options(text) collection(frus) start(1/1/1950) end(12/31/2000) text(league of nations) limit(400)
** 361 results

* %20

*** date search - works
histlabapi , options(date)  start(01/01/1947) end(12/01/1948)  limit(100)

histlabapi , options(date) start(01/1/1947) end(12/01/1948)  limit(100)
histlabapi , options(date) start(01/1/1973) end(2/01/1973)  limit(100) collection(kissinger)

histlabapi , options(date) start(01/1/1973) end(2/01/1973)  limit(100) collection(kissinger) fields(subject,body)

** with multiple collections
histlabapi , options(date) collection(cpdoc kissinger) start(01/1/1975) end(12/01/1975)  limit(100)

/*http://api.declassification-engine.org/declass/v0.4/text/?search=udeac&start_date=1950-1-1&end_date=2000-12-31&collections=frus */


histlabapi , options(date) collection(statedeptcables) start(01/1/1947) end(12/01/1948)  limit(100)

*** id search
histlabapi , options(id) id(1973LIMA07564)

histlabapi , options(id) id(1973LIMA07564,P760191-2216,1973LIMA01001)
histlabapi , options(id) id(1973LIMA07564 P760191-2216)


histlabapi , options(entity) geog(100) fields(subject,title)

histlabapi , options(entity) geog(100) fields(subject,title) start(1/1/1975) end(12/31/1980)

histlabapi , options(entity) topic(0) fields(subject,title) start(1/1/1975) end(12/31/1980)

histlabapi , options(entity) person(109882) fields(subject,title) start(1/1/1975) end(12/31/1980)



histlabapi , options(entity) geog(109882) fields(subject,title) start(1/1/1975) end(12/31/1980)
http://api.declassification-engine.org/declass/v0.4/?geo_ids=100&fields=subject,title
http://api.declassification-engine.org/declass/v0.4/?topic_ids=61  
http://api.declassification-engine.org/declass/v0.4/?geo_ids=010&topic_ids=61

/*
109882
id
1973LIMA07564
P760191-2216
frus1961-63v22d372
1973LAGOS03429
1976OSLO06300
1977BANGKO30867
1977SOFIA00759
P770062-2247
1997010100598
1974KINSHA07524
CAB_128_32_0_0003
2008090102984
1975STATE080528
1977STATE091435
1976LUSAKA A-30
2007070102002
chives-1772602_121
1979PEKING A-1
1976NICOSI03128
Clinton-46231
frus1948v07d686
1996010100599
1978MEXICO06413
1975STATE203316
1976NAIROB12533
*/