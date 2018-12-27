#!/usr/bin/env bash
#
# Generate the datadictionary "product" from the source ontologies
#

#
# Looks silly but fools IntelliJ to see the functions in the included files
#
false && source ../../lib/_functions.sh

#
# this is the new data dictionary. It is independent of any glossary work.
#
function publishProductDataDictionary() {

  logRule "Publishing the datadictionary product"

  setProduct ontology || return $?
  export ontology_product_tag_root="${tag_root}"

  setProduct datadictionary || return $?
  export datadictionary_product_tag_root="${tag_root}"

  (
    cd ${ontology_product_tag_root} && ls
  )

  export datadictionary_script_dir="${SCRIPT_DIR}/product/datadictionary"

  if [ ! -d "${datadictionary_script_dir}" ] ; then
    error "Could not find ${datadictionary_script_dir}"
    return 1
  fi

  #
  # Set the memory for ARQ
  #
  export JVM_ARGS=${JVM_ARGS:--Xmx4G}

  #
  # Get ontologies for Prod
  #
  ${JENA_ARQ} \
    $(${GREP} -r 'utl-av[:;.]Release' "${ontology_product_tag_root}" | ${SED} 's/:.*$//;s/^/--data=/' | ${GREP} -F ".rdf") \
    --data="${datadictionary_script_dir}/AllProd.ttl" \
    --query="${datadictionary_script_dir}/echo.sq" \
    --results=TTL > "${TMPDIR}/temp0B.ttl"

  log "here is the start of the combined file"
  wc    "${TMPDIR}/temp0B.ttl"

  ${JENA_ARQ} \
    --data="${TMPDIR}/temp0B.ttl" \
    --query="${datadictionary_script_dir}/pseudorange.sq" \
    > "${TMPDIR}/pr.ttl"

  wc "${TMPDIR}/pr.ttl"

  cat > "${TMPDIR}/con1.sq" <<EOF
PREFIX av: <https://spec.edmcouncil.org/fibo/ontology/FND/Utilities/AnnotationVocabulary/>
prefix rdfs: <http://www.w3.org/2000/01/rdf-schema#>

SELECT DISTINCT ?c
WHERE {?x av:forCM true .
?x rdfs:subClassOf* ?c  .
FILTER (ISIRI (?c))
}
EOF

  ${JENA_ARQ} \
    --data="${TMPDIR}/temp0B.ttl" \
    --query="${TMPDIR}/con1.sq" \
    --results=TSV > "${TMPDIR}/CONCEPTS"

  log "Here are the concepts"
  cat "${TMPDIR}/CONCEPTS"

  cat > "${TMPDIR}/ss.sq" << EOF
PREFIX afn: <http://jena.apache.org/ARQ/function#>
PREFIX owl: <http://www.w3.org/2002/07/owl#>
prefix rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
prefix rdfs: <http://www.w3.org/2000/01/rdf-schema#>
prefix skos: <http://www.w3.org/2004/02/skos/core#>
prefix edm: <http://www.edmcouncil.org/temp#>
PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>
PREFIX av: <https://spec.edmcouncil.org/fibo/ontology/FND/Utilities/AnnotationVocabulary/>

SELECT ?class ?table ?definition ?field ?description ?type ?maturity ?r1
WHERE {
  ?class a owl:Class .
  FILTER (ISIRI (?class))
  LET (?ont := IRI (REPLACE (xsd:string (?class), "/[^/]*$", "/")))
  ?ont av:hasMaturityLevel  ?smaturity .
  BIND (IF ((?smaturity = av:Release), "Production", "Development") AS ?maturity)
  FIlTER (REGEX (xsd:string (?class), "edmcouncil"))
  ?class rdfs:subClassOf* ?base1 .
  ?b1 edm:pseudodomain ?base1; a edm:PR ; edm:p ?p ; edm:pseudorange ?r1  .
  ?p av:forDD "true"^^xsd:boolean .
  FILTER NOT EXISTS {
    ?class rdfs:subClassOf* ?base2 .
# FILTER (?base2 != ?base1)
    ?b2 a edm:PR ; edm:p ?p ; edm:pseudorange ?r2 ; edm:pseudodomain ?base2 .
	  ?r2 rdfs:subClassOf+ ?r1
	}

  ?p rdfs:label ?field .
  OPTIONAL {?p  skos:definition ?dx}
  BIND (COALESCE (?dx, "(none)") AS ?description )
  ?r1 rdfs:label ?type .
  ?class rdfs:label ?table
  OPTIONAL {?class skos:definition  ?dy }
  BIND ( COALESCE (?dy, "(none)") AS ?definition )
}
EOF

  #
  # Turns out, putting this into a text file and grepping over it ran faster than putting it into a triple store.
  #
  ${JENA_ARQ} \
    --data="${TMPDIR}/temp0B.ttl" \
    --data="${TMPDIR}/pr.ttl" \
    --query="${TMPDIR}/ss.sq" \
    --results=TSV | ${SED} 's/"@../"/g' > "${TMPDIR}/ssx.txt"

  log "Here are the first few lines"
  head  "${TMPDIR}/ssx.txt"
  #
  # remove duplicate lines
  #
  sort -u "${TMPDIR}/ssx.txt" > "${TMPDIR}/ss.txt"
  #
  # Start with empty output
  #
  log "" > "${TMPDIR}/output.tsv"
  #
  # The CONCEPTS are stop-classes; we don't show those.  So we treat them as DONE at the start of the processing.
  #
  ${CP} "${TMPDIR}/CONCEPTS" "${TMPDIR}/DONE"
  #
  # Find the list of things to include.  This is too costly to include all classes.
  #
  cat > "${TMPDIR}/dumps.sq" <<EOF
prefix rdfs: <http://www.w3.org/2000/01/rdf-schema#>

SELECT DISTINCT ?c
WHERE {
  ?x <https://spec.edmcouncil.org/fibo/ontology/FND/Utilities/AnnotationVocabulary/dumpable> true .
  ## Swap these two to include all subclasses of marked classes
  ?c rdfs:subClassOf* ?x .
  #BIND (?x AS ?c)
  ?c rdfs:label ?lx
  BIND (UCASE (?lx) AS ?l)
} ORDER BY ?l
EOF

  ${JENA_ARQ}  --data="${TMPDIR}/temp0B.ttl"  --query="${TMPDIR}/dumps.sq"  --results=TSV > "${TMPDIR}/dumps"

  ${CP} "${TMPDIR}/dumps" "${TMPDIR}/pr.ttl"    "${TMPDIR}/temp0B.ttl"  ${datadictionary_product_tag_root}

  log "here are the dumps"
  cat "${TMPDIR}/dumps"
  log "that was the dumps"

  echo Writing into "${datadictionary_product_tag_root}/index.html"

  log "${datadictionary_script_dir/${WORKSPACE}/}/index.template contains"
  cat "${datadictionary_script_dir}/index.template"

  ${SED}  '/-- index of dictionaries goes here/,$d' \
  "${datadictionary_script_dir}/index.template" > "${datadictionary_product_tag_root}/index.html"

  cat >> "${datadictionary_product_tag_root}/index.html" <<EOF
<table>
EOF

  tail -n +2 "${TMPDIR}/dumps" | while read class ; do
    dumpdd $class
  done

  cat >> "${datadictionary_product_tag_root}/index.html" <<EOF
</table>
EOF

  ${SED} \
    '1,/-- index of dictionaries goes here/d' \
    "${datadictionary_script_dir}/index.template" >> "${datadictionary_product_tag_root}/index.html"

  return 0
}

