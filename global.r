#packages <- c("shiny", "openxlsx", "dplyr", "readr", "DT", "bslib", "shinybusy", "shinyhelper", "shinyjs", "shinyalert", "jsonlite)
#installed_packages <- packages %in% rownames(installed.packages())
#if(any(installed_packages == FALSE)) {
#  install.packages(packages[!installed_packages])
#}

# Packages loading
#lapply(packages, library, character.only = TRUE)
library(shiny)
library(jsonlite)
library(openxlsx)
library(dplyr)
library(readr)
library(DT)
library(bslib)
library(shinybusy)
library(shinyhelper)
library(shinyjs)
library(shinyalert)

names(state.abb) <- state.name
state_name <- list(`States`=state.abb, 
                   `Territories`=c("American Samoa"="AS", "Guam"="GU", "Northern Mariana Islands"="MP"))

`%!in%` = Negate(`%in%`)

# Indicators ----
choices2022 <- list(`Site Information`=c("Landscape Metrics"="landscape_wide_0", "Site Information"="siteinfo"),
                    `Human Health`=c("Enterococci"="enterococci", "Fish Tissue (Fillets) - Mercury"="mercury", "Fish Tissue (Fillets) - Lipid Content"="lipid", "Fish Tissue (Fillets) - PCB Congeners"="pcb", "Fish Tissue (Fillets) - PFAS"="pfas"),
                    Chemical=c("Cyanotoxin"="algaltoxins", "Atrazine"="atrazine", "Hydrographic Profile"="profile_wide", "Water Chemistry/Chlorophyll a"="waterchem_wide"),
                    Physical=c("Physical Habitat"="phab_wide", "Physical Habitat Metrics"="phabmets_wide_0"),
                    Biological=c("Benthic Macroinvertebrate Count"="benthic_counts", "Benthic Macroinvertebrate Metrics"="benthic_metrics", "Benthic MMI"="benthic_mmi_0", "Benthic Taxa List"="benthic_taxa", 
                                 "Secchi Depth"="secchi", "Zooplankton Count"="zooplanktoncount_wide", "Zooplankton Taxa List"="zooplanktontaxa"),
                    NARS=c("Condition Estimates"="condition_combined_2024-08-13_0", "Data for Population Estimates"="nla2007-2022_data_forpopestimates_indexvisits_probsites_0", "Sample Grid"="sample_grid"))

choices2021 <- list(`Site Information`=c("Site Information"="siteinfo"),
                    `Human Health`=c("Microcystin"="microcystin"),
                    Water=c("Water Chemistry/Chlorophyll a"="waterchem_wide"),
                    Physical=c("AA Characterization"="assewq_wide", "AA Hydrology Sources"="hydrology_sources_wide", "AA Hydrology USACOE"="hydrology_usacoe_wide", "Physical Alterations"="physalt_wide"),
                    Vegetation=c("Floras Used/VegPlot Layout"="vegplot_wide","Plant Cover/Height"="plant_wide", "Plant C Values"="plantcval", "Plant Native Status"="plantnative", "Plant WIS"="plantwis", "Plant Taxa"="planttaxa", "Tree Cover/Count"="tree_wide","VegPlot Location"="vegplotloc_wide"))

# choices2020 <- list(`Site Information`=c("Site Information"="siteinfo"),
#                     `Human Health`=c("Enterococci"="enterococci", "Fish Tissue (Plugs) - Mercury"="hg_fishplug", "Microcystin"="microcystin"),
#                     Chemical=c("Hydrographic Profile"="hydrographic_profile","Secchi Depth"="secchi", "Sediment Contaminants"="sediment_chemistry", "Sediment Toxicity (Replicate)"="sediment_toxicity_sample_replicate", "Water Chemistry"="water_chemistry"),
#                     Biological=c("Benthic Macroinvertebrate Count"="benthic_count", "Benthic Taxa List"="benttaxalist", "Benthic Grab Info"="bent_grab", "ECOFISH Fish Collection "="ecological-fish-tissue-contaminants-fish-collection", "ECOFISH Contaminants"="ecological_fish_tissue_contaminants"))

choices1819 <- list(`Site Information`=c("Landscape Data"="landscape", "Site Information"="SiteInfo"),
                    `Human Health`=c("Enterococci"="enterococci_0", "Fish Tissue (Plugs) - Mercury"="mercury_in_fish_tissue_plugs", "Fish Tissue (Fillets) - Mercury"="mercury", "Fish Tissue (Fillets) - PCB Congeners"="pcb", "Fish Tissue (Fillets) - PFAS"="pfas"),
                    Chemical=c("Cyanotoxin"="algal_toxin", "Field Chemistry Measures"="field_wide", "Water Chemistry/Chlorophyll a"="water_chemistry_chla"),
                    Physical=c("Physical Habitat Metrics"="physical_habitat_larger_set_of_metrics"),
                    Biological=c("Benthic Macroinvertebrate Count"="benthic_macroinvertebrate_count", "Benthic Macroinvertebrate Metrics"="benthic_macroinvertebrate_metrics", 
                                 "Fish Sampling Info"="fish-sampling-information", "Fish Count"="fish-count", "Fish Metrics"="fish-metrics", "Periphyton Biomass"="pbio_0", "Periphyton/Chlorophyll a"="PeriChla"))
