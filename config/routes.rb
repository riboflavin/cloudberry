OSConf::Application.routes.draw do
    
  get "/" => "home#index"
  get "/:loc" => "home#index"
  get "/:format/:loc" => "home#index"
  match '*path' => redirect('/')

end
