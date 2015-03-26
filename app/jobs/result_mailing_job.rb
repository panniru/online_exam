class ResultMailingJob
  attr_accessor :exam, :to, :subject, :body, :date_from, :date_to

  def initialize(exam, to, subject, body, date_from, date_to)
    self.exam = exam
    self.to = to
    self.subject = subject
    self.body = body
    self.date_from = date_from
    self.date_to = date_to
  end

  def perform
    schedules = []
    if date_from.present?
      schedules = exam.schedules.dated_on_or_after(date_from)
    elsif date_from.present? and date_to.present?
      schedules = exam.schedules.scheduled_between(date_from, date_to)
    else
      schedules = exam.schedules
    end
    results = Result.belongs_to_schedules(schedules.map(&:id))
    results = ResultsDecorator.decorate_collection(results)
    av = ActionView::Base.new
    av.view_paths = ActionController::Base.view_paths
    pdf_html = av.render :template => "results/results.pdf.haml",
    :layout => nil,
    :locals => { exam_name: exam.exam_full_name, date_from: date_from, results: results, date_to: date_to}
    doc_pdf = WickedPdf.new.pdf_from_string(pdf_html, :page_size => 'Letter')
    Notifier.exam_results(to, subject, body, pdf_html).deliver
  end
end
