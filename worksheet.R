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

raw_go_data <- read.delim("/Users/michaelriffle/Downloads/go_report_961.txt", comment.char="#", header=TRUE, stringsAsFactors=FALSE)
go_data = data.frame(acc=raw_go_data$GO.acc, count=raw_go_data$count)
