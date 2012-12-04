class ParticpantNotificationMailer < ActionMailer::Base
  default :from => ENV['ADMIN_EMAIL_ADDRESS'],
          :reply_to => ENV['ADMIN_EMAIL_ADDRESS'],
          :bcc => ENV['ADMIN_EMAIL_ADDRESS']

  def notify_participant(match)
    @giver = match['giver']
    @receiver = match['receiver']

    mail(
      :to => @giver['email_address'],
      :subject => "You've been assigned a Secret Santa match."
    )
  end
end
