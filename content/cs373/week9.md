---
title: "CS373 Spring 2020: Alice Reuter Week 9"
date: 2020-04-12 23:58:21 -0500
draft: false
readings: 3
tags: ["cs373"]
---


# 1. What did you do this past week?

This past week I worked on implementing searching on our software engineering site. It took me a surprisingly long time to implement unit testing for React components. One of the issues with unit testing was that we make use of the `Router` react-router component which expects a browser history, which isn't present in the testing environment. I ended up wrapping the test component with  the `MemoryRouter` component which emulates the browser's history. 
```javascript
ReactDOM.render(
    <MemoryRouter initEntries={'/animals'}>
        <Route path='/animals'>
            <Animals/>
        </Route>
    </MemoryRouter>
)

```

I've also been working on my global health paper. We're writing about the health infrastructure of romania and it's been interesting to see how Covid-19 has impacted things. 

# 2. What's in your way?

I have a multicore project and a software engineering project due next week. I also have linear and global health homework so I've just been working on getting them done. I also have a linear algebra take home test due tonight.

# 3. What will you do next week?

Finish implementing searching on our hikeadvisor site. I also want to start working on my linear algebra homework earlier. 

# 4. What was your experience of SQL?

I've used SQL before but I've not thought of it through the lense of relational algebra before. Having to implement the different relational algebra constructs has made me think more broadly about what can be accomplished using sql. I've read that relational algebra is not turing complete so I guess that means that you can only express a certain subset of computations using it. I also wonder if it's better to implement business logic as a complex sql query or to implement business logic on the results of the query. 

# 5. What was your experience with ethics material?

I found the ethics material to be interesting. I took a philosophy course in high school so I have some familiarity with ethical thought experiments. The conversation around how to program self driving cars is interesting because it forces us to encode our society's ethical beliefs. The part around algorithmic biases got me thinking about how I can work to prevent them. 

# 6. What made you happy this week?

Talking with friends.

# 7. What's your pick of the week?

My pick of the week are the [react dev tools](https://chrome.google.com/webstore/detail/react-developer-tools/fmkadmapgofadopljbjfkapdkoienihi?hl=en). They make it much easier to debug what the state of your components are. I used them a lot to understand how the`useEffect` function updated a components state. 
