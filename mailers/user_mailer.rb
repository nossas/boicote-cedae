# encoding: utf-8

class UserMailer < ActionMailer::Base
  def thanks(user)
    mail(to: user.email, from: "test@example.com", subject: "Obrigado por se comprometer com o boicote à Cedae! Agora Espalhe!")
  end
end
