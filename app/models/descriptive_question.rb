require 'spreadsheet'
WillPaginate.per_page = 15
class DescriptiveQuestion < ActiveRecord::Base
  validates :description, :presence => true
  validates :answer, :presence => true

  has_one :audio_video_question, :foreign_key => :question_id, :dependent => :destroy
  accepts_nested_attributes_for :audio_video_question

  attr_accessor :is_descriptive

  belongs_to :exam

  def question_type
    "descriptive"
  end
  
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

  def xls_template
    template_headers = ['description', 'answer']
    book = Spreadsheet::Workbook.new
    sheet1 = book.create_worksheet :name => "Descriptive Questions"
    sheet1.insert_row(0,template_headers)
    book
  end

  def method_missing(name, *args, &block)
    if name =~ /^option_*/
      nil
    else
      super
    end
  end
  
  def description
    self.attributes["description"]
  end

  def description_with_html
    self.attributes["description"].gsub(/\n/, '<br/>').gsub(/\s+/, '&nbsp;').html_safe
  end
  
  alias_method_chain :description, :html

end
