Rails.application.routes.draw do
  resources :help, only: [] do
    collection do
      get 'authentication'
      get 'master_authentication'
    end
  end
end