choices2017 <- list(`Site Information`=c("Landscape Metrics"="landMets", "Site Information"="site_information"),
                    `Human Health`=c("E. Coli"="e.coli"),
                    Chemical=c("Cyanotoxin"="algal_toxin", "Atrazine"="atrazine", "Hydrographic Profile"="profile", "Sediment Contaminants"="sediment_chemistry","Water Chemistry/Chlorophyll a"="water_chemistry_chla"),
                    Physical=c("Physical Habitat"="phab"),
                    Biological=c("Benthic Macroinvertebrate Count"="benthic_count", "Benthic Macroinvertebrate Metrics"="benthic_metrics", "Benthic Taxa List"="benthic_taxa_list",
                                 "Phytoplankton Count"="phytoplankton_count", "Phytoplankton Taxa List"="phytoplankton_taxa", "Secchi Depth"="secchi",  
                                 "Zooplankton Count"="zooplankton-count", "Zooplankton Count (Raw)"="zooplankton-raw-count", "Zooplankton Metrics"="zooplankton-metrics", "Zooplankton Taxa List"="zooplankton-taxa-list"),
                    NARS=c("Condition Estimates"="condition_estimates", "Data for Population Estimates"="data_for_population_estimates"))

choices2016 <- list(`Site Information`=c("Site Information"="site-information", "AA Characterization"="aa_characterization", "Landscape Metrics"="landscape_metrics"),
                    `Human Health`=c("Microcystin"="microcystin"),
                    Water=c("Water Chemistry/Chlorophyll a"="water_chemistry_chla", "Surface Water Characterization"="surface_water_characterization"),
                    Soil=c("Soil Horizon Chemistry"="soil_horizon_chemistry", "Soil Depth Core Chemistry"="soil_stddepth_core_chemistry", "Soil Horizon Description"="soil_horizon_description", "Soil Pit Characteristics"="soil_pit_characteristics"),
                    Physical=c("AA Hydrology USACOE"="aa_hydrology_usacoe", "AA Hydrology Stressors"="aa_hydrology_sources",
                               "Buffer Native Cover"="buffer_characterization_natcover", "Buffer Stressors"="buffer_characterization_stressors"),
                    Vegetation=c("Floras Used/VegPlot Layout"="floras_used_and_veg_plot_layout", "Ground Surface"="ground_surface", "Plant Cover/Height"="plant-species-cover-height", "Plant C Values"="plant_cvalues", "Plant Native Status"="plant_native_status", "Plant WIS"="plant_wis", "Plant Taxa"="plant_taxa",
                                 "Tree Cover/Count"="tree_cover_count", "Vegetation MMI"="veg_mmi", "Vegetation Type"="vegetation_type",
                                 "VegPlot Location"="veg_plot_location"),
                    NARS=c("Condition Estimates"="condition_estimates", "Data for Population Estimates"="2011_data_for_population_estimates", "Stressor Condition"="cond_stress"))

choices2015estuarine <- list(`Site Information`=c("Site Information"="site_information"),
                               `Human Health`=c("Enterococci"="enterococci", "Fish Tissue (Plugs) - Mercury"="mercury_in_fish_tissue_plugs", "Microcystin"="microcystin"),
                               Chemical=c("Hydrographic Profile"="hydrographic_profile","Secchi Depth"="secchi", "Sediment Contaminants"="sediment_chemistry", "Sediment Toxicity (Replicate)"="sediment_toxicity_sample_replicate", "Water Chemistry"="water_chemistry"),
                               Biological=c("Benthic Macroinvertebrate Count"="benthic_count", "Benthic Grab Info"="benthic_grab", "ECOFISH Fish Collection "="ecological-fish-tissue-contaminants-fish-collection", "ECOFISH Contaminants"="ecological_fish_tissue_contaminants"))

choices2015great_lakes <- list(`Site Information`=c("Site Information"="site_information"),
                             `Human Health`=c("Enterococci"="enterococci", "Fish Tissue (Plugs) - Mercury"="mercury_in_fish_tissue_plugs", "Fish Tissue (Fillets) - Mercury"="mercury", "Fish Tissue (Fillets) - Dioxin & Furan"="dioxin-furan", "Fish Tissue (Fillets) - Fatty Acids"="fatty-acids", "Fish Tissue (Fillets) - PCB Congeners"="pcb", "Fish Tissue (Fillets) - PFAS"="pfas", "Microcystin"="microcystin"),
                              Chemical=c("Hydrographic Profile"="hydrographic_profile","Secchi Depth"="secchi", "Sediment Contaminants"="sediment_chemistry", "Sediment Toxicity (Replicate)"="sediment_toxicity_sample_replicate", "Water Chemistry"="water_chemistry"),
                              Biological=c("Benthic Macroinvertebrate Count"="benthic_count", "Benthic Grab Info"="benthic_grab", "ECOFISH Fish Collection "="ecological-fish-tissue-contaminants-fish-collection", "ECOFISH Contaminants"="ecological_fish_tissue_contaminants"))

choices1314 <- list(`Site Information`=c("Site Information"="siteinformation_wide"),
                    `Human Health`=c("Enterococci"="ente", "Fish Tissue (Plugs) - Mercury"="fishplug_hg", "Microcystin"="micx"),
                    Chemical=c("Field Chemistry"="wide_field_meas", "Water Chemistry"="widechem", "Water Chemistry Indicator"="chem"),
                    Physical=c("Physical Habitat Metrics"="phabmed"),
                    Biological=c("Benthic Macroinvertebrate Count"="bentcnts", "Benthic Macroinvertebrate Metrics"="bentmet", "Benthic Macroinvertebrate MMI"="bentmmi", "Chlorophyll a"="widewchl", "Fish Metrics"="fishmet", "Fish MMI"="fishmmi", "Fish Counts" = "fishcts",
                                 "Periphyton"="widepchl", "Periphyton Biomass"="widepbio"),
                    NARS=c("Indicator Condition"="key_var"))

