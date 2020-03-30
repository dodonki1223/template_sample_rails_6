# frozen_string_literal: true

json.array! @high_scores, partial: 'high_scores/high_score', as: :high_score
