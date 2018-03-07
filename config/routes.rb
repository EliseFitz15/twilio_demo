Rails.application.routes.draw do
  scope 'api/v1' do
    use_doorkeeper do
      controllers applications: 'oauth/applications'
    end
  end

  mount API::Base, at: '/'

  namespace :admin do
    resources :users
    resources :members
    resources :memberships
    resources :clients
    resources :locations
    resources :interactions

    root to: 'users#index'
  end

  namespace :webhooks do
    post 'twilio/reply' => 'twilio#reply'
    post 'twilio/status_callback' => 'twilio#status_callback', as: :twilio_status_callback
  end

  resource :interactions, only: %i[create]
  get '/interactions/:id/conversation', to: 'interactions#conversation', as: :conversation
  get '/atlas.vcard' => 'vcards#atlas', as: :vcard

  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'home#index'
  mount GrapeSwaggerRails::Engine, at: '/api/v1/documentation'
end
