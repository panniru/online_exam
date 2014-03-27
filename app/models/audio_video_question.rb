require 'carrierwave/orm/activerecord'
class AudioVideoQuestion < ActiveRecord::Base
  validate :digi_file, :presence => true
  mount_uploader :digi_file, DigitalQuestionUploader
  attr_accessor :digi_file_cache
  attr_accessor :remove_digi_file

end
