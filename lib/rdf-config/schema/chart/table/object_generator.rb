require 'rdf-config/schema/chart/table/svg_generator'
require 'rdf-config/schema/chart/table/element_generator'
require 'rdf-config/schema/chart/table/constant'
require 'rdf-config/schema/chart/constant'

class RDFConfig
  class Schema
    class Chart
      class Table
        class ObjectGenerator < ElementGenerator
          def initialize(object, xpos, ypos, table_width, opts = {})
            super(xpos, ypos, table_width, opts)
            @bnode_ident = opts[:bnode_ident] || 0
            @xpos += Constant::SUBJECT_WRAPPER_PADDING if in_bnode?
            @object = object
            @is_last = opts[:is_last]
          end

          def generate
            g = REXML::Element.new('g')
            rect = REXML::Element.new('rect')
            rect.add_attribute_by_hash(
              x: @xpos, y: @ypos,
              width: width,
              height: OBJECT_HEIGHT,
              class: area_css_class
            )
            g.add_element(rect)
            g.add_element(generate_name)
            g.add_element(generate_type)

            g
          end

          def generate_name
            text = REXML::Element.new('text')
            text.add_attribute_by_hash(
              x: name_x_position,
              y: text_y_position(OBJECT_HEIGHT, FONT_SIZE),
              class: text_css_class
            )

            txt = element_text

            # TC: allow to display concise predicate, e.g., compound_preflabel -> preflabel
            if !txt.nil? && !txt.empty?
              tokens = txt.split('_')
              if tokens.size > 1 && RDFConfig::Schema::Chart::Constant::PUBCHEMRDF_SUBDOMAINS.include?(tokens[0])
                txt = tokens[1..-1].join('_')
              end
            end

            text.add_text(txt)
            # TC

            text
          end

          def generate_type
            text = REXML::Element.new('text')
            text.add_attribute_by_hash(
              x: @xpos + width - TABLE_PADDING_RIGHT,
              y: text_y_position(OBJECT_HEIGHT, FONT_SIZE),
              'text-anchor' => 'end',
              class: 'object-type'
            )

            # # TC: add styles for PubChem entities
            # if RDFConfig::Schema::Chart::Constant::PUBCHEMRDF_SUBDOMAINS.include?(type_text.downcase)
            #   text.add_attribute_by_hash(class: "object-type .stPubChem .st#{type_text}")
            # end
            # # TC

            text.add_text(type_text)

            text
          end

          def element_text
            if @object.blank_node?
              @object.value.bnode_name
            elsif subject?
              case @object
              when Model::Subject
                @object.as_object_name
              when Model::ValueList
                subject = @object.instances.select(&:subject?).first
                if subject
                  subject.as_object_name
                else
                  ''
                end
              else
                ''
              end
            else
              @object.name
            end
          end

          def type_text
            case @object
            when Model::Subject
              @object.name
            when Model::ValueList
              type_text_by_value_list
            else
              @object.instance_type.to_s
            end
          end

          def type_text_by_value_list
            first_value = @object.first_instance
            if first_value.is_a?(Model::Subject)
              subjects = @object.instances.select(&:subject?)
              case subjects.size
              when 0
                ''
              when 1
                subjects.first.name
              when 2, 3
                subjects.map(&:name).join(', ')
              else
                subjects[0..2].map(&:name).join(', ') + ', ...'
              end
            else
              first_value.instance_type.to_s
            end
          end

          def area_css_class
            # TC: add styles for PubChem entities
            if RDFConfig::Schema::Chart::Constant::PUBCHEMRDF_SUBDOMAINS.include?(@object.name.downcase)
              return "subject-object stPubChem st#{@object.name}" if subject?
            end
            # TC

            return 'subject-object' if subject?

            case @object
            when Model::URI
              'uri-object'
            when Model::Literal
              'literal-object'
            when Model::BlankNode
              'blank-node-object'
            when Model::ValueList
              if @object.first_instance.is_a?(Model::URI)
                'uri-object'
              else
                'literal-object'
              end
            else
              'unknown-object'
            end
          end

          def text_css_class
            'object-text'
          end

          def width
            object_width = @table_width - SUBJECT_WRAPPER_PADDING * 2
            object_width -= (SUBJECT_WRAPPER_PADDING + @bnode_ident * BLANK_NODE_LEFT_MARGIN) if in_bnode?

            object_width
          end

          def in_bnode?
            SvgGenerator.in_bnode?
          end

          def subject?
            @object.instances.select(&:subject?).any?
          end
        end
      end
    end
  end
end
