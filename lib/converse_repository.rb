class Converse
  attr_accessor :id, :receiving_user_id, :sender_user_id, :message_time, :message_content, :date_list_id, :listing_name, :date_list_id
end

class ConverseRepository

  def show_all_messages_in_thread(receiver_id1, sender_id1, receiver_id2, sender_id2)
    sql = "select * from converse where sender_user_id in ($1,$2) and receiver_user_id in ($3,$4) order by message_time desc"
    DatabaseConnection.exec_params(sql,[receiver_id1, sender_id1,receiver_id2, sender_id2])
  end

  def add_new_message(receiver_id, sender_id, content)
    sql = 'insert into converse ("receiver_user_id", "sender_user_id", "message_time", "message_content") Values ($1,$2,now()::timestamp(0),$3)'
    DatabaseConnection.exec_params(sql,[receiver_id, sender_id, content])
  end
  
end
