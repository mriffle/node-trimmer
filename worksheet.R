source('node-trimmer-functions.R')
source('misc-go-functions.R')

# read in and prepare the data
go_structure <- read.delim("~/RProjects/node-trimmer/go_structure.txt", header=FALSE, stringsAsFactors=FALSE)
names(go_structure) <- c('parent', 'parent_name', 'child', 'child_name')

# some basic sanity checks of our functions
go_name_map = create_go_name_map(go_structure)
go_name_map['GO:0044237']
go_name_map['GO:0001887']

parent_relationship_map = create_parent_relationship_map(go_structure)
parent_relationship_map
parent_relationship_map[['all']]    # should have six things, including:
go_name_map['GO:0005575']   # cellular component
go_name_map['GO:0003674']   # molecular function
go_name_map['GO:0008150']   # biological process

leaves <- get_leaves(go_structure$child, go_structure$parent)
leaves
parent_relationship_map[['GO:0008165']]   # should be null, it's a leaf


###########

# read in GO report from metagomics
raw_go_data <- read.delim("/mnt/c/Users/mriffle/Downloads/go_report_970.txt", comment.char="#", header=TRUE, stringsAsFactors=FALSE)

# grab just the columns we want as a named vector
go_data = as.list(raw_go_data$ratio)
names(go_data) = raw_go_data$GO.acc
go_data[['GO:0005575']]
go_data['foo']

results = get_independent_nodes(go_structure, go_data, 0.5)
length(results$leaves)

#install.packages('visNetwork')
library(igraph)
library(visNetwork)

children = unlist(results$remaining_edges['child'], use.names=FALSE)
parents = unlist(results$remaining_edges['parent'], use.name=FALSE)
children
parents

# use visNetwork to visualize
unique_nodes = unique(c(children, parents))
nodes = data.frame(id = unique_nodes, label = unique_nodes)
edges = data.frame(from = children, to = parents)
visNetwork(nodes, edges, width = "100%", height="500px") %>% 
  visEdges(arrows = "to") %>% 
  visHierarchicalLayout()


# use Rgraphviz to visualize
if (!require("BiocManager", quietly = TRUE))
  install.packages("BiocManager")

BiocManager::install("Rgraphviz")
library(Rgraphviz)
graphvizCapabilities()

