Rails.application.routes.draw do
 devise_for :users, :controllers => { :registrations => "users/registrations" }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :jobs do
    member do()
      post :upvote
      post :downvote

      post :add_to_favorite
      post :quit_favorite

    end
    collection do
      get :search
    end
    resources :resumes
    resources :comments
  end
  root'welcome#index'
  namespace :admin do
    resources :jobs do
      member do
        post :publish
        post :hide
      end
      resources :resumes
    end
  end
end