#
# Helper Function for datadictionary
#
function localdd () {

  if ${GREP} -q "$1" "${TMPDIR}/DONE" ; then
    log "I've seen it before!"
    return 0
  fi

  echo "$1" >>  "${TMPDIR}/DONE"

  ${GREP}  "^$1" "${TMPDIR}/ss.txt" | \
  ${SED} "s/^[^\t]*\t//; s/\t[^\t]*$//; 2,\$s/^[^\t]*\t[^\t]*\t/\t\"\"\t/" >> "${TMPDIR}/output.tsv"

  log "Finished tsv sed for $1"

  #tdbquery --loc=TEMP  --query=temp2.sq --results=TSV   > next
  ${GREP} "^$1" "${TMPDIR}/ss.txt" | ${SED} 's/^.*\t//'  |  while read uri ; do
    localdd "$(echo "${uri}" | ${SED} 's/\r//')"
  done

  return 0
}


#
# Helper Function for datadictionary
#
function dumpdd () {

  log "Creating Data Dictionary for $1"

  # Extract the filename from the local part of the class IRI
  local t=${1##*/}
  local fname=${t%>*}

  cat >> "${datadictionary_product_tag_root}/index.html" << EOF
<tr><td>${fname}</td><td><a href="${fname}.xlsx">excel</a></td><td><a href="${fname}.csv">CSV</a></td></tr>
EOF

  # Reset the output to blank
  echo "" > "${TMPDIR}/output.tsv"

  #Reset the "seen" list to be the stopclasses
  ${CP} "${TMPDIR}/CONCEPTS"  "${TMPDIR}/DONE"

  localdd $1

  cat > "${datadictionary_product_tag_root}/${fname}.csv" <<EOF
Table,Definition,Field,Field Definition,Type,Maturity
EOF

  ${SED} 's/"\t"/","/g; s/^\t"/,"/' "${TMPDIR}/output.tsv" >> "${datadictionary_product_tag_root}/${fname}.csv"

  ${PYTHON3} ${SCRIPT_DIR}/lib/csv-to-xlsx.py \
    "${datadictionary_product_tag_root}/${fname}.csv" \
    "${datadictionary_product_tag_root}/${fname}.xlsx" \
    "${datadictionary_script_dir}/csvconfig"

  return 0
}