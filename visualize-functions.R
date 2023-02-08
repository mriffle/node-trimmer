source('https://raw.githubusercontent.com/mriffle/node-trimmer/main/misc-go-functions.R')

visualize_go_dag = function(
    go_accs,
    go_names,
    children,
    parents
) {
  levels = get_levels(go_accs, children, parents)
  nodes = data.frame(id = go_accs, label = levels, levels = levels)
  edges = data.frame(from = children, to = parents)
  
  visNetwork(nodes, edges, width = "100%", height="500px") %>% 
    visEdges(arrows = "to") %>% 
    visHierarchicalLayout()
}

get_levels = function(go_accs, children, parents) {
  parent_child_map <- create_parent_relationship_map(parents, children)
  print(parent_child_map[['all']])
  level = 1
  levels = rep(c(0),times=length(go_accs))
  root_nodes = get_roots(children, parents)

  fill_levels(levels, level, go_accs, root_nodes, parent_child_map)
  return(levels)
}

fill_levels = function(levels, level, go_accs, go_accs_to_fill, parent_child_map) {
  print(paste('0', go_accs_to_fill))
  print(which(go_accs %in% go_accs_to_fill))
  
  levels[which(go_accs %in% go_accs_to_fill)] = level
  print(levels)
  
  level = level + 1
  for(go_acc in go_accs_to_fill) {
    new_nodes = parent_child_map[[go_acc]]
    print(paste('1', go_acc))
    print(paste(new_nodes))
    if(!is.null(new_nodes) && length(new_nodes) > 0) {
      fill_levels(levels, level, go_acc, new_nodes, parent_child_map)
    }
  }
}
