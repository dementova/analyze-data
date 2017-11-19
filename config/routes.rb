Rails.application.routes.draw do
  root to: "charts#index"

  post 'charts/generate'
end
