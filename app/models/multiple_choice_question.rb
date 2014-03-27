WillPaginate.per_page = 15
class MultipleChoiceQuestion < ActiveRecord::Base
  validates :description, :presence => true
  validates :option_1, :presence => true
  validates :option_2, :presence => true
  validates :option_3, :presence => true
  validates :option_4, :presence => true
  validates :answer, :presence => true

  attr_accessor :is_descriptive

  belongs_to :exam
  has_one :audio_video_question, :foreign_key => :question_id, :dependent => :destroy

  accepts_nested_attributes_for :audio_video_question

  def update(params)
    if params[:audio_video_question_attributes].present?
      if !params[:audio_video_question_attributes][:digi_file].present? and params[:audio_video_question_attributes][:remove_digi_file] == "0"
        params.delete(:audio_video_question_attributes)
      elsif params[:audio_video_question_attributes][:remove_digi_file] == "1"
        self.audio_video_question.remove_digi_file!
        self.audio_video_question.save
        params.delete(:audio_video_question_attributes)
      end
    end
    super
  end


  def xls_template(options)
    template_headers = ['description', 'option_1', 'option_2', 'option_3', 'option_4', 'answer']
    CSV.generate(options) do |csv|
      csv << attribute_names.select { |name| template_headers.include?name }
    end
  end
  
end
