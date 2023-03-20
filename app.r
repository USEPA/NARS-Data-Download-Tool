#packages <- c("shiny", "openxlsx", "dplyr", "readr", "DT", "bslib", "shinybusy", "shinyhelper", "shinyjs", "shinyalert")
#installed_packages <- packages %in% rownames(installed.packages())
#if(any(installed_packages == FALSE)) {
#  install.packages(packages[!installed_packages])
#}

# Packages loading
#lapply(packages, library, character.only = TRUE)
library(shiny)
library(openxlsx)
library(dplyr)
library(readr)
library(DT)
library(bslib)
library(shinybusy)
library(shinyhelper)
library(shinyjs)
library(shinyalert)

addResourcePath(prefix = 'www', directoryPath = './www')


state_name <- as.character(c(state.abb, "AS", "GU", "MP"))

# Indicators ----
choices1819 <- c("Algal Toxin"="algal_toxin", "Benthic Macroinvertebrate Count"="benthic_macroinvertebrate_count", "Benthic Macroinvertebrate Metrics"="benthic_macroinvertebrate_metrics", "Enterococci"="enterococci_0",
                 "Field Chemistry Measures"="field_wide", "Fish Tissue (Plugs)-Mercury"="mercury_in_fish_tissue_plugs", "Fish Sampling Info"="fish-sampling-information", "Fish Count"="fish-count", "Fish Metrics"="fish-metrics", 
                 "Landscape Data"="landscape", "Periphyton Biomass"="pbio_0", "Periphyton/Chlorophyll a"="PeriChla", "Physical Habitat Metrics"="physical_habitat_larger_set_of_metrics", "Site Information"="SiteInfo", "Water Chemistry/Chlorophyll a"="water_chemistry_chla")

choices2017 <- c("Algal Toxin"="algal_toxin", "Atrazine"="atrazine", "Benthic Macroinvertebrate Count"="benthic_count", "Benthic Macroinvertebrate Metrics"="benthic_metrics", 
                 "E. Coli"="e.coli", "Hydrographic Profile"="profile", "Physical Habitat"="phab", "Secchi Depth"="secchi", "Phytoplankton Count"="phytoplankton_count", "Sediment Chemistry"="sediment_chemistry", 
                 "Site Information"="site_information", "Water Chemistry/Chlorophyll a"="water_chemistry_chla", "Zooplankton Count"="zooplankton-count",
                 "Zooplankton Count (Raw)"="zooplankton-raw-count", "Zooplankton Metrics"="zooplankton-metrics")

choices2016 <- c("AA Characterization"="aa_characterization", "AA Hydrology USACOE"="aa_hydrology_usacoe", "AA Hydrology Stressors"="aa_hydrology_sources", "Buffer Native Cover"="buffer_characterization_natcover", 
                 "Buffer Stressors"="buffer_characterization_stressors", "Floras Used/VegPlot Layout"="floras_used_and_veg_plot_layout", "Ground Surface"="ground_surface", "Microcystin"="microcystin", 
                 "Plant Cover Height"="plant-species-cover-height", "Site Information"="site-information", "Soil Horizon Chemistry"="soil_horizon_chemistry", 
                 "Soil Depth Core Chemistry"="soil_stddepth_core_chemistry", "Soil Horizon Description"="soil_horizon_description", "Soil Pit Characteristics"="soil_pit_characteristics",  
                 "Surface Water Characterization"="surface_water_characterization",  "Tree Cover/Count"="tree_cover_count", "Vegetation Type"="vegetation_type",
                 "VegPlot Location"="veg_plot_location", "Water Chemistry/Chlorophyll a"="water_chemistry_chla")

choices2015 <- c("Benthic Macroinvertebrate Count"="benthic_count", "Benthic Grab"="benthic_grab", "ECOFISH Fish Collection "="ecological-fish-tissue-contaminants-fish-collection", "ECOFISH Contaminant Index"="ecological_fish_tissue_contaminants", "Enterococci"="enterococci", "Fish Tissue (Plugs)-Mercury"="mercury_in_fish_tissue_plugs",  
                 "Hydrographic Profile"="hydrographic_profile", "Microcystin"="microcystin", "Secchi Depth"="secchi", "Sediment Chemistry"="sediment_chemistry", "Site Information"="site_information", "Water Chemistry"="water_chemistry")

choices1314 <- c("Benthic Macroinvertebrate Count"="bentcnts", "Benthic Macroinvertebrate Metrics"="bentmet", "Benthic Macroinvertebrate MMI"="bentmmi", "Chlorophyll a"="widewchl", "Enterococci"="ente", "Field Chemistry"="wide_field_meas", 
                 "Fish Metrics"="fishmet", "Fish MMI"="fishmmi", "Fish Counts" = "fishcts", "Fish Tissue (Plugs)-Mercury"="fishplug_hg", "Microcystin"="micx", "Periphyton"="widepchl", "Periphyton Biomass"="widepbio", "Physical Habitat Metrics"="phabmed", 
                 "Site Information"="siteinformation_wide", "Water Chemistry"="widechem", "Water Chemistry Indicator"="chem")

choices2012 <- c("Algal Toxin"="algaltoxins", "Atrazine"="atrazine", "Benthic Condition"="bentcond", "Benthic Macroinvertebrate Count"="wide_benthic", "Benthic Macroinvertebrate Metrics"="bentmet", "Chlorophyll a"="chla_wide", 
                 "Phytoplankton Count"="wide_phytoplankton_count", "Physical Habitat"="wide_phab", "Physical Habitat Metrics"="wide_phabmet", "Secchi Depth"="secchi", "Sediment (Mercury)"="topsedhg", 
                 "Site Information"="wide_siteinfo", "Water Chemistry"="waterchem_wide", "Water Isotope Variables"="isotopes_wide", "Hydrographic Profile"="wide_profile", "Zooplankton Count"="zooplankton-count-data-updated", 
                 "Zooplankton Count (Raw)"="zooplankton-raw-count", "Zooplankton Metrics"="zooplankton-metrics")

choices2011 <- c("AA Characterization"="aachar", "Algal Toxin"="algaltoxin", "Buffer Characterization"="bufferchar", "Chlorophyll a"="chla", "Disturbance Gradiant Inputs"="distgrad_inputs", "Floras/Vegplot Layouts"="floras_vegplotlayout",
                 "Hydrology"="hydro", "Indicator Conditions"="cond_stress", "Landscape Metrics"="landscapechar", "Plant Cover and Height"="plant_pres_cvr", "Plant Vouchers"="plantvoucher", "Sediment Enzymes"="sedenzymes", "Site Information"="siteinfo", 
                 "Soil Chemistry"="soilchem", "Soil Profile Descriptions"="soilprofhorizons", "Soil Profile Attributes" = "soilprofsum", "Tree Data"="tree", "USARAM Attributes"="usaram_attributes", "USARAM Summary"="usaram_summary", 
                 "Vegetation Metrics"="vegmetrics", "Vegetation MMI"="vegmmi", "Vegetation Plot Location"="vegplotloc", "Vegetation Type and Ground Surface"="vegtype_grndsurf", "Water Chemistry"="waterchem")

choices2010 <- c("Benthic Macroinvertebrates"="benthic_data", "ECOFISH Collection Info"="ecofish_collection_info", "ECOFISH Contaminant Index"="ecological_fish_tissue_contaminant_data", "Hydrographic Profile"="hydrolab", 
                 "Sediment Chemistry"="sediment_chemistry.revised.06.21.2016", "Sediment Toxicity"="sediment_toxicity_results", "Site Information"="siteinfo.revised.06212016", "Water Chemistry"="waterchem")

choices0809 <- c("Benthic Macroinvertebrate Count"="bentcts", "Benthic Macroinvertebrate MMI"="bentcond", "Enterococci"="enterocond", "Field Chemistry"="fieldchemmeasure", "Fish Metrics"="fishmet", "Fish MMI"="fishcond", "Fish Counts" = "fishcts", 
                 "Landscape Metrics"="land", "Physcial Habitat Metrics (Common)"="phablow", "Physical Habitat Metrics (Large)"="phabmed", "Site Information"="siteinfo_0", "Water Chemistry"="chem", "Water Chemistry Indicator"="chemcond")

choices2007 <- c("Benthic Macroinvertebrate Condition"="bentcond_08232016", "Benthic Macroinvertebrate Count"="wide_benthic_08092016", "Benthic Macroinvertebrate Metrics"="bentmet", "Hydrographic Profile"="profile_20091008", 
                 "Landscape Metrics"="basin_landuse_metrics_20061022", "Physical Habitat"="phab_indexvalues", "Physical Habitat Condition"="phab_condtionestimates_20091130", "Physical Habitat Metrics (A)"="phab_metrics_a", 
                 "Physical Habitat Metrics (B)"="phab_metrics_b", "Phytoplankton Condition"="plankton_oemodel_conditionestimates_20091125", "Phytoplankton Count (Diamtoms)"="phytoplankton_diatomcount_20091125", 
                 "Phytoplankton Count (Soft Algae)"="phytoplankton_softalgaecount_20091023", "Phytoplankton Sample Info"="phytoplankton_sampleinfo_20091023", "Secchi Depth"="secchi_20091008", "Site Information"="sampledlakeinformation_20091113", 
                 "Trophic Status"="trophic_conditionestimate_20091123", "Water Chemistry Condition"="chemical_conditionestimates_20091123", "Water Isotope"="isotopes_wide", "Zooplankton Count"="zooplankton_count_20091022", 
                 "Zooplankton Sample Info"="zooplankton_sampleinformation_20091020")

choices0506 <- c("Benthic Macroinvertebrates"="benthicdata", "Sediment Chemistry"="sedchemdata", "Site Information"="siteinformationdata", "Water Chemistry"="waterchemdata")  

# siteinfo ----
site1819 <- c("Add Site Info (optional)"="", "Aggr. Ecoregion 3"="AG_ECO3", "Aggr. Ecoregion 9"="AG_ECO9", "County"="CNTYNAME", "Feature Type"="FTYPE", "Elevation"="ELEVATION", "EPA Region"="EPA_REG", "GNIS Name"="GNIS_NAME", "HUC8", "Major Basin Name"="MAJ_BAS_NM", 
              "NARS_Name"="NARS_NAME", "Strahler Order"="STRAH_ORD", "Unique ID"="UNIQUE_ID", "Urban/NonUrban"="URBN_NRS18", "US L3 Name"="US_L3NAME", "US L4 Name"="US_L4NAME")

site2017 <- c("Add Site Info (optional)"="", "Aggr. Ecoregion 3"="AG_ECO3", "Aggr. Ecoregion 9"="AG_ECO9", "Area (Hectares)"="AREA_HA", "County"="CNTYNAME", "Elevation"="ELEVATION", "EPA Region"="EPA_REG", "Feature Type"="DES_FTYPE", "GNIS Name"="GNIS_NAME", "HUC8",
              "Lake Owner"="OWN_NARS", "Major Basin Name"="MAJ_BAS_NM", "NES Lake"="NES_LAKE", "Unique ID"="UNIQUE_ID", "Urban/NonUrban"="URBN_NLA17", "US L3 Name"="US_L3NAME", "US L4 Name"="US_L4NAME")

site2016 <- c("Add Site Info (optional)"="", "Aggr. Ecoregion 3"="AG_ECO3", "Aggr. Ecoregion 9"="AG_ECO9", "COE Region"="COE_REGION", "County"="CNTYNAME", "HUC12"="HUC12", "LRR Name"="LRR_NAME", "LRR Symbol"="LRR_SYM", "MLRA Symbol"="MLRARSYM", 
              "NEP Name"="NEP_NAME", "Reference NWCA"="REF_NWCA", "US L3 Name"="US_L3NAME", "US L3 Code"="US_L3CODE", "Wetland Class"="WETCLS_EVL", "Wetland Class HGM"="WETCLS_HGM")

site2015est <- c("Add Site Info (optional)"="", "DWH Region"="DWH_REGION", "EPA Region"="EPA_REG", "Estuarine Group"="EST_GROUP", "Estuary Size"="SMALL_EST", "Feature Name"="FEAT_NM", "NCCA Region"="NCCA_REG", "NEP Name"="NEP_NAME", "Province"="PROVINCE",
                 "Stratum"="STRATUM", "Station Depth"="STATION_DEPTH")
site2015gl <- c("Add Site Info (optional)"="", "EPA Region"="EPA_REG", "Feature Name"="FEAT_NM", "Great Lake"="GREAT_LAKE", "Lake Region"="LAKE_REG", "NCCA Region"="NCCA_REG", "NPS Park"="NPS_PARK", "Province"="PROVINCE",
                "Stratum"="STRATUM", "Station Depth"="STATION_DEPTH")  

site1314 <- c("Add Site Info (optional)"="", "Aggr. Ecoregion 3"="AG_ECO3", "Aggr. Ecoregion 9"="AG_ECO9", "County"="CNTYNAME", "Elevation"="ELEVATION", "EPA Region"="EPA_REG", "GNIS Name"="GNIS_NAME", "HUC8", "Major Basin Name"="MAJ_BAS_NM", 
              "NARS_Name"="NARS_NAME", "Strahler Order"="STRAH_CAL", "Urban/NonUrban"="NRS13_URBN", "US L3 Name"="US_L3NAME", "US L4 Name"="US_L4NAME")

site2012 <- c("Add Site Info (optional)"="", "Aggr. Ecoregion 3"="AGGR_ECO3_2015", "Aggr. Ecoregion 9"="AGGR_ECO9_2015", "Area (Hectares)"="AREA_HA", "County"="CNTYNAME", "Elevation"="ELEVATION", "EPA Region"="EPA_REG", "Feature Type"="DES_FTYPE", "GNIS Name"="GNIS_NAME", "HUC8",
              "Lake Owner"="OWNSHP", "Major Basin Name"="MAJ_BASIN", "NES Lake"="NES_LAKE", "Urban/NonUrban"="URBAN", "US L3 Code"="US_L3CODE_2015", "US L4 Code"="US_L4CODE_2015")

site2011 <- c("Add Site Info (optional)"="", "Aggr. Ecoregion 3"="AGGR_ECO3_2015", "Aggr. Ecoregion 9"="AGGR_ECO9_2015", "COE Region"="COE_REGION", "County"="COUNTY", "HUC10"="HUC10", "LRR Name"="LRR_NAME", "LRR Symbol"="LRRSYM", "MLRA ID"="MLRA_ID",
              "MLRA Name"="MLRA_NAME", "NEP Name"="NEP_NAME", "Reference NWCA"="REF_NWCA", "US L3 Name"="US_L3NAME_2015", "US L3 Code"="US_L3CODE_2015", "Wetland Class"="NWCA_WET_GRP", "Wetland Class HGM"="CLASS_FIELD_HGM")

site2010 <- c("Add Site Info (optional)"="", "EPA Region"="EPA_REG", "NCA Region"="NCA_REGION", "NEP Name"="NEP_NM", "NPS Park"="NPSPARK", "RSRC Class"="RSRC_CLASS", "Province"="PROVINCE", "Station Depth"="STATION_DEPTH", "Waterbody Name"="WTBDY_NM")

