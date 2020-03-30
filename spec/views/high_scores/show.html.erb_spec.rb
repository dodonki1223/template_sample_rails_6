# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'high_scores/show', type: :view do
  before do
    @high_score = assign(:high_score, HighScore.create!(
                                        game: 'Game',
                                        score: 2
                                      ))
  end

  it 'renders attributes in <p>' do
    render
    expect(rendered).to match(/Game/)
    expect(rendered).to match(/2/)
  end
end
