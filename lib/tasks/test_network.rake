# 'test:coverage' rake task to generate code coverage from a testing session.
#
# Examples:
#   rake test:coverage
#   rake test:coverage[units]
#   rake test:coverage[functionals]
#
# Rake task parameters based on:
# http://viget.com/extend/protip-passing-parameters-to-your-rake-tasks
#
namespace :test do

  desc 'Test with live network connectivity to a HDHomeRun device.'
  task :network, [:tuner] do |t, args|
    ENV['TESTS_USE_LIVE_NETWORK'] = 'true'
    ENV['TEST_TUNER'] = args[:tuner] if args[:tuner].present?
    Rake::Task['test'].invoke
  end

end
