#' Create a Summary of the Data for a hosp_network Object
#'
#' @details \code{weights} is the \code{\link{hub_score}} and \code{\link{authority_score}} option already given in this function, so to do more customization, please choose other options.
#'
#' @param object An object of class \code{hosp_network}
#' @param by Two options, either \code{'unit'} or \code{'room'}, telling whether to graph by unit or room interconnectivity
#' @param ... Additional arguments to be passed to \code{\link{hub_score}} and \code{\link{authority_score}}, such as \code{scale}. The ones already set are listed in the details above.
#'
#' @return A list containing the edges, nodes, largest cliques, hub score, authority score, edge density, mean distance, betweenness, reciprocity, degree, Eigen centrality, and assortativity degree of the network given by the object. Check out the following help pages to learn more about the functions used to calculate statistics:
#' \itemize{
#'   \item Largest Cliques - \code{\link{largest_cliques}}
#'   \item Hub Score - \code{\link{hub_score}}
#'   \item Authority Score - \code{\link{authority_score}}
#'   \item Edge Density - \code{\link{edge_density}}
#'   \item Mean Distance - \code{\link{mean_distance}}
#'   \item Betweenness - \code{\link{betweenness}}
#'   \item Reciprocity - \code{\link{reciprocity}}
#'   \item Degree - \code{\link{degree}}
#'   \item Eigen Centrality - \code{\link{eigen_centrality}}
#'   \item Assortativity Degree - \code{\link{assortativity_degree}}
#' }
#'
#' @export
#'
#' @importFrom igraph graph_from_data_frame largest_cliques hub_score authority_score edge_density mean_distance betweenness reciprocity degree eigen_centrality assortativity_degree
#'
#' @examples
#' hn_data <- hosp_network_data # read in example data provided in package
#'
#' cleaned_hn_data <- clean_hosp_network(data = hn_data, uniqueID = UniqueEncountID, startDate = BeginDate, endDate = EndDate, unitName = UnitName, roomNum = RoomNumber) # clean the data using specific columns in the dataset
#'
#' hn_object <- hosp_network(x = cleaned_hn_data, fromUnit = UnitName, toUnit = next_unit, fromRoom = RoomNumber, toRoom = next_room) # create an object of class hosp_network
#'
#' summary(hn_object) # create summary for hosp_network object's unit data
#'
#' summary(hn_object, by = "room", scale = FALSE) # create summary for hosp_network object's room data but do not scale hub scores and authority scores
summary.hosp_network <- function(object, by = c("unit", "room"), ...) {

  by <- match.arg(by)

  switch(by, "unit" = {

    from <- attr(object, "from_unit")

    to <- attr(object, "to_unit")

    if(length(from) == 0 | length(to) == 0) {

      stop("You must have both a from unit and a to unit in your data to get the summary for the unit data.", call. = FALSE)

    }

    from_to <- cbind(from, to)

  }, "room" = {

    from <- attr(object, "from_room")

    to <- attr(object, "to_room")

    if(length(from) == 0 | length(to) == 0) {

      stop("You must have both a from room and a to room in your data to get the summary for the room data.", call. = FALSE)

    }

    from_to <- cbind(from, to)

  })

  from_missing <- which(is.na(from) | is.null(from))

  to_missing <- which(is.na(to) | is.null(to))

  data <- from_to[-c(from_missing, to_missing),]

  edges <- cbind(data[,1], data[,2])

  nodes <- unique(c(edges[,1], edges[,2]))

  net1 <- graph_from_data_frame(d = edges, vertices = nodes, directed = TRUE)

  large_cliques <- largest_cliques(net1)

  hub_scores <- hub_score(net1, weights = NA, ...)$vector

  authority_scores <- authority_score(net1, weights = NA, ...)$vector

  net_density <- edge_density(net1, loops = TRUE)

  net_distance <- mean_distance(net1, directed = TRUE)

  net_betweenness <- betweenness(net1)

  net_reciprocity <- reciprocity(net1)

  net_degree <- degree(net1)

  net_eigen_cent <- eigen_centrality(net1)

  assort_degree <- assortativity_degree(net1, directed = TRUE)

  output <- list(edges, nodes, large_cliques, hub_scores, authority_scores, net_density,
                 net_distance, net_betweenness, net_reciprocity, net_degree,
                 net_eigen_cent, assort_degree)

  names(output) <- c("Edges", "Nodes", "Largest Cliques", "Hub Score", "Authority Score",
                     "Edge Density", "Mean Distance", "Betweenness", "Reciprocity",
                     "Degree", "Eigen Centrality", "Assortativity Degree")

  return(output)

}
