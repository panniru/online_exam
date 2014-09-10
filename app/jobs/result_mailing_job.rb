class ResultMailingJob
  attr_accessor :exam, :to, :subject, :body, :schedule_date

  def initialize(exam, to, subject, body, date)
    self.exam = exam
    self.to = to
    self.subject = subject
    self.body = body
    self.schedule_date = date
  end

  def perform
    schedules = exam.schedules.dated_on(schedule_date)
    results = Result.belongs_to_schedules(schedules.map(&:id))
    results = ResultsDecorator.decorate_collection(results)
    av = ActionView::Base.new
    av.view_paths = ActionController::Base.view_paths
    pdf_html = av.render :template => "results/results.pdf.haml",
    :layout => nil,
    :locals => { exam_name: exam.exam_full_name, date: schedule_date, results: results }
    doc_pdf = WickedPdf.new.pdf_from_string(pdf_html, :page_size => 'Letter')
    Notifier.exam_results(to, subject, body, pdf_html).deliver
  end
end
