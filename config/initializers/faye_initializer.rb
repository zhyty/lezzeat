start_script = Rails.root.join('start_faye.sh').to_s
if Rails.env.production?
  Rails.logger.debug('Starting Faye in production mode')
  Thread.new {system("#{start_script} production")}
else
  Rails.logger.debug('Starting Faye in development')
  Thread.new {system(start_script)}
end
