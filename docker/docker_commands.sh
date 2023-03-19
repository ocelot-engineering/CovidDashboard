# Docker commands

# Run container
# TODO: use docker compose
docker run --rm -ti -p 3838:3838 -d shinycontainer

# Run with bind mount for live code updates
# docker run --rm -ti -p 3838:3838 -d -v "$(pwd):/srv/shiny-server/CovidDashboard:ro" shinycontainer # 

# Open bash terminal in container
docker exec -it <container_name> bash
