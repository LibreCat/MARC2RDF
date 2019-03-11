usage:
	@echo "usage: make TARGET"
	@echo
	@echo "targets:"
	@echo "  carton"
	@echo "  camel"
	@echo "  camel_rdf"
	@echo "  camel_yaml"
	@echo "  aleph_rdf"
	@echo "  aleph_yaml"
	@echo "  mml01_rdf"
	@echo "  mml01_aleph"

carton:
	@ carton

camel:
	@ carton exec 'catmandu convert MARC to MARCMaker < data/camel.mrc'

camel_rdf:
	@ carton exec 'catmandu convert MARC --fix fix/camel.fix --fix fix/marc_rdf_dct.fix to NTriples < data/camel.mrc'

camel_yaml:
	@ carton exec 'catmandu convert MARC --fix fix/camel.fix --fix fix/marc_rdf_dct.fix to YAML < data/camel.mrc'

aleph_yaml:
	@ carton exec 'catmandu convert ALEPHSEQ --fix fix/rug01.fix --fix fix/marc_rdf_dct.fix --fix fix/viaf_lookup.fix to YAML < data/rug01.aleph'

aleph_rdf:
	@ carton exec 'catmandu convert ALEPHSEQ --fix fix/rug01.fix --fix fix/marc_rdf_dct.fix --fix fix/viaf_lookup.fix to NTriples < data/rug01.aleph'

mml01_yaml:
	@ carton exec 'catmandu convert ALEPHSEQ --fix fix/mml01.fix --fix fix/marc_rdf_dct.fix to YAML < data/mml01.sample'

mml01_rdf:
	@ carton exec 'catmandu convert ALEPHSEQ --fix fix/mml01.fix --fix fix/marc_rdf_dct.fix to NTriples < data/mml01.sample'
