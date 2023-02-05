#strategy: get all leaves, for all leaves beneath threshold:
#  get indices of all those leaves in child list
#  remove those rows from parent and child lists
#  re-get all leaves and repeat until no changes
#  return leaves

# edges is a data frame that must include a column named
# "child" and a column named "parent", which are the names of the
# node linked by a child -> parent relationship.
#
# node_values must be a a named list with the same node names as
# edges and some numeric value to test for threshold
get_independent_nodes <- function(edges, node_values, threshold) {
  children = as.vector(edges$child)
  parents = as.vector(edges$parent)
  
  leaves <- get_leaves(children, parents)
  leaves_to_remove <- get_leaves_to_remove(leaves, node_values, threshold)
  
  while(length(leaves_to_remove) > 1) {
    print(paste("Removing", length(leaves_to_remove), "nodes..."))
    remove_results <- remove_leaves(leaves_to_remove, children, parents)
    children <- remove_results$children
    parents <- remove_results$parents
    
    leaves <- get_leaves(children, parents)
    leaves_to_remove <- get_leaves_to_remove(leaves, node_values, threshold)
  }
  
  return(list(leaves=leaves, remaining_edges=data.frame(child=children, parent=parents)))
}

remove_leaves <- function(leaves_to_remove, children, parents) {
  indices <- which(children %in% leaves_to_remove)
  children <- children[-indices]
  parents <- parents[-indices]
  
  return(list(children=children, parents=parents))
}

get_leaves_to_remove <- function(leaves, node_values, threshold) {
  leaves_to_remove = c()
  for(acc in leaves) {
    
    # if we have no value for this node, remove it    
    if(is.null(node_values[[acc]])) {
      leaves_to_remove <- append(leaves_to_remove, acc)
    }
    
    # if this node's value is less than the threshold, remove it
    else if(node_values[[acc]] < threshold) {
      leaves_to_remove <- append(leaves_to_remove, acc)
    }
  }
  
  return(leaves_to_remove)
}

get_leaves <- function(child_nodes, parent_nodes) {
  return(setdiff(child_nodes, parent_nodes))
}
