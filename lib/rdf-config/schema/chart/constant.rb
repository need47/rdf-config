class RDFConfig
  class Schema
    class Chart
      module Constant
        # TC: PubChemRDF subdomains
        PUBCHEMRDF_SUBDOMAINS = %w(
          anatomy
          author
          bioassay
          book
          cell
          compound
          concept
          conserveddomain
          cooccurrence
          cooccurrencecompoundcompound
          cooccurrencecompounddisease
          cooccurrencecompoundgene
          cooccurrencediseasedisease
          cooccurrencediseasecompound
          cooccurrencediseasegene
          cooccurrencegenegene
          cooccurrencegenecompound
          cooccurrencegenedisease
          descriptor
          descriptorcompoundidentifier
          descriptorcanonicalsmiles
          descriptorcovalentunitcount
          descriptordefinedatomstereocount
          descriptordefinedbondstereocount
          descriptorexactmass
          descriptorheavyatomcount
          descriptorhydrogenbondacceptorcount
          descriptorhydrogenbonddonorcount
          descriptorisomericsmiles
          descriptorisotopeatomcount
          descriptorinchi
          descriptormolecularformula
          descriptormolecularweight
          descriptormonoisotopicweight
          descriptoriupacname
          descriptorrotatablebondcount
          descriptorstructurecomplexity
          descriptortotalformalcharge
          descriptortpsa
          descriptorundefinedatomstereocount
          descriptorundefinedbondstereocount
          descriptorxlogp3
          descriptorsubstanceversion
          disease
          endpoint
          gene
          genesymbol
          grant
          inchikey
          journal
          measuregroup
          neighbor
          organization
          patent
          patentcpc
          patentipc
          patentassignee
          patentinventor
          pathway
          protein
          reference
          source
          substance
          synonym
          taxonomy
        ).to_set.freeze
        # TC

        SUBJECT_NAME_FONT_FAMILY = 'Helvetica-bold'.freeze
        FONT_FAMILY = 'Helvetica'.freeze
        FONT_SIZE = '12px'.freeze
        # TC: larger rect width
        # RECT_WIDTH = 180
        RECT_WIDTH = 345
        # RECT_HEIGHT = 50
        RECT_HEIGHT = 44
        MARGIN_RECT = 20

        # VALUE_MARGIN_TOP = 18
        VALUE_MARGIN_TOP = 16
        # TC

        PREDICATE_AREA_WIDTH = 270
        PREDICATE_TRIANGLE_BASE_LEN = 10
        PREDICATE_TRIANGLE_HEIGHT = 13

        RDF_TYPE_RECT_BG = '#fff4c3'.freeze
        URI_INSTANCE_RECT_BG = '#ffce9f'.freeze
        URI_RECT_RADIUS = 7.5

        LITERAL_RECT_BG = '#f8cecc'.freeze
        LITERAL_TYPE_RECT_WIDTH = RECT_HEIGHT
        LITERAL_TYPE_RECT_HEIGHT = 20
        LITERAL_MARGIN_LEFT = 8
        LITERAL_MARGIN_RIGHT = 8

        UNKNOWN_RECT_BG = '#e0e0e0'.freeze

        BNODE_CIRCLE_BG = '#f2f2e9'.freeze
        BNODE_RADIUS = 20

        STROKE_WIDTH = 2
        STROKE_COLOR = '#000000'.freeze

        TITLE_FONT_SIZE = '18px'.freeze
      end
    end
  end
end