choices2012 <- list(`Site Information`=c("Site Information"="wide_siteinfo"),
                    `Human Health`=c("Cyanotoxin"="algaltoxins"),
                    Chemical=c("Atrazine"="atrazine", "Hydrographic Profile"="wide_profile", "Sediment (Mercury)"="topsedhg", "Water Isotope Variables"="isotopes_wide", "Water Chemistry"="waterchem_wide"),
                    Physical=c("Physical Habitat"="wide_phab", "Physical Habitat Metrics"="wide_phabmet"),
                    Biological=c("Benthic Condition"="bentcond", "Benthic Macroinvertebrate Count"="wide_benthic", "Benthic Macroinvertebrate Metrics"="bentmet", "Chlorophyll a"="chla_wide", "Phytoplankton Count"="wide_phytoplankton_count",  "Secchi Depth"="secchi","Zooplankton Count"="zooplankton-count-data-updated", 
                                 "Zooplankton Count (Raw)"="zooplankton-raw-count", "Zooplankton Metrics"="zooplankton-metrics-data-updated-12092021"))

choices2011 <- list(`Site Information`=c("AA Characterization"="aachar", "Landscape Metrics"="landscapechar", "Site Information"="siteinfo"),
                    `Human Health`=c("Cyanotoxin"="algaltoxin"),
                    Water=c("Chlorophyll a"="chla", "Hydrology"="hydro", "Water Chemistry"="waterchem"),
                    Soil=c("Sediment Enzymes"="sedenzymes", "Soil Chemistry"="soilchem", "Soil Profile Descriptions"="soilprofhorizons", "Soil Profile Attributes" = "soilprofsum"),
                    Physical=c("Buffer Characterization"="bufferchar", "Disturbance Gradiant Inputs"="distgrad_inputs", "USARAM Attributes"="usaram_attributes", "USARAM Summary"="usaram_summary"),
                    Vegetation=c("Floras/Vegplot Layouts"="floras_vegplotlayout", "Plant Cover and Height"="plant_pres_cvr", "Plant Vouchers"="plantvoucher", "Tree Data"="tree",
                                 "Vegetation Metrics"="vegmetrics", "Vegetation MMI"="vegmmi", "Vegetation Plot Location"="vegplotloc", "Vegetation Type and Ground Surface"="vegtype_grndsurf"),
                    NARS=c("Indicator Conditions"="cond_stress"))

choices2010 <- list(`Site Information`=c("Site Information"="siteinfo.revised.06212016"),
                    `Human Health`=c("Fish Tissue (Fillets) - Mercury"="mercury", "Fish Tissue (Fillets) - Fatty Acids"="fatty-acids", "Fish Tissue (Fillets) - PBDE"="pbde", "Fish Tissue (Fillets) - PCB Congeners"="pcb", "Fish Tissue (Fillets) - PFAS"="pfas"),
                    Chemical=c("Hydrographic Profile"="hydrolab", "Sediment Contaminants"="sediment_chemistry.revised.06.21.2016", "Sediment Toxicity"="sediment_toxicity_results", "Water Chemistry"="waterchem"),
                    Biological=c("Benthic Macroinvertebrates"="benthic_data", "ECOFISH Collection Info"="ecofish_collection_info", "ECOFISH Contaminants"="ecological_fish_tissue_contaminant_data"))

choices0809 <- list(`Site Information`=c("Landscape Metrics"="land", "Site Information"="siteinfo_0"),
                    `Human Health`=c("Enterococci"="enterocond"),
                    Chemical=c("Field Chemistry"="fieldchemmeasure", "Water Chemistry"="chem", "Water Chemistry Condition"="chemcond"),
                    Physical=c( "Physcial Habitat Metrics (Common)"="phablow", "Physical Habitat Metrics (Large)"="phabmed"),
                    Biological=c("Benthic Macroinvertebrate Count"="bentcts", "Benthic Macroinvertebrate MMI"="bentcond", "Fish Metrics"="fishmet", "Fish MMI"="fishcond", "Fish Counts" = "fishcts"))

choices2007 <- list(`Site Information`=c("Landscape Metrics"="basin_landuse_metrics_20061022", "Site Information"="sampledlakeinformation_20091113"),
                    Chemical=c("Hydrographic Profile"="profile_20091008", "Water Isotope"="isotopes_wide", "Water Chemistry Condition"="chemical_conditionestimates_20091123"),
                    Physical=c("Physical Habitat"="phab_indexvalues", "Physical Habitat Condition"="phab_condtionestimates_20091130", "Physical Habitat Metrics (A)"="phab_metrics_a", "Physical Habitat Metrics (B)"="phab_metrics_b"),
                    Biological=c("Benthic Macroinvertebrate Condition"="bentcond_08232016", "Benthic Macroinvertebrate Count"="wide_benthic_08092016", "Benthic Macroinvertebrate Metrics"="bentmet",
                                 "Phytoplankton Condition"="plankton_oemodel_conditionestimates_20091125", "Phytoplankton Count (Diamtoms)"="phytoplankton_diatomcount_20091125", 
                                 "Phytoplankton Count (Soft Algae)"="phytoplankton_softalgaecount_20091023", "Phytoplankton Sample Info"="phytoplankton_sampleinfo_20091023",  "Secchi Depth"="secchi_20091008", 
                                 "Trophic Status"="trophic_conditionestimate_20091123", "Zooplankton Count"="zooplankton_count_20091022", "Zooplankton Sample Info"="zooplankton_sampleinformation_20091020"))

choices0506 <- list(`Site Information`=c("Site Information"="siteinformationdata"),
                    Chemical=c("Sediment Contaminants"="sedchemdata", "Water Chemistry"="waterchemdata"),
                    Biological=c("Benthic Macroinvertebrates"="benthicdata"))


