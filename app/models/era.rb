class Era < ApplicationRecord
    has_many :sub_eras, dependent: :destroy
    
    validates :name, presence: true

    def self.ransackable_attributes(auth_object = nil)
        ["id", "name"]
    end
end
