require 'carrierwave/orm/activerecord'
class AudioVideoQuestion < ActiveRecord::Base
  validate :digi_file, :presence => true
  mount_uploader :digi_file, DigitalQuestionUploader
end
