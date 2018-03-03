Coursera Data Science Capstone: NLP Predictor
========================================================
author: Jorge Robledo
date: 03/03/2018
autosize: true

Introduction
========================================================

This slide deck presents NLP Predictor, an app that predicts the next word given a phrase entered by the user.
The prediction makes use of a N-gram corpus previously constructed that contains Four-grams, Tri-grams, Bi-grams and Uni-grams present in a huge set of samples from blogs, news publications and tweets (all of them are formed with english words).

Basically, the user writes a phrase and once he requests a prediction for the next word, the algorithm will search the top 10 words more probable to continue the series considering the N-gram that compounds the model.

All of the code is stored on GitHub and reacheable by clicking the next link: https://github.com/yorch78/Data_Science_Capstone

* N-gram:  sequence of n contiguous words (word-1 word-2 word-3 ... word-n).

The Algorithm
========================================================

NLP Predictor uses the phrase introduced by the user in a input box. After clicking "Predict next word", it will search in the corpus across the Four-gram, Tri-gram, Bi-gram and Uni-gram the most probable words that follow the last introduced.

It uses a simple Kneser-Ney algorithm, starting from the Four-gram list and the app will always give an output with 10 predicted words to the user considering the highest probabilities present in every N-gram that matches the input phrase.
The data used to make the model is a collection of unstructured sentences from US blogs, Twitter, and US news sources with additional processing tasks like:

- Filtered to exclude numbers, profanities, and misspellings.
- Split into n-grams and tabulated by frequency counts.
- Exclude URLs, e-mail, white spaces.

Instructions
========================================================

1. Type your phrase in the input box.
2. Every new word included in the phrase will be showed automatically in a separate table "extractedTokens" that shows the splitted words by row.
3. Click on the green button "Predict next word".
4. The application will process the input applying the algorithm described previously.
5. After 1-2 seconds, it will report the results as a plot with 10 bars representing the probability of every word predicted.

Instructions
========================================================

<img src="NLP_Predictor.png" width = 780 height = 450;>

https://yorch78.shinyapps.io/NLP_Predictor/
