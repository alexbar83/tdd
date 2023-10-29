class NewAnswerNotificationJob < ApplicationJob
  queue_as :default

  def perform(_answer)
    Services::NewAnswerNotification.new.answer_notification
  end
end
