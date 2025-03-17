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

              .stPubChem { fill: #c0c0c080; }
              .stAnatomy { fill: #c2b28080; }
              .stBioAssay, .stMeasureGroup, .stEndpoint { fill: #8c5ad980; }
              .stCell { fill: #00808080; }
              .stCompound, .stConcept, .stInChIKey { fill: #02bfe780; }
              [class*="stCooccurrence"] { fill: #83529480; }
              [class*="stDescriptor"] { fill: #7cbb9980; }
              .stDisease { fill: #a52a2a80; }
              .stGene, .stGeneSymbol { fill: #e31ca180; }
              .stProtein, .stConservedDomain, .stEnzyme { fill: #e35f1c80; }
              [class*="stPatent"] { fill: #225e6580; }
              .stPathway { fill: #73e53180; }
              .stReference, .stAuthor, .stBook, .stJournal, .stGrant { fill: #15705880; }
              .stSource, .stOrganization { fill: #4aa56480; }
              .stSubstance { fill: #f9c64280; }
              .stSynonym { fill: #7cbb9980; }
              .stTaxonomy { fill: #00abba80; }
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
