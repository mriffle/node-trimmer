## Examples of how to use the GO DAG trimmer function
## Michael Riffle <mriffle@uw.edu>
## February 2023

# import the GO DAG trimming function
source('https://raw.githubusercontent.com/mriffle/node-trimmer/main/node-trimmer-functions.R')

# read in and prepare the GO DAG used by metagomics
go_structure <- read.delim("https://raw.githubusercontent.com/mriffle/node-trimmer/main/go_structure.txt", header=FALSE, stringsAsFactors=FALSE)
names(go_structure) <- c('parent', 'parent_name', 'child', 'child_name')

#########
# THE NEXT TWO BLOCKS ARE DIFFERENT WAYS TO GET GO DATA, ONLY USE ONE OF THEM #
#########

############# WORK WITH GO RATIOS ALL TIME POINTS #######################

# read in all GO ratios, change the file path to the location on your computer
all_go_ratios <- read.csv("/mnt/c/Users/mriffle/Desktop/HAB_2021_GOratios_all.csv", header=TRUE, stringsAsFactors=FALSE)

# create a single named list where the names are the GO accession strings
# and the values are the means of the ratios for all time points. This
# single value can be used for thresholding
go_data = as.list(rowMeans(all_go_ratios[,4:39], na.rm = TRUE))
names(go_data) = all_go_ratios[,1]

#########################################################################


############# WORK WITH A SINGLE METAGOMICS RUN #########################

# read in GO a report from a specific metagomics run
# change the path to where the file is on your computer
raw_go_data <- read.delim("/Users/michaelriffle/Downloads/go_report_961.txt", comment.char="#", header=TRUE, stringsAsFactors=FALSE)

# grab just the columns we want as a named list
# here we are using the ratio as the value on the GO nodes. this could be counts
go_data = as.list(raw_go_data$ratio)
names(go_data) = raw_go_data$GO.acc

#########################################################################

############# GET THE SET OF INDEPENDENT GO TERMS #######################

# get the set of GO leaves after trimming the DAG using the given threshold
# make the threshold smaller to get more GO Nodes
results = get_independent_nodes(go_structure, go_data, threshold = 0.2)

results$leaves      # print the set of GO terms to use for clustering, etc

# report the number of leaves returned
length(results$leaves)

########################################################################

########################################################################
# Filter the all_go_ratios data to only include rows from the filtered
# set of independent GO terms
########################################################################

filtered_go_ratios = all_go_ratios[which(all_go_ratios$GO.acc %in% results$leaves),]

View(filtered_go_ratios)   # view the data

############## VERY BASIC VISUALIZATION, WORK IN PROGRESS ##############

# very basic visualization for the moment of the resulting DAG
install.packages('visNetwork')
library(visNetwork)

children = unlist(results$remaining_edges['child'], use.names=FALSE)
parents = unlist(results$remaining_edges['parent'], use.name=FALSE)

# use visNetwork to visualize
unique_nodes = unique(c(children, parents))
nodes = data.frame(id = unique_nodes, label = unique_nodes)
edges = data.frame(from = children, to = parents)
visNetwork(nodes, edges, width = "100%", height="500px") %>% 
  visEdges(arrows = "to") %>% 
  visHierarchicalLayout()

visualize_go_dag(unique_nodes, list(), children, parents)

########################################################################
