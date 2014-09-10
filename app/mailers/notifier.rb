class Notifier < ActionMailer::Base
  default from: 'noreply.olexam@gmail.com'

  def exam_results(recipients, subject, content, attachment_html)
    @content = content
    attachments[subject] = { mime_type: 'application/pdf',
      content: WickedPdf.new.pdf_from_string(attachment_html, :page_size => 'Letter')
    }
    mail(to: recipients, subject: subject)
  end
end
