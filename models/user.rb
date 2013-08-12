class User < ActiveRecord::Base
  validates :name, :email, presence: true
  validates :email, format: { with: /\A([\w\.%\+\-]+)@([\w\-]+\.)+([\w]{2,})\z/i }, uniqueness: true

  after_create :deliver_email

  private
    def deliver_email
      UserMailer.thanks(self).deliver
    end
end
