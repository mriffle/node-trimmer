source('https://raw.githubusercontent.com/mriffle/node-trimmer/main/misc-go-functions.R')

visualize_go_dag = function(
    go_accs,
    go_names,
    children,
    parents
) {
  levels = get_levels(go_accs, children, parents)
  print(levels)
  nodes = data.frame(id = go_accs, label = go_accs, level = levels)
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
  nodes_to_fill = get_roots(children, parents)
  
  while(!is.null(nodes_to_fill) && length(nodes_to_fill) > 0) {
    levels[which(go_accs %in% nodes_to_fill)] = level
    new_nodes_to_fill = c()
    level = level + 1
    for(go_acc in nodes_to_fill) {
      new_nodes_to_fill = append(new_nodes_to_fill, parent_child_map[[go_acc]])
    }
    nodes_to_fill = unique(new_nodes_to_fill)
  }

  return(levels)
}