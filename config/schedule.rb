every 5.minutes do
  rake 'loan:calculate_interest'
end

every 5.minutes do
  rake "loan:repay"
end
