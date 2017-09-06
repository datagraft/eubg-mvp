Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
    root 'search#new'
    
    get '/search_offline', to: 'search#search_offline'
    
    get '/company_info', to: 'search#company_info'
    
    get '/company_info_offline', to: 'search#company_info_offline'
    
    get '/help', to: 'static_pages#help'
    
    get '/about', to: 'static_pages#about'
    
    get '/contact', to: 'static_pages#contact'

end
