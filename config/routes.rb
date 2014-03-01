OnlineExam::Application.routes.draw do
  devise_for :users, :controllers => { :sessions => 'sessions' }

  resources :users

  resources :students do
    collection do
      get "new_upload"
      post "upload"
    end

    member do
      get "results"
    end
  end

  resources :faculties
  resources :courses

  resources :exams do
    collection do
      get "course_exams_json"
    end

    resources :descriptive_questions do
      collection do
        get 'xls_template_descriptive'
        get 'upload_new'
        post 'upload'
      end
    end
    resources :multiple_choice_questions do
      collection do
        get 'upload_new'
        post 'upload'
        get 'xls_template'
      end
    end
  end

  resources :schedules do
    member do
      get "exam"
      post "exam"
      get "review_exam"
      get "submit_exam"
      get "exam_entrance"
      post "validate_exam_entrance"
    end
  end


  get 'auto_search/autocomplete_user_user_id'
  get 'auto_search/autocomplete_user_user_info'
  get 'auto_search/autocomplete_student_roll_number'
  get 'auto_search/autocomplete_faculty_name'
  get 'auto_search/autocomplete_course_name'
  get 'auto_search/autocomplete_exam_subject'
  get 'auto_search/autocomplete_exam_exam_name'

  root to: "home#index"


end