# Datasets ----
dataset2022 <- c("Landscape Metrics"="landscape_wide_0", "Site Information"="siteinfo", 
                 "Enterococci"="enterococci", "Fish Tissue-Mercury"="mercury", "Fish Tissue-Lipid Content"="lipid", "Fish Tissue-PCB Congeners"="pcb", "Fish Tissue-PFAS"="pfas",
                 "Cyanotoxin"="algaltoxins", "Atrazine"="atrazine", "Hydrographic Profile"="profile_wide", "Water Chemistry/Chlorophyll a"="waterchem_wide",
                 "Physical Habitat"="phab_wide", "Physical Habitat Metrics"="phabmets_wide_0", "Benthic Macroinvertebrate Count"="benthic_counts", "Benthic Macroinvertebrate Metrics"="benthic_metrics", "Benthic MMI"="benthic_mmi_0", "Benthic Taxa List"="benthic_taxa",
                 "Secchi Depth"="secchi", "Zooplankton Count"="zooplanktoncount_wide", "Zooplankton Taxa List"="zooplanktontaxa",
                 "Condition Estimates"="condition_combined_2024-08-13_0", "Data for Population Estimates"="nla2007-2022_data_forpopestimates_indexvisits_probsites_0", "Sample Grid"="sample_grid")

dataset2021 <- c("Site Information"="siteinfo",
                 "Microcystin"="microcystin",
                 "Water Chemistry/Chlorophyll a"="waterchem_wide",
                 "AA Characterization"="assewq_wide", "AA Hydrology Sources"="hydrology_sources_wide", "AA Hydrology USACOE"="hydrology_usacoe_wide", "Physical Alterations"="physalt_wide",
                 "Floras Used/VegPlot Layout"="vegplot_wide","Plant Cover/Height"="plant_wide", "Plant C Values"="plantcval", "Plant Native Status"="plantnative", "Plant WIS"="plantwis", "Plant Taxa"="planttaxa", "Tree Cover/Count"="tree_wide","VegPlot Location"="vegplotloc_wide")

# dataset2020 <- c("Site Information"="siteinfo",
#                  "Enterococci"="enterococci", "Fish Tissue (Plugs) - Mercury"="hg_fishplug", "Microcystin"="microcystin",
#                  "Hydrographic Profile"="hydrographic_profile","Secchi Depth"="secchi", "Sediment Contaminants"="sediment_chemistry", "Sediment Toxicity (Replicate)"="sediment_toxicity_sample_replicate", "Water Chemistry"="water_chemistry",
#                  "Benthic Macroinvertebrate Count"="benthic_count", "Benthic Taxa List"="benttaxalist", "Benthic Grab Info"="bent_grab", "ECOFISH Fish Collection "="ecological-fish-tissue-contaminants-fish-collection", "ECOFISH Contaminants"="ecological_fish_tissue_contaminants")

dataset1819 <- c("Cyanotoxin"="algal_toxin", "Benthic Macroinvertebrate Count"="benthic_macroinvertebrate_count", "Benthic Macroinvertebrate Metrics"="benthic_macroinvertebrate_metrics", "Enterococci"="enterococci_0",
                 "Field Chemistry Measures"="field_wide", "Fish Tissue (Plugs) - Mercury"="mercury_in_fish_tissue_plugs", "Fish Tissue (Fillets) - Mercury"="mercury", "Fish Tissue (Fillets) - PCB Congeners"="pcb", "Fish Tissue (Fillets) - PFAS"="pfas", "Fish Sampling Info"="fish-sampling-information", 
                 "Fish Count"="fish-count", "Fish Metrics"="fish-metrics", "Landscape Data"="landscape", "Periphyton Biomass"="pbio_0", "Periphyton/Chlorophyll a"="PeriChla", "Physical Habitat Metrics"="physical_habitat_larger_set_of_metrics", "Site Information"="SiteInfo", "Water Chemistry/Chlorophyll a"="water_chemistry_chla")

dataset2017 <- c("Cyanotoxin"="algal_toxin", "Atrazine"="atrazine", "Benthic Macroinvertebrate Count"="benthic_count", "Benthic Macroinvertebrate Metrics"="benthic_metrics", "Benthic Taxa List"="benthic_taxa_list", "Condition Estimates"="condition_estimates", "Data for Population Estimates"="data_for_population_estimates",
                 "E. Coli"="e.coli", "Hydrographic Profile"="profile", "Landscape Metrics"="landMets", "Physical Habitat"="phab", "Phytoplankton Count"="phytoplankton_count", "Phytoplankton Taxa List"="phytoplankton_taxa", "Secchi Depth"="secchi", "Sediment Contaminants"="sediment_chemistry", 
                 "Site Information"="site_information", "Water Chemistry/Chlorophyll a"="water_chemistry_chla", "Zooplankton Count"="zooplankton-count", "Zooplankton Count (Raw)"="zooplankton-raw-count", "Zooplankton Metrics"="zooplankton-metrics", "Zooplankton Taxa List"="zooplankton-taxa-list")


