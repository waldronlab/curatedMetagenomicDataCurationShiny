#' Run App
#'
#' \code{myApp} runs a shinyApp for the \code{get_metadata} and
#' \code{checkCuration} functions of the curatedMetagenomicDataCuration
#' package.
#'
#' @return An instance of a shinyApp.
#'
#' @import shiny
#' @importFrom curatedMetagenomicDataCuration get_metadata
#' @importFrom utils write.table
#' @importFrom utils read.table
#' @importFrom shinyjs useShinyjs
#' @importFrom shinyjs html
#' @importFrom rlang .data
#' @importFrom dplyr group_by
#' @importFrom dplyr across
#' @importFrom dplyr summarise
#' @importFrom dplyr ungroup
#' @importFrom magrittr %>%
#'
#' @export
#'
#' @examples
#'
#' \dontrun{
#'
#' myApp()
#'
#' }
#'
myApp <- function() {

    ui <- fluidPage(

        titlePanel("curatedMeatgenomicDataCuration"),
        shinyjs::useShinyjs(),
        tabsetPanel(

            ## Starts code for get_metadata UI ####
            tabPanel(
                "Get metadata",
                h1("Get metadata"),
                textOutput("instructions_get_metadata"),
                textInput(
                    "SRP",
                    "Enter NCBI's SRP identifier, e.g., SRP145336",
                    placeholder = "SRP145336"
                ),
                fluidRow(
                    actionButton("get_metadata_click", "Get metadata"),
                    downloadButton("download_metadata")
                ),
                waiter::use_waiter(),
                h4(textOutput("text_output")),
                dataTableOutput("metadata")
            ),

            ## Starts code for checkCuration UI ####
            tabPanel(
                "Check curation",

                ## Section 1 - Upload file
                h1("Check curation"),
                textOutput("instructions_checkCuration"),
                h2("Upload metadata file"),
                fileInput(
                    "upload", NULL,
                    buttonLabel = "Upload...",
                    placeholder = "AsnicarF_2017_metadata.tsv",
                    accept = c("_metadata.tsv")
                ),
                waiter::use_waiter(),
                dataTableOutput("metadata_tsv"),

                ## Section 2 - Check
                h2("Check metadata file"),
                actionButton("check", label = "Check file"),
                waiter::use_waiter(),
                h4(textOutput("text_output_2")),
                verbatimTextOutput("report")
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
                paste0("Getting metadata for ", input$SRP), duration = 3
            )
            df <- get_metadata(input$SRP)
            df2 <- df %>%
                dplyr::group_by(dplyr::across(-.data[["SRRs"]])) %>%
                dplyr::summarise(
                    dplyr::across(.data[["SRRs"]], ~ paste0(.x, collapse = ";"))
                ) %>%
                dplyr::ungroup() %>%
                as.data.frame()
            df2 <- df2[, colnames(df)]
            df2
        })

        output$download_metadata <- downloadHandler(
            filename = function() {
                paste0(input$SRP, ".tsv")
            },
            content = function(file) {
                write.table(metadata(), file, sep = "\t", quote = TRUE)
            }
        )

        output$instructions_get_metadata <- renderText({
            .instructions_get_metadata()
        })

        output$text_output <- renderText(display_text())

        output$metadata <- renderDataTable({
            metadata()
        }, options = list(pageLength = 10))

        ## Starts code for checkCuration server ####

        metadata_file <- reactive({
            req(input$upload)
            waiter <- waiter::Waiter$new()
            waiter$show()
            on.exit(waiter$hide())
            showNotification(
                paste0("Uploading ", input$upload$name), duration = 3
            )
            fname <- input$upload$name
            if (!grepl("_metadata.tsv$", fname)) {
                validate(paste0(
                        "Invalid file name.",
                        " Please upload a tab separated file whose name ends",
                        " in *_metadata.tsv file."
                ))
            }
            tsv <- read.table(input$upload$datapath, sep = "\t", header = TRUE)
            tsv
        })

        display_text_2 <- eventReactive(input$check, {
            text <- paste0("Displaying report for ", input$upload$name)
            text
        })

        output$instructions_checkCuration <- renderText({
            .instructions_checkCuration()
        })

        output$metadata_tsv <- renderDataTable({
            metadata_file()
        }, options = list(pageLength = 10))

        output$text_output_2 <- renderText(display_text_2())

        ## https://stackoverflow.com/questions/30474538/possible-to-show-console-messages-written-with-message-in-a-shiny-ui
        observeEvent(input$check, {
            waiter <- waiter::Waiter$new()
            waiter$show()
            on.exit(waiter$hide())
            showNotification(
                paste0("Checking ", input$upload$name), duration = 3
            )
            withCallingHandlers({
                shinyjs::html("report", "")
                .curationReport(metadata_file())
            },
                message = function(m) {
                    shinyjs::html(id = "report", html = m$message, add = TRUE)
                })
        })

    }

    shinyApp(ui, server)
}
