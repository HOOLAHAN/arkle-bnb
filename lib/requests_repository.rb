class Request
    attr_accessor :id, :user_id, :date_list_id
end

class RequestsRepository
  
  def all
    sql = 'SELECT * FROM requests'
    response_array = DatabaseConnection.exec_params(sql, [])

    requests = []
    response_array.each do |record|
      request = Request.new
      request.user_id = record["user_id"]
      request.date_list_id = record["date_list_id"]

      requests << request
    end
    requests
  end

  def find_requests_by_requester_user_id(user_id)
    sql = 'select * from requests where user_id = $1'
    DatabaseConnection.exec_params(sql,[user_id])
  end
  
  def find_requests_by_listing_user_id(user_id)
    sql = 'select * from requests
    inner join dates_list on requests.date_list_id = dates_list.id
    inner join listings on dates_list.listing_id = listings.id
    inner join users on listings.user_id = users.id
    where users.id = $1'
    DatabaseConnection.exec_params(sql,[user_id])
  end
end