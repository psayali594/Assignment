#------------------------------------------------------------------------------------#
#                   Mikha Pillai - 11915045                                          #
#                   Sandhya Raju - 11915065                                          #
#                   Sayali Patil - 11915056                                          #
#------------------------------------------------------------------------------------#


shinyServer(function(input, output) {
      Input_File <- reactive({
    
    if (is.null(input$file)) {   
      return(NULL) } else{
        input_data <- readLines(input$file$datapath,encoding = "UTF-8")
        return(input_data)
      }
  })
  Annotated<-reactive({
    
    if (is.null(input$udp_file)) {   
      return(NULL) } else{
        
        model_file <- udpipe_load_model(file = input$udp_file$datapath)
        annotated_text <- udpipe_annotate(modelfl, x = as.character(Input_File()))
        annotated_text <- as.data.frame(annotated_text)
        return(annotated_text)
      }
  })
  # Annotation   
  
  output$plot3 = renderPlot({
    input_Text <-  as.character(Input_File())
    udp_model = udpipe_load_model(file=input$udp_file$datapath)
    x <- udpipe_annotate(udp_model, x = input_Text, doc_id = seq_along(input_Text))
    x <- as.data.frame(x)
    if (input$Language == "English"){
      co_occurrence <- cooccurrence(   	
        x = subset(x, x$xpos %in% input$upos_tag), term = "lemma", 
        group = c("doc_id", "paragraph_id", "sentence_id"))  
    }
    else{
      Check_Output <- input$upos_tag
      for(i in seq_len(length(input$upos_tag))){
        if (input$upos_tag[i] == "JJ"){
          Check_Output[i] <- "ADJ"
        }
        else if (input$upos_tag[i] == "NN"){
          Check_Output[i] <- "NOUN"
        }
        else if (input$upos_tag[i] == "NNP"){
          Check_Output[i] <- "PROPN"
        }
        else if (input$upos_tag[i] == "RB"){
          Check_Output[i] <- "ADV"
        }
        else{
          Check_Output[i] <- "VB"
        }
      }
      co_occurrence <- cooccurrence(   	
        x = subset(x, x$upos %in% Check_Output), term = "lemma", 
        group = c("doc_id", "paragraph_id", "sentence_id"))  
    }
    word_network <- head(co_occurrence, 75)
    word_network <- igraph::graph_from_data_frame(wordnetwork) 
    
    suppressWarnings(ggraph(wordnetwork, layout = "fr") +  
                       
                       geom_edge_link(aes(width = cooc, edge_alpha = cooc), edge_colour = "orange") +  
                       geom_node_text(aes(label = name), col = "darkgreen", size = 6) +
                       
                       theme_graph(base_family = "Arial Unicode MS") +  
                       theme(legend.position = "none") +
                       
                       labs(title = "Co-occurrence Plot", subtitle = "Speech Tags"))
  })
  output$plot1 = renderPlot({
    input_Text <-  as.character(Input_File())
    udp_model = udpipe_load_model(file=input$udp_file$datapath)
    x <- udpipe_annotate(udp_model, x = input_Text, doc_id = seq_along(input_Text))
    x <- as.data.frame(x)
    if (input$Language == "English"){
      word_bag = x %>% subset(., xpos %in% input$upos_tag);
    }
    else{
      Check_Output <- input$upos_tag
      for(i in seq_len(length(input$upos_tag))){
        if (input$upos_tag[i] == "JJ"){
          Check_Output[i] <- "ADJ"
        }
        else if (input$upos_tag[i] == "NN"){
          Check_Output[i] <- "NOUN"
        }
        else if (input$upos_tag[i] == "NNP"){
          Check_Output[i] <- "PROPN"
        }
        else if (input$upos_tag[i] == "RB"){
          Check_Output[i] <- "ADV"
        }
        else{
          Check_Output[i] <- "VB"
        }
      }
      word_bag = x %>% subset(., upos %in% Check_Output);
    }
    top_words = txt_freq(word_bag$lemma)
    wordcloud(top_words_key = top_words$key, 
              frequency = top_words$frequency, 
              min.frequency = 2, 
              max.top_words_key = 100,
              random.order = FALSE
              )
  })
  output$Text_Data = renderText({
    input_Text <-  as.character(Input_File())
    input_Text
  })
})