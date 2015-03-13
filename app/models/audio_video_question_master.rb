class AudioVideoQuestionMaster < ActiveRecord::Base
  validate :digi_file, :presence => true
  validate :description, :presence => true

  mount_uploader :digi_file, DigitalQuestionUploader
  attr_accessor :digi_file_cache
  attr_accessor :remove_digi_file
  belongs_to :exam
  has_many :multiple_choice_questions, :dependent => :destroy

  scope :having_question_type, lambda{|question_type| where(:question_type => question_type)}
  
  class << self

    def preapre_a_v_question(params)
      a_v_qtn = AudioVideoQuestionMaster.new(audio_video_question_master_params(params))
      a_v_qtn.prepare_multiple_choice_question(params[:multiple_choice_questions])
      a_v_qtn
    end
    
    def audio_video_question_master_params(params)
      params.require(:audio_video_question_master).permit(:digi_file, :remove_digi_file, :digi_file_cache, :question_type, :exam_id, :description)
    end
  end

  def save_question
    ActiveRecord::Base.transaction do
      if save
        if save_multiple_choice
          return true
        else
          raise ActiveRecord::Rollback
        end
      else
        raise ActiveRecord::Rollback
      end
    end
  end


  def update_a_v_question(params)
    ActiveRecord::Base.transaction do
      if self.update(self.class.audio_video_question_master_params(params))
        prepare_multiple_choice_question(params[:multiple_choice_questions])
        if save_multiple_choice
          return true
        else
          raise ActiveRecord::Rollback
          return false
        end
      else
        raise ActiveRecord::Rollback
      end
    end
  end

  def prepare_multiple_choice_question(params)
    questions = 4.times.map do |i|
      qt_params = params[i.to_s]
      question = MultipleChoiceQuestion.where(:id => qt_params[:id]).first || MultipleChoiceQuestion.new(question_params(qt_params))
      question.answer = qt_params[qt_params['answer']]
      question.question_type = self.question_type
      question.audio_video_question_master_id = self.id
      question
    end
    self.multiple_choice_questions = questions
  end

  def save_multiple_choice
    if (not multiple_choice_questions.empty?) and multiple_choice_questions.map(&:valid?).all?
      return multiple_choice_questions.map(&:save).all?
    else
      multiple_choice_questions.each_with_index do |qtn, index|
        unless qtn.errors.messages.empty?
          self.errors.add :base,  "Question #{index+1} : #{qtn.errors.messages.map{|key, val| key.to_s.concat(" ").concat(val.join(","))}.join(', ')}"
        end
      end
      return false
    end
  end

  private
  def question_params(params)
    params.permit(:description, :option_1, :option_2, :option_3, :option_4, :audio_video_question_master, :id, :question_type)
  end


end
