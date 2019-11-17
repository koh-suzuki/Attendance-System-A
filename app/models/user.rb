class User < ApplicationRecord
  has_many :attendances, dependent: :destroy
  attr_accessor :remember_token
  before_save { self.email = email.downcase }
  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 100 }, format: { with: VALID_EMAIL_REGEX },
                    uniqueness: true
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true
  validates :affiliation, length: { in: 2..30 }, allow_blank: true
  validates :basic_time, presence: true
  validates :work_time, presence: true
  
  def User.digest(string)
    cost = 
      if ActiveModel::SecurePassword.min_cost
        BCrypt::Engine::MIN_COST
      else
        BCrypt::Engine.cost
      end
      BCrypt::Password.create(string, cost: cost)
  end
  
  def User.new_token
    SecureRandom.urlsafe_base64
  end
  
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end
  
  def authenticated?(remember_token)
    return false if remember_digest.nil? 
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end
  
  def forget
    update_attribute(:remember_digest, nil)
  end
  
  def self.import(file)
    # 登録処理前のレコード数
    csv = []
    # windowsで作られたファイルに対応するので、encoding: "SJIS"を付けている
    CSV.foreach(params[:file].path, headers: true, encoding: "SJIS") do |row|
      csv << User.new({ name: row["name"], email: row["email"], affiliation: row["affiliation"], employee_number: row["employee_number"],
                          uid: row["uid"], basic_time: row["basic_time"], designated_work_start_time: row["designated_work_start_time"],
                          designated_work_end_time: row["designated_work_end_time"], superior: row["superior"], admin: row["admin"], password: row["password"]
                      })
    end
    # importメソッドでバルクインサートできる
    User.import(csv)
  end
end
