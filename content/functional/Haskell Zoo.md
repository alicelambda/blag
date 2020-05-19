---
title: "Haskell Zoo"
date: 2019-07-06T17:47:39
draft: false
tags: ["functional"]
description:  "Haskell Zoo shows you how to use different parts of the Haskell language"
---
To run this code you will need to install the [haskell platform](https://www.haskell.org/downloads/#platform) then you will be able to run the code by either pasting it into ghci or saving it as a `.hs` file and compiling it.

- [Functions](#functions)
- [IO](#io)
- [Functors](#functors)
- [Reader Monad](#reader-monad)

# Functions
In Haskell, we define a function by writing its name and its parameters on the left and then we define the function body on the right.
```
add2 x = x + 2
```

```
Prelude> add2 x = x + 2
Prelude> add2 10
12
Prelude> add2 40
42
#+END_EXAMPLE
If statements always have to have an if true statement and an if false statement.
#+BEGIN_SRC haskell
conditionalAdd2 x = if x > 9 then x + 2 else x
```

```
Prelude> conditionalAdd2 2
2
Prelude> conditionalAdd2 10
12
Prelude> conditionalAdd2 9
9
```

You can use Haskell guards to match the parameters of a function. Here if the parameter to login is "alice" then we say hello. If we don't specify a string, like in the bottom case, then the function matches everything else. 
``` haskell
login "alice" = "Hello Alice"
login  _      = "Who are you?"
```

```
Prelude> login "mary"
"Who are you?"
Prelude> login "kate"
"Who are you?"
Prelude> login "alice"
"Hello Alice"
```
# IO
All input-output actions in Haskell are wrapped in the IO monad. This makes it easier to tell when a function makes changes to the outside world. 
``` haskell
-- | prints hello world
hello :: IO ()
hello = putStrLn "Hello What's your name"
```
The do notation allows us to run one command after another the <- arrow allows us to get the string out of IO so we can do stuff with it. Like printing. You can think of IO as a cage that values are trapped in and we need to explicitly ask to get values out of that cage.
``` haskell
-- | get a users name and print it 
sayHello :: IO ()
sayHello = do
  hello 
  name <- getLine :: IO String
  putStrLn name
```
Notice how we've reused the hello function. The dollar sign means to evaluate everything on the right side of the dollar sign before trying to apply the function on the left. In this case, it causes "hello" to get concatenated with "name" before the result is printed.
``` haskell
-- | personalize it 
makeItPersonal :: IO ()
makeItPersonal = do
  hello 
  name <- getLine :: IO String
  putStrLn $ "Hello " ++  name
```

# Functors
Functors in Haskell allow you to run a function over arbitrary structures.
``` haskell
f x = x + 1
added = f <$> [1,2,3,4]
```
```
Prelude> :l Zoo.hs
*Main> added
[2,3,4,5]
```
Here we ran a functor of the list since the list is an instance of the Functor typeclass. We can also run functors over many different structures.
```
*Main> f <$> Just 10
Just 11
```
We ran the same function f over the Maybe Monad.
``` haskell
f x = read x :: Int

add12 = do
  number <- f  <$>  getLine
  print (number + 12)
```
```
Prelude> :l Zoo.hs
*Main> add12
24
36
```
Here we apply the function f, that takes a string and returns an Int, over the IO structure.

# Reader Monad
The reader monad is a great way to pass state, like configuration data, around to many functions. In this example, we'll pass a user datatype across functions.
``` haskell
{-# LANGUAGE FlexibleContexts #-}
import Control.Monad.Reader

data User = User {
  username :: String,
  favouriteColor:: String
  }
```
Using the MonadReader we can pass user data implicity. The ask function is used to get the user state from the reader monad. The liftIO is needed to lift the type of puStrLn from `IO` and into `m` our Reader Monad and IO combination.
``` haskell
printWelcome :: (MonadReader User m, MonadIO m) => m ()
printWelcome = do
  user <- ask
  let name = username user
  liftIO $ putStrLn $ "Hello " ++ name
```
We can run the monad by passing the reader monad to a monad transformer.
``` haskell
alice :: User
alice = User "alice" "purple"

main :: IO ()
main = runReaderT printWelcome alice
```

```
alice$ ./Zoo
Hello Alice
```
The cool thing about the Reader Monad is we can define other functions that also act on the same implicit state.
``` haskell
printColor :: (MonadReader User m,MonadIO m) => m ()
printColor = do
  user <- ask
  let color = favouriteColor user
  liftIO $ putStrLn $ "Your color " ++ color
```
We can modify the printWelcome function to call printColor.
``` haskell
printWelcome :: (MonadReader User m, MonadIO m) => m ()
printWelcome = do
  user <- ask
  let name = username user
  liftIO $ putStrLn $ "Hello " ++ name
  printColor
```
Notice how we never explictly pass the User to the functions.
```
alice$ ./Zoo
Hello Alice
Your color purple
```