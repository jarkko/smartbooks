Event.addBehavior({
  'body' : function(e) {
    $('event_description').focus();
  },
  'input[type=submit]:click' : function(e) {
    this.disable();
  },
  'input.date' : DateSelector
});