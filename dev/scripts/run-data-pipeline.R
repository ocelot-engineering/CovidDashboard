#
# Refresh all data from WHO and builds features
#
# Each stage of the pipeline should be a self contained function
#

devtools::load_all()

# Pipeline ----------------------------------------------------------------

# TODO: consider that there may be a better way of doing this. This function
# potentially tries to generalise the process too much. Moving forward there
# may be data from other sources (such as OECD for historical population) which
# requires bespoke extraction. For now, we will keep it as is and change when we
# have to. But the lesson should be that the scope of this application and the
# data it uses may change.
run_etl_pipline()
