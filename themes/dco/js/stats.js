function setClassCount(queryUrl, selector){
    $.getJSON({
        url: queryUrl,
        success: function(data) {
            var count = data["results"]["bindings"][0]["count"]["value"];
            $(selector).html(count);
        }
    });
}

var queryPrefixes = "PREFIX rdf:   <http://www.w3.org/1999/02/22-rdf-syntax-ns#>" +
    "PREFIX rdfs:  <http://www.w3.org/2000/01/rdf-schema#>" +
    "PREFIX xsd:   <http://www.w3.org/2001/XMLSchema#>" +
    "PREFIX owl:   <http://www.w3.org/2002/07/owl#>" +
    "PREFIX swrl:  <http://www.w3.org/2003/11/swrl#>" +
    "PREFIX swrlb: <http://www.w3.org/2003/11/swrlb#>" +
    "PREFIX vitro: <http://vitro.mannlib.cornell.edu/ns/vitro/0.7#>" +
    "PREFIX bibo: <http://purl.org/ontology/bibo/>" +
    "PREFIX c4o: <http://purl.org/spar/c4o/>" +
    "PREFIX cito: <http://purl.org/spar/cito/>" +
    "PREFIX dcat: <http://www.w3.org/ns/dcat#>" +
    "PREFIX dcodata: <http://info.deepcarbon.net/data/schema#>" +
    "PREFIX dcosample: <http://info.deepcarbon.net/sample/schema#>" +
    "PREFIX dco: <http://info.deepcarbon.net/schema#>" +
    "PREFIX dc: <http://purl.org/dc/elements/1.1/>" +
    "PREFIX dct: <http://purl.org/dc/terms/>" +
    "PREFIX event: <http://purl.org/NET/c4dm/event.owl#>" +
    "PREFIX fabio: <http://purl.org/spar/fabio/>" +
    "PREFIX foaf: <http://xmlns.com/foaf/0.1/>" +
    "PREFIX geo: <http://aims.fao.org/aos/geopolitical.owl#>" +
    "PREFIX obo: <http://purl.obolibrary.org/obo/>" +
    "PREFIX ocrer: <http://purl.org/net/OCRe/research.owl#>" +
    "PREFIX ocresd: <http://purl.org/net/OCRe/study_design.owl#>" +
    "PREFIX p.1: <http://vivoweb.org/ontology/provenance-support#>" +
    "PREFIX prov: <http://www.w3.org/ns/prov#>" +
    "PREFIX samfl: <http://def.seegrid.csiro.au/ontology/om/sam-lite#>" +
    "PREFIX skos: <http://www.w3.org/2004/02/skos/core#>" +
    "PREFIX vcard: <http://www.w3.org/2006/vcard/ns#>" +
    "PREFIX vitro-public: <http://vitro.mannlib.cornell.edu/ns/vitro/public#>" +
    "PREFIX vivo: <http://vivoweb.org/ontology/core#>" +
    "PREFIX scires: <http://vivoweb.org/ontology/scientific-research#>";

var statistics_queries = {
    members: "SELECT (COUNT(DISTINCT ?s) AS ?count)" +
    "WHERE" +
    "{ " +
    "?s a foaf:Person . " +
    "?s <http://vivo.mydomain.edu/ns#networkId> ?id ." +
    "}",
    datasets: "SELECT (COUNT(DISTINCT ?s) AS ?count)" +
    "WHERE" +
    "{ " +
    "?s a dcodata:Dataset . " +
    "?s vitro:mostSpecificType dcodata:Dataset ." +
    "}",
    projects: "SELECT (COUNT(DISTINCT ?s) AS ?count)" +
    "WHERE" +
    "{ " +
    "?s a vivo:Project . " +
    "?s vitro:mostSpecificType vivo:Project ." +
    "}",
    field_studies: "SELECT (COUNT(DISTINCT ?s) AS ?count)" +
    "WHERE" +
    "{ " +
    "?s a dco:FieldStudy . " +
    "?s vitro:mostSpecificType dco:FieldStudy ." +
    "}",
    dco_publications: "SELECT (COUNT(DISTINCT ?publication) AS ?count) WHERE {" +
    "{ ?publication a bibo:Article . }" +
    "UNION { ?publication a bibo:Book . }" +
    "UNION { ?publication a bibo:DocumentPart . }" +
    "UNION { ?publication a dco:Poster . }" +
    "UNION { ?publication a bibo:Thesis . } " +
    "?publication dco:isContributionToDCO ?isDcoPublication ." +
    "FILTER (lcase(str(?isDcoPublication)) = 'yes')" +
    "}"
};

for (var key in statistics_queries) {
    var queryUrl = "https://info.deepcarbon.net/vivo/admin/sparqlquery?query=" +
            encodeURIComponent(queryPrefixes) + encodeURIComponent(statistics_queries[key]) +
            "&resultFormat=RS_JSON&rdfResultFormat=JSON-LD";
    setClassCount(queryUrl, "p.stats-count#" + key);
}
