module SessionsHelper
  def sign_in(user)
    remember_token = Farmer.new_remember_token
    cookies.permanent[:remember_token] = remember_token
    user.update_attribute(:remember_token, Farmer.encrypt(remember_token))
    self.current_user = user
  end

  def signed_in?
    !current_user.nil?
  end

  def current_user=(user)
    @current_user = user
  end

  def current_user
    remember_token = Farmer.encrypt(cookies[:remember_token])
    @current_user ||= Farmer.find_by_remember_token(remember_token)
  end

  def current_user?(user)
    user == current_user
  end

  # TODO: consistent method naming refactoring
  def signed_in_farmer
    unless signed_in?
      redirect_to login_path, notice: "Vennligst log inn"
    end
  end

  def sign_out
    self.current_user = nil
    cookies.delete(:remember_token)
  end
end
