class EmailHandlerTask < Volt::Task
  def send_email(emails)
    Mailer.deliver('admin/mailers/contribution', {to: emails})
  end

  def send_reminder(emails)
    Mailer.deliver('admin/mailers/reminder', {to: emails})
  end

  def send_group_email(emails, subject, body)
    Mailer.deliver('admin/mailers/competency_email', {to: emails, subject: subject, body: body})
  end
end
