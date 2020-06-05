---
title: "Deep Q Learning"
date: DATE
draft: true
tags: ["ml"]
description:  "Anatomy of DeepQ Learning"
---
<img src="/vids/ml/deepq.gif">


# Terms
Agent: The neural network that takes actions in the game.  
Action: An action the agent takes while playing the game.  
Q Value: The total predicted reward for a given action.  
Memory: An array that keeps track of:  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;The State before an action.  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;The action taken.  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;The reward expercienced after that action.  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;The next state.  
Prediction Network: The neural network that decides the playing actions.  
Training Network: The network that gets trained via action replay and 

# Memory Replay

Memory replay is the way our agent learns how to play the game. At first the agent makes random decisions and keeps track of the decisions made in it's memory. Once it's memory has reached a certain length. A random sample is taken from the memory and is used to train the training network. The training network is trained on every turn. The predictive network's weight, the network that actually decides what action gets taken, has its weights updated after a certain number of steps. 

# Training the training network

$$

# Things I learned along the way

At first I tried to apply deepq learning on `MountainCar-v0`. I found the mountain car environment only gives out rewards very rarely. Once the car reaches the top of the hill. This meant that the agent wasn't able to learn anything because it hadn't seen any rewards during the time it was playing the game.

I had bug in the way I used numpy's np.put function. I realized that the put function flattens the array before inserting the reward data into it. This meant the calculated rewards where being put in the wrong place. I switched the code to use np.putmask Which actually puts the rewards in their place with their corresponding actions. 

# Code


```python 
import gym
import numpy as np
from tensorflow.keras.utils import to_categorical
from tensorflow.keras import layers
import tensorflow as tf
import random
import time
import matplotlib.pyplot as plt
from collections import deque

env = gym.make("Breakout-ram-v0")

# capture video every 20 games
env = gym.wrappers.Monitor(env, "largebatch",
                           video_callable=lambda x: x % 20 == 0,
                           force=True)
INPUT_SHAPE = env.observation_space.shape
print(INPUT_SHAPE)
NUM_ACTIONS = env.action_space.n
print(NUM_ACTIONS)


def createRamModel():

    model = tf.keras.Sequential()
    model.add(layers.Dense(80, activation='relu', input_shape=INPUT_SHAPE))
    # output is the same size as number of outputs
    model.add(layers.Dense(60, activation='relu'))
    model.add(layers.Dense(NUM_ACTIONS, activation='linear'))

    model.compile(optimizer=tf.keras.optimizers.Adam(0.01),
                  loss='mse',       # mean squared error
                  metrics=['mae'])  # mean absolute error
    return model


target_model = createRamModel()
training_model = createRamModel()
training_model.set_weights(target_model.get_weights())

memory_actions = deque(maxlen=10000)
epsilon = 1
batch_size = 100
# number of steps taken before training network is updated
c = 300
episodes = []
for i in range(2000):
    total_reward = 0
    counter = 0
    obs = env.reset().reshape(1, -1)
    # the action the model takes is the output with the highest value
    action = np.argmax(target_model.predict(obs))
    done = False
    while not done:
        lastobs = obs
        obs, reward, done, info = env.step(action)
        total_reward += reward
        obs = obs.reshape(1, -1)
        if random.random() > epsilon:
            action = np.argmax(target_model.predict(obs))
        else:
            action = env.action_space.sample()
        step = [lastobs, action, reward, obs]
        memory_actions.append(step)
        if len(memory_actions) > 6000:
            print("training " + str(epsilon))
            # do training once we've sampled enough actions
            batch = np.asarray(random.sample(memory_actions, batch_size))
            current_states = np.concatenate([i[0] for i in batch])
            cur_q_vals = training_model.predict(current_states)
            next_states = np.concatenate([i[3] for i in batch])
            rewards = np.array([i[2] for i in batch])
            actions = to_categorical(
                np.array([i[1] for i in batch]), num_classes=NUM_ACTIONS)
            future_q_vals = training_model.predict(next_states)
            maxfuture_q = np.amax(future_q_vals, axis=1)
            updates = rewards + 0.99*maxfuture_q
            np.putmask(cur_q_vals, actions, updates.astype(
                'float32', casting='same_kind'))
            training_model.fit(current_states, cur_q_vals,
                               batch_size=batch_size)
            counter += 1
            epsilon = max(0.1,epsilon *0.999999)
            if counter > c:
                counter = 0
                print("SET WEIGHTS")
                target_model.set_weights(training_model.get_weights())

    episodes.append(total_reward)
```

# Sources
- [Playing Atari with Deep Reinforcment Learning](https://arxiv.org/pdf/1312.5602.pdf)
- [Deep Q Learning and Deep Reinforcement Learning Intro and Agent](https://pythonprogramming.net/deep-q-learning-dqn-reinforcement-learning-python-tutorial/)
- [Crash Course deep q networks from the ground up](https://towardsdatascience.com/qrash-course-deep-q-networks-from-the-ground-up-1bbda41d3677)
- [Human Level control through deep reinforcement learning](https://web.stanford.edu/class/psych209/Readings/MnihEtAlHassibis15NatureControlDeepRL.pdf)
- [A hands on Introduction to Deep Q Learning using OpenAI Gym in Python](https://www.analyticsvidhya.com/blog/2019/04/introduction-deep-q-learning-python/)