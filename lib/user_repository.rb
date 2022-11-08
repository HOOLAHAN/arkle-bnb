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

  def find_user_by_email(email)
    sql = 'SELECT * FROM users where email = $1'
    result = DatabaseConnection.exec_params(sql,[email])[0]
    user = User.new
    user.name = result['name']
    user.id = result['id']
    user.email = result['email']
    user.password = result['password']
    user
  end

end