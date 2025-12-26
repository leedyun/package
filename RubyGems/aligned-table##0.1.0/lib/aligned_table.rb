class AlignedTable
  VERSION = "0.1.0"

  attr_accessor :rows, :title, :separator

  def initialize
    @separator = " "
  end

  def render
    col_len = column_lengths
    rows = @rows.map do |row|
      render_row(row, col_len)
    end

    max_row_length = rows.max_by(&:length).length

    if @title
      rows.unshift(" #@title ".center(max_row_length, "="))
    end

    rows.join("\n")
  end

  def column_lengths
    columns = []

    @rows.each do |row|
      row.each_with_index do |col, index|
        columns[index] ||= []
        columns[index] << col
      end
    end

    columns.map! do |col|
      col.map { |x| x.to_s }.max_by(&:length).length
    end

    columns
  end

  def render_row(row, col_len)
    columns = row.each_with_index.map do |col, index|
      if col.is_a?(Symbol)
        col.to_s * col_len[index]
      else
        if index == 0
          col.to_s.rjust(col_len[index])
        else
          col.to_s.ljust(col_len[index])
        end
      end
    end
    columns.join(@separator)
  end
end
