Rails.application.routes.draw do
  get 'foo/bar'
  get 'foo/baz'
  get 'static_page/home'
  get 'static_page/help'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root "application#hello"
end
