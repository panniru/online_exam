class Ability
  include CanCan::Ability



  def initialize(user)
    user ||= User.new
    if user.admin?
      can :manage, [User, Student, Faculty, Course]
    elsif user.faculty?
      can :manage, [Exam, MultipleChoiceQuestion, DescriptiveQuestion, Schedule]
    elsif user.student?

    end
  end
end
