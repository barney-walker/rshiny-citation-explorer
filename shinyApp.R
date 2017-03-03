require(shiny)
require(visNetwork)
require(data.table)

rm(list=ls())

functions <- list.files(path="Functions/",pattern="*.R", full.names=T, recursive=FALSE)
lapply(functions,source)

#Load in prepared node and edge data

load('filledData.RData') 

#Add co-citations as new edge type
cocites = findCoCitations(data) 
data$edges = rbindlist(list(data$edges,cocites)) 

#Clean up data, selecting only node attributes we need.
graph = filterData(data,1:5,c('DOI','Title','Abstract','firstAuthor','Author','Year','key','cocitecount','citercount','citedcount','citecount'))

#Set up data with fields needed for visNetwork package
graph = visGraphPrep(graph)


#Define the different modes
modes = c('seed','old','new','cocited','all')
names(modes) = c('Seed Papers','Papers cited by Seed Papers','Papers that cite Seed Papers','Papers co-cited with Seed Papers','All Papers')


server <- function(input, output,session) {
  
  
  output$network1 <- renderVisNetwork({
    
    nodes = graph$nodes[graph$nodes$key,] #Select only key papers to start with
    
    edges = graph$edges
    
    visNetwork(nodes, edges) %>%
      visNodes(size=10,font=list(color='white',size=0))%>%
      visEdges(smooth=F,color=list(color='#eaeded',hover='black'),selectionWidth=2,arrows='to') %>%
      visPhysics(stabilization = F)%>%
      visGroups(groupname = "key", color = '#f1c40f')%>%
      visGroups(groupname = 'notkey',color='#3498db')%>%
      visOptions(highlightNearest = TRUE,
               nodesIdSelection = list(enabled = TRUE,selected=1))
    
    
  })
  
  #Observe for change in mode and update sliders and graph
  
  observeEvent(input$mode, {
  
    
    threshold = switch(input$mode,
                       seed = 0,
                       old = max(graph$nodes$citedcount),
                       new = max(graph$nodes$citercount),
                       cocited = max(graph$nodes$cocitecount),
                       all = max(graph$nodes$citecount))
    
    label = switch(input$mode,
                   seed = 'Minimum Total Citations',
                   old = 'Minimum Seed Papers Cited-by',
                   new = 'Minimum Seed Papers Cited',
                   cocited = 'Minimum Seed Paper Co-citations',
                   all = 'Minimum Network Citations')
    
    
    updateSliderInput(session, "thresh", value=threshold,max = threshold,label=label)
    
    
  })
  
    
    observe({
      
      #Define which metric to use for thresholding based on mode selected
      
      sortCol = switch(input$mode,
                              seed = 'citecount',
                              old = 'citedcount',
                              new = 'citercount',
                              cocited = 'cocitecount',
                              all = 'citecount')
      
      #Define which edge types to display based on mode selected
      
      showEdges = switch(input$mode,
                     seed = 4,
                     old = 2,
                     new = 3,
                     cocited =5,
                     all = c(1,2,3,4))
      
      
      #Select all nodes in the database
      nodes = graph$nodes
      
      #Choose nodes to remove (those which are below the threshold for display)
      killnodes = nodes$id[which(nodes[,get(sortCol)]<input$thresh)]
      
      #Remove the keynodes from this list (we always want them displayed)
      keynodes = nodes$id[nodes$key]
      killnodes = killnodes[!(killnodes %in% keynodes)]
      
      #Choose nodes to display (nodes > threshold plus the keynodes)
      newnodes = data.table::rbindlist(list(nodes[nodes$key,],nodes[which(nodes[,get(sortCol)]>input$thresh),]))
      

      if(input$mode=='seed') {newnodes = keynodes; killnodes = nodes$id[!nodes$key]}
      
      #Filter edges to display
      newedges = graph$edges[(graph$edges$type %in% showEdges),]
      killedges = graph$edges$id[!(graph$edges$type %in% showEdges)]
      
      visNetworkProxy("network1") %>%
        visUpdateNodes(nodes = newnodes)%>%
        visUpdateEdges(edges = newedges)%>%
        visRemoveNodes(id = killnodes)%>%
        visRemoveEdges(id = killedges)%>%
        visOptions(highlightNearest = TRUE,
                   nodesIdSelection = list(enabled = TRUE,useLabels=T))
      
    })
    
    observe(({
      
      visNetworkProxy("network1") %>%
      visSelectNodes(as.numeric(input$fulltable_rows_selected))
      
    }))
    
    #Make table of node details
    
    #output$node_details = renderTable({
      
     # if(input$tab=='network'){selection = as.numeric(input$network1_selected)}else{selection=input$fulltable_rows_selected}
      
      #graph$nodes[selection,c('Title','Author','Year','Abstract')]
      
      #})
    
    output$nodeinfo = renderText({
      
      if(input$tab=='network'){selection = as.numeric(input$network1_selected)}else{selection=input$fulltable_rows_selected}
      
      paste("<p> <b>Title :</b> ", graph$nodes$Title[selection],'</p>',
            "<p> <b>Authors : </b>", graph$nodes$Author[selection],'</p>',
            "<p> <b>Year : </b>", graph$nodes$Year[selection],'</p>',
            "<p> <b>Abstract : </b>", graph$nodes$Abstract[selection],'</p>')
    })
 
    
    output$fulltable = DT::renderDataTable({
      graph$nodes[,c('Author','Year','citecount','citercount','citedcount','cocitecount')]
    
    },selection='single')
    
    
    
    
  }
  
  ui <- fluidPage(
    
    
    titlePanel("Citation Explorer"),
    
    sidebarLayout(
      sidebarPanel(
        selectInput('mode','Select Mode:',choices=modes,selected='seed'),
        sliderInput("thresh",label='Minimum Total Citations',min=0,max=100,value=0),
        #checkboxGroupInput('hideEdges',label='Select Edge Types:',choices=c('Citations between Key papers'=4,'Citations from Key papers'=2,'Citations to Key Papers'=3,'Other Citations'=1),selected = 4),
        htmlOutput('nodeinfo')
      ),
    
      mainPanel(
        tabsetPanel(type = "tabs", id='tab',
                  tabPanel("Network", value ='network',visNetworkOutput("network1", height = "500px")), 
                  tabPanel("Table", value = 'table',DT::dataTableOutput("fulltable"))
        )
      )

    )
  )
    #wellPanel(
      
      #tableOutput('node_details')
    #)
  
  
  
  
  shinyApp(ui = ui, server = server)
  

