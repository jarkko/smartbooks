//= require foundation
// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
Event.addBehavior({
  'input.date' : DateSelector
});

jQuery(document).ready(function(){
    jQuery(document).foundation(function (response) {
        console.log(response.errors);
    });
});