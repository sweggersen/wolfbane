# Handles authentication and the sessions of logged in users
class SessionsController < ApplicationController
  def new
  end

  # Creates a session by authenticating a user logging in
  def create
    user = Farmer.find_by_email(params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      sign_in user
      redirect_to sheep_index_path
    else
      flash.now[:error] = 'Feil brukernavn eller passord'
      render 'new'
    end
  end

  # Deletes a session by removing the current user and redirecting to
  # the root page
  def destroy
    sign_out
    redirect_to root_path
  end
  
end
