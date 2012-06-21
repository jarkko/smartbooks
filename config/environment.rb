# -*- encoding : utf-8 -*-
# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Smartbooks::Application.initialize!

 MONTHS = [["Tammikuu", "1"],
           ["Helmikuu", "2"],
           ["Maaliskuu", "3"],
          ["Huhtikuu", "4"],
           ["Toukokuu", "5"],
           ["Kesäkuu", "6"],
           ["Heinäkuu", "7"],
           ["Elokuu", "8"],
           ["Syyskuu", "9"],
           ["Lokakuu", "10"],
           ["Marraskuu", "11"],
           ["Joulukuu", "12"]
         ]
