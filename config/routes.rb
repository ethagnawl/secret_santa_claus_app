SecretSanta::Application.routes.draw do
  resources :events, :only => [:new]
  root :to => 'events#new'
  match 'notify-participants' => 'events#notify_participants', :via => :post
  mount Resque::Server, :at => "/resque"
end
