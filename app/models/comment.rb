class Comment < ActiveRecord::Base
  belongs_to :report
  validates :text, presence: true, length: {maximum: 160}
end
