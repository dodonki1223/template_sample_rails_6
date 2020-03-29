require 'rails_helper'

RSpec.describe "high_scores/new", type: :view do
  before(:each) do
    assign(:high_score, HighScore.new(
      :game => "MyString",
      :score => 1
    ))
  end

  it "renders new high_score form" do
    render

    assert_select "form[action=?][method=?]", high_scores_path, "post" do

      assert_select "input[name=?]", "high_score[game]"

      assert_select "input[name=?]", "high_score[score]"
    end
  end
end
