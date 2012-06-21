# -*- encoding : utf-8 -*-
Smartbooks::Application.routes.draw do
  resources :event_lines
  resources :fiscal_years do
    resources :events
    resources :accounts
    resources :vat_reports
    resource :income_statement
    resource :balance_sheet
  end

  match '/' => 'fiscal_years#index'
end
