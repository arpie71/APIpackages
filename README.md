# API
Stata and R interfaces

## Description
This repository will hold the code for the Stata and R packages to interact with the History Lab API.


## TO-DO
**Stata:**
 1. Random IDs - the json program used does not support a single type of result it seems
 2. Multiple country, topic and person IDs - should restrict to single value for now
 3. String topic searches

**R:**
 1. Allow full text search for countries
 2. Allow full text search for topics
 3. Restrict entity searches to single value per entity for now

## API Issues
While multiple countries are okay in the API queries, multiple topics do not work very well. They are giving a 502 Proxy Error.
Also incorrect topics or countries return 0 results, but incorrect person IDs lead to an API error.

## Query Types
For now, I have divided the queries up into 6 types based on their purpose.

### Random Query
This query is to return a list of random IDs from the History Lab collection.

#### API code
```
http://api.declassification-engine.org/declass/v0.4/random
http://api.declassification-engine.org/declass/v0.4/random/?limit=25
```

#### Stata code - Does not currently work
```

```

#### R code
```
hlapi_random()
hlapi_random(limit=25)
```


### Date search
These queries allow a search of the History Lab collection for a given date or date range.
#### API code
```
http://api.declassification-engine.org/declass/v0.4/?start_date=1947-01-01&end_date=1948-12-01&page_size=100
http://api.declassification-engine.org/declass/v0.4/?start_date=1975-01-01&end_date=1975-12-01&page_size=100&collections=cpdoc,kissinger
http://api.declassification-engine.org/declass/v0.4/?start_date=1973-01-01&end_date=1973-02-01&page_size=100&collections=kissinger&fields=subject,body
```
#### Stata code
```
histlabapi , option(date)  start(01/01/1947) end(12/01/1948)  limit(100)
histlabapi , option(date) collection(cpdoc kissinger) start(01/1/1975) end(12/01/1975)  limit(100)
histlabapi , option(date) start(01/1/1973) end(2/01/1973)  limit(100) collection(kissinger) fields(subject,body)
```

#### R code
```
hlapi_date(start.date='1947-01-01', end.date='12/01/1948')
hlapi_date(start.date='1975-01-01', end.date='12/01/1975', collection=c('kissinger', 'cpdoc'), limit=100)
hlapi_date(start.date='1973-01-01', end.date='2/1/1973', collection='kissinger', fields=c('subject','body'), limit=100)
```

### Entity Query
These queries allow a search of the History Lab collection by country, topic, or person.
#### API code
```
http://api.declassification-engine.org/declass/v0.4/?geo_ids=100&fields=subject,title
http://api.declassification-engine.org/declass/v0.4/?geo_ids=100&topic_ids=0&fields=subject,title&page_size=50
http://api.declassification-engine.org/declass/v0.4/?topic_ids=0&start_date=1975-01-01&end_date=1980-12-31&fields=subject,title&page_size=25
```

#### Stata code
```
histlabapi , option(entity) geog(100) fields(subject,title)
histlabapi , option(entity) geog(100) topic(0) fields(subject,title) limit(50)
histlabapi , option(entity) topic(0) fields(subject,title) start(1/1/1975) end(12/31/1980)
```

#### R code
```
hlapi_entity('countries', fields=c('subject','title'), value='100', run='run')
hlapi_entity(c('countries','topics'), fields=c('subject','title'), value=c('100','0'), limit=50, run='run')
hlapi_entity('topics', fields=c('subject','title'), value='0', start.date="1/1/1975",end.date="12.31.1980", run='run')
```


### ID Query
This query is to return a data for an ID or list of IDs from the History Lab collection.

#### API code
```
http://api.declassification-engine.org/declass/v0.4/?id=1973LIMA07564
http://api.declassification-engine.org/declass/v0.4/?ids=1973LIMA07564,P760191-2216,1973LIMA01001
```

#### Stata code
```
histlabapi , option(id) id(1973LIMA07564)
histlabapi , option(id) id(1973LIMA07564,P760191-2216,1973LIMA01001)
```

#### R code
```
hlapi_id(ids='1973LIMA07564')
hlapi_id(ids=c('1973LIMA07564','P760191-2216','1973LIMA01001'), run='run')

```

### Full-text Query
This query does a full text search on the History Lab collections.
#### API code
```
http://api.declassification-engine.org/declass/v0.4/text/?search=udeac&collections=frus&start_date=1950-01-01&end_date=2000-12-31&page_size=25
http://api.declassification-engine.org/declass/v0.4/text/?search=udeac&collections=frus,statedeptcables&start_date=1950-01-01&end_date=2000-12-31&page_size=200
http://api.declassification-engine.org/declass/v0.4/text/?search=united%20nations&collections=frus,statedeptcables&start_date=1950-01-01&end_date=2000-12-31&page_size=200
http://api.declassification-engine.org/declass/v0.4/text/?search=league%20of%20nations&collections=frus&start_date=1950-01-01&end_date=2000-12-31&page_size=400
```

#### Stata code
```
histlabapi , option(text) collection(frus) start(01/01/1950) end(12/31/2000) text(udeac)
histlabapi , option(text) collection(frus,statedeptcables) start(1/1/1950) end(12/31/2000) text(udeac) limit(200)
histlabapi , option(text) collection(frus,statedeptcables) start(1/1/1950) end(12/31/2000) text(united nations) limit(200)
histlabapi , option(text) collection(frus) start(1/1/1950) end(12/31/2000) text(league of nations) limit(400)
```

#### R code
```
hlapi_search('udeac', coll.name='frus',  start.date="1950-01-01", end.date="2000-12-31")
hlapi_search('udeac', coll.name=c('statedeptcables','frus'),  start.date="1950-01-01", end.date="2000-12-31")
hlapi_search('united nations', coll.name=c('statedeptcables','frus'),  start.date="1950-01-01", end.date="2000-12-31", limit=200)
hlapi_search('league of nations', coll.name=c('statedeptcables','frus'),  start.date="1950-01-01", end.date="2000-12-31", limit=400)

```

### Overview Query
This is a catch-all set of queries that return an overview of the History Lab collections. Depending on the parameters, the query will return a list of all the collections available, a list of the fields available,or  a list of the entities available for a collection. It will also return a country of the number of times a given entity appears in a collection or the top entities in a collection for a given date range.
#### API code
```
http://api.declassification-engine.org/declass/v0.4/fields
http://api.declassification-engine.org/declass/v0.4/collections
http://api.declassification-engine.org/declass/v0.4/entity_info/?collection=frus
http://api.declassification-engine.org/declass/v0.4/entity_info/?collection=frus&entity=countries
http://api.declassification-engine.org/declass/v0.4/overview/?collection=frus&entity=countries&start_date=1973-01-01&end_date=1979-12-31

```

#### Stata code
```
histlabapi , option(fields)
histlabapi , option(collections)
histlabapi , option(overview) collection(frus)
histlabapi , option(overview) collection(frus) overview(countries)
histlabapi , option(overview) collection(frus) overview(persons) start("1973-01-01") end(12/31/1979)
```

#### R code
```
hlapi_overview(fields=TRUE)
hlapi_overview(collections=TRUE)
hlapi_overview(coll.name='frus', entity=TRUE)
hlapi_overview(coll.name='frus', entity=TRUE, entity.type = 'countries')
hlapi_overview(coll.name='frus', entity=TRUE, entity.type = 'countries', start.date='1973-01-01', end.date='12/31/1979', run=TRUE)
```
