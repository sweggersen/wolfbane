class SessionsController < ApplicationController
  def new
  end

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

  def destroy
    sign_out
    redirect_to root_path
  end
  
end
