class Ability
  include CanCan::Ability

  def initialize(user)

    alias_action :exam, :to => :read
    alias_action :review_exam, :to => :read
    alias_action :submit_exam, :to => :read
    alias_action :exam_entrance, :to => :read
    alias_action :validate_exam_entrance, :to => :read
    alias_action :results, :to => :read

    user ||= User.new
    if user.admin?
      can :manage, [User, Student, Faculty, Course]
    elsif user.faculty?
      can :manage, [Exam, MultipleChoiceQuestion, DescriptiveQuestion, Schedule]
    elsif user.student?
      can :read, [Schedule, Student]
    end
  end
end