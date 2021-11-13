#' Run App
#'
#' @return An instance of a shinyApp
#'
#' @import shiny
#' @importFrom curatedMetagenomicDataCuration get_metadata
#' @importFrom utils write.csv
#'
#' @export
#'
myApp <- function() {

    ui <- fluidPage(

        titlePanel("curatedMeatgenomicDataCuration"),
        tabsetPanel(

            ## Starts code for get_metadata UI ####
            tabPanel(
                "Get metadata",
                h1("Get metadata"),
                textInput(
                    "SRP",
                    "Enter NCBI's SRP identifier, e.g., SRP145336",
                    placeholder = "SRP145336"
                ),
                fluidRow(
                    actionButton("get_metadata_click", "Get metadata"),
                    #actionButton("clear", "Clear"),
                    downloadButton("download_metadata")
                ),
                waiter::use_waiter(),
                h4(textOutput("text_output")),
                dataTableOutput("metadata")
            ),

            ## Starts code for checkCuration UI ####
            tabPanel(
                "Check curation",
                fileInput("upload", NULL)
            )
        )
    )

    server <- function(input, output, session) {

        ## Starts code for get_metadata server ####

        display_text <- eventReactive(input$get_metadata_click, {
            text <- paste0("Displaying metadata for ", input$SRP)
            text
        })

        metadata <- eventReactive(input$get_metadata_click, {
            waiter <- waiter::Waiter$new()
            waiter$show()
            on.exit(waiter$hide())
            showNotification(
                paste0("Metadata for ", input$SRP), duration = 3
            )
            df <- get_metadata(input$SRP)
            df$SRRs <- as.character(df$SRRs)
            df
        })

        output$text_output <- renderText(display_text())

        output$metadata <- renderDataTable({
            metadata()
        }, options = list(pageLength = 10))

        output$download_metadata <- downloadHandler(
            filename = function() {
                paste0(input$SRP, ".csv")
            },
            content = function(file) {
                write.csv(metadata(), file)
            }
        )

        ## Starts code for checkCuration server ####

    }

    shinyApp(ui, server)
}
