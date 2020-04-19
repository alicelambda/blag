---
title: "CS373 Spring 2020: Alice Reuter Week 10"
date: DATE
draft: false
readings: 3
tags: ["cs373","react"]
---

<img src="/img/cs373/linkedin.png" width="200" align="left" style="padding-right:2rem" />

# 1. What did you do this past week?

This past week I worked on implementing search, filtering and sorting on the model pages for our [software engineering project](https://hikeadvisor.me/). It took me a while to combine a bunch of fetch requests. Our API didn't support sorting or filtering so I decided to implement these features on the client side. This meant that the site had to request all the pages of results in order to filter them. I ended up using [Promise.all](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Promise/all) which combines multiple Promises and return once all of them have been fulfilled. Here's how I ended using it.

```javascript
 fetch("https://api.hikeadvisor.me/api/animal?page=" + page)
      .then(response => response.json())
      .then(data => {
        Promise.all(
          Array(data.total_pages + 1)
            .fill()
            .map((_,i) => {
              return fetch("https://api.hikeadvisor.me/api/animal?page=" + i).then(response => response.json());
            }
            )

        ).then((all) => {
          setAnimalData(all.map(x => x.objects).flat());
        })
      })
```
This snippet makes a single request to our api it then requests all of api pages based off the number of total pages returned in the first request. Learning more about asynchronous javascript was interesting because it allows you to write code that won't make your website block and freeze up. At first our search was making our website to freeze when you type in a query that matched many results like `b`. At first I thought this was because the actual searching took a while. So I also made our search function asynchronous. However, I realized that actual rendering of components was what was making the page freeze. By implementing pagination on the query results I was able to sop the page from freezing.

# 2. What's in you way?

I have a linear algebra exam next week. I also have a multicore operating system's project due. I also have a paper to work on for global health about the healthcare system of Romania.

# 3. What will you do next week?

Next week, I will continue to work on catching up on assignments. I'm also going to try to plan out my course schedule because registration is coming up. 

# 3. What was your experience of more SQL?

Learning about join queries showed me how to combine data between tables. It also got me thinking about the different types of relationships tables can have. 

# 5. What made you happy this week?
I've gotten a lot better at managing online classes. 

# 6. What's your pick of the week?

The mozilla web docs is my pick of the week. The documents have a lot of useful information about writing javascript. They also include a lot of sample code which is nice to be able to see how things are ued. 