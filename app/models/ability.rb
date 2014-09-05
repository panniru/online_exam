class Ability
  include CanCan::Ability

  def initialize(user)

    alias_action :exam, :to => :read
    alias_action :review_exam, :to => :read
    alias_action :submit_exam, :to => :read
    alias_action :exam_entrance, :to => :read
    alias_action :validate_exam_entrance, :to => :read
    alias_action :results, :to => :read
    alias_action :heirarchy, :to => :read
    alias_action :next_question, :to => :read
    alias_action :update_result_details, :to => :update
    user ||= User.new
    if user.admin?
      can :manage, :all
    elsif user.faculty?
      can :manage, [Exam, MultipleChoiceQuestion, DescriptiveQuestion, Schedule, AudioVideoQuestion, Instruction]
      can :read, [Course, Student]
      can :update, [User, Result]
    elsif user.student?
      can :read, [Schedule, Student]
      can :update, [User]
    end
  end
end
