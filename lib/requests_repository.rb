class Request
    attr_accessor :id, :user_id, :user_name, :date_list_id, :listing_id, :listing_name, :date
end

class RequestsRepository

    def find_requests_by_requester_user_id(user_id)
        sql = "select * from requests inner join dates_list on requests.date_list_id = dates_list.id where user_id = $1"
        DatabaseConnection.exec_params(sql,[user_id])
    end

    def find_requests_by_listing_user_id(user_id)
        sql = "select * from requests 
        inner join dates_list on requests.date_list_id = dates_list.id
        inner join listings on dates_list.listing_id = listings.id
        inner join users on listings.user_id = users.id
        where users.id = $1"
        DatabaseConnection.exec_params(sql,[user_id])
    end

end