---
title: "CS373 Spring 2020: Alice Reuter Week 9"
date: DATE
draft: false
readings: 3
tags: ["cs373"]
---

<img src="/img/cs373/linkedin.png" width="200" align="left" style="padding-right:2rem" />

# 1. What did you do this past week?

This past week  worked on implement searching on our software engineering site. I took me a surprisingly long time to implement unit testing for React components. Run of the issues with unit testing was that we make use of the `Router` react-router component which expects a browser history, which isn't present in the testing environment. I ended up wrapping the test components with  the `MemoryRouter` component which emulates the browsers history. 
```javascript
ReactDOM.render(
    <MemoryRouter initEntries={'/animals'}>
        <Route path='/animals'>
            <Animals/>
        </Route>
    </MemoryRouter>
)

```

I've also been working on my global health paper. My cyber team competed virtually at Southwest Collegiate Cyber Defense competition at we placed [third](https://twitter.com/SWCCDC/status/1249487908974649345)! The competition itself was fun and I learnt a lot about the windows registry and group policy. Hunting for malware is always fun. Though, in a perfect world I would have enjoyed to have the competition person because then you get to interact with physical hardware. 

# 2. What's in your way?

I have a multicore project and a software project due next week. As well as homework so I've just been grinding to get them done.

# 3. What will you do next week?

Finish implementing searching on our SWE site. I also want to start working on my linear algebra homework earlier. 

# 4. What was your experience of SQL?

I've used SQL before but I've not thought of it through the lense of relational algebra. Having to implement the different relational algebra constructs has made me think more broadly about what can be accomplished using sql.

# 5. What was your experience with ethics material?

I found the ethics material to be interesting. I took a philosophy course in high school so I have some familiarity with ethical thought experiences. The conversation around how to program self driving cars is interesting because it forces us to encode our society's ethical beliefs. The part around algorithmic biases got me thinking about I can work to prevent them. 

# 6. What made you happy this week?

Competing with my cyber security team and being able to seem them all again. Also being with my family during this global pandemic.

# 7. What's your pick of the week?

My pick of the week are the [react dev tools](https://chrome.google.com/webstore/detail/react-developer-tools/fmkadmapgofadopljbjfkapdkoienihi?hl=en). They make it much easier to debug what the state of your components. It used them a lot to understand how the`useEffect` function updates a components state. 