require 'rdf-config/schema/chart/table/element_generator'

class RDFConfig
  class Schema
    class Chart
      class Table
        class StyleGenerator < ElementGenerator
          def initialize
          end

          def generate
            defs = REXML::Element.new('defs')
            style = REXML::Element.new('style')
            style.add_attribute('type', 'text/css')
            # TC: add styles for PubChem entities
            style.add_text(<<~STYLE)
              .table-container {
                  fill: #fff;
                  stroke-width: 2px;
                  stroke: #000;
              }

              .subject-container {
                  fill: #5a4838;
              }

              .subject-type {
                  fill: #fff;
                  font-size: #{FONT_SIZE}px;
                  font-family: Helvetica, Arial, sans-serif;
              }

              .subject-text {
                  font-weight: bold;
                  opacity: 0.8;
                  fill: #fff;
                  font-size: #{FONT_SIZE}px;
                  font-family: Helvetica, Arial, sans-serif;
              }

              .uri-object {
                  fill: #ccf8f8;
              }

              .literal-object {
                  fill: #f8cecc;
              }

              .blank-node-object {
                  fill: #f2f2e9;
                  stroke: #000;
                  stroke-dasharray: 0 0 2.5 2.5;
              }

              .subject-object {
                  fill: #ffce9f;
              }

              .unknown-object {
                  fill: #e0e0e0;
              }

              .object-type {
                  font-weight: bold;
                  opacity: 0.8;
                  fill: #666;
                  font-size: #{FONT_SIZE}px;
                  font-family: Helvetica, Arial, sans-serif;
              }

              .object-text {
                  font-size: #{FONT_SIZE}px;
                  font-family: Helvetica, Arial, sans-serif;
              }

              .stPubChem {fill:#02bfe7; }
              .stAnatomy {fill:#c2b280; }
              .stBioAssay {fill:#8c5ad9; }
              .stCell {fill:#008080; }
              .stCompound {fill:#02bfe7; }
              .stConcept {fill:#02bfe7; }
              .stDisease {fill:#a52a2a; }
              .stGene {fill:#e31ca1; }
              .stProtein {fill:#e35f1c; }
              .stPatent {fill:#225e65; }
              .stPathway {fill:#73e531; }
              .stSource {fill:#4aa564; }
              .stSubstance {fill:#f9c642; }
              .stTaxonomy {fill:#00abba; }
            STYLE
            # TCß

            defs.add_element(style)

            defs
          end
        end
      end
    end
  end
end