dataset2016 <- c("AA Characterization"="aa_characterization", "AA Hydrology USACOE"="aa_hydrology_usacoe", "AA Hydrology Stressors"="aa_hydrology_sources", "Buffer Native Cover"="buffer_characterization_natcover", 
                 "Buffer Stressors"="buffer_characterization_stressors", "Condition Estimates"="condition_estimates", "Data for Population Estimates"="2011_data_for_population_estimates", "Floras Used/VegPlot Layout"="floras_used_and_veg_plot_layout", "Ground Surface"="ground_surface", "Landscape Metrics"="landscape_metrics", "Microcystin"="microcystin", 
                 "Plant Cover Height"="plant-species-cover-height", "Plant C Values"="plant_cvalues", "Plant Native Status"="plant_native_status", "Plant Wis"="plant_wis", "Plant Taxa"="plant_taxa", "Site Information"="site-information", "Soil Horizon Chemistry"="soil_horizon_chemistry", 
                 "Soil Depth Core Chemistry"="soil_stddepth_core_chemistry", "Soil Horizon Description"="soil_horizon_description", "Soil Pit Characteristics"="soil_pit_characteristics",  
                 "Stressor Condition"="cond_stress", "Surface Water Characterization"="surface_water_characterization",  "Tree Cover/Count"="tree_cover_count", "Vegetation MMI"="veg_mmi", "Vegetation Type"="vegetation_type",
                 "VegPlot Location"="veg_plot_location", "Water Chemistry/Chlorophyll a"="water_chemistry_chla")

dataset2015 <- c("Benthic Macroinvertebrate Count"="benthic_count", "Benthic Grab Info"="benthic_grab", "ECOFISH Fish Collection "="ecological-fish-tissue-contaminants-fish-collection", "ECOFISH Contaminants"="ecological_fish_tissue_contaminants", "Enterococci"="enterococci", "Fish Tissue (Plugs) - Mercury"="mercury_in_fish_tissue_plugs",
                 "Fish Tissue (Fillets) - Mercury"="mercury", "Fish Tissue (Fillets) - Dioxin & Furan"="dioxin-furan", "Fish Tissue (Fillets) - Fatty Acids"="fatty-acids", "Fish Tissue (Fillets) - PCB Congeners"="pcb", "Fish Tissue (Fillets) - PFAS"="pfas",
                 "Hydrographic Profile"="hydrographic_profile", "Microcystin"="microcystin", "Secchi Depth"="secchi", "Sediment Contaminants"="sediment_chemistry", "Sediment Toxicity (Replicates)"="sediment_toxicity_sample_replicate", "Site Information"="site_information", "Water Chemistry"="water_chemistry")

dataset1314 <- c("Benthic Macroinvertebrate Count"="bentcnts", "Benthic Macroinvertebrate Metrics"="bentmet", "Benthic Macroinvertebrate MMI"="bentmmi", "Chlorophyll a"="widewchl", "Enterococci"="ente", "Field Chemistry"="wide_field_meas", 
                 "Fish Metrics"="fishmet", "Fish MMI"="fishmmi", "Fish Counts" = "fishcts", "Fish Tissue (Plugs) - Mercury"="fishplug_hg", "Indicator Condition"="key_var", "Microcystin"="micx", "Periphyton"="widepchl", "Periphyton Biomass"="widepbio", "Physical Habitat Metrics"="phabmed", 
                 "Site Information"="siteinformation_wide", "Water Chemistry"="widechem", "Water Chemistry Indicator"="chem")

dataset2012 <- c("Cyanotoxin"="algaltoxins", "Atrazine"="atrazine", "Benthic Condition"="bentcond", "Benthic Macroinvertebrate Count"="wide_benthic", "Benthic Macroinvertebrate Metrics"="bentmet", "Chlorophyll a"="chla_wide", 
                 "Phytoplankton Count"="wide_phytoplankton_count", "Physical Habitat"="wide_phab", "Physical Habitat Metrics"="wide_phabmet", "Secchi Depth"="secchi", "Sediment (Mercury)"="topsedhg", 
                 "Site Information"="wide_siteinfo", "Water Chemistry"="waterchem_wide", "Water Isotope Variables"="isotopes_wide", "Hydrographic Profile"="wide_profile", "Zooplankton Count"="zooplankton-count-data-updated", 
                 "Zooplankton Count (Raw)"="zooplankton-raw-count", "Zooplankton Metrics"="zooplankton-metrics-data-updated-12092021")

dataset2011 <- c("AA Characterization"="aachar", "Cyanotoxin"="algaltoxin", "Buffer Characterization"="bufferchar", "Chlorophyll a"="chla", "Disturbance Gradiant Inputs"="distgrad_inputs", "Floras/Vegplot Layouts"="floras_vegplotlayout",
                 "Hydrology"="hydro", "Indicator Conditions"="cond_stress", "Landscape Metrics"="landscapechar", "Plant Cover and Height"="plant_pres_cvr", "Plant Vouchers"="plantvoucher", "Sediment Enzymes"="sedenzymes", "Site Information"="siteinfo", 
                 "Soil Chemistry"="soilchem", "Soil Profile Descriptions"="soilprofhorizons", "Soil Profile Attributes" = "soilprofsum", "Tree Data"="tree", "USARAM Attributes"="usaram_attributes", "USARAM Summary"="usaram_summary", 
                 "Vegetation Metrics"="vegmetrics", "Vegetation MMI"="vegmmi", "Vegetation Plot Location"="vegplotloc", "Vegetation Type and Ground Surface"="vegtype_grndsurf", "Water Chemistry"="waterchem")

dataset2010 <- c("Benthic Macroinvertebrates"="benthic_data", 
                 "Fish Tissue (Fillets) - Mercury"="mercury", "Fish Tissue (Fillets) - Fatty Acids"="fatty-acids", "Fish Tissue (Fillets) - PBDE"="pbde", "Fish Tissue (Fillets) - PCB Congeners"="pcb", "Fish Tissue (Fillets) - PFAS"="pfas",
                 "ECOFISH Collection Info"="ecofish_collection_info", "ECOFISH Contaminants"="ecological_fish_tissue_contaminant_data", "Hydrographic Profile"="hydrolab", 
                 "Sediment Contaminants"="sediment_chemistry.revised.06.21.2016", "Sediment Toxicity"="sediment_toxicity_results", "Site Information"="siteinfo.revised.06212016", "Water Chemistry"="waterchem")

