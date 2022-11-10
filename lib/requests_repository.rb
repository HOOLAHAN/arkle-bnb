class Request
    attr_accessor :id, :user_id, :user_name, :date_list_id, :listing_id, :listing_name, :date
end

class RequestsRepository

    def find_requests_by_requester_user_id(user_id)
        sql = "select * from requests inner join dates_list on requests.date_list_id = dates_list.id inner join listings on dates_list.listing_id = listings.id where requests.user_id = $1"
        requests = DatabaseConnection.exec_params(sql,[user_id])
    end

    def find_requests_by_listing_user_id(user_id)
        
        sql = "CREATE TABLE transient as select requests.user_id as requester_id, date_list_id, listings.name as listing_name, 
        listings.id as uniq_listing_id, date, description, night_price, users.name as lister_name, dates_list.booked_status 
        from requests inner join dates_list on requests.date_list_id = dates_list.id
        inner join listings on dates_list.listing_id = listings.id
        inner join users on listings.user_id = users.id
        where users.id = $1"

        DatabaseConnection.exec_params(sql,[user_id])

        sql2 = "select date_list_id, requester_id, users.name as requester_name, email as requester_email, 
        uniq_listing_id, listing_name, date as date_requested, night_price, lister_name, booked_status from transient
        inner join users on transient.requester_id = users.id order by date_requested;"
        requests = DatabaseConnection.exec_params(sql2,[])
        DatabaseConnection.exec_params('drop table if exists transient', [])
        return requests
    end

end
