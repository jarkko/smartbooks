ActionController::Routing::Routes.draw do |map|
  map.resources :event_lines

  map.resources :fiscal_years do |fy|
    fy.resources :events
    fy.resources :accounts
    fy.resources :vat_reports
    fy.resource  :income_statement
    fy.resource  :balance_sheet
  end  
  
  # The priority is based upon order of creation: first created -> highest priority.
  
  # Sample of regular route:
  # map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  # map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # You can have the root of your site routed by hooking up '' 
  # -- just remember to delete public/index.html.
  map.root :controller => "fiscal_years"
end
