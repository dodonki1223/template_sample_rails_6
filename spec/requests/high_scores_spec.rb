# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'HighScores', type: :request do
  describe 'GET /high_scores' do
    it 'works! (now write some real specs)' do
      get high_scores_path
      expect(response).to have_http_status(:ok)
    end
  end
end
