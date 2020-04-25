---
title: "Configuring Elasticsearch for HTTPS Queries"
date: 2020-04-09T21:21:33-05:00
draft: false
readings: 3
tags: ["ops","elasticsearch"]
description: "Elasticsearch isn't configured for HTTPS requests out of the box. He are the config changes necessary to make https queries and how to query Elasticsearch from React"
---

I use Elasticsearch to collect metrics for my todo app. To render visualizations of the data I was embedding kibana visualization into my stats page. I found that Kibana took around 5 seconds to load. It was also difficult to apply styling to the Kibana visualizations as well because they are loaded in an Iframe. I decided to recreate the visualizations using React to decrease the load time and to allow for a cleaner UI. When I tried to make an https query to elasticsearch however I found that I had CORS error because Elasticsearch was not setting the `access-control-allow-origin` header.

## Enabling CORS
To set the CORS header make the following changes to the `elasticsearch.yml` for your cluster

```
http.cors.enabled: true
http.cors.allow-origin: "example.com"
http.cors.allow-headers: " X-Requested-With, Content-Type, Content-Length, authorization"
```

When you restart the cluster you will be able to make https queries. Here's an example https query using fetch.

```
fetch('https://example.com:9243/_search', {
      method: 'POST',
      headers: {
        Accept: 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Basic ' + btoa("elastic:password"),
      },
      body: JSON.stringify({
        "version": true,
        "size": 500,
        "sort": [
          {
            "_score": {
              "order": "desc"
            }
          }
        ],
        "_source": {
          "excludes": []
        },
        "stored_fields": [
          "*"
        ],
        "script_fields": {},
        "docvalue_fields": [
          {
            "field": "timestamp",
            "format": "date_time"
          }
        ],
        "query": {
          "bool": {
            "must": [],
            "filter": [
              {
                "match_all": {}
              },
              {
                "range": {
                  "timestamp": {
                    "gte": "now/d",
                    "time_zone": "America/Chicago"
                  }
                }
              },
              {
                "match_phrase": {
                  "type": {
                    "query": "update"
                  }
                }
              }
            ],
            "should": [],
            "must_not": []
          }
        },
        "highlight": {
          "pre_tags": [
            "@kibana-highlighted-field@"
          ],
          "post_tags": [
            "@/kibana-highlighted-field@"
          ],
          "fields": {
            "*": {}
          },
          "fragment_size": 2147483647
        }
      }
      )
    })

```

Elasticsearch allows for HTTP auth so you will have to set the authorization header to make queries.
## Viewing Kibana Visualization queries
In order to see the query a Kibana visualization uses. Navigate to your visualization click on the save Icon and click on the `Save Current query` button. Then give the query a name and save it. Then go to the management page. Under Kibana click on saved objects. Then click on the inspect option and click request to see the query. 
