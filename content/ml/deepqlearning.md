---
title: "Deep Q Learning"
date: DATE
draft: true
tags: ["ml"]
description:  "My journey trying to implement Deep Q Learning."
---
I wanted to implement DeepQ learning before I started doing research this summer to have fun. I knew about deepq learning from hearing about [Deep Mind's AlphaGo](https://deepmind.com/research/case-studies/alphago-the-story-so-far). After reading a bunch of articles here is my first try. I decided to use the [OpenAi Gym's MountainCar-v0](https://gym.openai.com/envs/MountainCar-v0/)

```python 
import gym
import numpy as np
from tensorflow.keras.utils import to_categorical
from tensorflow.keras import layers
import tensorflow as tf
import random
import time
import matplotlib.pyplot as plt

env = gym.make("Breakout-ram-v0")
env = gym.wrappers.Monitor(env, "mow",
                           video_callable= lambda x:x % 20 == 0,
                          force=True)
INPUT_SHAPE = env.observation_space.shape
print(INPUT_SHAPE)
NUM_ACTIONS = env.action_space.n
print(NUM_ACTIONS)


def createRamModel(): 

    model = tf.keras.Sequential()
    model.add(layers.Dense(128, activation='relu',input_shape=INPUT_SHAPE))
    # output is the same size as number of outputs
    model.add(layers.Dense(70,activation='relu'))

    model.add(layers.Dense(NUM_ACTIONS,activation='linear'))
    model.compile(optimizer=tf.keras.optimizers.Adam(0.01),
              loss='mse',       # mean squared error
              metrics=['mae'])  # mean absolute error
    return model


target_model = createRamModel()

memory_actions = []
epsilon = 1
batch_size = 4
episodes = []
for i in range(2000):
    total_reward = 0
    obs = env.reset().reshape(1,-1)
    # the action the model takes is the output with the highest value
    action = np.argmax(target_model.predict(obs))
    done = False
    while not done:
        lastobs = obs
        obs, reward, done, info = env.step(action)
        total_reward += reward
        obs = obs.reshape(1,-1)
        if random.random() > epsilon:
            action = np.argmax(target_model.predict(obs))
        else:
            action = env.action_space.sample()
        step = [lastobs,action,reward,obs]
        memory_actions.append(step)


    if len(memory_actions) > 1000:
        print("training " +str(epsilon))
        # do training once we've sampled enough actions
        batch = np.asarray(random.sample(memory_actions,batch_size))
        current_states = np.concatenate([i[0] for i in batch])
        cur_q_vals = target_model.predict(current_states)
        next_states = np.concatenate([i[3] for i in batch])
        rewards = np.array([i[2] for i in batch])
        actions = to_categorical(np.array([i[1] for i in batch]),num_classes=NUM_ACTIONS)
        future_q_vals = target_model.predict(next_states)
        maxfuture_q = np.amax(future_q_vals,axis=1)
        updates = rewards + 0.999*maxfuture_q
        np.putmask(cur_q_vals,actions,updates.astype('float32',casting='same_kind'))
        target_model.fit(current_states,cur_q_vals,batch_size=batch_size)

    episodes.append(total_reward)
    epsilon*=0.999
```

# Sources
- [Playing Atari with Deep Reinforcment Learning](https://arxiv.org/pdf/1312.5602.pdf)
- [Deep Q Learning and Deep Reinforcement Learning Intro and Agent](https://pythonprogramming.net/deep-q-learning-dqn-reinforcement-learning-python-tutorial/)
- [Crash Course deep q networks from the ground up](https://towardsdatascience.com/qrash-course-deep-q-networks-from-the-ground-up-1bbda41d3677)
- [Human Level control through deep reinforcement learning](https://web.stanford.edu/class/psych209/Readings/MnihEtAlHassibis15NatureControlDeepRL.pdf)
- [A hands on Introduction to Deep Q Learning using OpenAI Gym in Python](https://www.analyticsvidhya.com/blog/2019/04/introduction-deep-q-learning-python/)