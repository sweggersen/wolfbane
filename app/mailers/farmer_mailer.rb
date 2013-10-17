class FarmerMailer < ActionMailer::Base
  default from: "gruppe20@wolfbane.com"

  def alert_email(farmer)
    @farmer = farmer
    @url = 'http://wolfbane.heroku.com'
    mail(to: @farmer.email, subject: 'Your sheep is under attack!')
  end
end
