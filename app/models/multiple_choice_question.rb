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


  def xls_template(options)
    template_headers = ['description', 'option_1', 'option_2', 'option_3', 'option_4', 'answer']
    CSV.generate(options) do |csv|
      csv << attribute_names.select { |name| template_headers.include?name }
    end
  end

end
