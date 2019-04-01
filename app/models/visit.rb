class Visit < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :hotel


end
