class FarmerMailer < ActionMailer::Base
  default from: "gruppe20@wolfbane.com"

  def alert_email(farmer, sheep)
    @farmer = farmer
    @sheep = sheep
    @url = "http://#{(Rails.env.development? ? 'localhost:3000' : 'wolfbane.heroku.com')}"
    mail(to: @farmer.email, subject: 'Your sheep is under attack!')
  end
end
