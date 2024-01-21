
function(input, output, session) {
  
  
  # chargement donnees interactive fileinput 
  
  
  
  #identite
  #carte_interactive
  #recuperation_et_traitement_donnees_
  #Donnees
  
  
  output$tableau_donnees <- DT::renderDataTable(DT::datatable({
    data <- Donnees[,c(1:5)]
    if (input$Pays != "All") {
      data <- data[data$store_location == input$Pays,]
    }
    data}))
  
  output$graphemois <- renderHighchart({
    # Filtrer les données en fonction de l'année sélectionnée
    data <- Donnees %>%
      filter(date == input$selected_year) %>%
      group_by(month) %>%
      summarize(count = n())
    
    hchart(data, "bar", hcaes(x = month, y = count))
  })
  output$evol <- renderHighchart({
    # Exemple : Courbe temporelle basée sur la date et le nombre de commentaires par jour
    data <- Donnees %>%
      group_by(year) %>%
      summarize(count = n())
    
    hchart(data, "line", hcaes(x = year, y = count))
  })
  output$map <- renderLeaflet({
    leaflet(Donnees) %>%
      addTiles() %>%
      addMarkers(
        clusterOptions = markerClusterOptions(),
        popup = ~paste("Review ID: ", Donnees$reviewer_id),
        icon = makeIcon(
          iconUrl = "http://leafletjs.com/examples/custom-icons/leaf-red.png", # Image d'icône rouge
          iconWidth = 38, iconHeight = 55,
          iconAnchorX = 22, iconAnchorY = 94,
          popupAnchorX = -3, popupAnchorY = -76
        )
      )
  })
  output$review_chart <- renderHighchart({
    data <- Donnees %>%
      filter(month == input$selected_month) %>%
      group_by(date) %>%
      summarize(count = n())
    
    highchart() %>%
      hc_chart(type = "bar") %>%
      hc_xAxis(categories = data$date) %>%
      hc_add_series(
        name = "Review Count",
        data = data$count,
        color = "#3498db"  # Blue color
      )
  })
  output$downloadPDF <- downloadHandler(
    filename = function() {
      paste("graphique", Sys.Date(), ".pdf", sep = "_")
    },
    content = function(file) {
      # Code pour générer le graphique en PDF
      # Utilisez les bibliothèques nécessaires
      # ggsave(file, ggplot_object, device = "pdf")
    }
  )
  
  # Fonction pour exporter en PNG
  output$downloadPNG <- downloadHandler(
    filename = function() {
      paste("graphique", Sys.Date(), ".png", sep = "_")
    },
    content = function(file) {
      # Code pour générer le graphique en PNG
      # Utilisez les bibliothèques nécessaires
      # ggsave(file, ggplot_object, device = "png")
    }
  )
  
  # Fonction pour exporter en CSV
  output$downloadCSV <- downloadHandler(
    filename = function() {
      paste("donnees", Sys.Date(), ".csv", sep = "_")
    },
    content = function(file) {
      # Code pour générer le fichier CSV
      # Utilisez les bibliothèques nécessaires
      # write.csv(Donnees, file, row.names = FALSE)
    }
  )
  observeEvent(input$loadDataBtn, {
    req(input$file)  # Assurez-vous qu'un fichier est sélectionné
    
    # Chargez les données depuis le fichier CSV
    Donnees <- read.csv(input$file$datapath)
    
    # Mettez à jour les éléments de l'interface utilisateur liés aux données (par exemple, le tableau)
    updateDataTable(session, "tableau_donnees", data = Donnees)
  })
}


