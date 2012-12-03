class EventsController < ApplicationController
  require 'secret_santa'
  def new; end

  def notify_participants
    logger.info params[:participant].inspect

    begin
      participants = params[:participant].values.map { |v| v.split('&') }
      SecretSanta::Participants.new(participants).match
      render :text => 'true'
    rescue
      render :text => 'false'
    end
  end
end
