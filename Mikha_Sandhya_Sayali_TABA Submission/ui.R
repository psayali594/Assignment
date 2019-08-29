#---------------------------------------------------------------------#
#                       UPOS tagging App                              #
#---------------------------------------------------------------------#
#------------------------------------------------------------------------------------#
#                   Mikha Pillai - 11915045                                          #
#                   Sandhya Raju - 11915065                                          #
#                   Sayali Patil - 11915056                                          #
#------------------------------------------------------------------------------------#

library("shiny")

shinyUI(
  fluidPage(
    
    titlePanel("Universal POS Tagging"),
    
    sidebarLayout(  
      
      sidebarPanel(  
        
        fileInput("file", "Upload data (Text File)"),
        fileInput("udp_file", "Udpipe File: Upload here"),
        
        checkboxGroupInput("upos_tag",label = h4("Parts of Speech"),
                           c("Adjective" = "ADJ",
                             "Propernoun" = "PROPN",
                             "Adverb" = "ADV",
                             "Noun" = "NOUN",
                             "Verb"= "VERB"),
                           selected = c("ADJ","NOUN","PROPN") )
      ),   # end of sidebar panel
      
      
      mainPanel(
        
        tabsetPanel(type = "tabs",
                    
                    tabPanel("Description",
                             h4(p("Purpose")),
                             p("This is a Universal POS tagging application. Using this app you can visualize annotated documents, word-clouds and plot co-occurences.",align="justify"),
                             br
                             
                             #img(src = "Parts-of-Speech.png", height = 487, width = 611)
                             
                    ),
                    tabPanel("Annotated Documents", 
                             plotOutput('plot1')),
                    
                    tabPanel("Word-Cloud",
                             tableOutput('plot2')),
                    
                    tabPanel("Co-Occurence Plot",
                             dataTableOutput('plot3'))
        )
      )
    )
  )
)

