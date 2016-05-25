/**
 * Created by Hao on 7/21/15.
 */
// var theQueryRSJSON = "https://info.deepcarbon.net/vivo/admin/sparqlquery?query=PREFIX+rdf%3A+++%3Chttp%3A%2F%2Fwww.w3.org%2F1999%2F02%2F22-rdf-syntax-ns%23%3E%0D%0APREFIX+rdfs%3A++%3Chttp%3A%2F%2Fwww.w3.org%2F2000%2F01%2Frdf-schema%23%3E%0D%0APREFIX+xsd%3A+++%3Chttp%3A%2F%2Fwww.w3.org%2F2001%2FXMLSchema%23%3E%0D%0APREFIX+owl%3A+++%3Chttp%3A%2F%2Fwww.w3.org%2F2002%2F07%2Fowl%23%3E%0D%0APREFIX+swrl%3A++%3Chttp%3A%2F%2Fwww.w3.org%2F2003%2F11%2Fswrl%23%3E%0D%0APREFIX+swrlb%3A+%3Chttp%3A%2F%2Fwww.w3.org%2F2003%2F11%2Fswrlb%23%3E%0D%0APREFIX+vitro%3A+%3Chttp%3A%2F%2Fvitro.mannlib.cornell.edu%2Fns%2Fvitro%2F0.7%23%3E%0D%0APREFIX+agu-index%3A+%3Chttp%3A%2F%2Fdeepcarbon.net%2Fontology%2Fagu-index%23%3E%0D%0APREFIX+bibo%3A+%3Chttp%3A%2F%2Fpurl.org%2Fontology%2Fbibo%2F%3E%0D%0APREFIX+c4o%3A+%3Chttp%3A%2F%2Fpurl.org%2Fspar%2Fc4o%2F%3E%0D%0APREFIX+cito%3A+%3Chttp%3A%2F%2Fpurl.org%2Fspar%2Fcito%2F%3E%0D%0APREFIX+dcat%3A+%3Chttp%3A%2F%2Fwww.w3.org%2Fns%2Fdcat%23%3E%0D%0APREFIX+dco%3A+%3Chttp%3A%2F%2Finfo.deepcarbon.net%2Fschema%23%3E%0D%0APREFIX+event%3A+%3Chttp%3A%2F%2Fpurl.org%2FNET%2Fc4dm%2Fevent.owl%23%3E%0D%0APREFIX+fabio%3A+%3Chttp%3A%2F%2Fpurl.org%2Fspar%2Ffabio%2F%3E%0D%0APREFIX+foaf%3A+%3Chttp%3A%2F%2Fxmlns.com%2Ffoaf%2F0.1%2F%3E%0D%0APREFIX+geo%3A+%3Chttp%3A%2F%2Faims.fao.org%2Faos%2Fgeopolitical.owl%23%3E%0D%0APREFIX+p.1%3A+%3Chttp%3A%2F%2Fpurl.org%2Fdc%2Felements%2F1.1%2F%3E%0D%0APREFIX+p.2%3A+%3Chttp%3A%2F%2Fpurl.org%2Fdc%2Fterms%2F%3E%0D%0APREFIX+obo%3A+%3Chttp%3A%2F%2Fpurl.obolibrary.org%2Fobo%2F%3E%0D%0APREFIX+ocrer%3A+%3Chttp%3A%2F%2Fpurl.org%2Fnet%2FOCRe%2Fresearch.owl%23%3E%0D%0APREFIX+ocresd%3A+%3Chttp%3A%2F%2Fpurl.org%2Fnet%2FOCRe%2Fstudy_design.owl%23%3E%0D%0APREFIX+p.3%3A+%3Chttp%3A%2F%2Fvivoweb.org%2Fontology%2Fprovenance-support%23%3E%0D%0APREFIX+prov%3A+%3Chttp%3A%2F%2Fwww.w3.org%2Fns%2Fprov%23%3E%0D%0APREFIX+skos%3A+%3Chttp%3A%2F%2Fwww.w3.org%2F2004%2F02%2Fskos%2Fcore%23%3E%0D%0APREFIX+vcard%3A+%3Chttp%3A%2F%2Fwww.w3.org%2F2006%2Fvcard%2Fns%23%3E%0D%0APREFIX+vitro-public%3A+%3Chttp%3A%2F%2Fvitro.mannlib.cornell.edu%2Fns%2Fvitro%2Fpublic%23%3E%0D%0APREFIX+vivo%3A+%3Chttp%3A%2F%2Fvivoweb.org%2Fontology%2Fcore%23%3E%0D%0APREFIX+scires%3A+%3Chttp%3A%2F%2Fvivoweb.org%2Fontology%2Fscientific-research%23%3E%0D%0A%0D%0ASELECT+DISTINCT+%3FexpertiseName+%3FexpertiseUri+%28COUNT+%28%3Fperson%29+AS+%3Fcount%29%0D%0AWHERE%0D%0A%7B%0D%0A%3FexpertiseUri+vivo%3AresearchAreaOf+%3Fperson+.%0D%0A%3Fperson+rdf%3Atype+foaf%3APerson+.%0D%0A%3FexpertiseUri+rdfs%3Alabel+%3FexpertiseName+.%0D%0AFILTER+%28%3FexpertiseUri+%21%3D+%3Chttp%3A%2F%2Finfo.deepcarbon.net%2Findividual%2Fa7bc1230-44af-4a01-84cf-e4d7bf5643d8%3E%29%0D%0A%7D%0D%0AGROUP+BY+%3FexpertiseUri+%3FexpertiseName%0D%0AORDER+BY+DESC%28%3Fcount%29+%3FexpertiseName&resultFormat=RS_JSON&rdfResultFormat=RDF%2FXML-ABBREV";
var theQueryRSJSON = "statsJSON/expertiseAreas.json";
// var theQueryRSJSON = "statsJSON/dcoStats.json";

// Create the XHR object.
// function createCORSRequest(method, url) {
//     var xhr = new XMLHttpRequest();
//     if ("withCredentials" in xhr) {
//         // XHR for Chrome/Firefox/Opera/Safari.
//         xhr.open(method, url, true);
//     } else if (typeof XDomainRequest != "undefined") {
//         // XDomainRequest for IE.
//         xhr = new XDomainRequest();
//         xhr.open(method, url);
//     } else {
//         // CORS not supported.
//         xhr = null;
//     }
//     return xhr;
// }
//
// // Helper method to parse the title tag from the response.
// function getTitle(text) {
//     return text.match('<title>(.*)?</title>')[1];
// }
//
// // Make the actual CORS request.
// function makeCorsRequest() {
//     // All HTML5 Rocks properties support CORS.
//     var url = 'http://updates.html5rocks.com';
//
//     var xhr = createCORSRequest('GET', url);
//     if (!xhr) {
//         alert('CORS not supported');
//         return;
//     }
//
//     // Response handlers.
//     xhr.onload = function() {
//         var text = xhr.responseText;
//         var title = getTitle(text);
//         alert('Response from CORS request to ' + url + ': ' + title);
//     };
//
//     xhr.onerror = function() {
//         alert('Woops, there was an error making the request.');
//     };
//
//     xhr.send();
// }
