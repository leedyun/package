require 'spec_helper'

describe AlignedTable do
  describe ".column_lengths" do
    context "with a column of nils" do
      it "returns 0 for the column count" do
        at = AlignedTable.new
        at.rows = [[nil],[nil]]
        expect(at.column_lengths).to eq([0])
      end
    end

    context "with a column of strings" do
      it "returns the maximum string length" do
        at = AlignedTable.new
        at.rows = [["some"],["random"],["content"]]
        expect(at.column_lengths).to eq([7])
      end
    end

    context "with multiple columns of strings" do
      it "returns the maximum string length" do
        at = AlignedTable.new
        at.rows = [
          ["some", "more"],
          ["random", "things"],
          ["content", "here"]
        ]
        expect(at.column_lengths).to eq([7, 6])
      end
    end
  end

  describe ".render_row" do
    context "with a symbol" do
      it "renders symbols as a repeated line" do
        at = AlignedTable.new
        rendered = at.render_row([:-], [5])
        expect(rendered).to eq("-----")
      end
    end

    context "with rows with text" do
      it "renders the first column left padded" do
        at = AlignedTable.new
        rendered = at.render_row(["col1", "col2"], [5, 4])
        expect(rendered).to eq(" col1 col2")
      end

      it "renders additional columns right padded" do
        at = AlignedTable.new
        rendered = at.render_row(["col1", "col2"], [5, 7])
        expect(rendered).to eq(" col1 col2   ")
      end
    end

    describe "with a nonstandard separator" do
      it "renders rows with separator" do
        at = AlignedTable.new
        at.separator = " | "
        rendered = at.render_row(["col1", "col2"], [3, 3])
        expect(rendered).to eq("col1 | col2")
      end
    end
  end

  describe ".rows" do
    context "with a title" do
      it "renders the title before rows" do
        at = AlignedTable.new
        at.title = "Table"
        at.rows = [
          ["hey", "what's"],
          ["going", "on"]
        ]
        output = at.render
        expect(output).to eq("== Table ===\n  hey what's\ngoing on    ")
      end
    end

    context "without a title" do
      it "renders the rows" do
        at = AlignedTable.new
        at.rows = [
          ["hey", "what's"],
          ["going", "on"]
        ]
        output = at.render
        expect(output).to eq("  hey what's\ngoing on    ")
      end
    end
  end
end
