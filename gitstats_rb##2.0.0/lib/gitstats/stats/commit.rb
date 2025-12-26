class CommitAccumulator
  attr_reader :commits
  attr_reader :files_added
  attr_reader :files_deleted
  attr_reader :lines_added
  attr_reader :lines_deleted
  attr_reader :first_commit
  attr_reader :last_commit

  def files
    @files_added - @files_deleted
  end

  def lines
    @lines_added - @lines_deleted
  end

  def initialize
    @commits = 0
    @files_added = 0
    @files_deleted = 0
    @lines_added = 0
    @lines_deleted = 0
    @first_commit = nil
    @last_commit = nil
  end

  def update(commit)
    @commits += 1
    @files_added += commit[:files_added]
    @files_deleted += commit[:files_deleted]
    @lines_added += commit[:lines_added]
    @lines_deleted += commit[:lines_deleted]

    @first_commit ||= commit[:time]
    @last_commit ||= commit[:time]

    @first_commit = commit[:time] if commit[:time] < @first_commit
    @last_commit = commit[:time] if commit[:time] > @last_commit
  end
end

class CommitStats < CommitAccumulator
  def initialize
    super
    @days = {}
  end

  def days
    @days.size
  end

  def daystats
    @days
  end

  def update(commit)
    super(commit)
    day = commit[:time].to_date
    @days[day] ||= CommitAccumulator.new
    @days[day].update(commit)
  end
end