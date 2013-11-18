# Helper for the sessions controller
# A helper are included into all controllers, and are thus a way to group
# common functionality shared among controllers.
module SessionsHelper
  # Signs in user and saves a token for permanent login
  def sign_in(user)
    remember_token = Farmer.new_remember_token
    cookies.permanent[:remember_token] = remember_token
    user.update_attribute(:remember_token, Farmer.encrypt(remember_token))
    self.current_user = user
  end

  # Checks if a user is signed in
  def signed_in?
    !current_user.nil?
  end

  # Sets the current user
  def current_user=(user)
    @current_user = user
  end

  # Returns the current user
  def current_user
    remember_token = Farmer.encrypt(cookies[:remember_token])
    @current_user ||= Farmer.find_by_remember_token(remember_token)
  end

  # Checks if the user provided is the current user
  def current_user?(user)
    user == current_user
  end

  # Redirects to login page if a user is not signed in
  def signed_in_farmer
    unless signed_in?
      redirect_to root_path, notice: "Vennligst log inn"
    end
  end

  # Signs out a user
  def sign_out
    self.current_user = nil
    cookies.delete(:remember_token)
  end
end
