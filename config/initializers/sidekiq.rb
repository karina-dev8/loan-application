require 'sidekiq'
require 'sidekiq-cron'

Sidekiq.configure_server do |config|
  config.redis = { url: 'redis://localhost:6379/1' }
end

Sidekiq.configure_client do |config|
  config.redis = { url: 'redis://localhost:6379/1' }
end

Sidekiq::Cron::Job.create(
  name: 'Calculate Loan Interest - every 5 minutes',
  cron: '*/5 * * * *',
  class: 'CalculateLoanInterestJob'
)
