# cronotab.rb — Crono configuration file
#
# Here you can specify periodic jobs and schedule.
# You can use ActiveJob's jobs from `app/jobs/`
# You can use any class. The only requirement is that
# class should have a method `perform` without arguments.
#
# class TestJob
#   def perform
#     puts 'Test!'
#   end
# end
#
Crono.perform(BatchProcessRunningJob).every 5.minutes
Crono.perform(CsvJoinsJob).every 1.day, at: {hour: 23, min: 15}
#
