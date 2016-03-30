class EmailHandlerTask < Volt::Task
  def send_email(email)
    Mailer.deliver('admin/mailers/contribution', {to: "#{email}"})
  end

end
