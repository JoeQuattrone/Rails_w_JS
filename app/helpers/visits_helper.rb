module VisitsHelper
  def format_start_visit(visit)
    visit.start_visit.strftime('%m/%d/%Y')
  end

  def format_end_visit(visit)
    visit.end_visit.strftime('%m/%d/%Y')
  end
end
