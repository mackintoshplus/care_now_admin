Rails.application.routes.draw do
  devise_for :admins

  namespace :admin do
    resources :entry_logs do
      collection do
        get :exit
        post :update_exit_time
      end
    end
  end


 
end