dataset0809 <- c("Benthic Macroinvertebrate Count"="bentcts", "Benthic Macroinvertebrate MMI"="bentcond", "Enterococci"="enterocond", "Field Chemistry"="fieldchemmeasure", "Fish Metrics"="fishmet", "Fish MMI"="fishcond", "Fish Counts" = "fishcts", 
                 "Landscape Metrics"="land", "Physcial Habitat Metrics (Common)"="phablow", "Physical Habitat Metrics (Large)"="phabmed", "Site Information"="siteinfo_0", "Water Chemistry"="chem", "Water Chemistry Indicator"="chemcond")

dataset2007 <- c("Benthic Macroinvertebrate Condition"="bentcond_08232016", "Benthic Macroinvertebrate Count"="wide_benthic_08092016", "Benthic Macroinvertebrate Metrics"="bentmet", "Hydrographic Profile"="profile_20091008", 
                 "Landscape Metrics"="basin_landuse_metrics_20061022", "Physical Habitat"="phab_indexvalues", "Physical Habitat Condition"="phab_condtionestimates_20091130", "Physical Habitat Metrics (A)"="phab_metrics_a", 
                 "Physical Habitat Metrics (B)"="phab_metrics_b", "Phytoplankton Condition"="plankton_oemodel_conditionestimates_20091125", "Phytoplankton Count (Diamtoms)"="phytoplankton_diatomcount_20091125", 
                 "Phytoplankton Count (Soft Algae)"="phytoplankton_softalgaecount_20091023", "Phytoplankton Sample Info"="phytoplankton_sampleinfo_20091023", "Secchi Depth"="secchi_20091008", "Site Information"="sampledlakeinformation_20091113", 
                 "Trophic Status"="trophic_conditionestimate_20091123", "Water Chemistry Condition"="chemical_conditionestimates_20091123", "Water Isotope"="isotopes_wide", "Zooplankton Count"="zooplankton_count_20091022", 
                 "Zooplankton Sample Info"="zooplankton_sampleinformation_20091020")

dataset0506 <- c("Benthic Macroinvertebrates"="benthicdata", "Sediment Contaminants"="sedchemdata", "Site Information"="siteinformationdata", "Water Chemistry"="waterchemdata")  


# siteinfo ----
site2022  <- list(Empty=c("Add Site Info (optional)"=""),
                  Local=c("Area (Hectares)"="AREA_HA", "County"="CNTYNAME", "Elevation"="ELEVATION", "Feature Type"="DES_FTYPE", "GNIS Name"="GNIS_NAME", "HUC8",
                          "Lake Origin"= "LAKE_ORGN", "Lake Owner"="OWN_NARS", "NES Site"="NES_SITE", "Size Class"="AREA_CAT6",  "Urban/NonUrban"="URBN_NLA17"),
                  Regional=c("Aggr. Ecoregion 3"="AG_ECO3", "Aggr. Ecoregion 9"="AG_ECO9", "EPA Region"="EPA_REG", "L3 Ecoregion"="US_L3NAME", "L4 Ecoregion"="US_L4NAME", "Major Basin Name"="MAJ_BAS_NM"),
                  NARS=c("Albers XCOORD"="XCOORD", "Albers YCOORD"="YCOORD", "Index Site Depth"="INDEX_SITE_DEPTH", "Index Site Latitude"="INDEX_LAT_DD", "Index Site Longitude"="INDEX_LON_DD", "Weight Category (NLA)"="WGT_CAT_NR_NLA", "Weights for NLA 2022 Pop. Estimates"="WGT_TP_CORE_NLA",
                         "Weight Category (NES)"="WGT_CAT_NES", "Weights for NES 2022 Pop. Estimates"="WGT_TP_NES", "Unique ID"="UNIQUE_ID"))

site2021  <- list(Empty=c("Add Site Info (optional)"=""),
                  Local=c("County"="CNTYNAME", "HUC12"="HUC12", "NEP Name"="NEP_NAME", "Wetland Class (Cowardin)"="WETCLS_EVL", "Wetland Class (HGM)"="WETCLS_HGM"),
                  Regional=c("Aggr. Ecoregion 3"="AG_ECO3", "Aggr. Ecoregion 9"="AG_ECO9", "EPA Region"="EPA_REG", "L3 Ecoregion"="US_L3NAME", "L4 Ecoregion"="US_L4NAME", "LRR Name"="LRR_NAME", "LRR Symbol"="LRR_SYM", "MLRA Symbol"="MLRARSYM", "NWCA Ecoregion 5"="NWCA_ECO5", "USACE Region"="COE_REGION"),
                  NARS=c("Albers XCOORD"="XCOORD", "Albers YCOORD"="YCOORD", "Panel"="PANEL_USE", "Stratum"="STRATUM", "Unique ID"="UNIQUE_ID", "Weights for 2021 Pop. Estimates"="WGT_TP_CORE"))

site2020est <- list(Empty=c("Add Site Info (optional)"=""),
                    Local=c("Estuarine Group"="EST_GROUP", "Estuary Size"="SMALL_EST", "NEP Name"="NEP_OR_ESTUARY_PROGRAM_NAME", "Station Depth"="STATION_DEPTH"),
                    Regional=c("DWH Region"="DWH_REGION", "EPA Region"="EPA_REG", "NCCA Region"="NCCA_REG", "Province"="PROVINCE"),
                    NARS=c("Albers XCOORD"="XCOORD", "Albers YCOORD"="YCOORD", "Stratum"="STRATUM", "Unique ID"="UNIQUE_ID", "Weights for 2020 Pop. Estimates"="WGT_SP"))
