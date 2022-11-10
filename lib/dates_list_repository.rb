# require 'date'

class DateList
  attr_accessor :id, :listing_id, :date, :booked_status, :booker_id
end

class DatesListRepository
  def add_dates(listing_id, start_date, end_date)
    startdate = Date.parse(start_date)
    enddate = Date.parse(end_date)
    sql = 'insert into dates_list ("listing_id", "date", "booked_status", "booker_id") VALUES ($1, $2, FALSE, null)'

    (startdate..enddate).each do |date|
      DatabaseConnection.exec_params(sql, [listing_id, date.to_s])
    end
  end

  def find_by_date_list_id_as_object(date_list_id)
    sql = 'SELECT * FROM dates_list WHERE id = $1'
    params = [date_list_id]

    result = DatabaseConnection.exec_params(sql, params)
    
    date_list = DateList.new
    date_list.id = result[0]["id"]
    date_list.listing_id = result[0]["listing_id"]
    date_list.date = result[0]["date"]
    date_list.booked_status = result[0]["booked_status"]
    date_list.booker_id = result[0]["booker_id"]

    date_list
  end
  
  def find_by_listing(listing_id)
    sql = 'select * from dates_list where listing_id = $1'
    DatabaseConnection.exec_params(sql, [listing_id])
  end

  def find_by_listing_as_objects(listing_id)
    sql = 'select * from dates_list where listing_id = $1'
    response_array = DatabaseConnection.exec_params(sql, [listing_id])

    dates_list = []
    response_array.each do |record|
      date_list = DateList.new
      date_list.id = record['id']
      date_list.listing_id = record['listing_id']
      date_list.date = record['date']
      date_list.booked_status = record['booked_status']
      date_list.booker_id = record['booker_id']

      dates_list << date_list
    end
    dates_list
  end
  
  def find_by_listing_dates(listing_id)
    results = find_by_listing(listing_id)
    date_array = []
    results.each { |date| date_array << date['date'] }
    date_array
  end

  
  def update_booked_status(date_list_id, status, booker_id)
    sql = "update dates_list set booked_status = $2, booker_id = $3 where id = $1"
    results = DatabaseConnection.exec_params(sql,[date_list_id, status, booker_id])
  end

  def find_by_date_list_id(date_list_id)
    sql = "select * from dates_list where id = $1"
    return DatabaseConnection.exec_params(sql,[date_list_id])
  end

  def select_all_confirmed_bookings_by_userid(user_id)
    sql = "select * from dates_list where booker_id = $1 and booked_status = TRUE"
    DatabaseConnection.exec_params(sql,[user_id])
  end

end
