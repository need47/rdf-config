require 'rdf-config/schema/chart/constant'

class RDFConfig
  class Schema
    class Chart
      class URINodeGenerator
        include Constant

        BEZIER_AREA = 8
        BEZIER_CONTROL = 3.6
        BEZIER_CONTROL_DIST = (BEZIER_AREA - BEZIER_CONTROL).round(1).freeze

        HLINE_WIDHT = (RECT_WIDTH - (BEZIER_AREA * 2)).freeze
        VLINE_HEIGHT = (RECT_HEIGHT - (BEZIER_AREA * 2)).freeze

        HEADER_AREA_HEIGHT = 20
        HEADER_AREA_VLINE_HEIGHT = (HEADER_AREA_HEIGHT - BEZIER_AREA).freeze
        # TC: value area height
        # VALUE_AREA_HEIGHT = (RECT_HEIGHT - HEADER_AREA_HEIGHT).freeze
        VALUE_AREA_HEIGHT = (RECT_HEIGHT - HEADER_AREA_HEIGHT - BEZIER_AREA).freeze
        # TC
        MARGIN_LEFT = 8
        MARGIN_RIGHT = 8

        def initialize(node, pos, opts = {})
          @node = node
          @pos = pos

          @drawing_mode = opts.key?(:drawing_mode) ? opts[:drawing_mode] : :subject
          @nest = opts.key?(:nest) ? opts[:nest] : false
          @model = opts.key?(:model) ? opts[:model] : nil
        end

        def generate
          uri_elements
        end

        private

        def uri_elements
          wrapper = REXML::Element.new('g')
          wrapper.add_element(rect_element)
          wrapper.add_element(header_rect_element)
          # TC: multiple values (e.g., multiple subject examples)
          value_elements.each { |e| wrapper.add_element(e) }
          # wrapper.add_element(value_element)
          # TC
          wrapper.add_element(header_element)
          wrapper.add_element(type_element)

          [wrapper]
        end

        def rect_element
          wrapper = REXML::Element.new('g')

          rect = REXML::Element.new('path')
          rect.add_attribute_by_hash(
            d: rect_paths.join(' '),
            class: fill_class
          )

          wrapper.add_element(rect)
          wrapper.add_element(outline_element)

          wrapper
        end

        def outline_element
          outer_line = REXML::Element.new('path')
          outer_line.add_attribute_by_hash(
            d: rect_paths.join(' '),
            class: 'st1'
          )

          outer_line
        end

        def header_rect_element
          variable = REXML::Element.new('path')
          paths = ["M#{@pos.x},#{@pos.y + HEADER_AREA_HEIGHT}"]
          paths << "v-#{HEADER_AREA_VLINE_HEIGHT}"
          paths << "c0,-#{BEZIER_CONTROL_DIST} #{BEZIER_CONTROL},-#{BEZIER_AREA} #{BEZIER_AREA},-#{BEZIER_AREA}"
          paths << "h#{HLINE_WIDHT}"
          paths << "c#{BEZIER_CONTROL_DIST},0 #{BEZIER_AREA},#{BEZIER_CONTROL} #{BEZIER_AREA},#{BEZIER_AREA}"
          paths << "v#{HEADER_AREA_VLINE_HEIGHT}"
          variable.add_attribute_by_hash(d: paths.join(' '))

          wrapper = REXML::Element.new('g')
          wrapper.add_attribute_by_hash(class: 'st2')
          wrapper.add_element(variable)

          wrapper
        end

        # TC: multiple values (e.g., multiple subject examples)
        def value_elements
          wrappers = []

          if !@node.is_a?(Model::Subject)
            wrappers << value_element

            return wrappers
          end

          value_text.split(" ").each_with_index do |txt, idx|
            value = REXML::Element.new('text')
            value.add_attribute_by_hash(
              x: @pos.x + MARGIN_LEFT,
              y: @pos.y + VALUE_AREA_HEIGHT * idx + HEADER_AREA_HEIGHT + VALUE_MARGIN_TOP,
              class: 'st3 st4'
            )
            value.add_text(txt)
            # $stderr.puts "value_text: #{txt}"

            wrapper = REXML::Element.new('g')
            wrapper.add_attribute_by_hash(transform: 'translate(-0.5 -0.5)')
            wrapper.add_element(value)

            wrappers << wrapper
          end

          wrappers
        end
        # TC

        def value_element
          value = REXML::Element.new('text')
          value.add_attribute_by_hash(
            x: @pos.x + MARGIN_LEFT,
            y: @pos.y + HEADER_AREA_HEIGHT + VALUE_MARGIN_TOP,
            class: 'st3 st4'
          )
          value.add_text(value_text)

          wrapper = REXML::Element.new('g')
          wrapper.add_attribute_by_hash(transform: 'translate(-0.5 -0.5)')
          wrapper.add_element(value)

          wrapper
        end

        def header_element
          header = REXML::Element.new('text')
          header.add_attribute_by_hash(
            x: @pos.x + MARGIN_LEFT,
            y: @pos.y + HEADER_AREA_HEIGHT / 2,
            class: 'st5 st6 st7',
            'dominant-baseline' => 'middle'
          )

	        # TC: allow to display concise predicate, e.g., compound_has_attribute -> has_attribute
          txt = header_text

          if !txt.nil? && !txt.empty?
            tokens = txt.split('_')
            if tokens.size > 1 && RDFConfig::Schema::Chart::Constant::PUBCHEMRDF_SUBDOMAINS.include?(tokens[0])
              txt = tokens[1..-1].join('_')
            end
          end

          header.add_text(txt)
          # TC

          wrapper = REXML::Element.new('g')
          wrapper.add_attribute_by_hash(transform: 'translate(-0.5 -0.5)')
          wrapper.add_element(header)

          wrapper
        end

        def type_element
          type = REXML::Element.new('text')
          type.add_attribute_by_hash(
            x: @pos.x + RECT_WIDTH - MARGIN_RIGHT,
            y: @pos.y + HEADER_AREA_HEIGHT / 2,
            class: 'st8 st6 st7',
            'text-anchor' => 'end',
            'dominant-baseline' => 'middle'
          )
          type.add_text('URI')

          wrapper = REXML::Element.new('g')
          wrapper.add_attribute_by_hash(transform: 'translate(-0.5 -0.5)')
          wrapper.add_element(type)

          wrapper
        end

        # TC: multiple values (e.g., multiple subject examples)
        def rect_paths
          multi = value_text.split().size
          multi = 1 if multi == 0
          delta = VALUE_AREA_HEIGHT * (multi - 1)

          paths = ["M#{@pos.x + RECT_WIDTH},#{@pos.y + RECT_HEIGHT - BEZIER_AREA + delta}"]
          paths << "c0,#{BEZIER_CONTROL_DIST} -#{BEZIER_CONTROL},#{BEZIER_AREA} -#{BEZIER_AREA},#{BEZIER_AREA}"
          paths << "h-#{HLINE_WIDHT}"
          paths << "c-#{BEZIER_CONTROL_DIST},0 -#{BEZIER_AREA},-#{BEZIER_CONTROL} -#{BEZIER_AREA},-#{BEZIER_AREA}"
          paths << "v-#{VLINE_HEIGHT + delta}"
          paths << "c0,-#{BEZIER_CONTROL_DIST} #{BEZIER_CONTROL},-#{BEZIER_AREA} #{BEZIER_AREA},-#{BEZIER_AREA}"
          paths << "h#{HLINE_WIDHT}"
          paths << "c#{BEZIER_CONTROL_DIST},0 #{BEZIER_AREA},#{BEZIER_CONTROL} #{BEZIER_AREA},#{BEZIER_AREA}"
          paths << "v#{VLINE_HEIGHT + delta}"
          paths << 'z'

          paths
        end

        # def rect_paths
        #   paths = ["M#{@pos.x + RECT_WIDTH},#{@pos.y + RECT_HEIGHT - BEZIER_AREA}"]
        #   paths << "c0,#{BEZIER_CONTROL_DIST} -#{BEZIER_CONTROL},#{BEZIER_AREA} -#{BEZIER_AREA},#{BEZIER_AREA}"
        #   paths << "h-#{HLINE_WIDHT}"
        #   paths << "c-#{BEZIER_CONTROL_DIST},0 -#{BEZIER_AREA},-#{BEZIER_CONTROL} -#{BEZIER_AREA},-#{BEZIER_AREA}"
        #   paths << "v-#{VLINE_HEIGHT}"
        #   paths << "c0,-#{BEZIER_CONTROL_DIST} #{BEZIER_CONTROL},-#{BEZIER_AREA} #{BEZIER_AREA},-#{BEZIER_AREA}"
        #   paths << "h#{HLINE_WIDHT}"
        #   paths << "c#{BEZIER_CONTROL_DIST},0 #{BEZIER_AREA},#{BEZIER_CONTROL} #{BEZIER_AREA},#{BEZIER_AREA}"
        #   paths << "v#{VLINE_HEIGHT}"
        #   paths << 'z'

        #   paths
        # end
        # TC

        def fill_class
          if @node.is_a?(Model::Subject)
            # TC: allow to customize fill color
            if RDFConfig::Schema::Chart::Constant::PUBCHEMRDF_SUBDOMAINS.include?(@node.name.downcase)
              "st0 stPubChem st#{@node.name}"
            else
              "st0 st#{@node.name}"
            end
            # TC
          else
            'st9uri'
          end
        end

        def header_text
          if @node.is_a?(Model::Subject)
            subject_header_text
          else
            @node.name
          end
        end

        def subject_header_text
          if @drawing_mode == :object
            @node.as_object_name
          else
            @node.name
          end
        end

        def value_text
          if @node.is_a?(Model::Subject)
            subject_value_text
          else
            @node.value
          end
        end

        def subject_value_text
          if @drawing_mode == :object
            @node.name
          else
            @node.value
          end
        end
      end
    end
  end
end
