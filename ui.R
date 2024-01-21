source("package.R")
source("global.R")

fluidPage(

  tags$head(
    tags$link(href="styles.css", rel="stylesheet", type="text/css")
  ),
  
  fluidRow(
    
    column(
      width = 10, offset = 1,
      
      tags$div(
        class = "title",
        tags$br(),
        tags$h1("Etude shopper sentiment data 2023", class = "titre"),
        tags$br(), 
        tags$br(), 
        tags$span(icon("chart-line"), class = "main-icon")
      ),
      verticalTabsetPanel(
        #Information gÃÂ©nÃÂ©rales
        #données
        verticalTabPanel(
          fileInput("file", "Veuillez charger vos données", accept = ".csv"),
          actionButton("loadDataBtn", "Charger les données"),
          title = "Données", icon = icon("database", class = "fa-2x"),
          selectInput("Pays","Pays:",c("All",unique(as.character(Donnees$store_location)))),
          DT::dataTableOutput("tableau_donnees"),
      ),
      verticalTabPanel(
        title = "Etude dans le temps", icon = icon("calendar-days", class = "fa-2x"),
        #niveau formation
        p(style="text-align: center","Repartition des commentaires par mois"),
        #selectInput("Annee","Annee:",c("All",unique(Donnees$date))),
        selectInput("selected_year", "Sélectionner une année", choices = unique(Donnees$date)),
        highchartOutput("graphemois",height="200px"),
        br(),
        p(style="text-align: center","Evolution"),
        highchartOutput("evol",height="200px"),
        downloadButton("downloadPDF", label = "Exporter en PDF"),
        downloadButton("downloadPNG", label = "Exporter en PNG"),
        downloadButton("downloadCSV", label = "Exporter en CSV")
        
      ),
      verticalTabPanel(
        title = "Etude dans l'espace", icon = icon("location-dot", class = "fa-2x"),
        p(style="text-align: center","Localisation des stores"),
        leafletOutput("map", height=300),
       
      ),
      verticalTabPanel(
        title = "Evaluation des ratings", icon = icon("square-check", class = "fa-2x"),
        p(style="text-align: center","Evaluation des ratings"),
        selectInput("selected_month", "Select a month", choices = unique(Donnees$month)),
        highchartOutput("review_chart", height="300px"),
        br(),
        #ide
      ),
      
      #en savoir plus
      br(),
      actionLink(
        inputId = "about", label = "En savoir plus", icon = icon("solid fa-plus"),
        tags$img(src = "loupe.jpg", style = "width: 50px; height:40px; float:left; margin-right: 10px;"),
      )
     
      
    )
  )
)
)
