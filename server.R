shinyServer(function(input, output, session) {
  
  # Activate reactive token extraction.
  extractPhraseTokens <- reactive(getFilteredTokens(input$userPhrase))
  
  # Extract tokens from user phrase and show it in table format.
  output$phraseTokens <- renderTable(width = "300", align = "c", spacing = "s", hover = "true", {
    
    tokenizedPhrase <- extractPhraseTokens()
    hint <- tokenizedPhrase$hint
    extractedTokens <- tokenizedPhrase$tokens
    extractedTokens[extractedTokens == 'BREAK'] <- '.'
    as.data.frame(extractedTokens)
  })
  
  # Activate reactive prediction.
  getPrediction <- reactive({
    
    input$predictButton
    
    tokensPresent <- isolate(extractPhraseTokens())
    hint <- tokensPresent$hint
    tokensPresent <- tokensPresent$tokens
    
    if (length(tokensPresent) < 3) {
      tokensPresent <- c(rep('BREAK', 3 - length(tokensPresent)), tokensPresent)
    }
    
    wordIndex1 <- match(tokensPresent[length(tokensPresent) - 2], repositoryWords$w)
    wordIndex2 <- match(tokensPresent[length(tokensPresent) - 1], repositoryWords$w)
    wordIndex3 <- match(tokensPresent[length(tokensPresent)], repositoryWords$w)
    
    Pkn <- KneserNeyRootPrediction(wordIndex1, wordIndex2, wordIndex3)$ProbabilityKneyser
    wordsCatalog <- repositoryWords$w
    wordsCatalog[KEYWORDS$BREAK] <- '.'
    df <- data.frame(wordsCatalog, Pkn)
    df <- df[-c(KEYWORDS$UNK, KEYWORDS$NUM),]
    
    if (!is.null(hint)) {
      df <- df[grepl(paste0('^', hint), df$wordsCatalog),]
      df <- transform(df, Pkn = Pkn / sum(Pkn))
    }
    df <- arrange(df, desc(Pkn))
  })
  
  # Get prediction for the most probable next word.
  output$predict <- renderPlot({
    
    top10predicted <- getPrediction()[1:10,1:2]
    top10predicted[top10predicted$wordsCatalog == 'BREAK',1] <- '.'
    top10predicted <- melt(top10predicted)

    ggplot(top10predicted, aes(x = factor(wordsCatalog, unique(wordsCatalog)), y = value, fill = "red") ) +
      geom_bar(stat = 'identity') +
      ggtitle('Top 10 most probable next word prediction') +
      labs( y = 'Probability', x = 'Probable next word', size = 20) +
      guides(fill = FALSE) +
      scale_y_continuous(labels = percent) +
      theme(plot.title = element_text(color = "darkgreen", size = 26, face = "bold", hjust = 0.5),
            axis.text.x = element_text(angle = 30, hjust = 1, size = 20, colour = "darkgreen"),
            axis.text.y = element_text(hjust = 1, size = 20))
  })
  
})
