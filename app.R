

# Charger l'interface utilisateur et le serveur
source("ui.R")
source("server.R")



# Lancer l'application
shinyApp(ui = shinyUI(), server = shinyServer())
