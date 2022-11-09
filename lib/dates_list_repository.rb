# require 'date'

class Date
    attr_accessor :id, :listing_id, :date, :booked_status, :booker_id
end

class DatesListRepository

  
  def add_dates(listing_id, start_date, end_date)
    startdate = Date.parse(start_date)
    enddate = Date.parse(end_date)
    sql = 'insert into dates_list ("listing_id", "date", "booked_status", "booker_id") VALUES ($1, $2, FALSE, null)'
    
    (startdate..enddate).each do |date|
      DatabaseConnection.exec_params(sql,[listing_id, date.to_s])
    end
  end
  
  def find_by_listing(listing_id)
    sql = "select * from dates_list where listing_id = $1"
    DatabaseConnection.exec_params(sql,[listing_id])
  end

  def find_by_listing_dates(listing_id)
    results = find_by_listing(listing_id)
    date_array = []
    results.each{|date| date_array << date['date']}
    date_array
  end

end