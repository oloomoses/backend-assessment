Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get '/api/posts/', to: 'posts#index'
  get '/api/ping/', to: 'posts#ping'
end
