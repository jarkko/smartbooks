Event.addBehavior({
  'body' : function(e) {
    $('event_description').focus();
  },
 //'.account > input' : function(e) {
 //  var id = this.up().id.gsub(/^[a-z_]*([0-9]*$)/, '#{1}');
 //  console.log("my id is " + this.id)
 //  console.log("id is " + id);
 //  new Autocompleter.Local(this, $('account_list_' + id), accounts.pluck('title'), 
 //        { fullSearch : true,
 //          afterUpdateElement : function(inputfield, selected) {
 //                   var account = accounts.find(function(acc) {
 //                     console.log("selected: " + selected.inspect());
 //                     console.log("innerHTML: " + selected.collectTextNodes());
 //                     return acc['title'] == selected.collectTextNodes();
 //                   });
 //                   console.log('setting selected hidden id to ' + account.id);
 //                   $('line_' + id + '_account_id').value = account.id;
 //                  }
 //          })
 //},
 '.account > select' : function(e) {
   var selected_value = $F(this);
   console.log("value is " + selected_value);
   
   if (selected_value) {
     var selected_name = this.select('option[selected]').first().collectTextNodes();
     console.log("selected node is " + selected_name);
   }
   
   var id = this.id.gsub(/^line\_([0-9]*)\_account\_id$/, '#{1}');
   var input = new Element('input', 
                { type : 'text',
                  id   : 'line_' + id + '_account_name',
                  name : 'line[' + id + '][account_name]',
                  size : 30 });
   
   var hidden = new Element('input',
               { type : 'hidden',
                 id   : 'line_' + id + '_account_id',
                 name : 'line[' + id + '][account_id]'});
   
   this.replace(input);
   input.insert({ after : hidden });
   
   if (selected_value) {
     input.value = selected_name;
     hidden.value = selected_value;
   }
   
   var account_list = new Element('div', 
                                { id : 'account_list_' + id,
                                  style : 'display: none;',
                                  class : 'account_list'});
   
   hidden.insert({ after : account_list });
   
   new Autocompleter.Local(input, account_list, accounts.pluck('title'), 
         { fullSearch : true,
           afterUpdateElement : function(inputfield, selected) {
                    var account = accounts.find(function(acc) {
                      console.log("selected: " + selected.inspect());
                      console.log("innerHTML: " + selected.collectTextNodes());
                      return acc['title'] == selected.collectTextNodes();
                    });
                    console.log('setting selected hidden id to ' + account.id);
                    $('line_' + id + '_account_id').value = account.id;
                   }
           });
 },
  'input[type=submit]:click' : function(e) {
    this.disable();
    this.up('form').submit();
    e.stop();
  },
  '.event_lines li input[type=text]:blur' : function(e) {
    fillEmpty();
  }
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
  return sum + numeric_value * 100;
}

function fillFirstEmptyLine(value) {
  var line = findFirstEmptyLine();
  if (line) {
    // input the value to the correct field
    // line.select('input').first().value = "Boo"
    console.log("Value is " + value);
    if (value != 0)
      fillValue(line, value);
  } else {
    console.log('No empty line found!')
  }
}

function findFirstEmptyLine() {
  var line = $$('.event_lines li').detect(function(line) {
    return line.select('.account').size() != 0 &&
           line.select('.account input').first().value == ""
  });
  return line;
}

function fillValue(line, value) {
  var field_name = value < 0 ? 'debit' : 'credit';
  console.log('Filling in ' + field_name + ' with ' + (value / 100) + '.');
  line.select('.' + field_name + ' input').first().value = value.abs() / 100;
}