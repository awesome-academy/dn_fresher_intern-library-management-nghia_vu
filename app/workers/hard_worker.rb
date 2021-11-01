class HardWorker
  include Sidekiq::Worker
  sidekiq_options retry: 5

  def perform email, name
    OrderMailer.order_uccess(email, name).deliver_later
  end
end
