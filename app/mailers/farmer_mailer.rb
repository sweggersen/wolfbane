# Handles sending of email to farmer and backup upon an attack alert.
# Inherits ActionMailer::Base, which handles the actual mailing.
# The settings of ActionMailer is located in config/application.rb
# The mail template is located in app/views/farmer_mailer
class FarmerMailer < ActionMailer::Base
  default from: "gruppe20@wolfbane.com"
  # Sets up objects to be referenced in the mail template, and sends the mail
  def alert_email(farmer, sheep)
    @farmer = farmer
    @sheep = sheep
    @url = "http://#{(Rails.env.development? ? 'localhost:3000' : 'wolfbane.heroku.com')}"
    mail(to: @farmer.email, subject: 'Your sheep is under attack!')
  end
end
