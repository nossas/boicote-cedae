# encoding: utf-8

class UserMailer < ActionMailer::Base
  def thanks(user)
    mail(to: user.email, from: "<Alessandra Orofino> alessandra@meurio.org.br", subject: "Obrigado por se comprometer com o boicote à Cedae! Agora Espalhe!")
  end
end
