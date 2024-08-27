every 5.minutes do
  rake 'loan:calculate_interest'
end

every 11.minutes do
  rake 'loan:repay_loan'
end