site0809 <- c("Add Site Info (optional)"="", "Aggr. Ecoregion 3"="AGGR_ECO3_2015", "Aggr. Ecoregion 9"="AGGR_ECO9_2015", "EPA Region"="EPA_REG", "HUC8", "Location Name"="LOC_NAME", "Strahler Order"="STRAHLERORDER", "Urban/NonUrban"="URBAN", 
              "US L3 Code"="US_L3CODE_2015", "US L4 Code"="US_L4CODE_2015", "Watershed Area"="WSAREA_NARS")

site2007 <- c("Add Site Info (optional)"="", "Aggr. Ecoregion 3"="WSA_ECO3", "Aggr. Ecoregion 9"="WSA_ECO9", "Area (Hectares)"="AREA_HA", "County"="CNTYNAME", "Elevation"="ELEV_PT", "EPA Region"="EPA_REG", "HUC8"="HUC_8", "Lake Name"="LAKENAME", "Lake Origin"="LAKE_ORIGIN", "NES Lake"="NESLAKE",  
              "Lake Perimeter"="LAKEPERIM", "Lake Max Depth"="DEPTHMAX", "Urban/NonUrban"="URBAN")





# EPA Template ----

ui <- fluidPage(tags$html(class = "no-js", lang="en"),
                tags$head(
                  HTML(
                    "<!-- Google Tag Manager -->
		<script>(function(w,d,s,l,i){w[l]=w[l]||[];w[l].push({'gtm.start':
		new Date().getTime(),event:'gtm.js'});var f=d.getElementsByTagName(s)[0],
		j=d.createElement(s),dl=l!='dataLayer'?'&l='+l:'';j.async=true;j.src=
		'https://www.googletagmanager.com/gtm.js?id='+i+dl;f.parentNode.insertBefore(j,f);
		})(window,document,'script','dataLayer','GTM-L8ZB');</script>
		<!-- End Google Tag Manager -->
		"
                  ),
		tags$meta(charset="utf-8"),
		tags$meta(property="og:site_name", content="US EPA"),
		#tags$link(rel = "stylesheet", type = "text/css", href = "css/uswds.css"),
		tags$link(rel = "stylesheet", type = "text/css", href = "https://cdnjs.cloudflare.com/ajax/libs/uswds/3.0.0-beta.3/css/uswds.min.css", integrity="sha512-ZKvR1/R8Sgyx96aq5htbFKX84hN+zNXN73sG1dEHQTASpNA8Pc53vTbPsEKTXTZn9J4G7R5Il012VNsDEReqCA==", crossorigin="anonymous", referrerpolicy="no-referrer"),
		tags$meta(property="og:url", content="https://www.epa.gov/themes/epa_theme/pattern-lab/.markup-only.html"),
		tags$link(rel="canonical", href="https://www.epa.gov/themes/epa_theme/pattern-lab/.markup-only.html"),
		tags$link(rel="shortlink", href="https://www.epa.gov/themes/epa_theme/pattern-lab/.markup-only.html"),
		tags$meta(property="og:url", content="https://www.epa.gov/themes/epa_theme/pattern-lab/.markup-only.html"),
		tags$meta(property="og:image", content="https://www.epa.gov/sites/all/themes/epa/img/epa-standard-og.jpg"),
		tags$meta(property="og:image:width", content="1200"),
		tags$meta(property="og:image:height", content="630"),
		tags$meta(property="og:image:alt", content="U.S. Environmental Protection Agency"),
		tags$meta(name="twitter:card", content="summary_large_image"),
		tags$meta(name="twitter:image:alt", content="U.S. Environmental Protection Agency"),
		tags$meta(name="twitter:image:height", content="600"),
		tags$meta(name="twitter:image:width", content="1200"),
		tags$meta(name="twitter:image", content="https://www.epa.gov/sites/all/themes/epa/img/epa-standard-twitter.jpg"),
		tags$meta(name="MobileOptimized", content="width"),
		tags$meta(name="HandheldFriendly", content="true"),
		tags$meta(name="viewport", content="width=device-width, initial-scale=1.0"),
		tags$meta(`http-equiv`="x-ua-compatible", content="ie=edge"),
		tags$script(src = "js/pattern-lab-head-script.js"),
		tags$title('NARS Data Download Tool | US EPA'),
		tags$link(rel="icon", type="image/x-icon", href="https://www.epa.gov/themes/epa_theme/images/favicon.ico"),
		tags$meta(name="msapplication-TileColor", content="#FFFFFF"),
		tags$meta(name="msapplication-TileImage", content="https://www.epa.gov/themes/epa_theme/images/favicon-144.png"),
		tags$meta(name="application-name", content=""),
		tags$meta(name="msapplication-config", content="https://www.epa.gov/themes/epa_theme/images/ieconfig.xml"),
		tags$link(rel="apple-touch-icon-precomposed", sizes="196x196", href="https://www.epa.gov/themes/epa_theme/images/favicon-196.png"),
		tags$link(rel="apple-touch-icon-precomposed", sizes="152x152", href="https://www.epa.gov/themes/epa_theme/images/favicon-152.png"),
		tags$link(rel="apple-touch-icon-precomposed", sizes="144x144", href="https://www.epa.gov/themes/epa_theme/images/favicon-144.png"),
		tags$link(rel="apple-touch-icon-precomposed", sizes="120x120", href="https://www.epa.gov/themes/epa_theme/images/favicon-120.png"),
		tags$link(rel="apple-touch-icon-precomposed", sizes="114x114", href="https://www.epa.gov/themes/epa_theme/images/favicon-114.png"),
		tags$link(rel="apple-touch-icon-precomposed", sizes="72x72", href="https://www.epa.gov/themes/epa_theme/images/favicon-72.png"),
		tags$link(rel="apple-touch-icon-precomposed", href="https://www.epa.gov/themes/epa_theme/images/favicon-180.png"),
		tags$link(rel="icon", href="https://www.epa.gov/themes/epa_theme/images/favicon-32.png", sizes="32x32"),
		tags$link(rel="preload", href="https://www.epa.gov/themes/epa_theme/fonts/source-sans-pro/sourcesanspro-regular-webfont.woff2", as="font", crossorigin="anonymous"),
		tags$link(rel="preload", href="https://www.epa.gov/themes/epa_theme/fonts/source-sans-pro/sourcesanspro-bold-webfont.woff2", as="font", crossorigin="anonymous"),
		tags$link(rel="preload", href="https://www.epa.gov/themes/epa_theme/fonts/merriweather/Latin-Merriweather-Bold.woff2", as="font", crossorigin="anonymous"),
		tags$link(rel="stylesheet", media="all", href="https://www.epa.gov/core/themes/stable/css/system/components/ajax-progress.module.css?r6lsex"),
		tags$link(rel="stylesheet", media="all", href="https://www.epa.gov/core/themes/stable/css/system/components/autocomplete-loading.module.css?r6lsex" ),
		tags$link(rel="stylesheet", media="all", href="https://www.epa.gov/core/themes/stable/css/system/components/js.module.css?r6lsex"),
		tags$link(rel="stylesheet", media="all", href="https://www.epa.gov/core/themes/stable/css/system/components/sticky-header.module.css?r6lsex"),
		tags$link(rel="stylesheet", media="all", href="https://www.epa.gov/core/themes/stable/css/system/components/system-status-counter.css?r6lsex"),
		tags$link(rel="stylesheet", media="all", href="https://www.epa.gov/core/themes/stable/css/system/components/system-status-report-counters.css?r6lsex"),
		tags$link(rel="stylesheet", media="all", href="https://www.epa.gov/core/themes/stable/css/system/components/system-status-report-general-info.css?r6lsex"),
		tags$link(rel="stylesheet", media="all", href="https://www.epa.gov/core/themes/stable/css/system/components/tabledrag.module.css?r6lsex"),
		tags$link(rel="stylesheet", media="all", href="https://www.epa.gov/core/themes/stable/css/system/components/tablesort.module.css?r6lsex"),
		tags$link(rel="stylesheet", media="all", href="https://www.epa.gov/core/themes/stable/css/system/components/tree-child.module.css?r6lsex"),
		tags$link(rel="stylesheet", media="all", href="https://www.epa.gov/themes/epa_theme/css/styles.css?r6lsex"),
		tags$link(rel="stylesheet", media="all", href="https://www.epa.gov/themes/epa_theme/css-lib/colorbox.min.css?r6lsex"),
		
		tags$script(src = 'https://cdnjs.cloudflare.com/ajax/libs/uswds/3.0.0-beta.3/js/uswds-init.min.js'),
		#fix container-fluid that boostrap RShiny uses
		tags$style(HTML(
		  '.container-fluid {
            padding-right: 0;
            padding-left: 0;
            margin-right: 0;
            margin-left: 0;
        }
        .tab-content {
            margin-right: 30px;
            margin-left: 30px;
        }'
		))
                ),
		tags$body(
		  class="path-themes not-front has-wide-template", id="top",
		  tags$script(
		    src = 'https://cdnjs.cloudflare.com/ajax/libs/uswds/3.0.0-beta.3/js/uswds.min.js'
		  )
		),
		# Site Header
		HTML(
		  '<div class="skiplinks" role="navigation" aria-labelledby="skip-to-main">
      <a id="skip-to-main" href="#main" class="skiplinks__link visually-hidden focusable">Skip to main content</a>
    </div>

	<!-- Google Tag Manager (noscript) -->
	<noscript><iframe src=https://www.googletagmanager.com/ns.html?id=GTM-L8ZB
	height="0" width="0" style="display:none;visibility:hidden"></iframe></noscript>
	<!-- End Google Tag Manager (noscript) -->

    <div class="dialog-off-canvas-main-canvas" data-off-canvas-main-canvas>
    <section class="usa-banner" aria-label="Official government website">
      <div class="usa-accordion">
        <header class="usa-banner__header">
          <div class="usa-banner__inner">
            <div class="grid-col-auto">
              <img class="usa-banner__header-flag" src="https://www.epa.gov/themes/epa_theme/images/us_flag_small.png" alt="U.S. flag" />
            </div>
            <div class="grid-col-fill tablet:grid-col-auto">
              <p class="usa-banner__header-text">An official website of the United States government</p>
              <p class="usa-banner__header-action" aria-hidden="true">Here’s how you know</p>
            </div>
            <button class="usa-accordion__button usa-banner__button" aria-expanded="false" aria-controls="gov-banner">
              <span class="usa-banner__button-text">Here’s how you know</span>
            </button>
          </div>
        </header>
        <div class="usa-banner__content usa-accordion__content" id="gov-banner">
          <div class="grid-row grid-gap-lg">
            <div class="usa-banner__guidance tablet:grid-col-6">
              <img class="usa-banner__icon usa-media-block__img" src="https://www.epa.gov/themes/epa_theme/images/icon-dot-gov.svg" alt="Dot gov">
              <div class="usa-media-block__body">
                <p>
                  <strong>Official websites use .gov</strong>
                  <br> A <strong>.gov</strong> website belongs to an official government organization in the United States.
                </p>
              </div>
            </div>
            <div class="usa-banner__guidance tablet:grid-col-6">
              <img class="usa-banner__icon usa-media-block__img" src="https://www.epa.gov/themes/epa_theme/images/icon-https.svg" alt="HTTPS">
              <div class="usa-media-block__body">
                <p>
                  <strong>Secure .gov websites use HTTPS</strong>
                  <br> A <strong>lock</strong> (<span class="icon-lock"><svg xmlns="http://www.w3.org/2000/svg" width="52" height="64" viewBox="0 0 52 64" class="usa-banner__lock-image" role="img" aria-labelledby="banner-lock-title banner-lock-description"><title id="banner-lock-title">Lock</title><desc id="banner-lock-description">A locked padlock</desc><path fill="#000000" fill-rule="evenodd" d="M26 0c10.493 0 19 8.507 19 19v9h3a4 4 0 0 1 4 4v28a4 4 0 0 1-4 4H4a4 4 0 0 1-4-4V32a4 4 0 0 1 4-4h3v-9C7 8.507 15.507 0 26 0zm0 8c-5.979 0-10.843 4.77-10.996 10.712L15 19v9h22v-9c0-6.075-4.925-11-11-11z"/></svg></span>) or <strong>https://</strong> means you’ve safely connected to the .gov website. Share sensitive information only on official, secure websites.
                </p>
              </div>
            </div>
          </div>
        </div>
      </div>
    </section>
    <div>
      <div class="js-view-dom-id-epa-alerts--public">
        <noscript>
          <div class="usa-site-alert usa-site-alert--info">
            <div class="usa-alert">
              <div class="usa-alert__body">
                <div class="usa-alert__text">
                  <p>JavaScript appears to be disabled on this computer. Please <a href="/alerts">click here to see any active alerts</a>.</p>
                </div>
              </div>
            </div>
          </div>
        </noscript>
      </div>
    </div>
    <header class="l-header">
      <div class="usa-overlay"></div>
      <div class="l-constrain">
        <div class="l-header__navbar">
          <div class="l-header__branding">
            <a class="site-logo" href="/" aria-label="Home" title="Home" rel="home">
              <span class="site-logo__image">
                <svg class="site-logo__svg" viewBox="0 0 1061 147" aria-hidden="true" xmlns="http://www.w3.org/2000/svg">
                  <path d="M112.8 53.5C108 72.1 89.9 86.8 69.9 86.8c-20.1 0-38-14.7-42.9-33.4h.2s9.8 10.3-.2 0c3.1 3.1 6.2 4.4 10.7 4.4s7.7-1.3 10.7-4.4c3.1 3.1 6.3 4.5 10.9 4.4 4.5 0 7.6-1.3 10.7-4.4 3.1 3.1 6.2 4.4 10.7 4.4 4.5 0 7.7-1.3 10.7-4.4 3.1 3.1 6.3 4.5 10.9 4.4 4.3 0 7.4-1.2 10.5-4.3zM113.2 43.5c0-24-19.4-43.5-43.3-43.5-24 0-43.5 19.5-43.5 43.5h39.1c-4.8-1.8-8.1-6.3-8.1-11.6 0-7 5.7-12.5 12.5-12.5 7 0 12.7 5.5 12.7 12.5 0 5.2-3.1 9.6-7.6 11.6h38.2zM72.6 139.3c.7-36.9 29.7-68.8 66.9-70 0 37.2-30 68-66.9 70zM67.1 139.3c-.7-36.9-29.7-68.8-67.1-70 0 37.2 30.2 68 67.1 70zM240 3.1h-87.9v133.1H240v-20.4h-60.3v-36H240v-21h-60.3v-35H240V3.1zM272.8 58.8h27.1c9.1 0 15.2-8.6 15.1-17.7-.1-9-6.1-17.3-15.1-17.3h-25.3v112.4h-27.8V3.1h62.3c20.2 0 35 17.8 35.2 38 .2 20.4-14.8 38.7-35.2 38.7h-36.3v-21zM315.9 136.2h29.7l12.9-35h54.2l-8.1-21.9h-38.4l18.9-50.7 39.2 107.6H454L400.9 3.1h-33.7l-51.3 133.1zM473.3.8v22.4c0 1.9.2 3.3.5 4.3s.7 1.7 1 2.2c1.2 1.4 2.5 2.4 3.9 2.9 1.5.5 2.8.7 4.1.7 2.4 0 4.2-.4 5.5-1.3 1.3-.8 2.2-1.8 2.8-2.9.6-1.1.9-2.3 1-3.4.1-1.1.1-2 .1-2.6V.8h4.7v24c0 .7-.1 1.5-.4 2.4-.3 1.8-1.2 3.6-2.5 5.4-1.8 2.1-3.8 3.5-6 4.2-2.2.6-4 .9-5.3.9-1.8 0-3.8-.3-6.2-1.1-2.4-.8-4.5-2.3-6.2-4.7-.5-.8-1-1.8-1.4-3.2-.4-1.3-.6-3.3-.6-5.9V.8h5zM507.5 14.5v-2.9l4.6.1-.1 4.1c.2-.3.4-.7.8-1.2.3-.5.8-.9 1.4-1.4.6-.5 1.4-.9 2.3-1.3.9-.3 2.1-.5 3.4-.4.6 0 1.4.1 2.4.3.9.2 1.9.6 2.9 1.2s1.8 1.5 2.4 2.6c.6 1.2.9 2.8.9 4.7l-.4 17-4.6-.1.4-16c0-.9 0-1.7-.2-2.4-.1-.7-.5-1.3-1.1-1.9-1.2-1.2-2.6-1.8-4.3-1.8-1.7 0-3.1.5-4.4 1.7-1.3 1.2-2 3.1-2.1 5.7l-.3 14.5-4.5-.1.5-22.4zM537.2.9h5.5V6h-5.5V.9m.5 10.9h4.6v25.1h-4.6V11.8zM547.8 11.7h4.3V6.4l4.5-1.5v6.8h5.4v3.4h-5.4v15.1c0 .3 0 .6.1 1 0 .4.1.7.4 1.1.2.4.5.6 1 .8.4.3 1 .4 1.8.4 1 0 1.7-.1 2.2-.2V37c-.9.2-2.1.3-3.8.3-2.1 0-3.6-.4-4.6-1.2-1-.8-1.5-2.2-1.5-4.2V15.1h-4.3v-3.4zM570.9 25.2c-.1 2.6.5 4.8 1.7 6.5 1.1 1.7 2.9 2.6 5.3 2.6 1.5 0 2.8-.4 3.9-1.3 1-.8 1.6-2.2 1.8-4h4.6c0 .6-.2 1.4-.4 2.3-.3 1-.8 2-1.7 3-.2.3-.6.6-1 1-.5.4-1 .7-1.7 1.1-.7.4-1.5.6-2.4.8-.9.3-2 .4-3.3.4-7.6-.2-11.3-4.5-11.3-12.9 0-2.5.3-4.8 1-6.8s2-3.7 3.8-5.1c1.2-.8 2.4-1.3 3.7-1.6 1.3-.2 2.2-.3 3-.3 2.7 0 4.8.6 6.3 1.6s2.5 2.3 3.1 3.9c.6 1.5 1 3.1 1.1 4.6.1 1.6.1 2.9 0 4h-17.5m12.9-3v-1.1c0-.4 0-.8-.1-1.2-.1-.9-.4-1.7-.8-2.5s-1-1.5-1.8-2c-.9-.5-2-.8-3.4-.8-.8 0-1.5.1-2.3.3-.8.2-1.5.7-2.2 1.3-.7.6-1.2 1.3-1.6 2.3-.4 1-.7 2.2-.8 3.6h13zM612.9.9h4.6V33c0 1 .1 2.3.2 4h-4.6l-.1-4c-.2.3-.4.7-.7 1.2-.3.5-.8 1-1.4 1.5-1 .7-2 1.2-3.1 1.4l-1.5.3c-.5.1-.9.1-1.4.1-.4 0-.8 0-1.3-.1s-1.1-.2-1.7-.3c-1.1-.3-2.3-.9-3.4-1.8s-2.1-2.2-2.9-3.8c-.8-1.7-1.2-3.9-1.2-6.6.1-4.8 1.2-8.3 3.4-10.5 2.1-2.1 4.7-3.2 7.6-3.2 1.3 0 2.4.2 3.4.5.9.3 1.6.7 2.2 1.2.6.4 1 .9 1.3 1.4.3.5.6.8.7 1.1V.9m0 23.1c0-1.9-.2-3.3-.5-4.4-.4-1.1-.8-2-1.4-2.6-.5-.7-1.2-1.3-2-1.8-.9-.5-2-.7-3.3-.7-1.7 0-2.9.5-3.8 1.3-.9.8-1.6 1.9-2 3.1-.4 1.2-.7 2.3-.7 3.4-.1 1.1-.2 1.9-.1 2.4 0 1.1.1 2.2.3 3.4.2 1.1.5 2.2 1 3.1.5 1 1.2 1.7 2 2.3.9.6 2 .9 3.3.9 1.8 0 3.2-.5 4.2-1.4 1-.8 1.7-1.8 2.1-3 .4-1.2.7-2.4.8-3.4.1-1.4.1-2.1.1-2.6zM643.9 26.4c0 .6.1 1.3.3 2.1.1.8.5 1.6 1 2.3.5.8 1.4 1.4 2.5 1.9s2.7.8 4.7.8c1.8 0 3.3-.3 4.4-.8 1.1-.5 1.9-1.1 2.5-1.8.6-.7 1-1.5 1.1-2.2.1-.7.2-1.2.2-1.7 0-1-.2-1.9-.5-2.6-.4-.6-.9-1.2-1.6-1.6-1.4-.8-3.4-1.4-5.9-2-4.9-1.1-8.1-2.2-9.5-3.2-1.4-1-2.3-2.2-2.9-3.5-.6-1.2-.8-2.4-.8-3.6.1-3.7 1.5-6.4 4.2-8.1 2.6-1.7 5.7-2.5 9.1-2.5 1.3 0 2.9.2 4.8.5 1.9.4 3.6 1.4 5 3 .5.5.9 1.1 1.2 1.7.3.5.5 1.1.6 1.6.2 1.1.3 2.1.3 2.9h-5c-.2-2.2-1-3.7-2.4-4.5-1.5-.7-3.1-1.1-4.9-1.1-5.1.1-7.7 2-7.8 5.8 0 1.5.5 2.7 1.6 3.5 1 .8 2.6 1.4 4.7 1.9 4 1 6.7 1.8 8.1 2.2.8.2 1.4.5 1.8.7.5.2 1 .5 1.4.9.8.5 1.4 1.1 1.9 1.8s.8 1.4 1.1 2.1c.3 1.4.5 2.5.5 3.4 0 3.3-1.2 6-3.5 8-2.3 2.1-5.8 3.2-10.3 3.3-1.4 0-3.2-.3-5.4-.8-1-.3-2-.7-3-1.2-.9-.5-1.8-1.2-2.5-2.1-.9-1.4-1.5-2.7-1.7-4.1-.3-1.3-.4-2.4-.3-3.2h5zM670 11.7h4.3V6.4l4.5-1.5v6.8h5.4v3.4h-5.4v15.1c0 .3 0 .6.1 1 0 .4.1.7.4 1.1.2.4.5.6 1 .8.4.3 1 .4 1.8.4 1 0 1.7-.1 2.2-.2V37c-.9.2-2.1.3-3.8.3-2.1 0-3.6-.4-4.6-1.2-1-.8-1.5-2.2-1.5-4.2V15.1H670v-3.4zM705.3 36.9c-.3-1.2-.5-2.5-.4-3.7-.5 1-1.1 1.8-1.7 2.4-.7.6-1.4 1.1-2 1.4-1.4.5-2.7.8-3.7.8-2.8 0-4.9-.8-6.4-2.2-1.5-1.4-2.2-3.1-2.2-5.2 0-1 .2-2.3.8-3.7.6-1.4 1.7-2.6 3.5-3.7 1.4-.7 2.9-1.2 4.5-1.5 1.6-.1 2.9-.2 3.9-.2s2.1 0 3.3.1c.1-2.9-.2-4.8-.9-5.6-.5-.6-1.1-1.1-1.9-1.3-.8-.2-1.6-.4-2.3-.4-1.1 0-2 .2-2.6.5-.7.3-1.2.7-1.5 1.2-.3.5-.5.9-.6 1.4-.1.5-.2.9-.2 1.2h-4.6c.1-.7.2-1.4.4-2.3.2-.8.6-1.6 1.3-2.5.5-.6 1-1 1.7-1.3.6-.3 1.3-.6 2-.8 1.5-.4 2.8-.6 4.2-.6 1.8 0 3.6.3 5.2.9 1.6.6 2.8 1.6 3.4 2.9.4.7.6 1.4.7 2 .1.6.1 1.2.1 1.8l-.2 12c0 1 .1 3.1.4 6.3h-4.2m-.5-12.1c-.7-.1-1.6-.1-2.6-.1h-2.1c-1 .1-2 .3-3 .6s-1.9.8-2.6 1.5c-.8.7-1.2 1.7-1.2 3 0 .4.1.8.2 1.3s.4 1 .8 1.5.9.8 1.6 1.1c.7.3 1.5.5 2.5.5 2.3 0 4.1-.9 5.2-2.7.5-.8.8-1.7 1-2.7.1-.9.2-2.2.2-4zM714.5 11.7h4.3V6.4l4.5-1.5v6.8h5.4v3.4h-5.4v15.1c0 .3 0 .6.1 1 0 .4.1.7.4 1.1.2.4.5.6 1 .8.4.3 1 .4 1.8.4 1 0 1.7-.1 2.2-.2V37c-.9.2-2.1.3-3.8.3-2.1 0-3.6-.4-4.6-1.2-1-.8-1.5-2.2-1.5-4.2V15.1h-4.3v-3.4zM737.6 25.2c-.1 2.6.5 4.8 1.7 6.5 1.1 1.7 2.9 2.6 5.3 2.6 1.5 0 2.8-.4 3.9-1.3 1-.8 1.6-2.2 1.8-4h4.6c0 .6-.2 1.4-.4 2.3-.3 1-.8 2-1.7 3-.2.3-.6.6-1 1-.5.4-1 .7-1.7 1.1-.7.4-1.5.6-2.4.8-.9.3-2 .4-3.3.4-7.6-.2-11.3-4.5-11.3-12.9 0-2.5.3-4.8 1-6.8s2-3.7 3.8-5.1c1.2-.8 2.4-1.3 3.7-1.6 1.3-.2 2.2-.3 3-.3 2.7 0 4.8.6 6.3 1.6s2.5 2.3 3.1 3.9c.6 1.5 1 3.1 1.1 4.6.1 1.6.1 2.9 0 4h-17.5m12.9-3v-1.1c0-.4 0-.8-.1-1.2-.1-.9-.4-1.7-.8-2.5s-1-1.5-1.8-2c-.9-.5-2-.8-3.4-.8-.8 0-1.5.1-2.3.3-.8.2-1.5.7-2.2 1.3-.7.6-1.2 1.3-1.6 2.3-.4 1-.7 2.2-.8 3.6h13zM765.3 29.5c0 .5.1 1 .2 1.4.1.5.4 1 .8 1.5s.9.8 1.6 1.1c.7.3 1.6.5 2.7.5 1 0 1.8-.1 2.5-.3.7-.2 1.3-.6 1.7-1.2.5-.7.8-1.5.8-2.4 0-1.2-.4-2-1.3-2.5s-2.2-.9-4.1-1.2c-1.3-.3-2.4-.6-3.6-1-1.1-.3-2.1-.8-3-1.3-.9-.5-1.5-1.2-2-2.1-.5-.8-.8-1.9-.8-3.2 0-2.4.9-4.2 2.6-5.6 1.7-1.3 4-2 6.8-2.1 1.6 0 3.3.3 5 .8 1.7.6 2.9 1.6 3.7 3.1.4 1.4.6 2.6.6 3.7h-4.6c0-1.8-.6-3-1.7-3.5-1.1-.4-2.1-.6-3.1-.6h-1c-.5 0-1.1.2-1.7.4-.6.2-1.1.5-1.5 1.1-.5.5-.7 1.2-.7 2.1 0 1.1.5 1.9 1.3 2.3.7.4 1.5.7 2.1.9 3.3.7 5.6 1.3 6.9 1.8 1.3.4 2.2 1 2.8 1.7.7.7 1.1 1.4 1.4 2.2.3.8.4 1.6.4 2.5 0 1.4-.3 2.7-.9 3.8-.6 1.1-1.4 2-2.4 2.6-1.1.6-2.2 1-3.4 1.3-1.2.3-2.5.4-3.8.4-2.5 0-4.7-.6-6.6-1.8-1.8-1.2-2.8-3.3-2.9-6.3h5.2zM467.7 50.8h21.9V55h-17.1v11.3h16.3v4.2h-16.3v12.1H490v4.3h-22.3zM499 64.7l-.1-2.9h4.6v4.1c.2-.3.4-.8.7-1.2.3-.5.8-1 1.3-1.5.6-.5 1.4-1 2.3-1.3.9-.3 2-.5 3.4-.5.6 0 1.4.1 2.4.2.9.2 1.9.5 2.9 1.1 1 .6 1.8 1.4 2.5 2.5.6 1.2 1 2.7 1 4.7V87h-4.6V71c0-.9-.1-1.7-.2-2.4-.2-.7-.5-1.3-1.1-1.9-1.2-1.1-2.6-1.7-4.3-1.7-1.7 0-3.1.6-4.3 1.8-1.3 1.2-2 3.1-2 5.7V87H499V64.7zM524.6 61.8h5.1l7.7 19.9 7.6-19.9h5l-10.6 25.1h-4.6zM555.7 50.9h5.5V56h-5.5v-5.1m.5 10.9h4.6v25.1h-4.6V61.8zM570.3 67c0-1.8-.1-3.5-.3-5.1h4.6l.1 4.9c.5-1.8 1.4-3 2.5-3.7 1.1-.7 2.2-1.2 3.3-1.3 1.4-.2 2.4-.2 3.1-.1v4.6c-.2-.1-.5-.2-.9-.2h-1.3c-1.3 0-2.4.2-3.3.5-.9.4-1.5.9-2 1.6-.9 1.4-1.4 3.2-1.3 5.4v13.3h-4.6V67zM587.6 74.7c0-1.6.2-3.2.6-4.8.4-1.6 1.1-3 2-4.4 1-1.3 2.2-2.4 3.8-3.2 1.6-.8 3.6-1.2 5.9-1.2 2.4 0 4.5.4 6.1 1.3 1.5.9 2.7 2 3.6 3.3.9 1.3 1.5 2.8 1.8 4.3.2.8.3 1.5.4 2.2v2.2c0 3.7-1 6.9-3 9.5-2 2.6-5.1 4-9.3 4-4-.1-7-1.4-9-3.9-1.9-2.5-2.9-5.6-2.9-9.3m4.8-.3c0 2.7.6 5 1.8 6.9 1.2 2 3 3 5.6 3.1.9 0 1.8-.2 2.7-.5.8-.3 1.6-.9 2.3-1.7.7-.8 1.3-1.9 1.8-3.2.4-1.3.6-2.9.6-4.7-.1-6.4-2.5-9.6-7.1-9.6-.7 0-1.5.1-2.4.3-.8.3-1.7.8-2.5 1.6-.8.7-1.4 1.7-1.9 3-.6 1.1-.9 2.8-.9 4.8zM620.2 64.7l-.1-2.9h4.6v4.1c.2-.3.4-.8.7-1.2.3-.5.8-1 1.3-1.5.6-.5 1.4-1 2.3-1.3.9-.3 2-.5 3.4-.5.6 0 1.4.1 2.4.2.9.2 1.9.5 2.9 1.1 1 .6 1.8 1.4 2.5 2.5.6 1.2 1 2.7 1 4.7V87h-4.6V71c0-.9-.1-1.7-.2-2.4-.2-.7-.5-1.3-1.1-1.9-1.2-1.1-2.6-1.7-4.3-1.7-1.7 0-3.1.6-4.3 1.8-1.3 1.2-2 3.1-2 5.7V87h-4.6V64.7zM650 65.1l-.1-3.3h4.6v3.6c1.2-1.9 2.6-3.2 4.1-3.7 1.5-.4 2.7-.6 3.8-.6 1.4 0 2.6.2 3.6.5.9.3 1.7.7 2.3 1.1 1.1 1 1.9 2 2.3 3.1.2-.4.5-.8 1-1.3.4-.5.9-1 1.5-1.6.6-.5 1.5-.9 2.5-1.3 1-.3 2.2-.5 3.5-.5.9 0 1.9.1 3 .3 1 .2 2 .7 3 1.3 1 .6 1.7 1.5 2.3 2.7.6 1.2.9 2.7.9 4.6v16.9h-4.6V70.7c0-1.1-.1-2-.2-2.5-.1-.6-.3-1-.6-1.3-.4-.6-1-1.2-1.8-1.6-.8-.4-1.8-.6-3.1-.6-1.5 0-2.7.4-3.6 1-.4.3-.8.5-1.1.9l-.8.8c-.5.8-.8 1.8-1 2.8-.1 1.1-.2 2-.1 2.6v14.1h-4.6V70.2c0-1.6-.5-2.9-1.4-4-.9-1-2.3-1.5-4.2-1.5-1.6 0-2.9.4-3.8 1.1-.9.7-1.5 1.2-1.8 1.7-.5.7-.8 1.5-.9 2.5-.1.9-.2 1.8-.2 2.6v14.3H650V65.1zM700.5 75.2c-.1 2.6.5 4.8 1.7 6.5 1.1 1.7 2.9 2.6 5.3 2.6 1.5 0 2.8-.4 3.9-1.3 1-.8 1.6-2.2 1.8-4h4.6c0 .6-.2 1.4-.4 2.3-.3 1-.8 2-1.7 3-.2.3-.6.6-1 1-.5.4-1 .7-1.7 1.1-.7.4-1.5.6-2.4.8-.9.3-2 .4-3.3.4-7.6-.2-11.3-4.5-11.3-12.9 0-2.5.3-4.8 1-6.8s2-3.7 3.8-5.1c1.2-.8 2.4-1.3 3.7-1.6 1.3-.2 2.2-.3 3-.3 2.7 0 4.8.6 6.3 1.6s2.5 2.3 3.1 3.9c.6 1.5 1 3.1 1.1 4.6.1 1.6.1 2.9 0 4h-17.5m12.8-3v-1.1c0-.4 0-.8-.1-1.2-.1-.9-.4-1.7-.8-2.5s-1-1.5-1.8-2c-.9-.5-2-.8-3.4-.8-.8 0-1.5.1-2.3.3-.8.2-1.5.7-2.2 1.3-.7.6-1.2 1.3-1.6 2.3-.4 1-.7 2.2-.8 3.6h13zM725.7 64.7l-.1-2.9h4.6v4.1c.2-.3.4-.8.7-1.2.3-.5.8-1 1.3-1.5.6-.5 1.4-1 2.3-1.3.9-.3 2-.5 3.4-.5.6 0 1.4.1 2.4.2.9.2 1.9.5 2.9 1.1 1 .6 1.8 1.4 2.5 2.5.6 1.2 1 2.7 1 4.7V87h-4.6V71c0-.9-.1-1.7-.2-2.4-.2-.7-.5-1.3-1.1-1.9-1.2-1.1-2.6-1.7-4.3-1.7-1.7 0-3.1.6-4.3 1.8-1.3 1.2-2 3.1-2 5.7V87h-4.6V64.7zM752.3 61.7h4.3v-5.2l4.5-1.5v6.8h5.4v3.4h-5.4v15.1c0 .3 0 .6.1 1 0 .4.1.7.4 1.1.2.4.5.6 1 .8.4.3 1 .4 1.8.4 1 0 1.7-.1 2.2-.2V87c-.9.2-2.1.3-3.8.3-2.1 0-3.6-.4-4.6-1.2-1-.8-1.5-2.2-1.5-4.2V65.1h-4.3v-3.4zM787.6 86.9c-.3-1.2-.5-2.5-.4-3.7-.5 1-1.1 1.8-1.7 2.4-.7.6-1.4 1.1-2 1.4-1.4.5-2.7.8-3.7.8-2.8 0-4.9-.8-6.4-2.2-1.5-1.4-2.2-3.1-2.2-5.2 0-1 .2-2.3.8-3.7.6-1.4 1.7-2.6 3.5-3.7 1.4-.7 2.9-1.2 4.5-1.5 1.6-.1 2.9-.2 3.9-.2s2.1 0 3.3.1c.1-2.9-.2-4.8-.9-5.6-.5-.6-1.1-1.1-1.9-1.3-.8-.2-1.6-.4-2.3-.4-1.1 0-2 .2-2.6.5-.7.3-1.2.7-1.5 1.2-.3.5-.5.9-.6 1.4-.1.5-.2.9-.2 1.2h-4.6c.1-.7.2-1.4.4-2.3.2-.8.6-1.6 1.3-2.5.5-.6 1-1 1.7-1.3.6-.3 1.3-.6 2-.8 1.5-.4 2.8-.6 4.2-.6 1.8 0 3.6.3 5.2.9 1.6.6 2.8 1.6 3.4 2.9.4.7.6 1.4.7 2 .1.6.1 1.2.1 1.8l-.2 12c0 1 .1 3.1.4 6.3h-4.2m-.5-12.1c-.7-.1-1.6-.1-2.6-.1h-2.1c-1 .1-2 .3-3 .6s-1.9.8-2.6 1.5c-.8.7-1.2 1.7-1.2 3 0 .4.1.8.2 1.3s.4 1 .8 1.5.9.8 1.6 1.1c.7.3 1.5.5 2.5.5 2.3 0 4.1-.9 5.2-2.7.5-.8.8-1.7 1-2.7.1-.9.2-2.2.2-4zM800.7 50.9h4.6V87h-4.6zM828.4 50.8h11.7c2.1 0 3.9.1 5.5.4.8.2 1.5.4 2.2.9.7.4 1.3.9 1.8 1.6 1.7 1.9 2.6 4.2 2.6 7 0 2.7-.9 5.1-2.8 7.1-.8.9-2 1.7-3.6 2.2-1.6.6-3.9.9-6.9.9h-5.7V87h-4.8V50.8m4.8 15.9h5.8c.8 0 1.7-.1 2.6-.2.9-.1 1.8-.3 2.6-.7.8-.4 1.5-1 2-1.9.5-.8.8-2 .8-3.4s-.2-2.5-.7-3.3c-.5-.8-1.1-1.3-1.9-1.7-1.6-.5-3.1-.8-4.5-.7h-6.8v11.9zM858.1 67c0-1.8-.1-3.5-.3-5.1h4.6l.1 4.9c.5-1.8 1.4-3 2.5-3.7 1.1-.7 2.2-1.2 3.3-1.3 1.4-.2 2.4-.2 3.1-.1v4.6c-.2-.1-.5-.2-.9-.2h-1.3c-1.3 0-2.4.2-3.3.5-.9.4-1.5.9-2 1.6-.9 1.4-1.4 3.2-1.3 5.4v13.3H858V67zM875.5 74.7c0-1.6.2-3.2.6-4.8.4-1.6 1.1-3 2-4.4 1-1.3 2.2-2.4 3.8-3.2 1.6-.8 3.6-1.2 5.9-1.2 2.4 0 4.5.4 6.1 1.3 1.5.9 2.7 2 3.6 3.3.9 1.3 1.5 2.8 1.8 4.3.2.8.3 1.5.4 2.2v2.2c0 3.7-1 6.9-3 9.5-2 2.6-5.1 4-9.3 4-4-.1-7-1.4-9-3.9-1.9-2.5-2.9-5.6-2.9-9.3m4.8-.3c0 2.7.6 5 1.8 6.9 1.2 2 3 3 5.6 3.1.9 0 1.8-.2 2.7-.5.8-.3 1.6-.9 2.3-1.7.7-.8 1.3-1.9 1.8-3.2.4-1.3.6-2.9.6-4.7-.1-6.4-2.5-9.6-7.1-9.6-.7 0-1.5.1-2.4.3-.8.3-1.7.8-2.5 1.6-.8.7-1.4 1.7-1.9 3-.7 1.1-.9 2.8-.9 4.8zM904.1 61.7h4.3v-5.2l4.5-1.5v6.8h5.4v3.4h-5.4v15.1c0 .3 0 .6.1 1 0 .4.1.7.4 1.1.2.4.5.6 1 .8.4.3 1 .4 1.8.4 1 0 1.7-.1 2.2-.2V87c-.9.2-2.1.3-3.8.3-2.1 0-3.6-.4-4.6-1.2-1-.8-1.5-2.2-1.5-4.2V65.1h-4.3v-3.4zM927.2 75.2c-.1 2.6.5 4.8 1.7 6.5 1.1 1.7 2.9 2.6 5.3 2.6 1.5 0 2.8-.4 3.9-1.3 1-.8 1.6-2.2 1.8-4h4.6c0 .6-.2 1.4-.4 2.3-.3 1-.8 2-1.7 3-.2.3-.6.6-1 1-.5.4-1 .7-1.7 1.1-.7.4-1.5.6-2.4.8-.9.3-2 .4-3.3.4-7.6-.2-11.3-4.5-11.3-12.9 0-2.5.3-4.8 1-6.8s2-3.7 3.8-5.1c1.2-.8 2.4-1.3 3.7-1.6 1.3-.2 2.2-.3 3-.3 2.7 0 4.8.6 6.3 1.6s2.5 2.3 3.1 3.9c.6 1.5 1 3.1 1.1 4.6.1 1.6.1 2.9 0 4h-17.5m12.9-3v-1.1c0-.4 0-.8-.1-1.2-.1-.9-.4-1.7-.8-2.5s-1-1.5-1.8-2c-.9-.5-2-.8-3.4-.8-.8 0-1.5.1-2.3.3-.8.2-1.5.7-2.2 1.3-.7.6-1.2 1.3-1.6 2.3-.4 1-.7 2.2-.8 3.6h13zM966.1 69.8c0-.3 0-.8-.1-1.4-.1-.6-.3-1.1-.6-1.8-.2-.6-.7-1.2-1.4-1.6-.7-.4-1.6-.6-2.7-.6-1.5 0-2.7.4-3.5 1.2-.9.8-1.5 1.7-1.9 2.8-.4 1.1-.6 2.2-.7 3.2-.1 1.1-.2 1.8-.1 2.4 0 1.3.1 2.5.3 3.7.2 1.2.5 2.3.9 3.3.8 2 2.4 3 4.8 3.1 1.9 0 3.3-.7 4.1-1.9.8-1.1 1.2-2.3 1.2-3.6h4.6c-.2 2.5-1.1 4.6-2.7 6.3-1.7 1.8-4.1 2.7-7.1 2.7-.9 0-2.1-.2-3.6-.6-.7-.2-1.4-.6-2.2-1-.8-.4-1.5-1-2.2-1.7-.7-.9-1.4-2.1-2-3.6-.6-1.5-.9-3.5-.9-6.1 0-2.6.4-4.8 1.1-6.6.7-1.7 1.6-3.1 2.7-4.2 1.1-1 2.3-1.8 3.6-2.2 1.3-.4 2.5-.6 3.7-.6h1.6c.6.1 1.3.2 1.9.4.7.2 1.4.5 2.1 1 .7.4 1.3 1 1.8 1.7.9 1.1 1.4 2.1 1.7 3.1.2 1 .3 1.8.3 2.6h-4.7zM973.6 61.7h4.3v-5.2l4.5-1.5v6.8h5.4v3.4h-5.4v15.1c0 .3 0 .6.1 1 0 .4.1.7.4 1.1.2.4.5.6 1 .8.4.3 1 .4 1.8.4 1 0 1.7-.1 2.2-.2V87c-.9.2-2.1.3-3.8.3-2.1 0-3.6-.4-4.6-1.2-1-.8-1.5-2.2-1.5-4.2V65.1h-4.3v-3.4zM993.5 50.9h5.5V56h-5.5v-5.1m.5 10.9h4.6v25.1H994V61.8zM1006.1 74.7c0-1.6.2-3.2.6-4.8.4-1.6 1.1-3 2-4.4 1-1.3 2.2-2.4 3.8-3.2 1.6-.8 3.6-1.2 5.9-1.2 2.4 0 4.5.4 6.1 1.3 1.5.9 2.7 2 3.6 3.3.9 1.3 1.5 2.8 1.8 4.3.2.8.3 1.5.4 2.2v2.2c0 3.7-1 6.9-3 9.5-2 2.6-5.1 4-9.3 4-4-.1-7-1.4-9-3.9-1.9-2.5-2.9-5.6-2.9-9.3m4.7-.3c0 2.7.6 5 1.8 6.9 1.2 2 3 3 5.6 3.1.9 0 1.8-.2 2.7-.5.8-.3 1.6-.9 2.3-1.7.7-.8 1.3-1.9 1.8-3.2.4-1.3.6-2.9.6-4.7-.1-6.4-2.5-9.6-7.1-9.6-.7 0-1.5.1-2.4.3-.8.3-1.7.8-2.5 1.6-.8.7-1.4 1.7-1.9 3-.6 1.1-.9 2.8-.9 4.8zM1038.6 64.7l-.1-2.9h4.6v4.1c.2-.3.4-.8.7-1.2.3-.5.8-1 1.3-1.5.6-.5 1.4-1 2.3-1.3.9-.3 2-.5 3.4-.5.6 0 1.4.1 2.4.2.9.2 1.9.5 2.9 1.1 1 .6 1.8 1.4 2.5 2.5.6 1.2 1 2.7 1 4.7V87h-4.6V71c0-.9-.1-1.7-.2-2.4-.2-.7-.5-1.3-1.1-1.9-1.2-1.1-2.6-1.7-4.3-1.7-1.7 0-3.1.6-4.3 1.8-1.3 1.2-2 3.1-2 5.7V87h-4.6V64.7zM479.1 100.8h5.2l14.1 36.1h-5.3l-3.8-9.4h-16.2l-3.8 9.4h-5l14.8-36.1m-4.4 22.7H488l-6.5-17.8-6.8 17.8zM508.7 138.8c.1.7.2 1.4.4 1.9.2.6.5 1.1.9 1.6.8.9 2.3 1.4 4.4 1.5 1.6 0 2.8-.3 3.7-.9.9-.6 1.5-1.4 1.9-2.4.4-1.1.6-2.3.7-3.7.1-1.4.1-2.9.1-4.6-.5.9-1.1 1.7-1.8 2.3-.7.6-1.5 1-2.3 1.3-1.7.4-3 .6-3.9.6-1.2 0-2.4-.2-3.8-.6-1.4-.4-2.6-1.2-3.7-2.5-1-1.3-1.7-2.8-2.1-4.4-.4-1.6-.6-3.2-.6-4.8 0-4.3 1.1-7.4 3.2-9.5 2-2.1 4.6-3.1 7.6-3.1 1.3 0 2.3.1 3.2.4.9.3 1.6.6 2.1 1 .6.4 1.1.8 1.5 1.2l.9 1.2v-3.4h4.4l-.1 4.5v15.7c0 2.9-.1 5.2-.2 6.7-.2 1.6-.5 2.8-1 3.7-1.1 1.9-2.6 3.2-4.6 3.7-1.9.6-3.8.8-5.6.8-2.4 0-4.3-.3-5.6-.8-1.4-.5-2.4-1.2-3-2-.6-.8-1-1.7-1.2-2.7-.2-.9-.3-1.8-.4-2.7h4.9m5.3-5.8c1.4 0 2.5-.2 3.3-.7.8-.5 1.5-1.1 2-1.8.5-.6.9-1.4 1.2-2.5.3-1 .4-2.6.4-4.8 0-1.6-.2-2.9-.4-3.9-.3-1-.8-1.8-1.4-2.4-1.3-1.4-3-2.2-5.2-2.2-1.4 0-2.5.3-3.4 1-.9.7-1.6 1.5-2 2.4-.4 1-.7 2-.9 3-.2 1-.2 2-.2 2.8 0 1 .1 1.9.3 2.9.2 1.1.5 2.1 1 3 .5.9 1.2 1.6 2 2.2.8.7 1.9 1 3.3 1zM537.6 125.2c-.1 2.6.5 4.8 1.7 6.5 1.1 1.7 2.9 2.6 5.3 2.6 1.5 0 2.8-.4 3.9-1.3 1-.8 1.6-2.2 1.8-4h4.6c0 .6-.2 1.4-.4 2.3-.3 1-.8 2-1.7 3-.2.3-.6.6-1 1-.5.4-1 .7-1.7 1.1-.7.4-1.5.6-2.4.8-.9.3-2 .4-3.3.4-7.6-.2-11.3-4.5-11.3-12.9 0-2.5.3-4.8 1-6.8s2-3.7 3.8-5.1c1.2-.8 2.4-1.3 3.7-1.6 1.3-.2 2.2-.3 3-.3 2.7 0 4.8.6 6.3 1.6s2.5 2.3 3.1 3.9c.6 1.5 1 3.1 1.1 4.6.1 1.6.1 2.9 0 4h-17.5m12.9-3v-1.1c0-.4 0-.8-.1-1.2-.1-.9-.4-1.7-.8-2.5s-1-1.5-1.8-2.1c-.9-.5-2-.8-3.4-.8-.8 0-1.5.1-2.3.3-.8.2-1.5.7-2.2 1.3-.7.6-1.2 1.3-1.6 2.3-.4 1-.7 2.2-.8 3.7h13zM562.9 114.7l-.1-2.9h4.6v4.1c.2-.3.4-.8.7-1.2.3-.5.8-1 1.3-1.5.6-.5 1.4-1 2.3-1.3.9-.3 2-.5 3.4-.5.6 0 1.4.1 2.4.2.9.2 1.9.5 2.9 1.1 1 .6 1.8 1.4 2.5 2.5.6 1.2 1 2.7 1 4.7V137h-4.6v-16c0-.9-.1-1.7-.2-2.4-.2-.7-.5-1.3-1.1-1.9-1.2-1.1-2.6-1.7-4.3-1.7-1.7 0-3.1.6-4.3 1.8-1.3 1.2-2 3.1-2 5.7V137h-4.6v-22.3zM607 119.8c0-.3 0-.8-.1-1.4-.1-.6-.3-1.1-.6-1.8-.2-.6-.7-1.2-1.4-1.6-.7-.4-1.6-.6-2.7-.6-1.5 0-2.7.4-3.5 1.2-.9.8-1.5 1.7-1.9 2.8-.4 1.1-.6 2.2-.7 3.2-.1 1.1-.2 1.8-.1 2.4 0 1.3.1 2.5.3 3.7.2 1.2.5 2.3.9 3.3.8 2 2.4 3 4.8 3.1 1.9 0 3.3-.7 4.1-1.9.8-1.1 1.2-2.3 1.2-3.6h4.6c-.2 2.5-1.1 4.6-2.7 6.3-1.7 1.8-4.1 2.7-7.1 2.7-.9 0-2.1-.2-3.6-.6-.7-.2-1.4-.6-2.2-1-.8-.4-1.5-1-2.2-1.7-.7-.9-1.4-2.1-2-3.6-.6-1.5-.9-3.5-.9-6.1 0-2.6.4-4.8 1.1-6.6.7-1.7 1.6-3.1 2.7-4.2 1.1-1 2.3-1.8 3.6-2.2 1.3-.4 2.5-.6 3.7-.6h1.6c.6.1 1.3.2 1.9.4.7.2 1.4.5 2.1 1 .7.4 1.3 1 1.8 1.7.9 1.1 1.4 2.1 1.7 3.1.2 1 .3 1.8.3 2.6H607zM629.1 137.1l-3.4 9.3H621l3.8-9.6-10.3-25h5.2l7.6 19.8 7.7-19.8h5z"/>
                </svg>
              </span>
            </a>
            <button class="usa-menu-btn usa-button l-header__menu-button">Menu</button>
          </div>
          <div class="l-header__search">
            <form class="usa-search usa-search--small usa-search--epa" method="get" action="https://search.epa.gov/epasearch">
              <div role="search">
                <label class="usa-sr-only" for="search-box">Search</label>
                <input class="usa-input" id="search-box" type="search" name="querytext" placeholder="Search EPA.gov">
                <!-- button class="usa-button" type="submit" --> <!-- type="submit" - removed for now to allow other unrendered buttons to render when triggered in RShiny app -->
                <!-- see: https://github.com/rstudio/shiny/issues/2922 -->
                <button class="usa-button usa-search__submit" style="height:2rem;margin:0;padding:0;padding-left:1rem;padding-right:1rem;border-top-left-radius: 0;border-bottom-left-radius: 0;">
                  <span class="usa-sr-only">Search</span>
                </button>
                <input type="hidden" name="areaname" value="">
                <input type="hidden" name="areacontacts" value="">
                <input type="hidden" name="areasearchurl" value="">
                <input type="hidden" name="typeofsearch" value="epa">
                <input type="hidden" name="result_template" value="">
              </div>
            </form>
          </div>
        </div>
      </div>
      <div class="l-header__nav">
        <nav class="usa-nav usa-nav--epa" role="navigation" aria-label="EPA header navigation">
          <div class="usa-nav__inner">
            <button class="usa-nav__close" aria-label="Close">
              <svg class="icon icon--nav-close" aria-hidden="true" role="img">
                <title>Primary navigation</title>
                <use xlink:href="https://www.epa.gov/themes/epa_theme/images/sprite.artifact.svg#close"></use>
              </svg> </button>
            <div class="usa-nav__menu">
               <ul class="menu menu--main">
                <li class="menu__item"><a href="https://www.epa.gov/environmental-topics" class="menu__link">Environmental Topics</a></li>
                <li class="menu__item"><a href="https://www.epa.gov/laws-regulations" class="menu__link" >Laws &amp; Regulations</a></li>
                <li class="menu__item"><a href="https://www.epa.gov/report-violation" class="menu__link" >Report a Violation</a></li>
                <li class="menu__item"><a href="https://www.epa.gov/aboutepa" class="menu__link" >About EPA</a></li>
              </ul>
            </div>
          </div>
        </nav>
      </div>
    </header>
    <main id="main" class="main" role="main" tabindex="-1">'
		),
	
	# Individual Page Header
	HTML(
	  '<div class="l-page  has-footer">
      <div class="l-constrain">
        <div class="l-page__header">
          <div class="l-page__header-first">
            <div class="web-area-title"></div>
          </div>
          <div class="l-page__header-last">
            <a href="https://www.epa.gov/national-aquatic-resource-surveys/forms/contact-us-about-national-aquatic-resource-surveys" class="header-link">Contact Us</a>
          </div>
        </div>
        <article class="article">'
	),
	####UI####
                theme = bs_theme(version = 3, bootswatch = "flatly"),
                useShinyjs(),
	tags$head(
	  tags$style(HTML("
                  a.action-button {
                    color: #00ff00;}
                  
                  .navbar-nav > li > a, .navbar-brand {
                   padding-top: 10px !important; 
                   height: 60px;
                   line-height: 1;}
                  
                  navbar-nav>.active>a:hover, .navbar-default .navbar-nav>.active>a:focus {
	                  color: #18BC9C;
	                  background-color: #2C3E50;
	                  padding-bottom: 10px;}
                  
                  .sweet-alert {
	                  max-height: calc(100% - 20px);
	                  top: 60%;}
                  
                  .shiny-output-error-validation {color: #ff0000; font-weight: bold;}
                  
                  .dataTables_scrollBody {transform:rotateX(180deg);}
                  .dataTables_scrollBody table {transform:rotateX(180deg);}
                  
                  .has-feedback .form-control { padding-right: 0px;}
                  "))
      	),
	        suppressWarnings(
                navbarPage(title = tagList(span("NARS Data Download Tool", style = "padding: 10px; font-weight: bold; font-size: 35px",
                                           actionLink("sidebar_button","", icon = icon("bars")))),
                           id = "navbar",
                           div(class="sidebar", 
                               sidebarPanel(#width = 3,
                                        #Survey Input
                                        fluidRow(
                                          column(7,
                                        selectInput(inputId = "Survey",
                                                    label = strong("Select Survey"),
                                                    choices = c("Rivers and Streams (NRSA)"="nrsa", "Lakes (NLA)"="nla", 
                                                                "Coastal (NCCA)"="ncca", "Wetlands (NWCA)"="nwca"),
                                                    selected = NULL,
                                                    multiple = FALSE, 
                                                    width = "230px") %>%
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
                                                    width = "230px") %>%
                                          #Survey helper
                                          helper(type = "inline",
                                                 title = "NARS Survey Year",
                                                 icon = "circle-question",
                                                 content = c("The four National Aquatic Resource Surveys are conducted on a five-year cycle with the Streams 
                                                             and Rivers survey requiring two years to complete."),
                                                 size = "s", easyClose = TRUE, fade = TRUE)
                                        )),
                                        fluidRow(
                                          column(9,
                                        conditionalPanel(
                                          condition = "input.Survey == 'ncca' & input.Year == '2015'",
                                          radioButtons(inputId = "NCCA_Type",
                                                       label = strong("Select Resource Type"),
                                                       choices = c("Estuarine"="estuarine", "Great Lakes"="great_lakes"),
                                                       selected = "estuarine",
                                                       inline=TRUE)),
                                        #Indicator Input
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
                                                             downloading dataset an a .XLSX file, metadata will be stored as seperate sheet."),
                                                 size = "s", easyClose = TRUE, fade = TRUE),
                                        #State Input
                                      #  conditionalPanel(
                                       #   condition="input.navbar !== 'metadata'",
                                        selectInput(inputId = "State",
                                                    label = strong("Select State(s) of Interest"),
                                                    choices = c("Choose State(s)"="", "All States", state_name),
                                                    selected = NULL,
                                                    multiple = TRUE, 
                                                    width = "350px"),
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
                                                       input.Year !== '1999-2001/2005-2006'",
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
                                                               'Site Information' selection under the NARS Dataset of Interest dropdown."),
                                                   size = "s", easyClose = TRUE, fade = TRUE)),#end of siteinfo condPanel
                                        # Press button for analysis 
                                        actionButton("goButton", strong("Assemble/Update Dataset"), 
                                                     style = "background-color:#337ab7; font-weight: bold; font-size: 20px")
                           ))
                           )),#sidebarPanel
                           tabPanel(title=span('NARS Data',
                                               style = "font-weight: bold; font-size: 35px;"),
                                    icon = icon('database'),
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
                           tabPanel(title=span("Metadata",
                                         style = "font-weight: bold; font-size: 35px"),
                                    icon = icon('clipboard-question'),
                                    value="metadata",
                                    mainPanel(
                                      conditionalPanel(condition = 'output.metatable',
                                                       column(12, offset=2,
                                                              span(h2(textOutput("datatitlemeta")))),
                                                    span(h3(strong("Export Data As:")), style = "color:#337ab7")),
                                      DT::dataTableOutput("metatable"))
                           ),#About tabPanel
                           tabPanel(value="about",
                                    class="about",
                                    icon = icon('message'),
                                    verify_fa = FALSE,
                                    span("About",
                                         style = "font-weight: bold; font-size: 35px; font-style:italic;"),
                                    )#About tabPanel
                 )#navbar
	        )#suppressWarnings
	# Individual Page Footer
	,HTML(
	  '</article>
    </div>
    <div class="l-page__footer">
      <div class="l-constrain">
        <p><a href="https://www.epa.gov/national-aquatic-resource-surveys/forms/contact-us-about-national-aquatic-resource-surveys">Contact Us</a> to ask a question, provide feedback, or report a problem.</p>
      </div>
    </div>
  </div>'
	),
	
	# Site Footer
	HTML(
	  '</main>
      <footer class="footer" role="contentinfo">
      <div class="l-constrain">
        <img class="footer__epa-seal" src="https://www.epa.gov/themes/epa_theme/images/epa-seal.svg" alt="United States Environmental Protection Agency" height="100" width="100">
        <div class="footer__content contextual-region">
          <div class="footer__column">
            <h2>Discover.</h2>
            <ul class="menu menu--footer">
              <li class="menu__item">
                <a href="https://www.epa.gov/accessibility" class="menu__link">Accessibility</a>
              </li>
              <!--li class="menu__item"><a href="#" class="menu__link">EPA Administrator</a></li-->
              <li class="menu__item">
                <a href="https://www.epa.gov/planandbudget" class="menu__link">Budget &amp; Performance</a>
              </li>
              <li class="menu__item">
                <a href="https://www.epa.gov/contracts" class="menu__link">Contracting</a>
              </li>
              <li class="menu__item">
                <a href="https://www.epa.gov/home/wwwepagov-snapshots" class="menu__link">EPA www Web Snapshot</a>
              </li>
              <li class="menu__item">
                <a href="https://www.epa.gov/grants" class="menu__link">Grants</a>
              </li>
              <li class="menu__item">
                <a href="https://www.epa.gov/ocr/whistleblower-protections-epa-and-how-they-relate-non-disclosure-agreements-signed-epa-employees" class="menu__link">No FEAR Act Data</a>
              </li>
              <li class="menu__item">
                <a href="https://www.epa.gov/web-policies-and-procedures/plain-writing" class="menu__link">Plain Writing</a>
              </li>
              <li class="menu__item">
                <a href="https://www.epa.gov/privacy" class="menu__link">Privacy</a>
              </li>
              <li class="menu__item">
                <a href="https://www.epa.gov/privacy/privacy-and-security-notice" class="menu__link">Privacy and Security Notice</a>
              </li>
            </ul>
          </div>
          <div class="footer__column">
            <h2>Connect.</h2>
            <ul class="menu menu--footer">
              <li class="menu__item">
                <a href="https://www.data.gov/" class="menu__link">Data.gov</a>
              </li>
              <li class="menu__item">
                <a href="https://www.epa.gov/office-inspector-general/about-epas-office-inspector-general" class="menu__link">Inspector General</a>
              </li>
              <li class="menu__item">
                <a href="https://www.epa.gov/careers" class="menu__link">Jobs</a>
              </li>
              <li class="menu__item">
                <a href="https://www.epa.gov/newsroom" class="menu__link">Newsroom</a>
              </li>
              <li class="menu__item">
                <a href="https://www.epa.gov/data" class="menu__link">Open Government</a>
              </li>
              <li class="menu__item">
                <a href="https://www.regulations.gov/" class="menu__link">Regulations.gov</a>
              </li>
              <li class="menu__item">
                <a href="https://www.epa.gov/newsroom/email-subscriptions-epa-news-releases" class="menu__link">Subscribe</a>
              </li>
              <li class="menu__item">
                <a href="https://www.usa.gov/" class="menu__link">USA.gov</a>
              </li>
              <li class="menu__item">
                <a href="https://www.whitehouse.gov/" class="menu__link">White House</a>
              </li>
            </ul>
          </div>
          <div class="footer__column">
            <h2>Ask.</h2>
            <ul class="menu menu--footer">
              <li class="menu__item">
                <a href="https://www.epa.gov/home/forms/contact-epa" class="menu__link">Contact EPA</a>
              </li>
              <li class="menu__item">
                <a href="https://www.epa.gov/web-policies-and-procedures/epa-disclaimers" class="menu__link">EPA Disclaimers</a>
              </li>
              <li class="menu__item">
                <a href="https://www.epa.gov/aboutepa/epa-hotlines" class="menu__link">Hotlines</a>
              </li>
              <li class="menu__item">
                <a href="https://www.epa.gov/foia" class="menu__link">FOIA Requests</a>
              </li>
              <li class="menu__item">
                <a href="https://www.epa.gov/home/frequent-questions-specific-epa-programstopics" class="menu__link">Frequent Questions</a>
              </li>
            </ul>
            <h2>Follow.</h2>
            <ul class="menu menu--social">
              <li class="menu__item">
                <a class="menu__link" aria-label="EPA’s Facebook" href="https://www.facebook.com/EPA">
                  <!-- svg class="icon icon--social" aria-hidden="true" -->
                  <svg class="icon icon--social" aria-hidden="true" viewBox="0 0 448 512" id="facebook-square" xmlns="http://www.w3.org/2000/svg">
                    <!-- use xlink:href="https://www.epa.gov/themes/epa_theme/images/sprite.artifact.svg#facebook-square"></use-->
                    <path fill="currentcolor" d="M400 32H48A48 48 0 000 80v352a48 48 0 0048 48h137.25V327.69h-63V256h63v-54.64c0-62.15 37-96.48 93.67-96.48 27.14 0 55.52 4.84 55.52 4.84v61h-31.27c-30.81 0-40.42 19.12-40.42 38.73V256h68.78l-11 71.69h-57.78V480H400a48 48 0 0048-48V80a48 48 0 00-48-48z"></path>
                  </svg> 
                  <span class="usa-tag external-link__tag" title="Exit EPA Website">
                    <span aria-hidden="true">Exit</span>
                    <span class="u-visually-hidden"> Exit EPA Website</span>
                  </span>
                </a>
              </li>
              <li class="menu__item">
                <a class="menu__link" aria-label="EPA’s Twitter" href="https://twitter.com/epa">
                  <!-- svg class="icon icon--social" aria-hidden="true" -->
                  <svg class="icon icon--social" aria-hidden="true" viewBox="0 0 448 512" id="twitter-square" xmlns="http://www.w3.org/2000/svg">
                    <!-- use xlink:href="https://www.epa.gov/themes/epa_theme/images/sprite.artifact.svg#twitter-square"></use -->
                    <path fill="currentcolor" d="M400 32H48C21.5 32 0 53.5 0 80v352c0 26.5 21.5 48 48 48h352c26.5 0 48-21.5 48-48V80c0-26.5-21.5-48-48-48zm-48.9 158.8c.2 2.8.2 5.7.2 8.5 0 86.7-66 186.6-186.6 186.6-37.2 0-71.7-10.8-100.7-29.4 5.3.6 10.4.8 15.8.8 30.7 0 58.9-10.4 81.4-28-28.8-.6-53-19.5-61.3-45.5 10.1 1.5 19.2 1.5 29.6-1.2-30-6.1-52.5-32.5-52.5-64.4v-.8c8.7 4.9 18.9 7.9 29.6 8.3a65.447 65.447 0 01-29.2-54.6c0-12.2 3.2-23.4 8.9-33.1 32.3 39.8 80.8 65.8 135.2 68.6-9.3-44.5 24-80.6 64-80.6 18.9 0 35.9 7.9 47.9 20.7 14.8-2.8 29-8.3 41.6-15.8-4.9 15.2-15.2 28-28.8 36.1 13.2-1.4 26-5.1 37.8-10.2-8.9 13.1-20.1 24.7-32.9 34z"></path>
                  </svg>
                  <span class="usa-tag external-link__tag" title="Exit EPA Website">
                    <span aria-hidden="true">Exit</span>
                    <span class="u-visually-hidden"> Exit EPA Website</span>
                  </span>
                </a>
              </li>
              <li class="menu__item">
                <a class="menu__link" aria-label="EPA’s Youtube" href="https://www.youtube.com/user/USEPAgov">
                  <!-- svg class="icon icon--social" aria-hidden="true" -->
                  <svg class="icon icon--social" aria-hidden="true" viewBox="0 0 448 512" id="youtube-square" xmlns="http://www.w3.org/2000/svg">
                    <!-- use xlink:href="https://www.epa.gov/themes/epa_theme/images/sprite.artifact.svg#youtube-square"></use -->
                    <path fill="currentcolor" d="M186.8 202.1l95.2 54.1-95.2 54.1V202.1zM448 80v352c0 26.5-21.5 48-48 48H48c-26.5 0-48-21.5-48-48V80c0-26.5 21.5-48 48-48h352c26.5 0 48 21.5 48 48zm-42 176.3s0-59.6-7.6-88.2c-4.2-15.8-16.5-28.2-32.2-32.4C337.9 128 224 128 224 128s-113.9 0-142.2 7.7c-15.7 4.2-28 16.6-32.2 32.4-7.6 28.5-7.6 88.2-7.6 88.2s0 59.6 7.6 88.2c4.2 15.8 16.5 27.7 32.2 31.9C110.1 384 224 384 224 384s113.9 0 142.2-7.7c15.7-4.2 28-16.1 32.2-31.9 7.6-28.5 7.6-88.1 7.6-88.1z"></path>
                  </svg>
                  <span class="usa-tag external-link__tag" title="Exit EPA Website">
                    <span aria-hidden="true">Exit</span>
                    <span class="u-visually-hidden"> Exit EPA Website</span>
                  </span>
                </a>
              </li>
              <li class="menu__item">
                <a class="menu__link" aria-label="EPA’s Flickr" href="https://www.flickr.com/photos/usepagov">
                  <!-- svg class="icon icon--social" aria-hidden="true" -->
                  <svg class="icon icon--social" aria-hidden="true" viewBox="0 0 448 512" id="flickr-square" xmlns="http://www.w3.org/2000/svg">
                    <!-- use xlink:href="https://www.epa.gov/themes/epa_theme/images/sprite.artifact.svg#flickr-square"></use -->
                    <path fill="currentcolor" d="M400 32H48C21.5 32 0 53.5 0 80v352c0 26.5 21.5 48 48 48h352c26.5 0 48-21.5 48-48V80c0-26.5-21.5-48-48-48zM144.5 319c-35.1 0-63.5-28.4-63.5-63.5s28.4-63.5 63.5-63.5 63.5 28.4 63.5 63.5-28.4 63.5-63.5 63.5zm159 0c-35.1 0-63.5-28.4-63.5-63.5s28.4-63.5 63.5-63.5 63.5 28.4 63.5 63.5-28.4 63.5-63.5 63.5z"></path>
                  </svg>
                  <span class="usa-tag external-link__tag" title="Exit EPA Website">
                    <span aria-hidden="true">Exit</span>
                    <span class="u-visually-hidden"> Exit EPA Website</span>
                  </span>
                </a>
              </li>
              <li class="menu__item">
                <a class="menu__link" aria-label="EPA’s Instagram" href="https://www.instagram.com/epagov">
                  <!-- svg class="icon icon--social" aria-hidden="true" -->
                  <svg class="icon icon--social" aria-hidden="true" viewBox="0 0 448 512" id="instagram-square" xmlns="http://www.w3.org/2000/svg">
                    <!-- use xlink:href="https://www.epa.gov/themes/epa_theme/images/sprite.artifact.svg#instagram-square"></use -->
                    <path fill="currentcolor" xmlns="http://www.w3.org/2000/svg" d="M224 202.66A53.34 53.34 0 10277.36 256 53.38 53.38 0 00224 202.66zm124.71-41a54 54 0 00-30.41-30.41c-21-8.29-71-6.43-94.3-6.43s-73.25-1.93-94.31 6.43a54 54 0 00-30.41 30.41c-8.28 21-6.43 71.05-6.43 94.33s-1.85 73.27 6.47 94.34a54 54 0 0030.41 30.41c21 8.29 71 6.43 94.31 6.43s73.24 1.93 94.3-6.43a54 54 0 0030.41-30.41c8.35-21 6.43-71.05 6.43-94.33s1.92-73.26-6.43-94.33zM224 338a82 82 0 1182-82 81.9 81.9 0 01-82 82zm85.38-148.3a19.14 19.14 0 1119.13-19.14 19.1 19.1 0 01-19.09 19.18zM400 32H48A48 48 0 000 80v352a48 48 0 0048 48h352a48 48 0 0048-48V80a48 48 0 00-48-48zm-17.12 290c-1.29 25.63-7.14 48.34-25.85 67s-41.4 24.63-67 25.85c-26.41 1.49-105.59 1.49-132 0-25.63-1.29-48.26-7.15-67-25.85s-24.63-41.42-25.85-67c-1.49-26.42-1.49-105.61 0-132 1.29-25.63 7.07-48.34 25.85-67s41.47-24.56 67-25.78c26.41-1.49 105.59-1.49 132 0 25.63 1.29 48.33 7.15 67 25.85s24.63 41.42 25.85 67.05c1.49 26.32 1.49 105.44 0 131.88z"></path>
                  </svg>
                  <span class="usa-tag external-link__tag" title="Exit EPA Website">
                    <span aria-hidden="true">Exit</span>
                    <span class="u-visually-hidden"> Exit EPA Website</span>
                  </span>
                </a>
              </li>
            </ul>
            <p class="footer__last-updated">
              Last updated on February 02, 2023
            </p>
          </div>
        </div>
      </div>
    </footer>
    <a href="#" class="back-to-top" title="">
      <svg class="back-to-top__icon" role="img" aria-label="">
      <svg class="back-to-top__icon" role="img" aria-label="" viewBox="0 0 19 12" id="arrow" xmlns="http://www.w3.org/2000/svg">
        <!-- use xlink:href="https://www.epa.gov/themes/epa_theme/images/sprite.artifact.svg#arrow"></use -->
        <path fill="currentColor" d="M2.3 12l7.5-7.5 7.5 7.5 2.3-2.3L9.9 0 .2 9.7 2.5 12z"></path>
      </svg>
    </a>'
	)
)#fluidPage


server <-function(input, output, session) {
  observe_helpers()
  
  shinyalert("Welcome to the NARS Data Download Tool!", 
             imageUrl ='www/NARS_logo_sm.jpg',
             paste("Use the dropdown menus to explore available datasets collected in the", 
                    a(href="https://www.epa.gov/national-aquatic-resource-surveys/data-national-aquatic-resource-surveys", "National Aquatic Resource Surveys (NARS).", target="_blank"),
                    "Users have the option to filter the data by state(s) of interest and join site information to selected datasets.",
                    br(), br(),
                    "Users of the data are encouraged to review the", 
                    a(href="https://www.epa.gov/national-aquatic-resource-surveys/outreach-materials-national-aquatic-resource-surveys", "Technical Reports, Field and Laboratory Manuals, and metadata files", target="_blank"),
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
                     "Users have the option to filter the data by state(s) of interest and join site information to selected datasets.",
                     br(), br(),
                     "Users of the data are encouraged to review the", 
                     a(href="https://www.epa.gov/national-aquatic-resource-surveys/outreach-materials-national-aquatic-resource-surveys", "Technical Reports, Field and Laboratory Manuals, and metadata files", target="_blank"),
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
    if(input$Year == "1819") {
      paste0("Dataset: ", toupper(input$Survey), input$Year,"_", names(choices1819)[choices1819 == input$Indicator])
    } else if(input$Year == "2017") {
      paste0("Dataset: ", toupper(input$Survey), input$Year,"_", names(choices2017)[choices2017 == input$Indicator])
    } else if(input$Year == "2016") {
      paste0("Dataset: ", toupper(input$Survey), input$Year,"_", names(choices2016)[choices2016 == input$Indicator])
    } else if(input$Year == "2015") {
      paste0("Dataset: ", toupper(input$Survey), input$Year,"_", names(choices2015)[choices2015 == input$Indicator])
    } else if(input$Year == "1314") {
      paste0("Dataset: ", toupper(input$Survey), input$Year,"_", names(choices1314)[choices1314 == input$Indicator])
    } else if(input$Year == "2012") {
      paste0("Dataset: ", toupper(input$Survey), input$Year,"_", names(choices2012)[choices2012 == input$Indicator])
    } else if(input$Year == "2011") {
      paste0("Dataset: ", toupper(input$Survey), input$Year,"_", names(choices2011)[choices2011 == input$Indicator])
    } else if(input$Year == "2010") {
      paste0("Dataset: ", toupper(input$Survey), input$Year,"_", names(choices2010)[choices2010 == input$Indicator])
    } else if(input$Year == "0809") {
      paste0("Dataset: ", toupper(input$Survey), input$Year,"_", names(choices0809)[choices0809 == input$Indicator])
    } else if(input$Year =="2007") {
      paste0("Dataset: ", toupper(input$Survey), input$Year,"_", names(choices2007)[choices2007 == input$Indicator])
    } else {
      paste0("Dataset: ", toupper(input$Survey), input$Year,"_", names(choices0506)[choices0506 == input$Indicator])
    }
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
      updateSelectInput(session, "Year", selected = NULL, choices = c("2017", "2012", "2007"))
    }
    if(input$Survey == "nwca") {
      updateSelectInput(session, "Year", selected = NULL, choices = c("2016", "2011"))
    }
    if(input$Survey == "ncca") {
      updateSelectInput(session, "Year", selected = NULL, choices = c("2015", "2010", "1999-2001/2005-2006"))
    }
    if(input$Survey == "nrsa") {
      updateSelectInput(session, "Year", selected = NULL, choices = c("2018/2019"="1819", "2013/2014"="1314", "2008/2009"="0809"))
    }})
  
  
  ## State Observers ----
  observe({
    req("All States" %in% input$State) 
    updateSelectInput(session, "State", selected = "All States", 
                      choices = c("All States"))
  })
  
  
  
  
  
  ## NCCA State Choices ----
  
 observe({
    req(is.null(input$State)) 
    
    if(input$NCCA_Type == "estuarine" & input$Year == 2015){
      updateSelectInput(session, "State",  
                        choices = c("Select State(s)"="", "All States","AL","AS", "CA","CT","DE","FL","GA","GU","HI","LA","MA","MD","ME","MP","MS","NC","NH","NJ","NY","OR","RI","SC","TX","VA","WA"))
    } else if(input$NCCA_Type == "great_lakes" & input$Year == 2015){
      updateSelectInput(session, "State",
                       choices = c("Select State(s)"="", "All States","IN","MI","MN","NY","OH","PA","WI"))
    } else {
      updateSelectInput(session, "State",
                        choices = c("Select State(s)"="", "All States", state_name))
    }
  })
  
  observe({
    req(input$Survey == "ncca")
    if(input$NCCA_Type == "estuarine" & input$Year == 2015){
      updateSelectInput(session, "State",  
                        choices = c("Select State(s)"="", "All States","AL","AS", "CA","CT","DE","FL","GA","GU","HI","LA","MA","MD","ME","MP","MS","NC","NH","NJ","NY","OR","RI","SC","TX","VA","WA"))
      updateSelectInput(session, "SiteInfo", 
                        choices = site2015est)
    }
    if(input$NCCA_Type == "great_lakes" & input$Year == 2015){
      updateSelectInput(session, "State",
                        choices = c("Select State(s)"="", "All States","IN","MI","MN","NY","OH","PA","WI"))
      updateSelectInput(session, "SiteInfo", 
                        choices = site2015gl)
    }
    if(input$Year != 2015){
      updateSelectInput(session, "State",
                        choices = c("Select State(s)"="", "All States", state_name))
    }
  })
  
  
  ## Indicator Choices ----
  observeEvent(input$Year,{
    if(input$Year == "1819") {
      updateSelectInput(session, "Indicator", 
                        choices = choices1819)
      updateSelectInput(session, "SiteInfo", 
                        choices = site1819)
    }
    if(input$Year == "2017") {
      updateSelectInput(session, "Indicator", 
                        choices = choices2017)
      updateSelectInput(session, "SiteInfo", 
                        choices = site2017)
    }
    if(input$Year == "2016") {
      updateSelectInput(session, "Indicator",
                        choices = choices2016)
      updateSelectInput(session, "SiteInfo", 
                        choices = site2016)
    }
    if(input$Year == "2015") {
      updateSelectInput(session, "Indicator",
                        choices = choices2015)
    } 
    if(input$Year == "1314") {
      updateSelectInput(session, "Indicator",
                        choices = choices1314)
      updateSelectInput(session, "SiteInfo", 
                        choices = site1314)
    } 
    if(input$Year == "2012") {
      updateSelectInput(session, "Indicator",
                        choices = choices2012)
      updateSelectInput(session, "SiteInfo", 
                        choices = site2012)
    }
    if(input$Year == "2011") {
      updateSelectInput(session, "Indicator",
                        choices = choices2011)
      updateSelectInput(session, "SiteInfo", 
                        choices = site2011)
    }
    if(input$Year == "2010") {
      updateSelectInput(session, "Indicator",
                        choices = choices2010)
      updateSelectInput(session, "SiteInfo", 
                        choices = site2010)
    }
    if(input$Year == "0809") {
      updateSelectInput(session, "Indicator",
                        choices = choices0809)
      updateSelectInput(session, "SiteInfo", 
                        choices = site0809)
    }
    if(input$Year == "2007") {
      updateSelectInput(session, "Indicator",
                        choices = choices2007)
      updateSelectInput(session, "SiteInfo", 
                        choices = site2007)
    }
    if(input$Year == "1999-2001/2005-2006") {
      updateSelectInput(session, "Indicator",
                        choices = choices0506)
    }
  })
  
  
  ## Data Extract ----
  Data <- eventReactive(input$goButton, {
    
    validate(
      need(input$State, 'Select State(s) of Interest!'))
    
    show_modal_spinner(spin = 'flower', text = 'Assembling Dataset.')
   ### 2018/19----
    if(input$Survey == "nrsa" & input$Year == "1819") {
      if(input$Indicator == "SiteInfo") {
          Data <- read_csv('https://www.epa.gov/system/files/other-files/2023-01/NRSA_1819_SiteInfo.csv')
        } else if(input$Indicator %in% c("fish-sampling-information", "fish-count", "fish-metrics")) {
          Data <- read_csv(paste0('https://www.epa.gov/system/files/other-files/2022-03/nrsa-1819-',input$Indicator,'-data.csv'))
        } else if(input$Indicator %in% c("pbio_0", "PeriChla", "landscape", "enterococci_0")){
          Data <- read_csv(paste0('https://www.epa.gov/system/files/other-files/2023-01/NRSA_1819_',input$Indicator,'.csv'))
        } else if(input$Indicator == "field_wide"){
          colnames <- c("UID", colnames(read_csv('https://www.epa.gov/system/files/other-files/2023-01/NRSA_1819_field_wide.csv', col_select = -c(1:2))))
          Data <- read_csv('https://www.epa.gov/system/files/other-files/2023-01/NRSA_1819_field_wide.csv', col_select = -c(1), skip = 1)
          names(Data) <- colnames
        } else {
          Data <- read_csv(paste0('https://www.epa.gov/sites/production/files/2021-04/',input$Survey,'_', input$Year,'_',input$Indicator,'_-_data.csv'))
        }
      
    
      if(input$State != "All States" || length(input$State) > 1) {
        if("PSTL_CODE" %in% colnames(Data)) {
          Data <- Data %>%
            filter(PSTL_CODE %in% input$State)
        } else if("STATE" %in% colnames(Data)){
          Data <- Data %>%
            filter(STATE %in% input$State)
        } else{
          siteinfo1819 <- read_csv(paste0('https://www.epa.gov/system/files/other-files/2023-01/NRSA_1819_SiteInfo.csv')) %>% 
            select(UID, SITE_ID, VISIT_NO, PSTL_CODE)
          Data <- left_join(Data, siteinfo1819) %>%
            filter(PSTL_CODE %in% input$State) %>% relocate(PSTL_CODE, .after = VISIT_NO)
        }
      }
      if(input$Indicator != "SiteInfo") {
        siteinfo <- read_csv(paste0('https://www.epa.gov/system/files/other-files/2023-01/NRSA_1819_SiteInfo.csv')) %>%
          select(UID, LAT_DD83, LON_DD83, input$SiteInfo)
        Data <- left_join(Data, siteinfo) %>% relocate(LAT_DD83, LON_DD83, input$SiteInfo, .after = VISIT_NO)
      }
    }
    ### 2017----
    if(input$Survey == "nla" & input$Year == "2017") {
      if(input$Indicator == "zooplankton-count") {
        Data <- read_csv(paste0('https://www.epa.gov/system/files/other-files/2021-12/',input$Survey,'-',input$Year,'-',input$Indicator,'-data.csv'))
      } else if (input$Indicator %in% c("zooplankton-raw-count","zooplankton-metrics")) {
        Data <- read_csv(paste0('https://www.epa.gov/system/files/other-files/2021-12/',input$Survey,'-',input$Year,'-',input$Indicator,'-data-updated-12092021.csv'))
      } else {
        Data <- read_csv(paste0('https://www.epa.gov/sites/production/files/2021-04/',input$Survey,'_',input$Year,'_',input$Indicator,'-data.csv'))
      }
      if(input$State != "All States" || length(input$State) > 1) {
        if("PSTL_CODE" %in% colnames(Data)) {
          Data <- Data %>%
            filter(PSTL_CODE %in% input$State)
        } else if("STATE" %in% colnames(Data)){
          Data <- Data %>%
            filter(STATE %in% input$State)
        } else{
          siteinfo2017 <- read_csv(paste0('https://www.epa.gov/sites/production/files/2021-04/nla_2017_site_information-data.csv')) %>% 
            select(UID, SITE_ID, VISIT_NO, PSTL_CODE)
          Data <- left_join(Data, siteinfo2017) %>%
            filter(PSTL_CODE %in% input$State) %>% relocate(PSTL_CODE, .after = VISIT_NO)
        }
      }
      if(input$Indicator != "site_information") {
        siteinfo <- read_csv(paste0('https://www.epa.gov/sites/production/files/2021-04/nla_2017_site_information-data.csv')) %>%
          select(UID, LAT_DD83, LON_DD83, input$SiteInfo)
        Data <- left_join(Data, siteinfo) %>% relocate(LAT_DD83, LON_DD83, input$SiteInfo, .after = VISIT_NO)
      }
    }
    ### 2016----
    if(input$Survey == "nwca" & input$Year == "2016"){
      
      if(input$Indicator == "site-information") {
        Data <- read_csv("https://www.epa.gov/system/files/other-files/2022-04/nwca-2016-site-information-data_0.csv")
      } else if (input$Indicator == "plant-species-cover-height") {
        Data <- read_csv("https://www.epa.gov/system/files/other-files/2022-04/nwca-2016-plant-species-cover-height-data.csv")
      } else {
        Data <- read_csv(paste0('https://www.epa.gov/sites/production/files/2021-04/',input$Survey,'_',input$Year,'_',input$Indicator,'_-_data_csv.csv'))
      }
      if(input$State != "All States" || length(input$State) > 1) {
        if("PSTL_CODE" %in% colnames(Data)) {
          Data <- Data %>%
            filter(PSTL_CODE %in% input$State)
        } else{
          Data <- Data %>%
            filter(STATE %in% input$State)
        }
      }
      if(input$Indicator != "site-information") {
        siteinfo <- read_csv(paste0('https://www.epa.gov/system/files/other-files/2022-04/nwca-2016-site-information-data_0.csv')) %>%
          select(UID, LAT_ANALYS, LON_ANALYS, input$SiteInfo)
        Data <- left_join(Data, siteinfo) %>% relocate(LAT_ANALYS, LON_ANALYS, input$SiteInfo, .after = VISIT_NO)
      }
    }
    ### 2015----
    if(input$Survey == "ncca" & input$Year == "2015") {
      if(input$Indicator == "ecological-fish-tissue-contaminants-fish-collection" & input$NCCA_Type == "estuarine"){
        Data <- read_csv(paste0('https://www.epa.gov/system/files/other-files/2021-08/ncca-2015-ecological-fish-tissue-contaminants-fish-collection-estuarine-data.csv'))
      } else if(input$Indicator == "ecological-fish-tissue-contaminants-fish-collection" & input$NCCA_Type == "great_lakes"){
        Data <- read_csv(paste0('https://www.epa.gov/system/files/other-files/2021-08/ncca-2015-ecological-fish-tissue-contaminants-fish-collection-great-lakes-data.csv')) 
      } else {
        Data <- read_csv(paste0('https://www.epa.gov/sites/production/files/2021-04/',input$Survey,'_',input$Year,'_',input$Indicator,'_',input$NCCA_Type,'-data.csv')) %>% 
                           filter(!grepl('(blank)', UID)) %>% mutate(UID=as.numeric(UID))
      }
      if(input$State != "All States" || length(input$State) > 1) {
        if("PSTL_CODE" %in% colnames(Data)) {
          Data <- Data %>%
            filter(PSTL_CODE %in% input$State)
        } else{
          Data <- Data %>%
            filter(STATE %in% input$State)
        }
      }
      if(input$Indicator != "site_information" & input$NCCA_Type == "estuarine") {
        siteinfo <- read_csv(paste0('https://www.epa.gov/sites/default/files/2021-04/ncca_2015_site_information_estuarine-data.csv')) %>%
          select(UID, LAT_DD83, LON_DD83, input$SiteInfo)
        Data <- left_join(Data, siteinfo) %>% relocate(LAT_DD83, LON_DD83, input$SiteInfo, .after = VISIT_NO)
      }
      if(input$Indicator != "site_information" & input$NCCA_Type == "great_lakes") {
        siteinfo <- read_csv(paste0('https://www.epa.gov/sites/default/files/2021-04/ncca_2015_site_information_great_lakes-data.csv')) %>%
          select(UID, LAT_DD83, LON_DD83, input$SiteInfo)
        Data <- left_join(Data, siteinfo) %>% relocate(LAT_DD83, LON_DD83, input$SiteInfo, .after = VISIT_NO)
      }
    }
    ### 2013/14----
    if(input$Survey == "nrsa" & input$Year == "1314") {
      if(input$Indicator %in% c("micx", "bentmmi", "bentcnts", "widepchl", "widepbio", "widewchl", "ente", "wide_field_meas", 
                                "fishmmi", "fishcts", "fishmet", "phabmed", "widechem", "chem")) {
        Data <- read_csv(paste0('https://www.epa.gov/sites/production/files/2019-04/',input$Survey, input$Year,'_',input$Indicator,'_04232019.csv'))
      }
      if(input$Indicator == "bentmet") {
        Data <- read_csv(paste0('https://www.epa.gov/sites/production/files/2019-04/',input$Survey, input$Year,'_',input$Indicator,'_02132019.csv'))
      }
      if(input$Indicator %in% c("fishplug_hg", "siteinformation_wide")) {
        Data <- read_csv(paste0('https://www.epa.gov/sites/production/files/2019-04/',input$Survey, input$Year,'_',input$Indicator,'_04292019.csv'))
      }
      if(input$State != "All States" || length(input$State) > 1) {
        if("PSTL_CODE" %in% colnames(Data)) {
          Data <- Data %>%
            filter(PSTL_CODE %in% input$State)
        } else if("STATE" %in% colnames(Data)){
          Data <- Data %>%
            filter(STATE %in% input$State)
        } else{
          siteinfo1314 <- read_csv('https://www.epa.gov/sites/production/files/2019-04/nrsa1314_siteinformation_wide_04292019.csv') %>% 
            select(UID, SITE_ID, VISIT_NO, STATE)
          Data <- left_join(Data, siteinfo1314) %>%
            filter(STATE %in% input$State) %>% relocate(STATE, .after = VISIT_NO)
        }
      }
      if(input$Indicator != "siteinformation_wide") {
        siteinfo <- read_csv(paste0('https://www.epa.gov/sites/production/files/2019-04/nrsa1314_siteinformation_wide_04292019.csv')) %>%
          select(UID, LAT_DD83, LON_DD83, input$SiteInfo)
        Data <- left_join(Data, siteinfo) %>% relocate(LAT_DD83, LON_DD83, input$SiteInfo, .after = VISIT_NO)
      }
    }
    ### 2012----
    if(input$Survey == "nla" & input$Year == "2012") {
      if(input$Indicator %in% c("algaltoxins","atrazine")) {
        Data <- read_csv(paste0('https://www.epa.gov/sites/production/files/2016-11/',input$Survey, input$Year,'_',input$Indicator,'_08192016.csv'))
      } else if(input$Indicator == "topsedhg") {
        Data <- read_csv(paste0('https://www.epa.gov/sites/production/files/2016-12/',input$Survey, input$Year,'_',input$Indicator,'_08192016.csv'))
      } else if(input$Indicator %in% c("bentcond","wide_benthic")) {
        Data <- read_csv(paste0('https://www.epa.gov/sites/production/files/2016-11/',input$Survey, input$Year,'_',input$Indicator,'_08232016.csv'))
      } else if(input$Indicator %in% c("secchi","wide_siteinfo","wide_profile")) {
        Data <- read_csv(paste0('https://www.epa.gov/sites/production/files/2016-12/',input$Survey, input$Year,'_',input$Indicator,'_08232016.csv'))
      } else if(input$Indicator == "wide_phab") {
        Data <- read_csv(paste0('https://www.epa.gov/sites/production/files/2016-12/',input$Survey, input$Year,'_',input$Indicator,'_08232016_0.csv'))
      } else if(input$Indicator %in% c("wide_phytoplankton_count")) {
        Data <- read_csv(paste0('https://www.epa.gov/sites/production/files/2017-02/',input$Survey, input$Year,'_',input$Indicator,'_02122014.csv'))
      } else if(input$Indicator == "wide_phabmet") {
        Data <- read_csv(paste0('https://www.epa.gov/sites/production/files/2016-12/',input$Survey, input$Year,'_',input$Indicator,'_10202016.csv'))
      } else if(input$Indicator %in% c("zooplankton-metrics-data-updated","zooplankton-count-data-updated")) {
        Data <- read_csv(paste0('https://www.epa.gov/system/files/other-files/2021-12/',input$Survey,'-',input$Year,'-',input$Indicator,'-12092021.csv'))
      } else if(input$Indicator %in% c("bentmet", "chla_wide")) {
        Data <- read_csv(paste0('https://www.epa.gov/sites/production/files/2016-11/',input$Survey, input$Year,'_',input$Indicator,'.csv'))
      } else if(input$Indicator == "waterchem_wide") {
        Data <- read_csv(paste0('https://www.epa.gov/sites/production/files/2016-12/',input$Survey, input$Year,'_',input$Indicator,'.csv'))
      } else if(input$Indicator == "isotopes_wide") {
        Data <- read_csv(paste0('https://www.epa.gov/sites/production/files/2018-08/',input$Survey, input$Year,'_',input$Indicator,'.csv'))
      } else {#"zooplankton-raw-count"
        Data <- read_csv(paste0('https://www.epa.gov/system/files/other-files/2021-12/',input$Survey,'-',input$Year,'-',input$Indicator,'-data.csv'))
      }
      if(input$State != "All States" || length(input$State) > 1) {
        if("PSTL_CODE" %in% colnames(Data)) {
          Data <- Data %>%
            filter(PSTL_CODE %in% input$State)
        } else if("STATE" %in% colnames(Data)){
          Data <- Data %>%
            filter(STATE %in% input$State)
        } else{
          siteinfo2012 <- read_csv('https://www.epa.gov/sites/production/files/2016-12/nla2012_wide_siteinfo_08232016.csv') %>% 
            select(UID, SITE_ID, VISIT_NO, STATE)
          Data <- left_join(Data, siteinfo2012) %>%
            filter(STATE %in% input$State) %>% relocate(STATE, .after = VISIT_NO)
        }
      }
      if(input$Indicator != "wide_siteinfo") {
        siteinfo <- read_csv(paste0('https://www.epa.gov/sites/default/files/2016-12/nla2012_wide_siteinfo_08232016.csv')) %>%
          select(UID, LAT_DD83, LON_DD83, input$SiteInfo)
        Data <- left_join(Data, siteinfo) %>% relocate(LAT_DD83, LON_DD83, input$SiteInfo, .after = VISIT_NO)
      }
    }
    ### 2011----
    if(input$Survey == "nwca" & input$Year == "2011") {
      Data <- read_csv(paste0('https://www.epa.gov/sites/production/files/2016-10/',input$Survey, input$Year,'_',input$Indicator,'.csv'))
      if(input$State != "All States" || length(input$State) > 1) {
        if("PSTL_CODE" %in% colnames(Data)) {
          Data <- Data %>%
            filter(PSTL_CODE %in% input$State)
        } else if("STATE" %in% colnames(Data)){
          Data <- Data %>%
            filter(STATE %in% input$State)
        } else{
          siteinfo2011 <- read_csv('https://www.epa.gov/sites/default/files/2016-10/nwca2011_siteinfo.csv') %>% 
            select(UID, SITE_ID, VISIT_NO, STATE)
          Data <- left_join(Data, siteinfo2011) %>%
            filter(STATE %in% input$State) %>% relocate(STATE, .after = VISIT_NO)
        }
      }
      if(input$Indicator != "siteinfo") {
        siteinfo <- read_csv(paste0('https://www.epa.gov/sites/default/files/2016-10/nwca2011_siteinfo.csv')) %>%
          select(UID, AA_CENTER_LAT, AA_CENTER_LON, input$SiteInfo)
        Data <- left_join(Data, siteinfo) %>% relocate(AA_CENTER_LAT, AA_CENTER_LON, input$SiteInfo, .after = VISIT_NO)
      }
    }
    ### 2010----
    if(input$Survey == "ncca" & input$Year == "2010") {
      if(input$Indicator %in% c("siteinfo.revised.06212016","sediment_chemistry.revised.06.21.2016")) {
        Data <- read_csv(paste0('https://www.epa.gov/sites/production/files/2016-06/assessed_',input$Survey, input$Year,'_',input$Indicator,'.csv'))
      } else if(input$Indicator == "ecofish_collection_info") {
        Data <- read_csv(paste0('https://www.epa.gov/sites/default/files/2016-01/ncca2010_ecofish_collection_info.csv'))
      } else {
        Data <- read_csv(paste0('https://www.epa.gov/sites/production/files/2016-01/assessed_',input$Survey, input$Year,'_',input$Indicator,'.csv'))
      }
      if(input$State != "All States" || length(input$State) > 1) {
        if("PSTL_CODE" %in% colnames(Data)) {
          Data <- Data %>%
            filter(PSTL_CODE %in% input$State)
        } else if("STATE" %in% colnames(Data)){
          Data <- Data %>%
            filter(STATE %in% input$State)
        } else{
          siteinfo2010 <- read_csv('https://www.epa.gov/sites/default/files/2016-06/assessed_ncca2010_siteinfo.revised.06212016.csv') %>% 
            select(UID, SITE_ID, STATE)
          Data <- left_join(Data, siteinfo2010) %>%
            filter(STATE %in% input$State) %>% relocate(STATE)
        }
      }
      if(input$Indicator != "siteinfo.revised.06212016") {
        siteinfo <- read_csv(paste0('https://www.epa.gov/sites/default/files/2016-06/assessed_ncca2010_siteinfo.revised.06212016.csv')) %>%
          select(UID, SITE_ID, ALAT_DD, ALON_DD, input$SiteInfo)
        Data <- left_join(Data, siteinfo) %>% relocate(ALAT_DD, ALON_DD, input$SiteInfo, .after = SITE_ID)
      }
    }
    ### 2008/09----
    if(input$Survey == "nrsa" & input$Year == "0809"){
      if(input$Indicator == "fieldchemmeasure") {
        Data <- read_csv("https://www.epa.gov/sites/default/files/2015-11/fieldchemmeasure.csv")
      } else if(input$Indicator == "bentcts") {
        Data <- read_csv("https://www.epa.gov/sites/default/files/2016-11/nrsa0809bentcts.csv")
      } else {
        Data <- read_csv(paste0('https://www.epa.gov/sites/production/files/2015-09/',input$Indicator,'.csv'))
      }
      if(input$State != "All States" || length(input$State) > 1) {
        if("PSTL_CODE" %in% colnames(Data)) {
          Data <- Data %>%
            filter(PSTL_CODE %in% input$State)
        } else if("STATE" %in% colnames(Data)){
          Data <- Data %>%
            filter(STATE %in% input$State)
        } else{
          siteinfo0809 <- read_csv('https://www.epa.gov/sites/default/files/2015-09/siteinfo_0.csv') %>% 
            select(UID, SITE_ID, VISIT_NO, STATE)
          Data <- left_join(Data, siteinfo0809) %>%
            filter(STATE %in% input$State) %>% relocate(STATE)
        }
      }
      if(input$Indicator != "siteinfo_0") {
        siteinfo <- read_csv(paste0('https://www.epa.gov/sites/default/files/2015-09/siteinfo_0.csv')) %>%
          select(UID, SITE_ID, VISIT_NO, LAT_DD83, LON_DD83, input$SiteInfo)
        Data <- left_join(Data, siteinfo) %>% relocate(LAT_DD83, LON_DD83, input$SiteInfo, .after = VISIT_NO)
      }
    }
    ### 2007----
    if(input$Survey == "nla" & input$Year == "2007") {
      #"Landscape Metrics",  Hydroprofile,
      if(input$Indicator %in% c("basin_landuse_metrics_20061022", "profile_20091008")) {
        Data <- read_csv(paste0('https://www.epa.gov/sites/production/files/2013-09/',input$Survey, input$Year,'_',input$Indicator,'.csv'))
      } else if(input$Indicator == "sampledlakeinformation_20091113") {
        Data <- read_csv(paste0('https://www.epa.gov/sites/production/files/2014-01/',input$Survey, input$Year,'_',input$Indicator,'.csv'))
      } else if(input$Indicator %in% c("wide_benthic_08092016", "bentmet", "bentcond_08232016")) {
        #"Benthic Macroinvertebrates", 
        Data <- read_csv(paste0('https://www.epa.gov/sites/production/files/2016-12/',input$Survey, input$Year,'_',input$Indicator,'.csv'))
      } else if(input$Indicator == "isotopes_wide") {
        Data <- read_csv("https://www.epa.gov/sites/default/files/2018-08/nla2007_isotopes_wide.csv")
      } else if(input$Indicator == "zooplankton_count_20091022") {
        Data <- read_csv("https://www.epa.gov/sites/default/files/2014-10/nla2007_zooplankton_count_20091022.csv")
      } else {
        #Phytoplankton, Physical Habitat, Secchi, waterchem, trophic, zooplankton
        Data <- read_csv(paste0('https://www.epa.gov/sites/production/files/2014-10/',input$Survey, input$Year,'_',input$Indicator,'.csv'))
      }
      if(input$State != "All States" || length(input$State) > 1) {
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
          siteinfo2007 <- read_csv('https://www.epa.gov/sites/default/files/2014-01/nla2007_sampledlakeinformation_20091113.csv') %>% 
            select(SITE_ID, VISIT_NO, STATE=ST)
          Data <- left_join(Data, siteinfo2007) %>%
            filter(STATE %in% input$State) %>% relocate(STATE)
        }
      }
      if(input$Indicator != "sampledlakeinformation_20091113") {
        siteinfo <- read_csv(paste0('https://www.epa.gov/sites/default/files/2014-01/nla2007_sampledlakeinformation_20091113.csv')) %>%
          select(SITE_ID, VISIT_NO, LAT_DD, LON_DD, input$SiteInfo)
        Data <- left_join(Data, siteinfo) %>% relocate(LAT_DD, LON_DD, input$SiteInfo, .after = VISIT_NO)
      }
    }
    ### 1999-2001/2005-2006----
    if(input$Survey == "ncca" & input$Year == "1999-2001/2005-2006") {
      Data <- read.xlsx(paste0("https://www.epa.gov/sites/default/files/2014-10/nca_", input$Indicator,"_narschallenge.xlsx"), sheet = 1)
      if(input$State != "All States" || length(input$State) > 1) {
        Data <- Data %>%
          filter(PSTL_CODE %in% input$State)
      }
    }
    
    remove_modal_spinner()
    
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
    validate(
      need(input$State, 'Select State(s) of Interest!'))
    
    show_modal_spinner(spin = 'flower', text = 'Assembling Metadata.')
    ### 2018/19----
    if (input$Survey == "nrsa" & input$Year == "1819") {
      if(input$Indicator == "mercury_in_fish_tissue_plugs") {
        MetaData <- read.delim(paste0('https://www.epa.gov/sites/production/files/2021-04/',input$Survey,'_', input$Year,'_',input$Indicator,'_-_metadata_.txt'))
      } else if(input$Indicator == "SiteInfo") {
        MetaData <- read.delim('https://www.epa.gov/system/files/other-files/2023-01/NRSA18_19_Site_Information_Metadata.txt')
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
      } else {
        MetaData <- read.delim(paste0('https://www.epa.gov/sites/production/files/2021-04/',input$Survey,'_', input$Year,'_',input$Indicator,'_-_metadata.txt'))
      }
    }
    
    ### 2017----
    if(input$Survey == "nla" & input$Year == "2017") {
      
      if(input$Indicator == "zooplankton-count") {
        MetaData <- read.delim(paste0('https://www.epa.gov/system/files/other-files/2021-12/',input$Survey,'-',input$Year,'-',input$Indicator,'-metadata.txt'))
      } else if (input$Indicator %in% c("zooplankton-raw-count","zooplankton-metrics")) {
        MetaData <- read.delim(paste0('https://www.epa.gov/system/files/other-files/2021-12/',input$Survey,'-',input$Year,'-',input$Indicator,'-metadata-updated-12092021.txt'))
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
      } else {
        MetaData <- read.delim(paste0('https://www.epa.gov/sites/production/files/2021-04/',input$Survey,'_',input$Year,'_',input$Indicator,'_',input$NCCA_Type,'-metadata.txt'))
      }
    }
    ### 2013/14----
    if (input$Survey == "nrsa" & input$Year == "1314") {
      if(input$Indicator == "fishmmi"){
        MetaData <- read.delim(paste0('https://www.epa.gov/sites/production/files/2019-04/',input$Survey, input$Year,'_','fish_meta_04292019.txt'))
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
      } else if(input$Indicator %in% c("wide_phab","wide_phabmet","secchi","wide_siteinfo","wide_profile")) {
        MetaData <- read.delim(paste0('https://www.epa.gov/sites/production/files/2016-12/',input$Survey, input$Year,'_',input$Indicator,'_meta_08232016.txt'))
      } else if(input$Indicator == "topsedhg") {
        MetaData <- read.delim(paste0('https://www.epa.gov/sites/production/files/2016-12/',input$Survey, input$Year,'_',input$Indicator,'_meta_08192016.txt'))
      } else if (input$Indicator == "zooplankton-metrics-data-updated") {
        MetaData <- read.delim(paste0('https://www.epa.gov/system/files/other-files/2021-12/',input$Survey,'-', input$Year,'zooplankton-metrics-metadata-updated-12092021.txt'))
      } else if (input$Indicator == "zooplankton-count-data-updated") {
        MetaData <- read.delim(paste0('https://www.epa.gov/system/files/other-files/2021-12/',input$Survey,'-', input$Year,'-zooplankton-raw-count-metadata.txt'))
      } else {#"zooplankton-raw-count"
        MetaData <- read.delim(paste0('https://www.epa.gov/system/files/other-files/2021-12/',input$Survey,'-', input$Year,'-',input$Indicator,'-metadata.txt'))
      }
    }
    ### 2011----
    if(input$Survey == "nwca" & input$Year == "2011") {
      MetaData <- read.delim(paste0('https://www.epa.gov/sites/production/files/2016-10/',input$Survey, input$Year,'_',input$Indicator,'-meta.txt'))
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
    if(input$Survey == "ncca" & input$Year == "1999-2001/2005-2006"){ 
        if(input$Indicator == "sedchemdata") {
        MetaData <- as.data.frame("Metadata Not Available")
      } else {
        MetaData <- read.xlsx(paste0("https://www.epa.gov/sites/default/files/2014-10/nca_", input$Indicator,"_narschallenge.xlsx"), sheet = 2)
      }
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
