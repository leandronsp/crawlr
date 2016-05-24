Rails.application.routes.draw do
  get  '/',      to: 'sitemaps#new'
  post '/sitemaps/generate', to: 'sitemaps#generate'
end
