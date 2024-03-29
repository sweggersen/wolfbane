# Base class for all Rails Controllers.
# Inherits from ActionController::Base to handle a lot of the database magic
class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  include SessionsHelper
end
