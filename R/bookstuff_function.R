require(shiny)

#' @title bookstuff
#' @description function creates a shiny app which lets you manage your book list and export it as a csv.
#' @param None This function does not take any parameters
#' @return a shiny app


bookStuff <- function() {
  
  ui <- fluidPage(
    titlePanel("Bookshelf"),
    sidebarLayout(
      sidebarPanel(
        fileInput("file",
                  label = "Upload a CSV file",
                  multiple = FALSE,
                  accept = c(".csv"),
                  buttonLabel = "Upload"),
        textInput("title", "Book Title"),
        textInput("author", "Author"),
        selectInput("status", "Status", choices = c("Finished", "Currently Reading", "To Be Read")),
        actionButton("addBtn", "Add Book"),
        actionButton("removeBtn", "Remove Book"),
        actionButton("exportBtn", "Export to CSV")
      ),
      mainPanel(
        dataTableOutput("bookTable")
      )
    )
  )
  
  server <- function(input, output, session) {
    # Initialize reactiveValues to store books
    rv <- reactiveValues(books = data.frame(Title = character(), Author = character(), Status = character(), stringsAsFactors = FALSE))
    
    # load csv file
    observeEvent(input$file, {
      
      rv$books <- read.csv(input$file$datapath)
    })
    
    # Add Book button 
    observeEvent(input$addBtn, {
      author <- input$author
      title <- input$title
      status <- input$status
      new_book <- data.frame(Author = author, Title = title, Status = status, stringsAsFactors = FALSE)
      rv$books <- rbind(rv$books, new_book)
    })
    
    # Remove Book button 
    observeEvent(input$removeBtn, {
      title_to_remove <- input$title
      rv$books <- rv$books[rv$books$Title != title_to_remove, ]
    })
    
    # Export to CSV button 
    observeEvent(input$exportBtn, {
      write.csv(rv$books, 'books.csv', row.names = FALSE)
    })
    
    # print df
    output$bookTable <- renderDataTable({
      rv$books
    })
  }
  
  shinyApp(ui = ui, server = server)
}

