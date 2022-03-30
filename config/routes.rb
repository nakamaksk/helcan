Rails.application.routes.draw do

  # Devise disable signup
  # https://gist.github.com/zernel/3943463
  devise_for :users, :skip => [:registrations]
  as :user do
    get 'users/edit' => 'devise/registrations#edit', :as => 'edit_user_registration'
    put 'users' => 'devise/registrations#update', :as => 'user_registration'
  end

  root to: "people#index"

  resources :people


  namespace :line do
    get :test
  end
end
