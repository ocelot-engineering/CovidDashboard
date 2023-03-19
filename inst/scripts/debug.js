/*
Functions to help with debugging the application
*/

// Triggers browser() in the server function
function debug() {
    Shiny.setInputValue("debug", true, {priority: "event"});
}
