#
# Plot world map
#
# TODO: docs, tests, hardening and clean up
# TODO: map should be put in module to be reusable

plot_world_map <- function(outbreak_ratings) {
    
    # Get world map polygons
    world_map_polys <- rnaturalearth::ne_countries(returnclass = "sf") %>% 
        dplyr::select(NAME = name, ISO2 = iso_a2, GEOMETRY = geometry) %>% 
        dplyr::left_join(outbreak_ratings, by = c("ISO2" = "COUNTRY_CODE"))
    
    # Generate labels for each coutnry
    country_labels <- generate_map_labels(dat = world_map_polys)
    
    # Set up color pallet
    bins <- c(0, seq(1, 30, length.out = 7), 100)
    pallet <- colorBin("YlOrRd", domain = world_map[["OUTBREAK_RATING"]], bins = bins)
    
    # Generate world map output
    world_map <- leaflet::leaflet() %>% 
        setView(lng = 0, lat = 50, zoom = 1) %>% 
        leaflet::addPolygons(data = world_map_polys,
                             fillColor = ~pallet(OUTBREAK_RATING),
                             weight = 1,
                             color = "lightblue",
                             opacity = 0.2,
                             fillOpacity = 0.5,
                             highlightOptions = highlightOptions(
                                 weight = 2,
                                 color = "#666"),
                             label = country_labels,
                             labelOptions = labelOptions(
                                 style = list("font-weight" = "normal", padding = "3px 8px"),
                                 textsize = "15px",
                                 direction = "auto")
        )
    
    return(world_map)
}


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
