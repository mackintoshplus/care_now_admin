  require 'barby'
  require 'barby/barcode/ean_13'

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :reservations

  before_create :assign_barcode_number  # これがbefore_createフックです

  private

  def assign_barcode_number
    self.barcode_number = generate_unique_number_for_user  # ここで13桁の数字が割り当てられます
  end

  def generate_unique_number_for_user
    loop do
      random_number = rand(1_000_000_000_000..9_999_999_999_999).to_s[0, 12]
      ean = Barby::EAN13.new(random_number)
      complete_number = ean.to_s # これで13桁になります

      unless User.exists?(barcode_number: complete_number)
        return complete_number  # この13桁の数字がassign_barcode_numberメソッドでbarcode_numberに割り当てられます。
      end
    end
  end
  
  
  
end
