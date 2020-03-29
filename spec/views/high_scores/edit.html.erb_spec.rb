require 'rails_helper'

RSpec.describe "high_scores/edit", type: :view do
  before(:each) do
    @high_score = assign(:high_score, HighScore.create!(
      :game => "MyString",
      :score => 1
    ))
  end

  it "renders the edit high_score form" do
    render

    assert_select "form[action=?][method=?]", high_score_path(@high_score), "post" do

      assert_select "input[name=?]", "high_score[game]"

      assert_select "input[name=?]", "high_score[score]"
    end
  end
end
