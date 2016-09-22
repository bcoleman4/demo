class GuestsCleanupJob < ActiveJob::Base
  queue_as :default

  puts "starting job"
  @atime = Time.new
  puts "Time now is #{@atime}"
  def perform()
  	puts "inside perform def"
  	variablea = 1
  	until variablea >= 10 do
  		outputa = "I'm working with the variablea = #{variablea}" + "\r"
    print outputa
    $stdout.flush
    sleep (1)
    variablea = variablea +1
	end
  end
end
