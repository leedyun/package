module NamesHelper
  def label(name)
    @names ||= {
      :repos => 'Repositories',
      :general => 'Stats',
      :commits_per_author => 'Activity per author',
      :commits_per_author_detailed => 'Author details',
      :activity_per_day => 'Activity per day',
      :activity_per_week_last_year => 'Activity per week (last year)',
      :activity_per_hour => 'Activity per hour',
      :activity_per_weekday => 'Activity per weekday',
      :activity_per_weekday_and_hour => 'Activity per weekday and hour',
      :activity_per_month => 'Activity per month',
      :commits_per_year => 'Commits per year',
      :commits_per_yearmonth => 'Commits per year and month',
      :authors => "Top authors",
      :top_authors_of_year => "Top authors of year",
      :top_authors_of_yearmonth => "Top authors of year and month",
      :files_by_yearmonth => 'Files by year and month',
      :filechanges_by_yearmonth => 'Filechanges by year and month',
      :lines_by_yearmonth => 'Lines by year and month',
      :linechanges_by_yearmonth => 'Linechanges by year and month',
      :filetypes => 'Filetypes',
      :lastweeks => 'Last years weeks',
      :fileschart => 'Fileschart',
      :lineschart => 'Lineschart',
      :globalstats => 'Overview'
    }

    @names[name].nil? ? name.to_s : @names[name]
  end

  def weekday(wday)
    case wday
    when 0
      'Monday'
    when 1
      'Tuesday'
    when 2
      'Wednesday'
    when 3
      'Thursday'
    when 4
      'Friday'
    when 5
      'Saturday'
    when 6
      'Sunday'
    end
  end

  def monthnames()
    return ["January","February","March","April","May","June","July","August","September","October","November","December"]
  end

  def monthname(month)
    return monthnames[month-1]
  end
end

self.extend NamesHelper

