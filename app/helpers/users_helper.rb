module UsersHelper
  def months_labels
    months = %w( Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec )
    current_month = Time.now.month
    ((current_month - 11 - 1)..current_month - 1).map { |m| months[m] }.inspect
  end
end
