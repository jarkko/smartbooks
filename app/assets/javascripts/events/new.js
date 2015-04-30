Event.addBehavior({
  'body' : function(e) {
    $('event_description').focus();
  },
 //'.account > input' : function(e) {
 //  var id = this.up().id.gsub(/^[a-z_]*([0-9]*$)/, '#{1}');
 //  // console.log("my id is " + this.id)
 //  // console.log("id is " + id);
 //  new Autocompleter.Local(this, $('account_list_' + id), accounts.pluck('title'),
 //        { fullSearch : true,
 //          afterUpdateElement : function(inputfield, selected) {
 //                   var account = accounts.find(function(acc) {
 //                     // console.log("selected: " + selected.inspect());
 //                     // console.log("innerHTML: " + selected.collectTextNodes());
 //                     return acc['title'] == selected.collectTextNodes();
 //                   });
 //                   // console.log('setting selected hidden id to ' + account.id);
 //                   $('line_' + id + '_account_id').value = account.id;
 //                  }
 //          })
 //},
 '.account > select' : function(e) {
   var selected_value = $F(this);
   //// console.log("value is " + selected_value);

   if (selected_value) {
     var selected_name = this.select('option[selected]').first().collectTextNodes();
     // console.log("selected node is " + selected_name);
   }

   var id = this.id.gsub(/^event\_event\_lines\_attributes\_([0-9]*)\_account\_id$/, '#{1}');
   var input = new Element('input',
                { type : 'text',
                  id   : 'event_event_lines_attributes_' + id + '_account_name',
                  name : 'event[event_lines_attributes][' + id + '][account_name]',
                  size : 30 });

   var hidden = new Element('input',
               { type : 'hidden',
                 id   : 'event_event_lines_attributes_' + id + '_account_id',
                 name : 'event[event_lines_attributes][' + id + '][account_id]'});

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
                      // console.log("selected: " + selected.inspect());
                      // console.log("innerHTML: " + selected.collectTextNodes());
                      return acc['title'] == selected.collectTextNodes();
                    });
                    // console.log('setting selected hidden id to ' + account.id);
                    $('event_event_lines_attributes_' + id + '_account_id').value = account.id;
                   }
           });
 },
  'input[type=submit]:click' : function(e) {
    this.disable();
    this.up('form').submit();
    e.stop();
  },
  '.event_lines li input[type=text]:blur' : function(e) {
    console.log(e.element())
    if (e.element().value == "") return;
    fillEmpty(e);
  },
  '#vat-24:click' : function (e) {
    e.preventDefault();
    var total = $$('#event_lines li')[1].select('.credit input')[0].value
    var sans_vat = Math.round(-total / 1.24 * 100) / 100;
    var vat = Math.round((-total - sans_vat) * 100) / 100;

    var vat_line = findFirstEmptyLine();
    fillFirstEmptyLine(vat * 100);
    var new_line = findFirstEmptyLine();
    fillFirstEmptyLine(sans_vat * 100);
    var vat_account = accounts.find(function (a) {return /Arvonlis.veros/.match(a.title)});

    vat_line.select('input[type=text]')[0].value = vat_account.title;
    vat_line.select('input[type=hidden]')[0].value = vat_account.id;
    new_line.select('input[type=text]')[0].focus();
  },
  '#vat-24-10:click' : function (e) {
    e.preventDefault();
    var total = $$('#event_lines li')[1].select('.credit input')[0].value.replace(",", ".")

    var self_line = findFirstEmptyLine();
    fillFirstEmptyLine(-10 * 100);
    var self_account = accounts.find(function (a) {return /Yksityisnostot/.match(a.title)});
    self_line.select('input[type=text]')[0].value = self_account.title;
    self_line.select('input[type=hidden]')[0].value = self_account.id;

    total = total - 10;

    var sans_vat = Math.round(-total / 1.24 * 100) / 100;
    var vat = Math.round((-total - sans_vat) * 100) / 100;

    var vat_line = findFirstEmptyLine();
    fillFirstEmptyLine(vat * 100);
    var new_line = findFirstEmptyLine();
    fillFirstEmptyLine(sans_vat * 100);
    var vat_account = accounts.find(function (a) {return /Arvonlis.veros/.match(a.title)});

    vat_line.select('input[type=text]')[0].value = vat_account.title;
    vat_line.select('input[type=hidden]')[0].value = vat_account.id;
    new_line.select('input[type=text]')[0].focus();
  },
  '.split-vat-button:click' : function (e) {
    console.log('.split-vat-button:click', e, e.element())
    e.preventDefault();
    var line = this.up('.event_line');
    var value = getSum(line) / 100;
    console.log("line:", line, "value", value)
    var sans_vat = Math.round(value / 1.24 * 100) / 100;
    fillValue(line, -sans_vat * 100);
    fillFirstEmptyLine(-100 * (value - sans_vat));
  }
});

function fillEmpty(e) {
  var total = getSum();
  //alert('Sum of fields is ' + total);
  fillFirstEmptyLine(total, e);
}

function getSum(root_el) {
  var root;
  if (typeof root_el == "undefined") {
    root = $('event_lines');
  } else {
    root = $(root_el);
  }
  var debit_fields = root.select('.debit input');
  var credit_fields = root.select('.credit input');

  var credit_sum = credit_fields.inject(0, calculateSum);
  var debit_sum = debit_fields.inject(0, calculateSum);

  //// console.log('Sum of debit fields is' + debit_sum);
  //// console.log('Sum of credit fields is' + credit_sum);

  var total = (debit_fields.inject(0, calculateSum) -
               credit_fields.inject(0, calculateSum));
  return Math.round(total * 100) / 100;
}

function calculateSum(sum, n) {
  var value = $F(n).gsub(',', '.');
  var numeric_value = parseFloat(value) || 0;
  //// console.log('Value is ' + numeric_value);
  return sum + numeric_value * 100;
}

function fillFirstEmptyLine(value, event) {
  var line = findFirstEmptyLine();

  if (line) {
    // input the value to the correct field
    // line.select('input').first().value = "Boo"
    // console.log("Value is " + value);
    if (value != 0)
      fillValue(line, value);
  } else {
    // console.log('No empty line found!')
  }
}

function findFirstEmptyLine() {
  var line = $$('.event_lines li').detect(function(line) {
    return line.select('.account').size() != 0 &&
           line.select('.debit input').first().value == "" &&
           line.select('.credit input').first().value == ""
  });
  return line;
}

function fillValue(line, value) {
  var field_name = value < 0 ? 'debit' : 'credit';
  console.log('Filling in ' + field_name + ' with ' + (value / 100) + '.');
  line.select('.' + field_name + ' input').first().value = Math.round(value.abs()) / 100;
}