site2020gl <- list(Empty=c("Add Site Info (optional)"=""),
                   Local=c("Feature Name"="FEAT_NM", "Great Lake Name"="GREAT_LAKE", "NPS Name"="NPS_PARK", "Station Depth"="STATION_DEPTH"),
                   Regional=c("EPA Region"="EPA_REG", "Lake Region"="LAKE_REG", "NCCA Region"="NCCA_REG", "Province"="PROVINCE"),
                   NARS=c("Albers XCOORD"="XCOORD", "Albers YCOORD"="YCOORD", "Stratum"="STRATUM", "Unique ID"="UNIQUE_ID", "Weights for 2020 Pop. Estimates"="WGT_SP"))  

site1819 <- list(Empty=c("Add Site Info (optional)"=""),
                 Local=c("County"="CNTYNAME", "Feature Type"="FTYPE", "Elevation"="ELEVATION", "GNIS Name"="GNIS_NAME", "HUC8", 
                         "Strahler Order"="STRAH_ORD", "Urban/NonUrban"="URBN_NRS18", 
                         "Albers XCOORD"="XCOORD", "Albers YCOORD"="YCOORD"),
                 Regional=c("Aggr. Ecoregion 3"="AG_ECO3", "Aggr. Ecoregion 9"="AG_ECO9", "EPA Region"="EPA_REG", "L3 Ecoregion"="US_L3NAME", "L4 Ecoregion"="US_L4NAME", "Major Basin Name"="MAJ_BAS_NM", "Miss. Basin Name"="MIS_BAS_NM"),
                 NARS=c("NARS_Name"="NARS_NAME", "Unique ID"="UNIQUE_ID", "Weights for 2018/19 Pop. Estimates"="WGT_TP_CORE"))

site2017  <- list(Empty=c("Add Site Info (optional)"=""),
                  Local=c("Area (Hectares)"="AREA_HA", "County"="CNTYNAME", "Elevation"="ELEVATION", "Feature Type"="DES_FTYPE", "GNIS Name"="GNIS_NAME", "HUC8",
                          "Lake Origin"= "LAKE_ORGN", "Lake Owner"="OWN_NARS", "NES Lake"="NES_LAKE", "Site Type"="SITETYPE", "Size Class"="AREA_CAT6",  "Urban/NonUrban"="URBN_NLA17"),
                  Regional=c("Aggr. Ecoregion 3"="AG_ECO3", "Aggr. Ecoregion 9"="AG_ECO9", "EPA Region"="EPA_REG", "L3 Ecoregion"="US_L3NAME", "L4 Ecoregion"="US_L4NAME", "Major Basin Name"="MAJ_BAS_NM"),
                  NARS=c("Albers XCOORD"="XCOORD", "Albers YCOORD"="YCOORD", "Unique ID"="UNIQUE_ID", "Weight Category"="WGT_CAT", "Weights for 2017 Pop. Estimates"="WGT_TP_CORE"))

site2016  <- list(Empty=c("Add Site Info (optional)"=""),
                  Local=c("County"="CNTYNAME", "HUC12"="HUC12", "NEP Name"="NEP_NAME", "Reference NWCA"="REF_NWCA", "Wetland Class (Cowardin)"="WETCLS_EVL", "Wetland Class (HGM)"="WETCLS_HGM"),
                  Regional=c("Aggr. Ecoregion 3"="AG_ECO3", "Aggr. Ecoregion 9"="AG_ECO9", "EPA Region"="EPA_REG", "L3 Ecoregion"="US_L3NAME", "L4 Ecoregion"="US_L4NAME", "LRR Name"="LRR_NAME", "LRR Symbol"="LRR_SYM", "MLRA Symbol"="MLRARSYM", "USACE Region"="COE_REGION"),
                  NARS=c("Albers XCOORD"="XCOORD", "Albers YCOORD"="YCOORD", "Category"="PROB_CAT", "Panel"="PANEL_USE", "Stratum"="STRATUM", "Unique ID"="UNIQUE_ID", "Weights for 2016 Pop. Estimates"="WGT_TP_CORE"))

site2015est <- list(Empty=c("Add Site Info (optional)"=""),
                    Local=c("Estuarine Group"="EST_GROUP", "Estuary Size"="SMALL_EST", "Feature Name"="FEAT_NM",  "NEP Name"="NEP_NAME", "Station Depth"="STATION_DEPTH"),
                    Regional=c("DWH Region"="DWH_REGION", "EPA Region"="EPA_REG", "NCCA Region"="NCCA_REG", "Province"="PROVINCE"),
                    NARS=c("Albers XCOORD"="XCOORD", "Albers YCOORD"="YCOORD", "Stratum"="STRATUM", "Unique ID"="UNIQUE_ID", "Weights for 2015 Pop. Estimates"="WGT_SP"))
site2015gl <- list(Empty=c("Add Site Info (optional)"=""),
                   Local=c("Feature Name"="FEAT_NM", "Great Lake Name"="GREAT_LAKE", "NPS Name"="NPS_PARK", "Station Depth"="STATION_DEPTH"),
                   Regional=c("EPA Region"="EPA_REG", "Lake Region"="LAKE_REG", "NCCA Region"="NCCA_REG", "Province"="PROVINCE"),
                   NARS=c("Albers XCOORD"="XCOORD", "Albers YCOORD"="YCOORD", "Stratum"="STRATUM", "Unique ID"="UNIQUE_ID", "Weights for 2015 Pop. Estimates"="WGT_SP"))  

