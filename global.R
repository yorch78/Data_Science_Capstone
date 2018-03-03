library(shiny)
library(plyr)
library(reshape2)
library(data.table)
library(ggplot2)
library(scales)
library(tm)
library(openNLP)
load("modelData.RData")


getFilteredTokens <- function(phrase) {
  if (phrase == '') 
    phrase = '.'
  hint <- NULL
  
  if (grepl(' [a-z]$', phrase)) {
    hint <- substr(phrase, nchar(phrase), nchar(phrase))
    phrase <- substr(phrase, 1, nchar(phrase) - 2)
  }
  
  sentTokenAnnotator <- Maxent_Sent_Token_Annotator()
  sent <- as.character(as.String(phrase)[annotate(phrase, sentTokenAnnotator)])
  
  sent <- gsub('[^[:print:]]', '', sent)
  sent <- tolower(sent)
  sent <- gsub('\\d+[[:punct:]]*\\s*\\d*', ' NUM ', sent)
  sent <- gsub('-', ' ', sent)
  sent <- removePunctuation(sent)
  sent <- stripWhitespace(sent)
  sent <- sent[grepl('[[:alpha:]]', sent)]
  sent <- paste('BREAK ', sent)
  
  tokensIdentified <- scan_tokenizer(sent)
  list(tokens = tokensIdentified[-1], hint = hint)
}

KneserNeyRootPrediction <- function(idxWord1, idxWord2, idxWord3) {
  
  # The method is due to Reinhard Kneser and Hermann Ney.
  df <- data.frame(w = 1:nrow(repositoryWords),
                   probability1 = rep(0, nrow(repositoryWords)),
                   probability2 = rep(0, nrow(repositoryWords)),
                   probability3 = rep(0, nrow(repositoryWords)),
                   probability4 = rep(0, nrow(repositoryWords)))
  alpha1 <- 1
  alpha2 <- 1
  alpha3 <- 1
  
  if (!is.na(idxWord1) & !is.na(idxWord2) & !is.na(idxWord3) & idxWord2 != KEYWORDS$BREAK & idxWord3 != KEYWORDS$BREAK) {
    words <- list(idxWord1, idxWord2, idxWord3)
    firstSubstring <- continuousQuadrigram[words] # quadrigramTable
    df$probability1[firstSubstring$word4] <- firstSubstring$freq / sum(firstSubstring$freq)
    alpha1 <- 1 - sum(df$probability1)
  }
  
  if (!is.na(idxWord2) & !is.na(idxWord3) & idxWord3 != KEYWORDS$BREAK) {
    words <- list(idxWord2, idxWord3)
    secondSubstring <- continuousTrigram[words] # trigram
    df$probability2[secondSubstring$word4] <- secondSubstring$freq / sum(secondSubstring$freq)
    alpha2 <- 1 - sum(df$probability2)
  }
  
  if (!is.na(idxWord3)) {
    words <- list(idxWord3)
    thirdSubstring <- continuousBigram[words] # bigram
    df$probability3[thirdSubstring$w3] <- thirdSubstring$freq / sum(thirdSubstring$freq)
    alpha3 <- 1 - sum(df$probability3)
  }

  df$probability4[continuousUnigram$idxWord2] <- continuousUnigram$freq / sum(continuousUnigram$freq)

  df$ProbabilityKneyser <- df$probability1 + alpha1 * (df$probability2 + alpha2 * (df$probability3 + alpha3 * df$probability4))
  
  df
}
