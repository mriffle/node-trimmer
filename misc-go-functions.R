
create_go_name_map <- function(dag_structure) {
  l <- c()
  
  for (row in 1:nrow(dag_structure)) {
    l[dag_structure[row, "parent"]] = dag_structure[row, "parent_name"]
    l[dag_structure[row, "child"]] = dag_structure[row, "child_name"]
  }
  
  return(l)
}

create_parent_relationship_map <- function(dag_structure) {
  l <- list()
  
  for (row in 1:nrow(dag_structure)) {
    parent = dag_structure[row, "parent"]
    if(is.null(l[[parent]])) {
      l[[parent]] = c()
    }
    l[[parent]] = append(l[[parent]], dag_structure[row, "child"])
  }
  
  return(l)
}
