# Thresholded Multi-Armed Bandit

## Overview
This project explores the **Thresholded Multi-Armed Bandit** problem in the context of **dynamic spectrum access** with **rateless codes**. It aims to develop and evaluate online learning algorithms to maximize the probability of transmission success in uncertain environments.

The problem is formulated within the **multi-armed bandit (MAB) framework**, where the feedback structure and heterogeneous data rate requirements introduce unique challenges.

## Research Papers
For more details on the theoretical background, problem formulation, and proposed algorithms, refer to the following research papers:

1. **Threshold Bandits for Dynamic Spectrum Access with Rateless Codes**
   [Read the Paper](https://drive.google.com/file/d/1RLtM0fTCTSOCm-KpcWz7kTHarvf8Hvwk/view?usp=drive_link)

2. **UCB-based Learning Algorithm on Threshold Bandits for Dynamic Spectrum Access with Rateless Codes**
   [Read the Paper](https://drive.google.com/file/d/1KHSXthbfy97gNyYsYIC8DBFCmjNlF-YI/view?usp=drive_link)

## Implementation Details
- The implementation follows an **Upper Confidence Bound (UCB)-based approach** with variations that account for **censored feedback**.
- Key algorithms include:
- **Threshold-UCB (T-UCB)**
- **Threshold-UCB-Censored (T-UCB-C)**
- **Threshold-UCB with Left-Kaplan-Meier Estimator (T-UCB-LKM)**

## Contact

If you have any questions or suggestions, feel free to reach out to cxs1937@psu.edu.