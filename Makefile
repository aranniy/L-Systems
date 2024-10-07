OBJ = generated/convertisseur
XML = generated/l-systems_complet.xml generated/tortue.xml generated/traceur.xml
TXT = generated/lsystem.txt generated/tortue.txt generated/traceur.txt 
SVG = generated/output.svg

all: convertisseur

convertisseur: l-systems.c
	gcc -Wall l-systems.c -o generated/convertisseur
	./generated/convertisseur

validate_lsystem: generated/l-systems_complet.xml
	xmllint --schema XSD/l-systems.xsd generated/l-systems_complet.xml > generated/lsystem.txt

validate_tortue: generated/tortue.xml
	xmllint --schema XSD/tortue.xsd generated/tortue.xml > generated/tortue.txt

validate_traceur: generated/tortue.xml
	xmllint --schema XSD/tortue.xsd generated/tortue.xml > generated/tortue.txt

svg:
	java -jar saxon-he-10.3.jar -s:generated/traceur.xml -xsl:XSL/svg.xsl -o:generated/output.svg

tortue:
	java -jar saxon-he-10.3.jar -s:generated/l-systems_complet.xml -xsl:XSL/tortue.xsl -o:generated/tortue.xml name=$(n) iterations=$(i)

traceur:
	java -jar saxon-he-10.3.jar -s:generated/tortue.xml -xsl:XSL/traceur.xsl -o:generated/traceur.xml

clean:
	rm -f $(OBJ) $(XML) $(TXT) $(SVG)
