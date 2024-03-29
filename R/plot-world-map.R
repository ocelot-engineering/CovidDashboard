#
# Plot world map
#
# TODO: docs, tests, hardening and clean up
# TODO: map should be put in module to be reusable

#' @importFrom leaflet colorBin labelOptions highlightOptions setView addPolygons
#' @importFrom rnaturalearth ne_countries
#' @importFrom dplyr select left_join
plot_world_map <- function(outbreak_ratings, zoom = 1) {

    # Get world map polygons
    world_map_polys <- rnaturalearth::ne_countries(returnclass = "sf") %>%
        dplyr::select(NAME = .data$name, ISO2 = .data$iso_a2, GEOMETRY = .data$geometry) %>%
        dplyr::left_join(outbreak_ratings, by = c("ISO2" = "COUNTRY_CODE"))

    # Generate labels for each coutnry
    country_labels <- generate_map_labels(dat = world_map_polys)

    # Set up color palette
    bins <- c(0, seq(1, 30, length.out = 7), 100)
    palette <- leaflet::colorBin("YlOrRd", domain = world_map_polys[["OUTBREAK_RATING"]], bins = bins)

    # Generate world map output
    world_map <- leaflet::leaflet() %>%
        leaflet::setView(lng = 0, lat = 50, zoom = zoom) %>%
        leaflet::addPolygons(
            data = world_map_polys,
            fillColor = ~ palette(OUTBREAK_RATING),
            weight = 1,
            color = "lightblue",
            opacity = 0.2,
            fillOpacity = 0.5,
            highlightOptions = leaflet::highlightOptions(
                weight = 2,
                color = "#666"
            ),
            label = country_labels,
            labelOptions = leaflet::labelOptions(
                style = list("font-weight" = "normal", padding = "3px 8px"),
                textsize = "15px",
                direction = "auto"
            )
        )

    return(world_map)
}


#' Generates html labels for world map
#' @param dat dataframe with COUNTRY, OUTBREAK_RATING and OUTBREAK_DESC columns
#' @importFrom purrr map
generate_map_labels <- function(dat) {

    countries     <- dat[["COUNTRY"]]
    rating        <- dat[["OUTBREAK_RATING"]]
    outbreak_desc <- dat[["OUTBREAK_DESC"]]

    map_labels <- paste0(
        "<b>", countries, "</b><br>",
        "Outbreak rating: ", outbreak_desc, "<br>"
    ) %>% purrr::map(shiny::HTML)

    return(map_labels)

}