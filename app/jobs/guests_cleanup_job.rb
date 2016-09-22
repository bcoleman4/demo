class GuestsCleanupJob < ActiveJob::Base
  queue_as :default

  p "starting job"
  @atime = Time.new
  p "Time now is #{@atime}"
  def perform()
  	p "inside perform def"
  	variablea = 1
  	until variablea >= 10 do
    p "I'm working with variablea = #{variablea}"
    sleep (1)
    variablea = variablea +1
	end
  end
end
