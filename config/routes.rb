# frozen_string_literal: true

Rails.application.routes.draw do
  root 'high_scores#index'

  resources :high_scores
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
