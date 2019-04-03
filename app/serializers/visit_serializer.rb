class VisitSerializer < ActiveModel::Serializer
  attributes :id, :start_visit, :end_visit, :user_id, :created_at, :updated_at
  belongs_to :hotel
end
