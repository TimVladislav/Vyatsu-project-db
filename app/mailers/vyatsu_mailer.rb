class VyatsuMailer < ApplicationMailer
  default from: 'notifications@example.com'

  def welcome_email(user)
    @user = user
    @url = 'http://example.com/login'
    mail to: 'tiprog298@gmail.com',
         subject: 'Welcome to Vyatsu'
    
  end
end
