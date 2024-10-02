source("global.r")
addResourcePath(prefix = 'www', directoryPath = './www')
steps <- read.csv("www/help.csv")

ui <- fluidPage(tags$html(class = "no-js", lang="en"),
                tags$link(rel = "stylesheet", type = "text/css", href = "style.css"),
                tags$head(
                   tags$title('NARS Data Download Tool | US EPA'),
                   includeHTML("www/header.html"),
                  # includeCSS("www/introjs.min.css"),
                  # includeScript("www/intro.min.js"),
                  # includeScript("www/app.js")
                ),
	####UI####
                theme = bs_theme(version = 3, bootswatch = "flatly"),
                useShinyjs(),
	        suppressWarnings(
                navbarPage(title = tagList(
                  
                  span("NARS Data Download Tool", style = "padding: 10px; font-weight: bold; font-size: 35px",
                                           actionLink("sidebar_button","", icon = icon("bars")))),
                           id = "navbar",
                           div(class="sidebar", 
                               sidebarPanel(
                                        #Survey Input
                                        fluidRow(
                                          column(10,
                                                 div(id="step3",
                                        selectInput(inputId = "Survey",
                                                    label = strong("Select Survey"),
                                                    choices = c("Lakes (NLA)"="nla", "Wetlands (NWCA)"="nwca",  
                                                                "Rivers and Streams (NRSA)"="nrsa", "Coastal (NCCA)"="ncca"),
                                                    selected = NULL,
                                                    multiple = FALSE, 
                                                    width = "350px") %>%
                                          #Survey helper
                                          helper(type = "inline",
                                                 icon = "circle-question",
                                                 title = "National Resource Surveys (NARS)",
                                                 content = c("The National Aquatic Resource Surveys (NARS) are statistical surveys designed to assess the status of and changes 
                                                             in quality of the nation’s coastal waters, lakes and reservoirs, rivers and streams, and wetlands.",
                                                             "<b>NRSA:</b> National Rivers and Streams Assessment",
                                                             "<b>NWCA:</b> National Wetland Condition Assessment",
                                                             "<b>NCCA:</b> National Coastal Condition Assessment",
                                                             "<b>NLA:</b> National Lakes Assessment"),
                                                 size = "s", easyClose = TRUE, fade = TRUE),
                                        #Survey Year Input
                                        selectInput(inputId = "Year",
                                                    label = strong("Select Survey Year"),
                                                    choices = "",
                                                    selected = NULL,
                                                    multiple = FALSE, 
                                                    width = "350px") %>%
                                          #Survey helper
                                          helper(type = "inline",
                                                 title = "NARS Survey Year",
                                                 icon = "circle-question",
                                                 content = c("The four National Aquatic Resource Surveys are conducted on a five-year cycle with the Streams 
                                                             and Rivers survey requiring two years to complete."),
                                                 size = "s", easyClose = TRUE, fade = TRUE)),
                                        conditionalPanel(
                                          condition = "input.Survey == 'ncca' & input.Year == '2015' | input.Year == '2020'",
                                          radioButtons(inputId = "NCCA_Type",
                                                       label = strong("Select Resource Type"),
                                                       choices = c("Estuarine"="estuarine", "Great Lakes"="great_lakes"),
                                                       selected = "estuarine",
                                                       inline=TRUE)),
                                        #Indicator Input
                                        div(id="step4",
                                        selectInput(inputId = "Indicator",
                                                    label = strong(HTML("Select NARS Dataset <br/> of Interest")),
                                                    choices = "",
                                                    selected = NULL,
                                                    multiple = FALSE, 
                                                    width = "350px") %>%
                                          #Indicator helper
                                          helper(type = "inline",
                                                 icon = "circle-question",
                                                 title = "Survey Indicators",
                                                 content = c("NARS collects data on key indicators of biological, chemical and physical condition. 
                                                             These indicators are used to assess ecological condition and to examine conditions 
                                                             that may negatively influence or affect stream condition (i.e. stressors).",
                                                             "Metadata for each NARS dataset file can be found by navigating to the Metadata tab. If 
                                                             downloading a dataset as a .xlsx file, metadata will be stored as seperate sheet."),
                                                 size = "s", easyClose = TRUE, fade = TRUE)),
                                      #State Input
                                       conditionalPanel(
                                        condition="input.navbar !== 'metadata'",
                                      div(id="step5",
                                        selectInput(inputId = "State",
                                                    label = strong("Select State(s) of Interest"),
                                                    choices = c("Choose State(s)"="", "All States", state_name),
                                                    selected = NULL,
                                                    multiple = TRUE, 
                                                    width = "350px")),
                                        #Site Information Input
                                        conditionalPanel(
                                          condition = "input.Indicator !== 'SiteInfo' &
                                                       input.Indicator !== 'site-information' &
                                                       input.Indicator !== 'site_information' &
                                                       input.Indicator !== 'siteinformation_wide' &
                                                       input.Indicator !== 'wide_siteinfo' &
                                                       input.Indicator !== 'siteinfo' &
                                                       input.Indicator !== 'siteinfo.revised.06212016' &
                                                       input.Indicator !== 'siteinfo_0' &
                                                       input.Indicator !== 'sampledlakeinformation_20091113' &
                                                       input.Indicator !== 'siteinformationdata' &
                                                       
                                                       input.Indicator !== 'condition_estimates' &
                                                       input.Indicator !== 'plant_taxa' &
                                                       input.Indicator !== 'plant_native_status' &
                                                       input.Indicator !== 'plant_cvalues' &
                                                       input.Indicator !== 'plant_wis' &
                                                       
                                                       input.Indicator !== 'planttaxa' &
                                                       input.Indicator !== 'plantnative' &
                                                       input.Indicator !== 'plantcval' &
                                                       input.Indicator !== 'plantwis' &
                                          
                                                       input.Indicator !== 'phytoplankton_taxa' &
                                                       input.Indicator !== 'landscape_wide_0' &
                                                       input.Indicator !== 'zooplankton-taxa-list' &
                                                       input.Indicator !== 'zooplanktontaxa' &
                                                       input.Indicator !== 'benthic_taxa_list' &
                                                       input.Indicator !== 'benthic_taxa' &
                                                       input.Indicator !== 'benttaxalist' &
                                                       input.Indicator !== 'condition_combined_2024-08-13_0' &
                                                       input.Indicator !== 'nla2007-2022_data_forpopestimates_indexvisits_probsites_0'
                                          ",                                       
                                                      
                                          div(id="step6",
                                          selectInput(inputId = "SiteInfo",
                                                      label = strong(HTML("Select Site Information <br/> to Add")),
                                                      choices = "",
                                                      selected = NULL,
                                                      multiple = TRUE, 
                                                      width = "350px") %>%
                                            #Site Information helper
                                            helper(type = "inline",
                                                   icon = "circle-question",
                                                   title = "Site Information",
                                                   content = c("Choose 'Site Information' to add to each dataset. Additional site information and metadata can be found by viewing the 
                                                               'Site Information' selection under the NARS Dataset of Interest dropdown. This information can be linked to other data files
                                                                using UID and/or UNIQUE_ID fields."),
                                                   size = "s", easyClose = TRUE, fade = TRUE)))),#end of siteinfo condPanel
                                        # Press button for analysis 
                                        actionButton("goButton", strong("Assemble/Update Dataset"), 
                                                     style = "background-color:#337ab7; font-weight: bold; font-size: 20px")
                           ))
                           )),#sidebarPanel
                           tabPanel(
                                  div(id="step1",
                                    icon('database',
                                         class = "help-icon fa-pull-left"),
                                    span('NARS Data',
                                         style = "font-weight: bold; 
                                                  font-size: 30px;
                                                  display: flex;
                                                  flex-wrap: wrap;")),
                                    value="narsdata",
                                    mainPanel(
                                      conditionalPanel(condition = 'output.table',
                                                       column(12, offset=2,
                                                              span(h2(textOutput("datatitle")))),
                                                       span(h3(strong("Export Data As:")), style = "color:#337ab7;"),
                                                       downloadButton("dwnldcsv", icon=NULL, "CSV", 
                                                                      style = "background-color:#337AB7;
                                                                               color:#FFFFFF;
                                                                               border-color:#BEBEBE;
                                                                               border-style:solid;
                                                                               border-width:1px;
                                                                               border-radius:2px;
                                                                               font-size:16px;"),
                                      downloadButton("dwnldexcel", icon=NULL, "XLSX", 
                                                     style = "background-color:#337AB7;
                                                                               color:#FFFFFF;
                                                                               border-color:#BEBEBE;
                                                                               border-style:solid;
                                                                               border-width:1px;
                                                                               border-radius:2px;
                                                                               font-size:16px;")),
                                      br(),
                                      DT::dataTableOutput("table"), style = "font-weight:bold; font-size:90%;")
                           ),#MetaData tabPanel
                           tabPanel(div(id="step2",
                                    icon('clipboard-question',
                                                class = "help-icon fa-pull-left"),
                                    span("Metadata",
                                    style = "font-weight: bold; 
                                                  font-size: 30px;
                                                  display: flex;
                                                  flex-wrap: wrap;")),
                                    value="metadata",
                                    mainPanel(
                                      conditionalPanel(condition = 'output.metatable',
                                                       column(12, offset=2,
                                                              span(h2(textOutput("datatitlemeta")))),
                                                    span(h3(strong("Export Data As:")), style = "color:#337ab7")),
                                      DT::dataTableOutput("metatable"))
                           ),#About tabPanel
                           tabPanel(
                              div(id="step7",
                                    icon('message',
                                         class = "help-icon fa-pull-left",
                                         style = "padding-left: 100px;"),
                                    verify_fa = FALSE,
                                    span("About",
                                         style = "font-weight: bold; 
                                                  font-size: 30px; 
                                                  font-style:italic;
                                                  display: flex;
                                                  flex-wrap: wrap;")),
                              value="about",
                              class="about"
                                    )#About tabPanel
                 )#navbar
	        )#suppressWarnings
	# Footer
	,includeHTML("www/footer.html")
)#fluidPage


server <-function(input, output, session) {
  observe_helpers()
  
#  session$sendCustomMessage(type = 'setHelpContent', message = list(steps = toJSON(steps)))

  # myObserver <- observe({
  #   session$sendCustomMessage(type = 'startHelp', message = list(""))
  # })

  shinyalert("NARS Data Download Tool",
             imageUrl ='www/NARS_logo_sm.jpg',
             paste("Use the dropdown menus to explore available datasets collected in the", 
                   a(href="https://www.epa.gov/national-aquatic-resource-surveys/data-national-aquatic-resource-surveys", "National Aquatic Resource Surveys (NARS).", target="_blank"),
                   "Users have the option to filter the data by state(s) of interest and join site information to selected datasets.Metadata for each NARS dataset file can be found by navigating to the Metadata tab at the top of the page.",
                   br(), br(),
                   "Users of the data are encouraged to review the", 
                   a(href="https://www.epa.gov/national-aquatic-resource-surveys/manuals-used-national-aquatic-resource-surveys", "Technical Reports, Field and Laboratory Manuals, and metadata files", target="_blank"),
                   "to understand the types of data available and how they were collected or measured. Users are also encouraged to read 
                     and leverage the EPA survey reports developed from these data that highlight national and regional assessments."),
             closeOnClickOutside = TRUE,
             imageWidth = '300',
             imageHeight = '300',
             html = TRUE
  )
  
  observe({
    if(req(input$navbar=="about")){
      shinyalert("NARS Data Download Tool",
                 imageUrl ='www/NARS_logo_sm.jpg',
                 paste("Use the dropdown menus to explore available datasets collected in the", 
                     a(href="https://www.epa.gov/national-aquatic-resource-surveys/data-national-aquatic-resource-surveys", "National Aquatic Resource Surveys (NARS).", target="_blank"),
                     "Users have the option to filter the data by state(s) of interest and join site information to selected datasets.Metadata for each NARS dataset file can be found by navigating to the Metadata tab at the top of the page.",
                     br(), br(),
                     "Users of the data are encouraged to review the", 
                     a(href="https://www.epa.gov/national-aquatic-resource-surveys/manuals-used-national-aquatic-resource-surveys", "Technical Reports, Field and Laboratory Manuals, and metadata files", target="_blank"),
                     "to understand the types of data available and how they were collected or measured. Users are also encouraged to read 
                     and leverage the EPA survey reports developed from these data that highlight national and regional assessments."),
               closeOnClickOutside = TRUE,
               imageWidth = '300',
               imageHeight = '300',
               html = TRUE
      )
      
      updateNavbarPage(session, "navbar",
                       selected = "narsdata")
    }
  })
  
  
  
  observeEvent(input$sidebar_button,{
    shinyjs::toggle(selector = ".sidebar")
    js_maintab <- paste0('$(".tab-pane div[role=',"'main'",']")')
    
    if((input$sidebar_button %% 2) != 0) {
      runjs(paste0('
          width_percent = parseFloat(',js_maintab,'.css("width")) / parseFloat(',js_maintab,'.parent().css("width"));
            ',js_maintab,'.css("width","100%");
          '))
    } else {
      runjs(paste0('
          width_percent = parseFloat(',js_maintab,'.css("width")) / parseFloat(',js_maintab,'.parent().css("width"));
            ',js_maintab,'.css("width","");
          '))
    }
  })
  
  ## Data Title ----
  datatitle <- eventReactive(input$goButton, {
    dataset <- eval(parse(text = paste0("dataset", input$Year)))
    paste0("Dataset: ", toupper(input$Survey), input$Year,"_", names(dataset)[dataset == input$Indicator])
  })
  
  output$datatitle <- renderText({
    datatitle()
  })
  
  output$datatitlemeta <- renderText({
    datatitle()
  })
  ## Year Choices ----
  observeEvent(input$Survey,{
    if(input$Survey == "nla") {
      updateSelectInput(session, "Year", selected = NULL, choices = c("2022", "2017", "2012", "2007"))
    }
    if(input$Survey == "nwca") {
      updateSelectInput(session, "Year", selected = NULL, choices = c("2021", "2016", "2011"))
    }
    if(input$Survey == "ncca") {
      updateSelectInput(session, "Year", selected = NULL, choices = c("2015", "2010", "1999-2001/2005-2006"="0506"))
    }
    if(input$Survey == "nrsa") {
      updateSelectInput(session, "Year", selected = NULL, choices = c("2018/2019"="1819", "2013/2014"="1314", "2008/2009"="0809"))
    }
  })
  
  
  ## State Observers ----
  #Change to All States when certain datasets are called
  observe({
    #req("All States" %in% input$State) 
    req("All States" %in% input$State | input$Indicator %in% RemoveState)
    updateSelectInput(session, "State", selected = "All States", 
                      choices = c("All States"))
  })
  
 ## NCCA State Choices ----
  #This observer will update state selection after All States has been Removed.
 observe({
    req(is.null(input$State))
    
      updateSelectInput(session, "State",
                        choices = c("Select State(s)"="", "All States", state_name))
  })
  
  #This observer will update state selection for NCCA surveys.
  observeEvent(c(input$Survey, input$Year, input$NCCA_Type, input$Indicator), {
    req(input$Survey == "ncca")
    
    # if(input$NCCA_Type == "estuarine" & input$Year == "2020"){
    #   updateSelectInput(session, "State",  
    #                     choices = list("Select State(s)"="", 
    #                                    "All States",
    #                                    `States`=c("Alabama"="AL","California"="CA","Connecticut"="CT","Delaware"="DE","Florida"="FL","Georgia"="GA","Hawaii"="HI","Louisiana"="LA","Massachusettes"="MA","Maryland"="MD","Maine"="ME","Mississippi"="MS",
    #                                               "North Carolina"="NC","New Hampshire"="NH","New Jersey"="NJ","New York"="NY","Oregon"="OR","Rhode Island"="RI","South Carolina"="SC","Texas"="TX","Virginia"="VA","Washington"="WA"),
    #                                    `Territories`=c("American Samoa"="AS","Guam"="GU","Northern Mariana Islands"="MP")))
    #   updateSelectInput(session, "SiteInfo", 
    #                     choices = c("Optional"="", site2020est))
    # }
    # if(input$NCCA_Type == "great_lakes" & input$Year == "2020"){
    #   updateSelectInput(session, "State",
    #                     choices = list("Select State(s)"="", 
    #                                    "All States",
    #                                    `States`=c("Indiana"="IN","Illinois"="IL","Michigan"="MI","Minnesota"="MN","New York"="NY","Ohio"="OH","Pennsylvania"="PA","Wisconsin"="WI")))
    #   updateSelectInput(session, "SiteInfo", 
    #                     choices = c("Optional"="", site2020gl))
    # }
    if(input$NCCA_Type == "estuarine" & input$Year == "2015"){
      updateSelectInput(session, "State",  
                        choices = list("Select State(s)"="", 
                                       "All States",
                                       `States`=c("Alabama"="AL","California"="CA","Connecticut"="CT","Delaware"="DE","Florida"="FL","Georgia"="GA","Hawaii"="HI","Louisiana"="LA","Massachusettes"="MA","Maryland"="MD","Maine"="ME","Mississippi"="MS",
                                                  "North Carolina"="NC","New Hampshire"="NH","New Jersey"="NJ","New York"="NY","Oregon"="OR","Rhode Island"="RI","South Carolina"="SC","Texas"="TX","Virginia"="VA","Washington"="WA"),
                                       `Territories`=c("American Samoa"="AS","Guam"="GU","Northern Mariana Islands"="MP")))
      updateSelectInput(session, "SiteInfo", 
                        choices = c("Optional"="", site2015est))
    }
    if(input$NCCA_Type == "great_lakes" & input$Year == "2015"){
      updateSelectInput(session, "State",
                        choices = list("Select State(s)"="", 
                                       "All States",
                                       `States`=c("Indiana"="IN","Illinois"="IL","Michigan"="MI","Minnesota"="MN","New York"="NY","Ohio"="OH","Pennsylvania"="PA","Wisconsin"="WI")))
      updateSelectInput(session, "SiteInfo", 
                        choices = c("Optional"="", site2015gl))
    }
    if(input$Year == "0506" || input$Year == "2010" & input$Indicator %!in% c("pbde","fatty-acids","mercury","pcb","pfas")){
      updateSelectInput(session, "State",
                        choices = c("Choose State(s)"="", "All States", state_name))
    }
    if(input$Year == "2010" & input$Indicator %in% c("pbde","fatty-acids","mercury","pcb","pfas")){
      updateSelectInput(session, "State",
                        choices = list("Select State(s)"="", 
                                       "All States",
                                       `States`=c("Indiana"="IN","Illinois"="IL","Michigan"="MI","Minnesota"="MN","New York"="NY","Ohio"="OH","Pennsylvania"="PA","Wisconsin"="WI")))
    }
  })
  
  
  ## Indicator Choices ----
  observeEvent(c(input$Year,input$NCCA_Type), {
    req(input$Year)
    
    
      if(input$Year == "2015"){
        choices <- eval(parse(text = paste0("choices", input$Year, input$NCCA_Type)))
      } else {
        choices <- eval(parse(text = paste0("choices", input$Year)))
      }
      updateSelectInput(session, "Indicator", 
                        choices = choices)
      
      #Siteinfo update for NCCA is above (this operator works because of the !=)
      if(input$Year != "2020" & input$Year != "2015") {
      site <- eval(parse(text = paste0("site", input$Year)))
      updateSelectInput(session, "SiteInfo", 
                        choices = c("Optional"="", site))
      }
  })
  
  
  ## Data Extract ----
  Data <- eventReactive(input$goButton, {
    
    shiny::validate(
    need(input$State != "", 'Select State(s) of Interest!'))

    show_modal_spinner(spin = 'flower', text = 'Assembling Dataset.')
   ### 2022----
    if(input$Survey == "nla" & input$Year == "2022") {
      if(input$Indicator == "nla2007-2022_data_forpopestimates_indexvisits_probsites_0") {
          Data <- read.csv('https://www.epa.gov/system/files/other-files/2024-08/nla2007-2022_data_forpopestimates_indexvisits_probsites_0.csv')
        } else if(input$Indicator %in% c("profile_wide","phab_wide","phabmets_wide_0","sample_grid","landscape_wide_0")){
          Data <- read.csv(paste0('https://www.epa.gov/system/files/other-files/2024-08/nla2022_',input$Indicator,'.csv'))
        } else if(input$Indicator %in% c("mercury","pcb")){
          Data <- read.xlsx(paste0('https://www.epa.gov/system/files/documents/2024-08/final-nla-2022-',input$Indicator,'-public-release-file-7-24-24.xlsx'))
        } else if(input$Indicator %in% c("lipid")){
          Data <- read.xlsx('https://www.epa.gov/system/files/documents/2024-08/final-nla-2022-lipid-public-release-file-7-31-2024.xlsx')
        } else if(input$Indicator %in% c("pfas")){
          Data <- read.xlsx('https://www.epa.gov/system/files/documents/2024-08/final-nla-2022-pfas-public-release-file-8-19-24_0.xlsx')
        } else {
          Data <- read.csv(paste0('https://www.epa.gov/system/files/other-files/2024-08/nla22_',input$Indicator,'.csv'))
        }
      
      if(length(input$State) > 1 || input$State != "All States") {
        if("PSTL_CODE" %in% colnames(Data)) {
          Data <- Data %>%
            filter(PSTL_CODE %in% input$State)
        } else if("STATE" %in% colnames(Data)){
          Data <- Data %>%
            filter(STATE %in% input$State)
        } else if("State" %in% colnames(Data)){
          Data <- Data %>%
            filter(State %in% input$State)
        } else if(input$Indicator %in% RemoveState){ 
          Data <- Data
        } else{
          siteinfo2022 <- read.csv(paste0('https://www.epa.gov/system/files/other-files/2024-08/nla22_siteinfo.csv')) %>% 
            select(UID, SITE_ID, VISIT_NO, PSTL_CODE)
          Data <- left_join(Data, siteinfo2022) %>%
            filter(PSTL_CODE %in% input$State) %>% relocate(PSTL_CODE, .after = VISIT_NO)
        }
      }
      # Only for fish tissue 
      if(input$Indicator %in% c("mercury", "lipid","pcb","pfas")) {
        siteinfo <- read.csv(paste0('https://www.epa.gov/system/files/other-files/2024-08/nla22_siteinfo.csv')) %>%
          filter(SITESAMP=="YES") %>%
          filter(VISIT_NO=="1" | VISIT_NO==1) %>%
          select(Site.ID=SITE_ID, LAT_DD83, LON_DD83, input$SiteInfo)
        Data <- left_join(Data, siteinfo) %>% relocate(LAT_DD83, LON_DD83, input$SiteInfo, .after = Site.ID)
      }
      
      if(input$Indicator %!in% c("site_information", "benthic_taxa", "zooplanktontaxa", "condition_combined_2024-08-13_0", "nla2007-2022_data_forpopestimates_indexvisits_probsites_0", "sample_grid","mercury", "lipid","pcb","pfas","landscape_wide_0")) {
        siteinfo <- read.csv(paste0('https://www.epa.gov/system/files/other-files/2024-08/nla22_siteinfo.csv')) %>%
          filter(SITESAMP=="YES") %>%
          select(UID, SITE_ID, PSTL_CODE, LAT_DD83, LON_DD83, input$SiteInfo) %>%
          filter(!(is.na(UID)))
        if("WGT_TP_CORE_NLA" %in% input$SiteInfo || "WGT_TP_NES" %in% input$SiteInfo){
          if(length(input$State) > 1 || input$State != "All States") {
            Data <- full_join(Data, siteinfo) %>% relocate(PSTL_CODE, LAT_DD83, LON_DD83, input$SiteInfo, .after = VISIT_NO) %>%
              filter(PSTL_CODE %in% input$State)
          } else {
            Data <- full_join(Data, siteinfo) %>% relocate(PSTL_CODE, LAT_DD83, LON_DD83, input$SiteInfo, .after = VISIT_NO)
          }
        } else {
          Data <- left_join(Data, siteinfo) %>% relocate(PSTL_CODE, LAT_DD83, LON_DD83, input$SiteInfo, .after = VISIT_NO)
        }
      }
    }
    
    ### 2021----
    if(input$Survey == "nwca" & input$Year == "2021"){
      
      Data <- read.csv(paste0('https://www.epa.gov/system/files/other-files/2024-05/nwca21_',input$Indicator,'-data.csv'))
      
      if(length(input$State) > 1 || input$State != "All States") {
        if("PSTL_CODE" %in% colnames(Data)) {
          Data <- Data %>%
            filter(PSTL_CODE %in% input$State)
        } else if(input$Indicator %in% c("plant_taxa", "plant_native_status", "plant_cvalues", "plant_wis")) { 
          Data <- Data
        } else{
          Data <- Data %>%
            filter(STATE %in% input$State)
        }
      }
      if(input$Indicator %!in% c("siteinfo", "plantcval", "planttaxa", "plantwis", "plantnative")) {
        siteinfo <- read.csv(paste0('https://www.epa.gov/system/files/other-files/2024-05/nwca21_siteinfo-data.csv')) %>%
          select(UID, SITE_ID, PSTL_CODE, LAT_ANALYS, LON_ANALYS, input$SiteInfo) %>%
          filter(!(is.na(UID)))
        if("WGT_TP_CORE" %in% input$SiteInfo){
          if(length(input$State) > 1 || input$State != "All States") {
            Data <- full_join(Data, siteinfo) %>% relocate(PSTL_CODE, LAT_ANALYS, LON_ANALYS, input$SiteInfo, .after = VISIT_NO) %>%
              filter(PSTL_CODE %in% input$State)
          } else {
            Data <- full_join(Data, siteinfo) %>% relocate(PSTL_CODE, LAT_ANALYS, LON_ANALYS, input$SiteInfo, .after = VISIT_NO)
          }
        } else {
          Data <- left_join(Data, siteinfo) %>% relocate(PSTL_CODE, LAT_ANALYS, LON_ANALYS, input$SiteInfo, .after = VISIT_NO)
        }
      }
    }
    
   ### 2018/19----
    if(input$Survey == "nrsa" & input$Year == "1819") {
      if(input$Indicator == "SiteInfo") {
          Data <- read.csv('https://www.epa.gov/system/files/other-files/2023-01/NRSA_1819_SiteInfo.csv')
        } else if(input$Indicator %in% c("fish-sampling-information", "fish-count", "fish-metrics")) {
          Data <- read.csv(paste0('https://www.epa.gov/system/files/other-files/2022-03/nrsa-1819-',input$Indicator,'-data.csv'))
        } else if(input$Indicator %in% c("pbio_0", "PeriChla", "landscape", "enterococci_0")){
          Data <- read.csv(paste0('https://www.epa.gov/system/files/other-files/2023-01/NRSA_1819_',input$Indicator,'.csv'))
        } else if(input$Indicator == "field_wide"){
          colnames <- c("UID", colnames(read.csv('https://www.epa.gov/system/files/other-files/2023-01/NRSA_1819_field_wide.csv', col_select = -c(1:2))))
          Data <- read.csv('https://www.epa.gov/system/files/other-files/2023-01/NRSA_1819_field_wide.csv', col_select = -c(1), skip = 1)
          names(Data) <- colnames
        } else if(input$Indicator %in% c("mercury","pcb","pfas")){
          Data <- read.xlsx(paste0('https://www.epa.gov/system/files/documents/2023-01/',input$Indicator,'-data-2018.xlsx'))
        } else {
          Data <- read.csv(paste0('https://www.epa.gov/sites/production/files/2021-04/',input$Survey,'_', input$Year,'_',input$Indicator,'_-_data.csv'))
        }
      
      
      if(length(input$State) > 1 || input$State != "All States") {
        if("PSTL_CODE" %in% colnames(Data)) {
          Data <- Data %>%
            filter(PSTL_CODE %in% input$State)
        } else if("STATE" %in% colnames(Data)){
          Data <- Data %>%
            filter(STATE %in% input$State)
        } else if("State" %in% colnames(Data)){
          Data <- Data %>%
            filter(State %in% input$State)
        } else{
          siteinfo1819 <- read.csv(paste0('https://www.epa.gov/system/files/other-files/2023-01/NRSA_1819_SiteInfo.csv')) %>% 
            select(UID, SITE_ID, VISIT_NO, PSTL_CODE)
          Data <- left_join(Data, siteinfo1819) %>%
            filter(PSTL_CODE %in% input$State) %>% relocate(PSTL_CODE, .after = VISIT_NO)
        }
      }
      
      # Only for fish tissue 
      if(input$Indicator %in% c("mercury", "pcb","pfas")) {
        siteinfo <- read.csv(paste0('https://www.epa.gov/system/files/other-files/2023-01/NRSA_1819_SiteInfo.csv')) %>%
          filter(VISIT_NO=="1" | VISIT_NO==1) %>%
          select(Site.ID=SITE_ID, input$SiteInfo)
        Data <- left_join(Data, siteinfo) %>% relocate(input$SiteInfo, .after = Site.ID)
      }
      
      if(input$Indicator %!in% c("SiteInfo", "mercury", "pcb","pfas")) {
        if(input$Indicator == "landscape"){
          siteinfo <- read.csv(paste0('https://www.epa.gov/system/files/other-files/2023-01/NRSA_1819_SiteInfo.csv')) %>%
            select(SITE_ID, LAT_DD83, LON_DD83, input$SiteInfo) %>% unique()
          Data <- left_join(Data, siteinfo) %>% relocate(LAT_DD83, LON_DD83, input$SiteInfo, .after = SITE_ID)
        } else if("WGT_TP_CORE" %in% input$SiteInfo){
          siteinfo <- read.csv(paste0('https://www.epa.gov/system/files/other-files/2023-01/NRSA_1819_SiteInfo.csv')) %>%
            select(UID, SITE_ID, PSTL_CODE, LAT_DD83, LON_DD83, input$SiteInfo) %>%
            filter(!(is.na(UID)))
          if(length(input$State) > 1 || input$State != "All States") {
            Data <- full_join(Data, siteinfo) %>% relocate(PSTL_CODE, LAT_DD83, LON_DD83, input$SiteInfo, .after = VISIT_NO) %>%
              filter(PSTL_CODE %in% input$State)
          } else {
            Data <- full_join(Data, siteinfo) %>% relocate(PSTL_CODE, LAT_DD83, LON_DD83, input$SiteInfo, .after = VISIT_NO)
          }
        } else{
          siteinfo <- read.csv(paste0('https://www.epa.gov/system/files/other-files/2023-01/NRSA_1819_SiteInfo.csv')) %>%
            select(UID, LAT_DD83, LON_DD83, input$SiteInfo) %>%
            filter(!(is.na(UID)))
          Data <- left_join(Data, siteinfo) %>% relocate(PSTL_CODE, LAT_DD83, LON_DD83, input$SiteInfo, .after = VISIT_NO)
        }
      }
    }
    
    ### 2017----
    if(input$Survey == "nla" & input$Year == "2017") {
      if(input$Indicator == "zooplankton-count") {
        Data <- read.csv(paste0('https://www.epa.gov/system/files/other-files/2021-12/',input$Survey,'-',input$Year,'-',input$Indicator,'-data.csv'))
      } else if (input$Indicator %in% c("zooplankton-raw-count","zooplankton-metrics","zooplankton-taxa-list")) {
        Data <- read.csv(paste0('https://www.epa.gov/system/files/other-files/2021-12/',input$Survey,'-',input$Year,'-',input$Indicator,'-data-updated-12092021.csv'))
      } else if (input$Indicator %in% c("landMets")) {
        Data <- read.csv(paste0("https://www.epa.gov/system/files/other-files/2022-07/",input$Survey,input$Year,'_',input$Indicator,".csv"))
      } else if (input$Indicator == "condition_estimates") {
        Data <- read.csv("https://www.epa.gov/system/files/other-files/2022-07/nla2017_condition_estimates_20220217_ForWebsite.csv")
      } else if (input$Indicator == "data_for_population_estimates") {
        Data <- read.csv("https://www.epa.gov/system/files/other-files/2022-07/nla2017_all_sites-visits_data_for_population_estimates_220705_0.csv")
      } else {
        Data <- read.csv(paste0('https://www.epa.gov/sites/production/files/2021-04/',input$Survey,'_',input$Year,'_',input$Indicator,'-data.csv'))
      } 
      if(length(input$State) > 1 || input$State != "All States") {
        if("PSTL_CODE" %in% colnames(Data)) {
          Data <- Data %>%
            filter(PSTL_CODE %in% input$State)
        } else if("STATE" %in% colnames(Data)){
          Data <- Data %>%
            filter(STATE %in% input$State)
        } else if(input$Indicator %in% c("benthic_taxa_list","phytoplankton_taxa","zooplankton-taxa-list", "condition_estimates")){ 
          Data <- Data
        } else{
          siteinfo2017 <- read.csv(paste0('https://www.epa.gov/sites/production/files/2021-04/nla_2017_site_information-data.csv')) %>% 
            select(UID, SITE_ID, VISIT_NO, PSTL_CODE)
          Data <- left_join(Data, siteinfo2017) %>%
            filter(PSTL_CODE %in% input$State) %>% relocate(PSTL_CODE, .after = VISIT_NO)
        }
      }
      if(input$Indicator %!in% c("site_information", "benthic_taxa_list", "phytoplankton_taxa","zooplankton-taxa-list", "condition_estimates")) {
        siteinfo <- read.csv(paste0('https://www.epa.gov/sites/production/files/2021-04/nla_2017_site_information-data.csv')) %>%
          filter(SITESAMP=="Y") %>%
          select(UID, SITE_ID, PSTL_CODE, LAT_DD83, LON_DD83, input$SiteInfo) %>%
          filter(!(is.na(UID)))
        if("WGT_TP_CORE" %in% input$SiteInfo){
          if(length(input$State) > 1 || input$State != "All States") {
            Data <- full_join(Data, siteinfo) %>% relocate(PSTL_CODE, LAT_DD83, LON_DD83, input$SiteInfo, .after = VISIT_NO) %>%
              filter(PSTL_CODE %in% input$State)
          } else {
            Data <- full_join(Data, siteinfo) %>% relocate(PSTL_CODE, LAT_DD83, LON_DD83, input$SiteInfo, .after = VISIT_NO)
          }
        } else {
          Data <- left_join(Data, siteinfo) %>% relocate(PSTL_CODE, LAT_DD83, LON_DD83, input$SiteInfo, .after = VISIT_NO)
        }
      }
    }
   
    ### 2016----
    if(input$Survey == "nwca" & input$Year == "2016"){
      
      if(input$Indicator == "site-information") {
        Data <- read.csv("https://www.epa.gov/system/files/other-files/2022-04/nwca-2016-site-information-data_0.csv")
      } else if (input$Indicator == "plant-species-cover-height") {
        Data <- read.csv("https://www.epa.gov/system/files/other-files/2022-04/nwca-2016-plant-species-cover-height-data.csv")
      } else if (input$Indicator %in% c("plant_cvalues", "plant_taxa", "plant_wis", "plant_native_status")) {   
        Data <- read.csv(paste0('https://www.epa.gov/system/files/other-files/2023-03/nwca_2016_',input$Indicator,'.csv'))
      } else if (input$Indicator == "condition_estimates") {    
        Data <- read.csv("https://www.epa.gov/system/files/other-files/2023-04/nwca_2016_condition_estimates.csv")
      } else if (input$Indicator %in% c("aa_characterization")) {  
        Data <- read.csv(paste0('https://www.epa.gov/system/files/other-files/2023-03/nwca16_',input$Indicator,'_data.csv'))
      } else if (input$Indicator %in% c("vegetation_type", "ground_surface")) {  
        Data <- read.csv(paste0('https://www.epa.gov/system/files/other-files/2023-03/nwca_2016_',input$Indicator,'_data.csv'))
      } else if (input$Indicator %in% c("veg_mmi", "landscape_metrics", "plant_taxa")) {  
        Data <- read.csv(paste0('https://www.epa.gov/system/files/other-files/2023-03/nwca_2016_',input$Indicator,'.csv'))  
      } else if (input$Indicator %in% c("cond_stress", "2011_data_for_population_estimates")) {  
        Data <- read.csv(paste0('https://www.epa.gov/system/files/other-files/2023-04/nwca_2016_',input$Indicator,'.csv')) 
      } else {
        Data <- read.csv(paste0('https://www.epa.gov/sites/production/files/2021-04/',input$Survey,'_',input$Year,'_',input$Indicator,'_-_data_csv.csv'))
      }
      
      if(length(input$State) > 1 || input$State != "All States") {
        if("PSTL_CODE" %in% colnames(Data)) {
          Data <- Data %>%
            filter(PSTL_CODE %in% input$State)
        } else if (input$Indicator %in% c("plant_taxa", "plant_native_status", "plant_cvalues", "plant_wis", "condition_estimates")) { 
          Data <- Data
        } else{
          Data <- Data %>%
            filter(STATE %in% input$State)
        }
      }
      if(input$Indicator %!in% c("site-information", "plant_cvalues", "plant_taxa", "plant_wis", "plant_native_status", "condition_estimates")) {
        siteinfo <- read.csv(paste0('https://www.epa.gov/system/files/other-files/2022-04/nwca-2016-site-information-data_0.csv')) %>%
          select(UID, SITE_ID, PSTL_CODE, LAT_ANALYS, LON_ANALYS, input$SiteInfo) %>%
          filter(!(is.na(UID)))
        if("WGT_TP_CORE" %in% input$SiteInfo){
          if(length(input$State) > 1 || input$State != "All States") {
            Data <- full_join(Data, siteinfo) %>% relocate(PSTL_CODE, LAT_ANALYS, LON_ANALYS, input$SiteInfo, .after = VISIT_NO) %>%
              filter(PSTL_CODE %in% input$State)
          } else {
            Data <- full_join(Data, siteinfo) %>% relocate(PSTL_CODE, LAT_ANALYS, LON_ANALYS, input$SiteInfo, .after = VISIT_NO)
          }
        } else {
          Data <- left_join(Data, siteinfo) %>% relocate(PSTL_CODE, LAT_ANALYS, LON_ANALYS, input$SiteInfo, .after = VISIT_NO)
        }
      }
    }
    
    ### 2015----
    if(input$Survey == "ncca" & input$Year == "2015") {
      if(input$Indicator == "ecological-fish-tissue-contaminants-fish-collection" & input$NCCA_Type == "estuarine"){
        Data <- read.csv(paste0('https://www.epa.gov/system/files/other-files/2021-08/ncca-2015-ecological-fish-tissue-contaminants-fish-collection-estuarine-data.csv'))
      } else if(input$Indicator == "ecological-fish-tissue-contaminants-fish-collection" & input$NCCA_Type == "great_lakes"){
        Data <- read.csv(paste0('https://www.epa.gov/system/files/other-files/2021-08/ncca-2015-ecological-fish-tissue-contaminants-fish-collection-great-lakes-data.csv'))
      } else if(input$Indicator %in% c("dioxin-furan","fatty-acids","mercury","pcb","pfas")){
        Data <- read.xlsx(paste0('https://www.epa.gov/system/files/documents/2021-10/glhhffts-',input$Indicator,'-data-2015.xlsx'))  
      } else {
        Data <- read.csv(paste0('https://www.epa.gov/sites/production/files/2021-04/',input$Survey,'_',input$Year,'_',input$Indicator,'_',input$NCCA_Type,'-data.csv')) %>% 
                           filter(!grepl('(blank)', UID)) %>% mutate(UID=as.numeric(UID))
      }
      
      if(length(input$State) > 1 || input$State != "All States") {
        if("PSTL_CODE" %in% colnames(Data)) {
          Data <- Data %>%
            filter(PSTL_CODE %in% input$State)
        } else if("State" %in% colnames(Data)){
          Data <- Data %>%
            filter(State %in% input$State)
        } else{
          Data <- Data %>%
            filter(STATE %in% input$State)
        }
      }
      
      # Only for fish tissue 
      if(input$Indicator %in% c("dioxin-furan","fatty-acids","mercury","pcb","pfas") & input$NCCA_Type == "great_lakes") {
        siteinfo <- read.csv(paste0('https://www.epa.gov/sites/default/files/2021-04/ncca_2015_site_information_great_lakes-data.csv')) %>%
          filter(VISIT_NO=="1" | VISIT_NO==1) %>%
          select(Site.ID=SITE_ID, input$SiteInfo)
        Data <- left_join(Data, siteinfo) %>% relocate(input$SiteInfo, .after = Site.ID)
      }
      
      if(input$Indicator != "site_information" & input$NCCA_Type == "estuarine") {
        siteinfo <- read.csv(paste0('https://www.epa.gov/sites/default/files/2021-04/ncca_2015_site_information_estuarine-data.csv')) %>%
          select(UID, SITE_ID, PSTL_CODE, LAT_DD83, LON_DD83, input$SiteInfo) %>%
          filter(!(is.na(UID)))
        if("WGT_SP" %in% input$SiteInfo){
          if(length(input$State) > 1 || input$State != "All States") {
            Data <- full_join(Data, siteinfo) %>% relocate(PSTL_CODE, LAT_DD83, LON_DD83, input$SiteInfo, .after = VISIT_NO) %>%
              filter(PSTL_CODE %in% input$State)
          } else {
            Data <- full_join(Data, siteinfo) %>% relocate(PSTL_CODE, LAT_DD83, LON_DD83, input$SiteInfo, .after = VISIT_NO)
          }
        } else {
          Data <- left_join(Data, siteinfo) %>% relocate(LAT_DD83, LON_DD83, input$SiteInfo, .after = VISIT_NO)
        }
      }
      if(input$Indicator %!in% c("site_information","dioxin-furan","fatty-acids","mercury","pcb","pfas") & input$NCCA_Type == "great_lakes") {
        siteinfo <- read.csv(paste0('https://www.epa.gov/sites/default/files/2021-04/ncca_2015_site_information_great_lakes-data.csv')) %>%
          select(UID, SITE_ID, PSTL_CODE, LAT_DD83, LON_DD83, input$SiteInfo) %>%
          filter(!(is.na(UID)))
        if("WGT_SP" %in% input$SiteInfo){
          if(length(input$State) > 1 || input$State != "All States") {
            Data <- full_join(Data, siteinfo) %>% relocate(PSTL_CODE, LAT_DD83, LON_DD83, input$SiteInfo, .after = VISIT_NO) %>%
              filter(PSTL_CODE %in% input$State)
          } else {
            Data <- full_join(Data, siteinfo) %>% relocate(PSTL_CODE, LAT_DD83, LON_DD83, input$SiteInfo, .after = VISIT_NO)
          }
        } else {
          Data <- left_join(Data, siteinfo) %>% relocate(PSTL_CODE, LAT_DD83, LON_DD83, input$SiteInfo, .after = VISIT_NO)
        }
      }
    }
    
    ### 2013/14----
    if(input$Survey == "nrsa" & input$Year == "1314") {
      if(input$Indicator %in% c("micx", "bentmmi", "bentcnts", "widepchl", "widepbio", "widewchl", "ente", "wide_field_meas", 
                                "fishmmi", "fishcts", "fishmet", "phabmed", "widechem", "chem")) {
        Data <- read.csv(paste0('https://www.epa.gov/sites/production/files/2019-04/',input$Survey, input$Year,'_',input$Indicator,'_04232019.csv'))
      }
      if(input$Indicator == "bentmet") {
        Data <- read.csv(paste0('https://www.epa.gov/sites/production/files/2019-04/',input$Survey, input$Year,'_',input$Indicator,'_02132019.csv'))
      }
      if(input$Indicator %in% c("fishplug_hg", "siteinformation_wide")) {
        Data <- read.csv(paste0('https://www.epa.gov/sites/production/files/2019-04/',input$Survey, input$Year,'_',input$Indicator,'_04292019.csv'))
      }
      if(input$Indicator %in% c("key_var")) {
        Data <- read.csv(paste0('https://www.epa.gov/sites/default/files/2019-05/nrsa1314_allcond_05312019_0.csv'))
      }
      if(length(input$State) > 1 || input$State != "All States") {
        if("PSTL_CODE" %in% colnames(Data)) {
          Data <- Data %>%
            filter(PSTL_CODE %in% input$State)
        } else if("STATE" %in% colnames(Data)){
          Data <- Data %>%
            filter(STATE %in% input$State)
        } else{
          siteinfo1314 <- read.csv('https://www.epa.gov/sites/production/files/2019-04/nrsa1314_siteinformation_wide_04292019.csv') %>% 
            select(UID, SITE_ID, VISIT_NO, STATE)
          Data <- left_join(Data, siteinfo1314) %>%
            filter(STATE %in% input$State) %>% relocate(STATE, .after = VISIT_NO)
        }
      }
      if(input$Indicator != "siteinformation_wide") {
        siteinfo <- read.csv(paste0('https://www.epa.gov/sites/production/files/2019-04/nrsa1314_siteinformation_wide_04292019.csv')) %>%
          select(UID, SITE_ID, PSTL_CODE, LAT_DD83, LON_DD83, input$SiteInfo) %>%
          filter(!(is.na(UID)))
        if("WGT_EXT_SP" %in% input$SiteInfo){
          if(length(input$State) > 1 || input$State != "All States") {
            Data <- full_join(Data, siteinfo) %>% relocate(PSTL_CODE, LAT_DD83, LON_DD83, input$SiteInfo, .after = VISIT_NO)
          } else {
            Data <- full_join(Data, siteinfo) %>% relocate(PSTL_CODE, LAT_DD83, LON_DD83, input$SiteInfo, .after = VISIT_NO)
          }
        } else {
          Data <- left_join(Data, siteinfo) %>% relocate(PSTL_CODE, LAT_DD83, LON_DD83, input$SiteInfo, .after = VISIT_NO)
        }
      }
    }
    
    ### 2012----
    if(input$Survey == "nla" & input$Year == "2012") {
      if(input$Indicator %in% c("algaltoxins","atrazine")) {
        Data <- read.csv(paste0('https://www.epa.gov/sites/production/files/2016-11/',input$Survey, input$Year,'_',input$Indicator,'_08192016.csv'))
      } else if(input$Indicator == "topsedhg") {
        Data <- read.csv(paste0('https://www.epa.gov/sites/production/files/2016-12/',input$Survey, input$Year,'_',input$Indicator,'_08192016.csv'))
      } else if(input$Indicator %in% c("bentcond","wide_benthic")) {
        Data <- read.csv(paste0('https://www.epa.gov/sites/production/files/2016-11/',input$Survey, input$Year,'_',input$Indicator,'_08232016.csv'))
      } else if(input$Indicator %in% c("secchi","wide_siteinfo")) {
        Data <- read.csv(paste0('https://www.epa.gov/sites/production/files/2016-12/',input$Survey, input$Year,'_',input$Indicator,'_08232016.csv'))
      } else if(input$Indicator %in% c("wide_profile")) {
        Data <- read.csv('https://www.epa.gov/system/files/other-files/2024-09/nla2012_profile_wide.csv')
      } else if(input$Indicator == "wide_phab") {
        Data <- read.csv(paste0('https://www.epa.gov/sites/production/files/2016-12/',input$Survey, input$Year,'_',input$Indicator,'_08232016_0.csv'))
      } else if(input$Indicator %in% c("wide_phytoplankton_count")) {
        Data <- read.csv(paste0('https://www.epa.gov/sites/production/files/2017-02/',input$Survey, input$Year,'_',input$Indicator,'_02122014.csv'))
      } else if(input$Indicator == "wide_phabmet") {
        Data <- read.csv(paste0('https://www.epa.gov/sites/production/files/2016-12/',input$Survey, input$Year,'_',input$Indicator,'_10202016.csv'))
      } else if(input$Indicator == "zooplankton-count-data-updated") {
        Data <- read.csv(paste0('https://www.epa.gov/system/files/other-files/2021-12/nla-2012-zooplankton-count-data-updated-12092021.csv'))
      } else if(input$Indicator == "zooplankton-metrics-data-updated-12092021") {
        Data <- read.csv(paste0("https://www.epa.gov/system/files/other-files/2021-12/nla-2012-zooplankton-metrics-data-updated-12092021.csv"))
      } else if(input$Indicator %in% c("bentmet", "chla_wide")) {
        Data <- read.csv(paste0('https://www.epa.gov/sites/production/files/2016-11/',input$Survey, input$Year,'_',input$Indicator,'.csv'))
      } else if(input$Indicator == "waterchem_wide") {
        Data <- read.csv(paste0('https://www.epa.gov/sites/production/files/2016-12/',input$Survey, input$Year,'_',input$Indicator,'.csv'))
      } else if(input$Indicator == "isotopes_wide") {
        Data <- read.csv(paste0('https://www.epa.gov/sites/production/files/2018-08/',input$Survey, input$Year,'_',input$Indicator,'.csv'))
      } else {#"zooplankton-raw-count"
        Data <- read.csv(paste0('https://www.epa.gov/system/files/other-files/2021-12/',input$Survey,'-',input$Year,'-',input$Indicator,'-data.csv'))
      }
      if(length(input$State) > 1 || input$State != "All States") {
        if("PSTL_CODE" %in% colnames(Data)) {
          Data <- Data %>%
            filter(PSTL_CODE %in% input$State)
        } else if("STATE" %in% colnames(Data)){
          Data <- Data %>%
            filter(STATE %in% input$State)
        } else{
          siteinfo2012 <- read.csv('https://www.epa.gov/sites/production/files/2016-12/nla2012_wide_siteinfo_08232016.csv', locale = locale(encoding = "UTF-8")) %>% 
            select(UID, SITE_ID, VISIT_NO, STATE)
          Data <- left_join(Data, siteinfo2012) %>%
            filter(STATE %in% input$State) %>% relocate(STATE, .after = VISIT_NO)
        }
      }
      if(input$Indicator != "wide_siteinfo") {
        if(input$Indicator %in% c("chla_wide", "waterchem_wide")) {
          siteinfo <- read.csv(paste0('https://www.epa.gov/sites/default/files/2016-12/nla2012_wide_siteinfo_08232016.csv')) %>%
            select(UID, SITE_ID, STATE, VISIT_NO, LAT_DD83, LON_DD83, input$SiteInfo)
          if("WGT_ALL" %in% input$SiteInfo){
            if(length(input$State) > 1 || input$State != "All States") {
              Data <- full_join(Data, siteinfo) %>% relocate(STATE, LAT_DD83, LON_DD83, input$SiteInfo, .after = VISIT_NO) %>%
                filter(STATE %in% input$State)
            } else{
              Data <- full_join(Data, siteinfo) %>% relocate(STATE, LAT_DD83, LON_DD83, input$SiteInfo, .after = VISIT_NO)
            }
          } else {
            Data <- left_join(Data, siteinfo) %>% relocate(STATE, LAT_DD83, LON_DD83, input$SiteInfo, .after = VISIT_NO)
          }
        } else {
          siteinfo <- read.csv(paste0('https://www.epa.gov/sites/default/files/2016-12/nla2012_wide_siteinfo_08232016.csv')) %>%
            filter(SITESAMP=="Y") %>%
            select(UID, SITE_ID, STATE, LAT_DD83, LON_DD83, input$SiteInfo) %>%
            filter(!(is.na(UID)))
          if("WGT_ALL" %in% input$SiteInfo){
            if(length(input$State) > 1 || input$State != "All States") {
              Data <- full_join(Data, siteinfo) %>% relocate(STATE, LAT_DD83, LON_DD83, input$SiteInfo, .after = VISIT_NO) %>%
                filter(STATE %in% input$State)
            } else {
              Data <- full_join(Data, siteinfo) %>% relocate(STATE, LAT_DD83, LON_DD83, input$SiteInfo, .after = VISIT_NO)
            }
          } else {
            Data <- left_join(Data, siteinfo) %>% relocate(STATE, LAT_DD83, LON_DD83, input$SiteInfo, .after = VISIT_NO)
          }
        }
      }
    }
    
    ### 2011----
    if(input$Survey == "nwca" & input$Year == "2011") {
      if(input$Indicator == "siteinfo") {
      Data <- read.csv('https://www.epa.gov/system/files/other-files/2023-04/nwca11_siteinfo.csv')
      } else {
      Data <- read.csv(paste0('https://www.epa.gov/sites/production/files/2016-10/',input$Survey, input$Year,'_',input$Indicator,'.csv'))
      }
      if(length(input$State) > 1 || input$State != "All States") {
        if("PSTL_CODE" %in% colnames(Data)) {
          Data <- Data %>%
            filter(PSTL_CODE %in% input$State)
        } else if("STATE" %in% colnames(Data)){
          Data <- Data %>%
            filter(STATE %in% input$State)
        } else{
          siteinfo2011 <- read.csv('https://www.epa.gov/system/files/other-files/2023-04/nwca11_siteinfo.csv') %>% 
            select(UID, SITE_ID, VISIT_NO, STATE)
          Data <- left_join(Data, siteinfo2011) %>%
            filter(STATE %in% input$State) %>% relocate(STATE, .after = VISIT_NO)
        }
      }
      if(input$Indicator != "siteinfo") {
        siteinfo <- read.csv(paste0('https://www.epa.gov/system/files/other-files/2023-04/nwca11_siteinfo.csv')) %>%
          select(UID, SITE_ID, PSTL_CODE, LAT_DD83, LON_DD83, input$SiteInfo) %>%
          filter(!(is.na(UID)))
        if("WGT_TP" %in% input$SiteInfo){
          if(length(input$State) > 1 || input$State != "All States") {
            Data <- full_join(Data, siteinfo) %>% relocate(PSTL_CODE, LAT_DD83, LON_DD83, input$SiteInfo, .after = VISIT_NO) %>%
              filter(PSTL_CODE %in% input$State)
          } else {
            Data <- full_join(Data, siteinfo) %>% relocate(PSTL_CODE, LAT_DD83, LON_DD83, input$SiteInfo, .after = VISIT_NO)
          }
        } else {
          Data <- left_join(Data, siteinfo) %>% relocate(PSTL_CODE, LAT_DD83, LON_DD83, input$SiteInfo, .after = VISIT_NO)
        }
      }
    }
    
    ### 2010----
    if(input$Survey == "ncca" & input$Year == "2010") {
      if(input$Indicator %in% c("siteinfo.revised.06212016","sediment_chemistry.revised.06.21.2016")) {
        Data <- read.csv(paste0('https://www.epa.gov/sites/production/files/2016-06/assessed_',input$Survey, input$Year,'_',input$Indicator,'.csv'))
      } else if(input$Indicator == "ecofish_collection_info") {
        Data <- read.csv(paste0('https://www.epa.gov/sites/default/files/2016-01/ncca2010_ecofish_collection_info.csv'))
      } else if(input$Indicator %in% c("pbde","mercury")){
        Data <- read.xlsx(paste0('https://www.epa.gov/sites/default/files/2014-12/glhhfts-',input$Indicator,'-fish-tissue-data-09-30-2014.xlsx'))
      } else if(input$Indicator %in% c("fatty-acids")){
        Data <- read.xlsx('https://www.epa.gov/sites/default/files/2017-03/glhhfts-fatty-acids-fish-tissue-data.xlsx')
      } else if(input$Indicator %in% c("pcb")){
        Data <- read.xlsx('https://www.epa.gov/sites/default/files/2015-09/pcb-fish-tissue-data.xlsx')
      } else if(input$Indicator %in% c("pfas")){
        Data <- read.xlsx('https://www.epa.gov/system/files/documents/2022-02/pfas-data-2010.xlsx')
      } else {
        Data <- read.csv(paste0('https://www.epa.gov/sites/production/files/2016-01/assessed_',input$Survey, input$Year,'_',input$Indicator,'.csv'))
      }
      
      if(length(input$State) > 1 || input$State != "All States") {
        if("PSTL_CODE" %in% colnames(Data)) {
          Data <- Data %>%
            filter(PSTL_CODE %in% input$State)
        } else if("STATE" %in% colnames(Data)){
          Data <- Data %>%
            filter(STATE %in% input$State)
        } else if("State" %in% colnames(Data)){
          Data <- Data %>%
            filter(State %in% input$State)
        } else{
          siteinfo2010 <- read.csv('https://www.epa.gov/sites/default/files/2016-06/assessed_ncca2010_siteinfo.revised.06212016.csv') %>% 
            select(UID, SITE_ID, STATE)
          Data <- left_join(Data, siteinfo2010) %>%
            filter(STATE %in% input$State) %>% relocate(STATE)
        }
      }
      
      # Only for fish tissue 
      if(input$Indicator %in% c("pbde","fatty-acids","mercury","pcb","pfas")) {
        siteinfo <- read.csv(paste0('https://www.epa.gov/sites/default/files/2016-06/assessed_ncca2010_siteinfo.revised.06212016.csv')) %>%
          filter(VISIT_NO=="1" | VISIT_NO==1) %>%
          select(Site.ID=SITE_ID, ALAT_DD, ALON_DD, input$SiteInfo)
        Data <- left_join(Data, siteinfo) %>% relocate(ALAT_DD, ALON_DD, input$SiteInfo, .after = Site.ID)
      }
      
      if(input$Indicator %!in% c("siteinfo.revised.06212016","pbde","fatty-acids","mercury","pcb","pfas")) {
        siteinfo <- read.csv(paste0('https://www.epa.gov/sites/default/files/2016-06/assessed_ncca2010_siteinfo.revised.06212016.csv')) %>%
          select(UID, SITE_ID, STATE, SITE_ID, ALAT_DD, ALON_DD, input$SiteInfo) %>%
          filter(!(is.na(UID)))
        if("WGT_NCCA10" %in% input$SiteInfo){
          if(length(input$State) > 1 || input$State != "All States") {
            Data <- full_join(Data, siteinfo) %>% relocate(STATE, ALAT_DD, ALON_DD, input$SiteInfo, .after = SITE_ID) %>%
              filter(STATE %in% input$State)
          } else {
            Data <- full_join(Data, siteinfo) %>% relocate(STATE, ALAT_DD, ALON_DD, input$SiteInfo, .after = SITE_ID)
          }
        } else {
          Data <- left_join(Data, siteinfo) %>% relocate(STATE, ALAT_DD, ALON_DD, input$SiteInfo, .after = SITE_ID)
        }
      }
    }
    
    ### 2008/09----
    if(input$Survey == "nrsa" & input$Year == "0809"){
      if(input$Indicator == "fieldchemmeasure") {
        Data <- read.csv("https://www.epa.gov/sites/default/files/2015-11/fieldchemmeasure.csv")
      } else if(input$Indicator == "bentcts") {
        Data <- read.csv("https://www.epa.gov/sites/default/files/2016-11/nrsa0809bentcts.csv")
      } else {
        Data <- read.csv(paste0('https://www.epa.gov/sites/production/files/2015-09/',input$Indicator,'.csv'))
      }
      if(length(input$State) > 1 || input$State != "All States") {
        if("PSTL_CODE" %in% colnames(Data)) {
          Data <- Data %>%
            filter(PSTL_CODE %in% input$State)
        } else if("STATE" %in% colnames(Data)){
          Data <- Data %>%
            filter(STATE %in% input$State)
        } else{
          siteinfo0809 <- read.csv('https://www.epa.gov/sites/default/files/2015-09/siteinfo_0.csv') %>% 
            select(UID, SITE_ID, VISIT_NO, STATE)
          Data <- left_join(Data, siteinfo0809) %>%
            filter(STATE %in% input$State) %>% relocate(STATE)
        }
      }
      if(input$Indicator != "siteinfo_0") {
        siteinfo <- read.csv(paste0('https://www.epa.gov/sites/default/files/2015-09/siteinfo_0.csv')) %>%
          select(UID, SITE_ID, STATE, LAT_DD83, LON_DD83, input$SiteInfo) %>%
          filter(!(is.na(UID)))
        if("WGTNRSA09" %in% input$SiteInfo){
          if(length(input$State) > 1 || input$State != "All States") {
            Data <- full_join(Data, siteinfo) %>% relocate(STATE, LAT_DD83, LON_DD83, input$SiteInfo, .after = VISIT_NO) %>%
              filter(STATE %in% input$State)
          } else {
            Data <- full_join(Data, siteinfo) %>% relocate(STATE, LAT_DD83, LON_DD83, input$SiteInfo, .after = VISIT_NO)
          }
        } else {
          Data <- left_join(Data, siteinfo) %>% relocate(LAT_DD83, LON_DD83, input$SiteInfo, .after = VISIT_NO)
        }
      }
    }
    
    ### 2007----
    if(input$Survey == "nla" & input$Year == "2007") {
      #"Landscape Metrics",  Hydroprofile,
      if(input$Indicator %in% c("basin_landuse_metrics_20061022", "profile_20091008")) {
        Data <- read.csv(paste0('https://www.epa.gov/sites/production/files/2013-09/',input$Survey, input$Year,'_',input$Indicator,'.csv'))
      } else if(input$Indicator == "sampledlakeinformation_20091113") {
        Data <- read.csv(paste0('https://www.epa.gov/sites/production/files/2014-01/',input$Survey, input$Year,'_',input$Indicator,'.csv'))
      } else if(input$Indicator %in% c("wide_benthic_08092016", "bentmet", "bentcond_08232016")) {
        #"Benthic Macroinvertebrates", 
        Data <- read.csv(paste0('https://www.epa.gov/sites/production/files/2016-12/',input$Survey, input$Year,'_',input$Indicator,'.csv'))
      } else if(input$Indicator == "isotopes_wide") {
        Data <- read.csv("https://www.epa.gov/sites/default/files/2018-08/nla2007_isotopes_wide.csv")
      } else if(input$Indicator == "zooplankton_count_20091022") {
        Data <- read.csv("https://www.epa.gov/sites/default/files/2014-10/nla2007_zooplankton_count_20091022.csv")
      } else {
        #Phytoplankton, Physical Habitat, Secchi, waterchem, trophic, zooplankton
        Data <- read.csv(paste0('https://www.epa.gov/sites/production/files/2014-10/',input$Survey, input$Year,'_',input$Indicator,'.csv'))
      }
      if(length(input$State) > 1 || input$State != "All States") {
        if("PSTL_CODE" %in% colnames(Data)) {
          Data <- Data %>%
            filter(PSTL_CODE %in% input$State)
        } else if("STATE" %in% colnames(Data)) {
          Data <- Data %>%
            filter(STATE %in% input$State)
        } else if("ST" %in% colnames(Data)) {
          Data <- Data %>%
            filter(ST %in% input$State) %>%
            rename(STATE = ST)
        } else {
          siteinfo2007 <- read.csv('https://www.epa.gov/sites/default/files/2014-01/nla2007_sampledlakeinformation_20091113.csv') %>% 
            select(SITE_ID, VISIT_NO, STATE=ST)
          Data <- left_join(Data, siteinfo2007) %>%
            filter(STATE %in% input$State) %>% relocate(STATE)
        }
      }
      if(input$Indicator != "sampledlakeinformation_20091113") {
        siteinfo <- read.csv(paste0('https://www.epa.gov/sites/default/files/2014-01/nla2007_sampledlakeinformation_20091113.csv')) %>%
          filter(SAMPLED="YES") %>%
          select(SITE_ID, STATE=ST, LAT_DD, LON_DD, input$SiteInfo) %>%
          filter(!(is.na(SITE_ID)))
        if("WGT_NLA" %in% input$SiteInfo){
          if(length(input$State) > 1 || input$State != "All States") {
            Data <- full_join(Data, siteinfo) %>% relocate(STATE, LAT_DD, LON_DD, input$SiteInfo, .after = VISIT_NO) %>%
              filter(STATE %in% input$State)
          } else {
            Data <- full_join(Data, siteinfo) %>% relocate(STATE, LAT_DD, LON_DD, input$SiteInfo, .after = VISIT_NO)
          }
        } else {
          Data <- left_join(Data, siteinfo) %>% relocate(STATE, LAT_DD, LON_DD, input$SiteInfo, .after = VISIT_NO)
        }
      }
    }
    
    ### 1999-2001/2005-2006----
    if(input$Survey == "ncca" & input$Year == "0506") {
      Data <- read.csv(paste0("https://www.epa.gov/system/files/other-files/2023-03/nca_", input$Indicator,'.csv'))
      if(length(input$State) > 1 || input$State != "All States") {
        Data <- Data %>%
          filter(PSTL_CODE %in% input$State)
      }
      
      
      if(input$Indicator != "siteinformationdata") {
        siteinfo <- read.csv(paste0('https://www.epa.gov/system/files/other-files/2023-03/nca_siteinformationdata.csv')) %>%
          select(SITE_ID, PSTL_CODE, input$SiteInfo) %>%
          filter(!(is.na(SITE_ID)))
        if("WGT_NCA_91" %in% input$SiteInfo || "WGT_NCA_56" %in% input$SiteInfo){
          if(length(input$State) > 1 || input$State != "All States") {
            Data <- full_join(Data, siteinfo) %>% relocate(PSTL_CODE, LAT_DD, LON_DD, input$SiteInfo, .after = SITE_ID) %>%
              filter(PSTL_CODE %in% input$State)
          } else {
            Data <- full_join(Data, siteinfo) %>% relocate(PSTL_CODE, LAT_DD, LON_DD, input$SiteInfo, .after = SITE_ID)
          }
        } else {
          Data <- left_join(Data, siteinfo) %>% relocate(PSTL_CODE, LAT_DD, LON_DD, input$SiteInfo, .after = SITE_ID)
        }
      }
    } 
    
    remove_modal_spinner()
    
    shiny::validate(
      need(nrow(Data)!=0, 'No data are available for the selected criteria.')
    )
    
    Data
    
  })
  
  output$table <- renderDataTable({
    DT::datatable(
      Data(), 
      filter = list(position = 'top'),
      rownames = FALSE,
      options = list(
        autowidth = TRUE,
        scrollX = TRUE,
        searchHighlight = TRUE)
    )
  })
  
  output$dwnldcsv <- downloadHandler(
    filename = function() {
      unlist(strsplit(paste0(datatitle(), ".csv", sep = ""), split=':', fixed=TRUE))[2]
      },
      content = function(file) {
        write.csv(Data(), file, row.names = FALSE)
      }
    )
  
  
  
  output$dwnldexcel <- downloadHandler(
    filename = function(){unlist(strsplit(paste0(datatitle(), ".xlsx", sep = ""), split=':', fixed=TRUE))[2]},
    content = function(file) {
      wb <- createWorkbook(file)
      addWorksheet(wb, "data")
      addWorksheet(wb, "metadata")
      writeData(wb, x = Data(), sheet = "data")
      writeData(wb, x = MetaData(), sheet = "metadata")
      saveWorkbook(wb, file)
    },
    contentType="application/xlsx" 
  )

      
  ## Metadata Extract ----
  MetaData <- eventReactive(input$goButton, { 
    # shiny::validate(
    #   need(input$State != "", 'Select State(s) of Interest!'))
    # 
    show_modal_spinner(spin = 'flower', text = 'Assembling Metadata.')
    
    ### 2022----
    if (input$Survey == "nla" & input$Year == "2022") {
      if(input$Indicator == "nla2007-2022_data_forpopestimates_indexvisits_probsites_0") {
        MetaData <- read.delim('https://www.epa.gov/system/files/other-files/2024-08/nla2007-2022_metadata_forpopestimates_allvisits_allsitetypes_0.txt')
      } else if(input$Indicator %in% c("profile_wide","phab_wide","landscape_wide_0")){
        MetaData <- read.delim(paste0('https://www.epa.gov/system/files/other-files/2024-08/nla2022_',input$Indicator,'.txt'))
      } else if(input$Indicator %in% c("phabmets_wide_0")){
        MetaData <- read.delim('https://www.epa.gov/system/files/other-files/2024-08/nla2022_phabmets_wide.txt')
      } else if(input$Indicator %in% c("sample_grid")){
        MetaData <- read.delim(paste0('https://www.epa.gov/system/files/other-files/2024-04/nla2022_',input$Indicator,'.txt'))
      } else if(input$Indicator %in% c("benthic_mmi_0")){
        MetaData <- read.delim('https://www.epa.gov/system/files/other-files/2024-08/nla22_benthic_mmi.txt')
      } else if(input$Indicator %in% c("condition_combined_2024-08-13_0")){
        MetaData <- read.delim('https://www.epa.gov/system/files/other-files/2024-08/nla2022_condition_estimates_metadata_0.txt')
      } else if(input$Indicator %in% c("mercury","lipid","pcb","pfas")){
        MetaData <- data.frame("Metadata Not Available"="For more information visit: https://www.epa.gov/choose-fish-and-shellfish-wisely/2022-national-lakes-assessment-fish-tissue-study")
      } else {
        MetaData <- read.delim(paste0('https://www.epa.gov/system/files/other-files/2024-04/nla22_',input$Indicator,'.txt'))
      }
    }
    
    ### 2021----
    if(input$Survey == "nwca" & input$Year == "2021") {
        MetaData <- read.delim(paste0('https://www.epa.gov/system/files/other-files/2024-05/nwca21_',input$Indicator,'-meta.txt'))
    }
    ### 2018/19----
    if(input$Survey == "nrsa" & input$Year == "1819") {
      if(input$Indicator == "mercury_in_fish_tissue_plugs") {
        MetaData <- read.delim(paste0('https://www.epa.gov/sites/production/files/2021-04/',input$Survey,'_', input$Year,'_',input$Indicator,'_-_metadata_.txt'))
      } else if(input$Indicator == "SiteInfo") {
        MetaData <- read.delim('https://www.epa.gov/system/files/other-files/2023-01/NRSA18_19_Site_Information_Metadata.txt', stringsAsFactors = FALSE, fileEncoding = 'UTF-8')
      } else if(input$Indicator %in% c("fish-sampling-information", "fish-count", "fish-metrics")) {
        MetaData <- read.delim(paste0('https://www.epa.gov/system/files/other-files/2022-03/nrsa-1819-',input$Indicator,'-metadata.txt'))
      } else if(input$Indicator == "pbio_0"){
        MetaData <- read.delim('https://www.epa.gov/system/files/other-files/2023-02/nrsa1819_pbio_metadata.txt')  
      } else if(input$Indicator == "PeriChla"){
        MetaData <- read.delim('https://www.epa.gov/system/files/other-files/2023-01/nrsa1819_PeriChla.txt')  
      } else if(input$Indicator == "landscape"){
        MetaData <- read.delim('https://www.epa.gov/system/files/other-files/2023-01/NRSA_1819_Landscape_metadata.txt')  
      } else if(input$Indicator == "enterococci_0"){
        MetaData <- read.delim('https://www.epa.gov/system/files/other-files/2023-01/nrsa1819_enterococci_metadata.txt')
      } else if(input$Indicator == "field_wide"){
        MetaData <- read.delim('https://www.epa.gov/system/files/other-files/2023-01/nrsa1819_field_newUid.txt')  
      } else if(input$Indicator %in% c("mercury","pcb","pfas")){
        MetaData <- data.frame("Metadata Not Available"="For more information visit: https://www.epa.gov/choose-fish-and-shellfish-wisely/2018-2019-national-rivers-and-streams-assessment-fish-tissue-study")
      } else {
        MetaData <- read.delim(paste0('https://www.epa.gov/sites/production/files/2021-04/',input$Survey,'_', input$Year,'_',input$Indicator,'_-_metadata.txt'))
      }
    }
    
    ### 2017----
    if(input$Survey == "nla" & input$Year == "2017") {
      
      if(input$Indicator == "zooplankton-count") {
        MetaData <- read.delim(paste0('https://www.epa.gov/system/files/other-files/2021-12/',input$Survey,'-',input$Year,'-',input$Indicator,'-metadata.txt'))
      } else if (input$Indicator %in% c("zooplankton-raw-count","zooplankton-metrics","zooplankton-taxa-list")) {
        MetaData <- read.delim(paste0('https://www.epa.gov/system/files/other-files/2021-12/',input$Survey,'-',input$Year,'-',input$Indicator,'-metadata-updated-12092021.txt'))
      } else if (input$Indicator == "landMets") {  
        MetaData <- read.delim("https://www.epa.gov/system/files/other-files/2022-07/nla2017_landMets.txt")
      } else if (input$Indicator == "condition_estimates") { 
        MetaData <- read.delim("https://www.epa.gov/system/files/other-files/2023-01/nla2017_condition_estimates_metadata_220705.txt", stringsAsFactors = FALSE, fileEncoding = 'UTF-16LE')
      } else if (input$Indicator == "data_for_population_estimates") { 
        MetaData <- read.delim("https://www.epa.gov/system/files/other-files/2023-01/nla2017_metadata_for_population_estimates_220705.txt")
      } else {
        MetaData <- read.delim(paste0('https://www.epa.gov/sites/production/files/2021-04/',input$Survey,'_',input$Year,'_',input$Indicator,'-metadata.txt'))
      }
    }
    ### 2016----
    if(input$Survey == "nwca" & input$Year == "2016"){
      if(input$Indicator == "site-information") {
        MetaData <- read.delim("https://www.epa.gov/system/files/other-files/2022-04/nwca-2016-site-information-metadata_0.txt")
      } else if(input$Indicator == "plant-species-cover-height") {
        MetaData <- read.delim("https://www.epa.gov/system/files/other-files/2022-04/nwca-2016-plant-species-cover-height-metadata.txt")
      } else if (input$Indicator %in% c("plant_taxa")) {  
        MetaData <- read.delim(paste0('https://www.epa.gov/system/files/other-files/2023-03/nwca2016_',input$Indicator,'_metadata.txt'))
      } else if (input$Indicator %in% c("aa_characterization")) {  
        MetaData <- read.delim(paste0('https://www.epa.gov/system/files/other-files/2023-03/nwca16_',input$Indicator,'_metadata.txt'))
      } else if (input$Indicator %in% c("vegetation_type", "ground_surface", "veg_mmi", "landscape_metrics", "plant_native_status", "plant_cvalues", "plant_wis")) {  
        MetaData <- read.delim(paste0('https://www.epa.gov/system/files/other-files/2023-03/nwca_2016_',input$Indicator,'_metadata.txt'))
      } else if (input$Indicator %in% c("2011_data_for_population_estimates", "condition_estimates")) {   
        MetaData <- read.delim(paste0('https://www.epa.gov/system/files/other-files/2023-04/nwca_2016_',input$Indicator,'_metadata.txt'))
      } else if (input$Indicator %in% c("cond_stress")) {   
        MetaData <- read.delim('https://www.epa.gov/system/files/other-files/2023-04/nwca_2016_cond_stress.txt', stringsAsFactors = FALSE, fileEncoding = 'UTF-16LE')
      } else {
        MetaData <- read.delim(paste0('https://www.epa.gov/sites/production/files/2021-04/',input$Survey,'_',input$Year,'_',input$Indicator,'_-_metadata_txt.txt'))
      }
    }
    ### 2015----
    if(input$Survey == "ncca" & input$Year == "2015") {
      if(input$Indicator == "ecological-fish-tissue-contaminants-fish-collection" & input$NCCA_Type == "estuarine"){
        MetaData <- read.delim(paste0("https://www.epa.gov/system/files/other-files/2021-08/ncca-2015-ecological-fish-tissue-contaminants-fish-collection-estuarine-metadata.txt"))
      } else if(input$Indicator == "ecological-fish-tissue-contaminants-fish-collection" & input$NCCA_Type == "great_lakes"){
        MetaData <- read.delim(paste0("https://www.epa.gov/system/files/other-files/2021-08/ncca-2015-ecological-fish-tissue-contaminants-fish-collection-great-lakes-metadata.txt"))
      } else if(input$Indicator %in% c("dioxin-furan","fatty-acids","mercury","pcb","pfas")){
        MetaData <- data.frame("Metadata Not Available"="For more information visit: https://www.epa.gov/choose-fish-and-shellfish-wisely/2015-great-lakes-human-health-fish-fillet-tissue-study")
      } else {
        MetaData <- read.delim(paste0('https://www.epa.gov/sites/production/files/2021-04/',input$Survey,'_',input$Year,'_',input$Indicator,'_',input$NCCA_Type,'-metadata.txt'))
      }
    }
    ### 2013/14----
    if (input$Survey == "nrsa" & input$Year == "1314") {
      if(input$Indicator == "fishmmi"){
        MetaData <- read.delim(paste0('https://www.epa.gov/sites/production/files/2019-04/',input$Survey, input$Year,'_','fish_meta_04292019.txt'))
      } else if(input$Indicator %in% c("key_var")) {
        MetaData <- read.delim(paste0('https://www.epa.gov/sites/production/files/2019-05/nrsa1314_allcond_meta_05312019.txt'))
      } else if(input$Indicator == "siteinformation_wide") {
        MetaData <- read.delim(paste0('https://www.epa.gov/sites/production/files/2019-04/',input$Survey, input$Year,'_','sitesuids_wide_meta_04292019.txt'))
      } else if(input$Indicator == "fishplug_hg"){
        MetaData <- read.delim(paste0('https://www.epa.gov/sites/default/files/2019-04/nrsa1314_fishplugs_hg_meta_04292019.txt'))
      } else {
        MetaData <- read.delim(paste0('https://www.epa.gov/sites/production/files/2019-04/',input$Survey, input$Year,'_',input$Indicator,'_meta_04292019.txt'))
      }
    }
    ### 2012----
    if (input$Survey == "nla" & input$Year == "2012") {
      if(input$Indicator %in% c("algaltoxins","atrazine")) {
        MetaData <- read.delim(paste0('https://www.epa.gov/sites/production/files/2016-11/',input$Survey, input$Year,'_',input$Indicator,'_meta_08192016.txt'))
      } else if(input$Indicator %in% c("bentcond","wide_benthic")) {
        MetaData <- read.delim(paste0('https://www.epa.gov/sites/production/files/2016-11/',input$Survey, input$Year,'_',input$Indicator,'_meta_08232016.txt'))
      } else if(input$Indicator %in% c("bentmet","chla_wide")) {
        MetaData <- read.delim(paste0('https://www.epa.gov/sites/production/files/2016-11/',input$Survey, input$Year,'_',input$Indicator,'_meta.txt'))
      } else if (input$Indicator == "waterchem_wide") {
        MetaData <- read.delim(paste0('https://www.epa.gov/sites/production/files/2016-12/',input$Survey, input$Year,'_waterchem_meta.txt'))
      } else if(input$Indicator == "isotopes_wide") {
        MetaData <- read.delim(paste0('https://www.epa.gov/sites/production/files/2018-08/',input$Indicator,'_met.txt'))
      } else if(input$Indicator == "wide_phytoplankton_count") {
        MetaData <- read.delim(paste0('https://www.epa.gov/sites/production/files/2017-02/',input$Survey, input$Year,'_phytoplankton_wide_meta.txt'))
      } else if(input$Indicator %in% c("wide_phab","wide_phabmet","secchi","wide_siteinfo")) {
        MetaData <- read.delim(paste0('https://www.epa.gov/sites/production/files/2016-12/',input$Survey, input$Year,'_',input$Indicator,'_meta_08232016.txt'))
      } else if(input$Indicator %in% c("wide_profile")) {
        MetaData <- read.delim('https://www.epa.gov/system/files/other-files/2024-09/nla2012_profile_wide.txt')
      } else if(input$Indicator == "topsedhg") {
        MetaData <- read.delim(paste0('https://www.epa.gov/sites/production/files/2016-12/',input$Survey, input$Year,'_',input$Indicator,'_meta_08192016.txt'))
      } else if (input$Indicator == "zooplankton-metrics-data-updated-12092021") {
        MetaData <- read.delim(paste0('https://www.epa.gov/system/files/other-files/2021-12/nla-2012-zooplankton-metrics-metadata-updated-12092021.txt'))
      } else if (input$Indicator == "zooplankton-count-data-updated") {
        MetaData <- read.delim(paste0('https://www.epa.gov/system/files/other-files/2023-03/nla12_wide_zooplankton.txt'))
      } else {#"zooplankton-raw-count"
        MetaData <- read.delim(paste0('https://www.epa.gov/system/files/other-files/2021-12/',input$Survey,'-', input$Year,'-',input$Indicator,'-metadata.txt'))
      }
    }
    ### 2011----
    if(input$Survey == "nwca" & input$Year == "2011") {
      if(input$Indicator == "siteinfo") {
        MetaData <- read.delim("https://www.epa.gov/system/files/other-files/2023-04/nwca11_siteinfo_metadata.txt")
      } else {
        MetaData <- read.delim(paste0('https://www.epa.gov/sites/production/files/2016-10/',input$Survey, input$Year,'_',input$Indicator,'-meta.txt'))
      }
    }
    ### 2010----
    if(input$Survey == "ncca" & input$Year == "2010") {
      if(input$Indicator == "benthic_data") {
        MetaData <- read_delim("https://www.epa.gov/sites/default/files/2016-01/ncca_2010_benthic_metadata_0.txt", skip=9, col_select = c(1,3))
      } else if(input$Indicator == "siteinfo.revised.06212016") {
        MetaData <- read_delim("https://www.epa.gov/sites/default/files/2016-06/siteinfo_metadata.revised.06212016.txt", skip=13, col_select = c(1,3))
      } else if(input$Indicator == "sediment_chemistry.revised.06.21.2016") {
        MetaData <- read_delim("https://www.epa.gov/sites/default/files/2016-06/ncca_2010_sediment_chemistry_metadata.revised.06.21.2016.txt", skip=11, col_select = c(1,3))
      } else if(input$Indicator == "ecological_fish_tissue_contaminant_data") {
        MetaData <- read_delim('https://www.epa.gov/sites/default/files/2016-01/ncca_2010_ecological_fish_tissue_contaminant_metadata.txt', skip=9, col_select = c(1,3))
      } else if(input$Indicator == "ecofish_collection_info") {
        MetaData <- read_delim("https://www.epa.gov/sites/default/files/2016-01/ncca_2010_ecological_fish_collection_info_metadata.txt", skip=9, col_select = c(1,3)) %>% slice(-c(10:19))
      } else if(input$Indicator == "sediment_toxicity_results") {
        MetaData <- read_delim('https://www.epa.gov/sites/default/files/2016-01/ncca_2010_sediment_toxicity_metadata.txt', skip=13, col_select = c(6,7))
      } else if(input$Indicator == "hydrolab") {
        MetaData <- read_delim(paste0('https://www.epa.gov/sites/default/files/2016-01/ncca2010_hydrolab_metadata.txt'), skip=11, col_select = c(1,3))
      } else if(input$Indicator == "waterchem") {
        MetaData <- read_delim(paste0('https://www.epa.gov/sites/default/files/2016-01/ncca2010_waterchem_metadata.txt'), skip=9, col_select = c(1,3))
      } else if(input$Indicator %in% c("pbde","fatty-acids","mercury","pcb","pfas")){
        MetaData <- data.frame("Metadata Not Available"="For more information visit: https://www.epa.gov/choose-fish-and-shellfish-wisely/2010-great-lakes-human-health-fish-tissue-study")
      }
    }
    ### 2008/09----
    if(input$Survey == "nrsa" & input$Year == "0809") {
      if(input$Indicator == "bentcts") {
        MetaData <- read.delim("https://www.epa.gov/sites/default/files/2016-11/nrsa0809bentctsmet.txt")
      } else if(input$Indicator == "fieldchemmeasure") {
        MetaData <- read.delim("https://www.epa.gov/sites/default/files/2015-11/fieldchemmeas.txt")
      } else{
        MetaData <- read.delim(paste0('https://www.epa.gov/sites/production/files/2015-09/',input$Indicator,'.txt'))
      }
    }
    ### 2007----
    if(input$Survey == "nla" & input$Year == "2007") {
      if(input$Indicator == "basin_landuse_metrics_20061022") {
        MetaData <- read.delim("https://www.epa.gov/sites/default/files/2013-09/nla2007_basin_landuse_metrics_info_20091022.txt")
      } else if(input$Indicator == "profile_20091008") {
        MetaData <- read.delim("https://www.epa.gov/sites/default/files/2013-09/nla2007_profile_info_20091008_0.txt")
      } else if(input$Indicator == "sampledlakeinformation_20091113") {
        MetaData <- read.delim("https://www.epa.gov/sites/default/files/2014-01/nla2007_sampledlakeinformation_info_20091113.txt")
      } else if(input$Indicator == "wide_benthic_08092016") {
        MetaData <- read.delim("https://www.epa.gov/sites/default/files/2016-12/nla2012_wide_benthic_all_meta_08092016.txt")
      } else if(input$Indicator == "bentmet") {
        MetaData <- read.delim("https://www.epa.gov/sites/default/files/2016-12/nla2012_bentmet_all_meta.txt")
      } else if(input$Indicator == "bentcond_08232016") {
        MetaData <- read.delim("https://www.epa.gov/sites/default/files/2016-12/nla2012_bentcond_all_meta_08232016.txt")
      } else if(input$Indicator == "chemical_conditionestimates_20091123") {
        MetaData <- read.delim("https://www.epa.gov/sites/default/files/2014-10/nla2007_chemical_conditionestimates_info_20091123.txt")
      } else if(input$Indicator == "phab_condtionestimates_20091130") {
        MetaData <- read.delim("https://www.epa.gov/sites/default/files/2014-10/nla2007_phab_condtionestimates_info_20091130.txt")
      } else if(input$Indicator == "secchi_20091008") {
        MetaData <- read.delim("https://www.epa.gov/sites/default/files/2014-10/nla2007_secchi_info_20091008.txt")
      } else if(input$Indicator %in% c("phab_metrics_a", "phab_metrics_b")) {
        MetaData <- read.delim("https://www.epa.gov/sites/default/files/2014-10/nla2007_phab_metrics_info_20091120.txt")
      } else if(input$Indicator == "phab_indexvalues") {
        MetaData <- read.delim("https://www.epa.gov/sites/default/files/2014-10/nla2007_phab_indexvalues_info_20091120.txt")
      } else if(input$Indicator == "trophic_conditionestimate_20091123") {
        MetaData <- read.delim("https://www.epa.gov/sites/default/files/2014-10/nla2007_trophic_conditionestimate_info_20091123.txt")
      } else if(input$Indicator == "zooplankton_sampleinformation_20091020") {
        MetaData <- read.delim("https://www.epa.gov/sites/default/files/2014-10/nla2007_zooplankton_sampleinformation_info_20091020.txt")
      } else if(input$Indicator == "isotopes_wide") {
        MetaData <- read.delim("https://www.epa.gov/sites/default/files/2018-08/isotopes_wide_met_0.txt")
      } else { #zooplankton count
        MetaData <- read.delim("https://www.epa.gov/sites/default/files/2014-10/nla2007_zooplankton_count_info_20091022.txt")
      }
    }
    ### 1999-2001/2005-2006----
    if(input$Survey == "ncca" & input$Year == "0506"){ 
        MetaData <- read.delim(paste0("https://www.epa.gov/system/files/other-files/2023-03/nca_", input$Indicator,"_metadata.txt"))
    } 
    remove_modal_spinner()
    MetaData
  })
  
  output$metatable <- renderDataTable(server=FALSE, {
    DT::datatable(
      MetaData(),
      callback=JS('$("button.buttons-copy").css("background","#337ab7").css("color", "#fff");
                   $("button.buttons-csv").css("background","#337ab7").css("color", "#fff");
                   return table;'),
      extensions = c("Buttons"),
      rownames = FALSE,
      options = list(dom = 'Bflrtip',
                     scrollX = TRUE,
                     buttons = list(
                       list(extend = 'copy', filename = paste0(unlist(strsplit(datatitle(), split=' ', fixed=TRUE))[2],"_METADATA")),
                       list(extend = 'csv', filename = paste0(unlist(strsplit(datatitle(), split=' ', fixed=TRUE))[2],"_METADATA")))
      ))
  })
  
  #session$onSessionEnded(stopApp)
}

# shinyApp()
shinyApp(ui = ui, server = server)