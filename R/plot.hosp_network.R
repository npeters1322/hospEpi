#' @title Plot a \code{hosp_network} Object
#'
#' @description Create a network graph of your patient location history data
#'
#' @details \code{edge.arrow.size}, \code{edge.curved}, \code{vertex.label}, \code{vertex.label.cex}, \code{vertex.size}, \code{asp}, \code{layout}, and \code{main} are the \code{\link{plot.igraph}} options already given by this function, so to do more customization, please choose other options.
#'
#' @param x An object of class \code{hosp_network}
#' @param by Two options, either \code{'unit'} or \code{'room'}, telling whether to graph by unit or room interconnectivity
#' @param type Three options, either \code{'simple'}, \code{'hub score'}, or \code{'authority score'}, telling how the nodes should be sized. Simple graphs the nodes as all the same size, while the other two graph the nodes with sizes corresponding to their respective scores (see \code{\link{hub_score}} and \code{\link{authority_score}}).
#' @param ... Additional arguments to be passed to \code{\link{plot.igraph}}, such as \code{vertex.color}. The ones already set are listed in the details section.
#'
#' @return Returns NULL, invisibly, as \code{\link{plot.igraph}} is used to output the plot
#' @export
#'
#' @importFrom igraph graph_from_data_frame plot.igraph hub_score authority_score layout.fruchterman.reingold
#'
#' @examples
#' hn_data <- hosp_network_data # read in example data provided in package
#'
#' cleaned_hn_data <- clean_hosp_network(data = hn_data, uniqueID = UniqueEncountID, startDate = BeginDate, endDate = EndDate, unitName = UnitName, roomNum = RoomNumber) # clean the data using specific columns in the dataset
#'
#' hn_object <- hosp_network(x = cleaned_hn_data, fromUnit = UnitName, toUnit = next_unit, fromRoom = RoomNumber, toRoom = next_room) # create an object of class hosp_network
#'
#' plot(hn_object) # plot the hosp_network object using the unit data and type = simple, as those are the default options
#'
#' plot(hn_object, by = "room", type = "hub score") # plot hosp_network object using room data and type = hub score
#'
#' plot(hn_object, by = "unit", type = "authority score", vertex.color = "red") # plot hosp_network object using unit data, type = authority score, and vertex color = red
plot.hosp_network <- function(x, by = c("unit", "room"), type = c("simple", "hub score", "authority score"), ...) {

  by <- match.arg(by)

  type <- match.arg(type)

  switch(by, "unit" = {

    from <- attr(x, "from_unit")

    to <- attr(x, "to_unit")

    if(length(from) == 0 | length(to) == 0) {

      stop("You must have both a from unit and a to unit in your data to plot the unit data.", call. = FALSE)

    }

    from_to <- cbind(from, to)

    title <- "Unit"

  }, "room" = {

    from <- attr(x, "from_room")

    to <- attr(x, "to_room")

    if(length(from) == 0 | length(to) == 0) {

      stop("You must have both a from room and a to room in your data to plot the room data.", call. = FALSE)

    }

    from_to <- cbind(from, to)

    title <- "Room"

  })

  from_missing <- which(is.na(from) | is.null(from))

  to_missing <- which(is.na(to) | is.null(to))

  data <- from_to[-c(from_missing, to_missing),]

  edges <- cbind(data[,1], data[,2])

  nodes <- unique(c(edges[,1], edges[,2]))

  net1 <- graph_from_data_frame(d = edges, vertices = nodes, directed = TRUE)

  switch(type, "simple" = {

    plot.igraph(net1, edge.arrow.size = 0.1, edge.curved = 0.03, vertex.label = nodes,
                vertex.label.cex = 0.7, vertex.size = 2.3, asp = 0.5,
                layout = layout.fruchterman.reingold, main = paste(title, "Interconnectivity"), ...)

  }, "hub score" = {

    hs <- hub_score(net1, weights = NA)$vector

    plot.igraph(net1, edge.arrow.size = 0.1, edge.curved = 0.03, vertex.label = nodes,
                vertex.label.cex = 0.7, vertex.size = hs * 10, asp = 0.5,
                layout = layout.fruchterman.reingold, main = paste(title, "Size by Hub Score"), ...)

  }, "authority score" = {

    as <- authority_score(net1, weights = NA)$vector

    plot.igraph(net1, edge.arrow.size = 0.1, edge.curved = 0.03, vertex.label = nodes,
                vertex.label.cex = 0.7, vertex.size = as * 10, asp = 0.5,
                layout = layout.fruchterman.reingold, main = paste(title, "Size by Authority Score"), ...)

  })

}
