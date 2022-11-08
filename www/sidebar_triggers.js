/*
Sidebar side effects that cannot be done in easily in Shiny
- Hide logo when sidebar is collapsed.
*/

function toggleLogoVisibility() {
    // Get sidebar and logo elements
    let sidebar_collapsed = document.getElementById("sidebarCollapsed");
    let logo = document.getElementsByClassName("logo")[0]; // will only be one element of this class
    
    // Print to console since js code in Shiny app is rare and can confuse devs
    console.log("JS function: toggleLogoVisibility() has been triggered from sidebar collapse.");
    
    // Toggle logo visibility
    if (logo.style.visibility === 'hidden') {
        logo.style.visibility = 'visible';
    } else {
        logo.style.visibility = 'hidden';
    }
    
    return null;
};

// get sidebar buttom and add event listener to trigger logo visibility
let sidebar_btn = document.getElementsByClassName("sidebar-toggle")[0]; // will only be one element of this class
sidebar_btn.addEventListener("click", toggleLogoVisibility);
