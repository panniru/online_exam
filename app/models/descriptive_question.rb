WillPaginate.per_page = 15
class DescriptiveQuestion < ActiveRecord::Base
  validates :description, :presence => true
  validates :answer, :presence => true

  has_one :audio_video_question, :foreign_key => :question_id, :dependent => :destroy
  accepts_nested_attributes_for :audio_video_question

  attr_accessor :is_descriptive

  belongs_to :exam

  def xls_template(options)
    template_headers = ['description', 'answer']
    CSV.generate(options) do |csv|
      csv << attribute_names.select { |name| template_headers.include?name }
    end
  end
end
