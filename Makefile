# Location of mirah library files

MVD_MIRAH_LIBRARY = /Users/jdim006/Codes/MVD-project/develop-mvd/mvd-lib/src/

MVD_MIRAH_INCLUDES = "$(MVD_MIRAH_LIBRARY)make_query.mirah"

# Location of mirah extension macro jar, which needs to be present when compiling an MVD

MVD_MIRAH_JAR = /Users/jdim006/Codes/MVD-project/develop-mvd/mvd-compile-time-jar/mvd-macros.jar

# Path to BIMserver jars

BIMSERVER_PATH = /Users/jdim006/Desktop/BIMserver/bimserver-1.4.0-FINAL-2015-11-04/lib/

BIMSERVER_JARS = "$(BIMSERVER_PATH)org.eclipse.emf.common_2.9.1.v20130827-0309.jar:$(BIMSERVER_PATH)org.eclipse.emf_2.6.0.v20130902-0605.jar:$(BIMSERVER_PATH)org.eclipse.emf.ecore_2.9.1.v20130827-0309.jar:$(BIMSERVER_PATH)bimserver-1.4.0-FINAL-2015-11-04-shared.jar:$(BIMSERVER_PATH)bimserver-1.4.0-FINAL-2015-11-04.jar:$(BIMSERVER_PATH)commons-io-1.4.jar:$(BIMSERVER_PATH)guava-18.0.jar"

QUERY_PLUGIN_PATH = ../MVD-project/BIMserver-query-plugin-shell/

MIRAH_PARSER_PATH = /Users/jdim006/Codes/mirah-0.2.1/lib/mirah-complete.jar

OTHER_JARS = "$(QUERY_PLUGIN_PATH)BIMserver-query-plugin-shell.jar:$(MIRAH_PARSER_PATH):$(MVD_MIRAH_JAR)"

# Build directories

PACKAGE_DIR = com/arcabim/mvdlib/

TEMP_DIR = temp/

INTERMEDIATE = "$(PACKAGE_DIR)result.mirah"

ARTIFACTS = built/

# Location to output mvd jar

OUTPUT_MVD_JAR = mvd.jar

$(OUTPUT_MVD_JAR): $(INTERMEDIATE)
	mirahc -classpath "$(BIMSERVER_JARS):$(OTHER_JARS)" -d "$(ARTIFACTS)" $(INTERMEDIATE)
	cd "$(ARTIFACTS)" && jar cf mvd.jar * && cd -
	mv "$(ARTIFACTS)"mvd.jar "$(OUTPUT_MVD_JAR)"

#Example MIRAH_TARGETS = $(PACKAGE_DIR)map.mirah $(PACKAGE_DIR)reduce.mirah
# both map.mirah and reduce.mirah will get cat into INTERMEDIATE (see cat line below) 
MIRAH_TARGETS = $(PACKAGE_DIR)filter.mirah


$(INTERMEDIATE): $(MIRAH_TARGETS)
	mkdir -p "$(TEMP_DIR)"
	cat $(MVD_MIRAH_INCLUDES) $^ >$@

all: $(OUTPUT_MVD_JAR)

clean:
	rm -rf $(ARTIFACTS) "$(TEMP_DIR)"

.DEFAULT_GOAL := all

.PHONY: clean
