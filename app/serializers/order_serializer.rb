class OrderSerializer < ActiveModel::Serializer
  attributes :name, :quantity, :price, :description
end
