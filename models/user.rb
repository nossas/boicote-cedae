class User < ActiveRecord::Base
  validates :name, :email, presence: true
  validates :email, format: { with: /\A([\w\.%\+\-]+)@([\w\-]+\.)+([\w]{2,})\z/i }, uniqueness: true

  after_create :deliver_email, :mailchimp_sync

  def first_name
    name.split(" ").first
  end

  def last_name
    name.split(" ").last
  end

  private
    def deliver_email
      UserMailer.thanks(self).deliver
    end

    def mailchimp_sync
      gb = Gibbon::API.new(ENV['MAILCHIMP_API'])
      gb.lists.subscribe({ id: ENV['MAILCHIMP_LIST_ID'], 
                           email: { email: email }, 
                           merge_vars: { FNAME: first_name, LNAME: last_name}, 
                           double_optin: false })
    end
end
