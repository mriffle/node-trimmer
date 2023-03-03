# filter the dataframe generated from a metagomics taxonomy report on the
# supplied taxonomic level (e.g., 'class')
#
# returns a subset of the dataframe containing only items for that
# taxonomic class
filter_taxonomy_report_on_taxon_level <- function(taxa_report_df, level) {
  return (taxa_report_df[which(taxa_report_df$taxonomy.rank == level),])
}

# return a data frame equal the supplied data frame but with an added
# column: ratio.of.taxon
#
# this column is the fraction of the total signal for the respective
# taxon represented by the respective GO term
generate_ratio_of_taxon_report <- function(taxa_report_df) {
  
  # create lookup map of total signal for all taxa
  taxon_lookup_map <- generate_lookup_map_for_taxa_intensity(taxa_report_df)
  
  # add new column
  taxa_report_df$ratio.of.taxon = apply(taxa_report_df, 1, function(x) {
    as.numeric(x['PSM.count']) / as.numeric(taxon_lookup_map[[x['taxon.name']]])
  })
  
  return(taxa_report_df)
}

generate_lookup_map_for_taxa_intensity <- function(taxa_report_df) {
  sublist <- taxa_report_df[which(taxa_report_df$GO.acc == "n/a"), ]
  intensities <- as.list(sublist$PSM.count)
  names(intensities) <- sublist$taxon.name
  return(intensities)
}
