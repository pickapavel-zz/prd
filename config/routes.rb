Rails.application.routes.draw do

  root 'clients#index'
  get '/pup' => 'clients#pup'
  get '/test_response' => 'clients#test_response'
  get '/request_documents' => 'clients#request_documents'
  get '/documents_check' => 'clients#documents_check'

  resources :clients do
    collection do
      get :related
    end
    member do
      patch :add_partner
      patch :add_collaborator
      get :coworkers
      get :history
      get :identification
      delete :remove_partner
    end
  end

  resource :session, only: [:new, :create] do
    get :destroy, action: :destroy, as: :destroy
  end

end
