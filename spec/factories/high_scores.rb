# frozen_string_literal: true

FactoryBot.define do
  factory :high_score do
    game { 'MyString' }
    score { 1 }
  end
end
