require 'csv'

class RDFConfig
  class Convert
    class CSVReader
      def initialize(source_file, file_format)
        @source_file = source_file
        case file_format
        when 'csv'
          @col_sep = ','
        when 'tsv'
          @col_sep = "\t"
        end

        @line_no = 1
      end

      def each_row(&block)
        CSV.foreach(@source_file, **csv_opts) do |row|
          block.call(row)
        end
      end

      private

      def csv_opts
        {
          col_sep: @col_sep,
          headers: :first_row
        }
      end
    end
  end
end
