class Result < ActiveRecord::Base
  belongs_to :student
  belongs_to :schedule
end
