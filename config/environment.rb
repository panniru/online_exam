# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
OnlineExam::Application.initialize!

Date::DATE_FORMATS[:default] = lambda { |date| I18n.l(date) }
Time::DATE_FORMATS[:default] = "%d/%m/%Y %H:%M:%S"
