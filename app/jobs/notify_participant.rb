module Notify
  @queue = :participant

  def self.perform(participant)
    ParticpantNotificationMailer.notify_participant(participant).deliver
  end
end
