get_leaves <- function(child_nodes, parent_nodes) {
  return(setdiff(child_nodes, parent_nodes))
}

get_roots <- function(child_nodes, parent_nodes) {
  return(setdiff(parent_nodes, child_nodes))
}

create_go_name_map <- function(dag_structure) {
  l <- c()
  
  for (row in 1:nrow(dag_structure)) {
    l[dag_structure[row, "parent"]] = dag_structure[row, "parent_name"]
    l[dag_structure[row, "child"]] = dag_structure[row, "child_name"]
  }
  
  return(l)
}

create_parent_relationship_map <- function(parents, children) {
  l <- list()
  
  for (row in 1:length(parents)) {
    parent = parents[row]
    if(is.null(l[[parent]])) {
      l[[parent]] = c()
    }
    l[[parent]] = append(l[[parent]], children[row])
  }
  
  return(l)
}
