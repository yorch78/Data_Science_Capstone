# User Interface definition for the NLP predictor.

shinyUI(
  fluidPage(
    
     titlePanel("NLP Prediction Demo"),

     sidebarLayout( position = 'left',
       
       sidebarPanel(
         textInput('userPhrase', label = "Type here your text:", value = "This is my try "),
         actionButton('predictButton', "Predict next word", position = "right"),
         br(),
         br(),
         helpText(span("User instructions:", style = "color:darkgreen; font-size: 20px; font-style: bold;"),
                  br(),
                  "Start typing a letter behind ",
                  span("'This is my try...'", style = "color:darkred; font-style: italic;"),
                  "and click on 'Predict next word' to get an automatic prediction of the next word within the 10 more probable words."),
         br(),
         uiOutput('phraseTokens')
       ),
       
       mainPanel(
         br(),
         plotOutput('predict', width = '600px', height = '400px')
       )

    ),
    tags$head(tags$style("#userPhrase{background-color: LightYellow;
                                     color: red;
                                     text-align: center;
                                     font-size: 20px;
                                     font-style: bold;}")),
    tags$head(tags$style("#predictButton{background-color: LimeGreen;
                                    color: black;
                                    font-size: 20px;
                                    font-style: bold;
                                    width: 100%;}")),
    tags$head(tags$style("#tokens{background-color: LightSteelBlue;
                                  color: black;
                                  font-size: 16px;
                                  font-style: bold;}"))
  ) # fluidPage
) # shinyUI
