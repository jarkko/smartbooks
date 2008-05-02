steps_for(:fiscal_year) do
  Given "an empty database" do
    [EventLine, Account, Event, FiscalYear].each do |klass|
      klass.delete_all
    end
  end
  
  When "user loads the new fiscal year form" do
    visits "fiscal_years/new"
  end
end