Rails.application.routes.draw do
  get  '/sitemaps/new',      to: 'sitemaps#new'
  post '/sitemaps/generate', to: 'sitemaps#generate'
end
