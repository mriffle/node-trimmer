## Examples of how to use the GO DAG trimmer function
## Michael Riffle <mriffle@uw.edu>
## February 2023

# import the GO DAG trimming function
source('https://raw.githubusercontent.com/mriffle/node-trimmer/main/node-trimmer-functions.R')

# read in and prepare the GO DAG used by metagomics
go_structure <- read.delim("https://raw.githubusercontent.com/mriffle/node-trimmer/main/go_structure.txt", header=FALSE, stringsAsFactors=FALSE)
names(go_structure) <- c('parent', 'parent_name', 'child', 'child_name')

# read in GO a report from a specific metagomics run
# change the path to where the file is on your computer
raw_go_data <- read.delim("/Users/michaelriffle/Downloads/go_report_961.txt", comment.char="#", header=TRUE, stringsAsFactors=FALSE)

# grab just the columns we want as a named list
# here we are using the ratio as the value on the GO nodes. this could be counts
go_data = as.list(raw_go_data$ratio)
names(go_data) = raw_go_data$GO.acc

# get the set of GO leaves after trimming the DAG using the given threshold
results = get_independent_nodes(go_structure, go_data, threshold = 0.1)

# report the number of leaves returned
length(results$leaves)

# list the number of leaves returned
results

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
