class EmailHandlerTask < Volt::Task
  def send_email(emails)
    Mailer.deliver('admin/mailers/contribution', {to: emails})
  end

end
