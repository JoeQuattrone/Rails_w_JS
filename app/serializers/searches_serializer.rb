class SearchesSerializer < ActiveModel::Serializer
  attributes :id, :address, :image_url, :price, :name, :city
end
