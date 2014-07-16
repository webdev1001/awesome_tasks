# Execute jobs realtime when testing.
if Rails.env.production?
  Delayed::Worker.delay_jobs = true
else
  Delayed::Worker.delay_jobs = false
end
