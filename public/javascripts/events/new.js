Event.addBehavior({
  'body' : function(e) {
    $('event_description').focus();
  },
  'input[type=submit]:click' : function(e) {
    this.disable();
  },
  '.event_lines li input[type=text]:blur' : function(e) {
    fillEmpty();
  },
  'input.date' : DateSelector
});

function fillEmpty() {
  var total = getSum();
  //alert('Sum of fields is ' + total);
  fillFirstEmptyLine(total);
}

function getSum() {
  var debit_fields = $$('.debit input');
  var credit_fields = $$('.credit input');
  
  var credit_sum = credit_fields.inject(0, calculateSum);
  var debit_sum = debit_fields.inject(0, calculateSum);
  
  //console.log('Sum of debit fields is' + debit_sum);
  //console.log('Sum of credit fields is' + credit_sum);
  
  return debit_fields.inject(0, calculateSum) - 
         credit_fields.inject(0, calculateSum);
}

function calculateSum(sum, n) {
  var value = $F(n).gsub(',', '.');
  var numeric_value = parseFloat(value) || 0;
  //console.log('Value is ' + numeric_value);
  return sum + numeric_value;
}

function fillFirstEmptyLine(value) {
  var line = findFirstEmptyLine();
  if (line) {
    line.select('input').first().value = "Boo"
  } else {
    console.log('No empty line found!')
  }
}

function findFirstEmptyLine() {
  var line = $$('.event_lines li').detect(function(line) {
    return line.select('.debit input, .credit input').size() != 0 &&
           line.select('.debit input').first().value == "" &&
           line.select('.credit input').first().value == ""
  });
  return line;
}