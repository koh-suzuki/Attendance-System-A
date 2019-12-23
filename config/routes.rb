Rails.application.routes.draw do
  resources :bases

  root 'static_pages#top'
  get '/signup', to: 'users#new'

  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'
  resources :attendances do
    collection do
      get 'csv_output'
    end
  end
    
  resources :users do
    collection { post :import }
    get 'import', to: 'users#import'
    get 'index_attendance', to: 'users#index_attendance'
    member do
      get 'edit_basic_info'
      patch 'update_basic_info'
      get 'attendances/edit_one_month'
      patch 'attendances/update_one_month'
    end
    resources :attendances do
      patch 'update'
      # 残業申請モーダル
      get 'edit_overtime_app'
      patch 'update_over_app'
      # datetimeのnew
      get 'new'
    end
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
