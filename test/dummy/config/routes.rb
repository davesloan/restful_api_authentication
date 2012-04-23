Dummy::Application.routes.draw do
  resources :help, :only => [] do
    collection do
      get "authentication"
    end
  end
end
