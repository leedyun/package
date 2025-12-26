module ParamsHelper
  def maxAuthorsInGraph
    10
  end

  def maxAuthorsInTable
    500
  end

  def expandedAuthors
    maxAuthorsInGraph()
  end

  def maxDaysPerAuthorInGraph
    2*365
  end

  def maxDaysPerAuthorInTable
    maxDaysPerAuthorInGraph()
  end

  def maxAuthorDetails
    50
  end

  def maxDaysInGraph
    2*365
  end

  def maxDaysInTable
    maxDaysInGraph()
  end
end

self.extend ParamsHelper
