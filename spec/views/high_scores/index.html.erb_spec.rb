require 'rails_helper'

RSpec.describe "high_scores/index", type: :view do
  before(:each) do
    assign(:high_scores, [
      HighScore.create!(
        :game => "Game",
        :score => 2
      ),
      HighScore.create!(
        :game => "Game",
        :score => 2
      )
    ])
  end

  it "renders a list of high_scores" do
    render
    assert_select "tr>td", :text => "Game".to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
  end
end