site1314 <- list(Empty=c("Add Site Info (optional)"=""),
                 Local=c("County"="CNTYNAME", "Elevation"="ELEVATION", "GNIS Name"="GNIS_NAME", "HUC8", "Strahler Order"="STRAH_CAL", "Urban/NonUrban"="NRS13_URBN"),
                 Regional=c("Aggr. Ecoregion 3"="AG_ECO3", "Aggr. Ecoregion 9"="AG_ECO9",  "EPA Region"="EPA_REG", "L3 Ecoregion"="US_L3NAME", "L4 Ecoregion"="US_L4NAME", "Major Basin Name"="MAJ_BAS_NM"),
                 NARS=c("Albers XCOORD"="XCOORD", "Albers YCOORD"="YCOORD", "NARS_Name"="NARS_NAME", "Weights for 1314 Pop. Estimates"="WGT_EXT_SP"))

site2012 <- list(Empty=c("Add Site Info (optional)"=""),
                 Local=c("Area (Hectares)"="AREA_HA", "County"="CNTYNAME", "Elevation"="ELEVATION", "Feature Type"="DES_FTYPE", "GNIS Name"="GNIS_NAME", "HUC8",
                         "Lake Origin"="LAKE_ORIGIN", "Lake Owner"="OWNSHP", "Site Type"="SITETYPE", "Size Class"="SIZE_CLASS", "Urban/NonUrban"="URBAN"),
                 Regional=c("Aggr. Ecoregion 3"="AGGR_ECO3_2015", "Aggr. Ecoregion 9"="AGGR_ECO9_2015", "EPA Region"="EPA_REG","Major Basin Number"="MAJ_BASIN"),
                 NARS=c("NES Lake"="NES_LAKE", "Albers XCOORD"="XCOORD", "Albers YCOORD"="YCOORD", "Weight Category"="WGT_CAT", "Weights for 2012 Pop. Estimates"="WGT_ALL"))

site2011 <- list(Empty=c("Add Site Info (optional)"=""),
                 Local=c("County"="CNTYNAME", "HUC12"="HUC12", "LRR Name"="LRR_NAME", "LRR Symbol"="LRR_SYM", "MLRA Symbol"="MLRARSYM", "NEP Name"="NEP_NAME", "Wetland Class (Cowardin)"="WETCLS_EVL", "Wetland Class (HGM)"="WETCLS_HGM"),
                 Regional=c("Aggr. Ecoregion 3"="AG_ECO3", "Aggr. Ecoregion 9"="AG_ECO9", "EPA Region"="EPA_REG", "USACE Region"="COE_REGION", "L3 Ecoregion"="US_L3NAME", "L4 Ecoregion"="US_L4NAME"),
                 NARS=c("Albers XCOORD"="XCOORD", "Albers YCOORD"="YCOORD", "Unique ID"="UNIQUE_ID", "Weights for 2011 Pop. Estimates"="WGT_TP"))

site2010 <- list(Empty=c("Add Site Info (optional)"=""),
                 Local=c("NEP Name"="NEP_NM", "NPS Name"="NPSPARK", "Resource Class"="RSRC_CLASS", "Station Depth"="STATION_DEPTH", "Waterbody Name"="WTBDY_NM"),
                 Regional=c("EPA Region"="EPA_REG", "NCCA Region"="NCCR_REG", "Province"="PROVINCE"),
                 NARS=c("Stratum"="STRATUM", "Weights for 2010 Pop. Estimates"="WGT_NCCA10"))

site0809 <- list(Empty=c("Add Site Info (optional)"=""),
                 Local=c("HUC8", "Location Name"="LOC_NAME", "Strahler Order"="STRAHLERORDER", "Urban/NonUrban"="URBAN", "Watershed Area"="WSAREA_NARS"),
                 Regional=c("Aggr. Ecoregion 3"="AGGR_ECO3_2015", "Aggr. Ecoregion 9"="AGGR_ECO9_2015", "EPA Region"="EPA_REG"),
                 NARS=c("Weights for 0809 Pop. Estimates"="WGTNRSA09"))

site2007 <- list(Empty=c("Add Site Info (optional)"=""),
                 Local=c("Area (Hectares)"="AREA_HA", "County"="CNTYNAME", "Elevation"="ELEV_PT", "Lake Origin"="LAKE_ORIGIN", "Lake Perimeter"="LAKEPERIM", "Lake Max Depth"="DEPTHMAX", "Site Type"="SITETYPE", "Urban/NonUrban"="URBAN"),
                 Regional=c("Aggr. Ecoregion 3"="WSA_ECO3", "Aggr. Ecoregion 9"="WSA_ECO9", "EPA Region"="EPA_REG", "HUC8"="HUC_8", "Lake Name"="LAKENAME", "Lake Origin"="LAKE_ORIGIN"),
                 NARS=c("Albers XCOORD"="ALBERS_X", "Albers YCOORD"="ALBERS_Y", "NES Lake"="NESLAKE", "Size Class"="SIZE_CLASS", "Weights for 2007 Pop. Estimates"="WGT_NLA"))

site0506 <- list(Empty=c("Add Site Info (optional)"=""),
                 Local=c("Estuary"="ESTUARY"),
                 Regional=c("EPA Region"="EPA_REG", "NCA Region"="NCA_REGION"),
                 NARS=c("Weights for 99-01 Pop. Estimates"="WGT_NCA_91", "Weights for 05-06 Pop. Estimates"="WGT_NCA_56"))

#Remove State input when these datasets are called
RemoveState <- c("plant_cvalues", "plant_taxa", "plant_wis", "plant_native_status", "plantcval", "plantnative", "planttaxa", "Plantwis", "condition_estimates", "benthic_taxa_list", 
                 "phytoplankton_taxa","zooplankton-taxa-list","zooplanktontaxa","benthic_taxa","benttaxalist","condition_combined_2024-08-13_0")

