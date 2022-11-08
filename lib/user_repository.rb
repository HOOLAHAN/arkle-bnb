class User
  attr_accessor :id, :name, :email, :password
end

class UserRepository
  def create(user)
    sql = 'INSERT INTO users ("name", "email", "password") VALUES ($1, $2, $3)'
    params = [user.name, user.email, user.password]
    DatabaseConnection.exec_params(sql, params)

    return nil
  end

  def show_all
    sql = 'SELECT * FROM users'
    result_set = DatabaseConnection.exec_params(sql, [])
  end
end