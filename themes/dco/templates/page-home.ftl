<#-- $This file is distributed under the terms of the license in /doc/license.txt$  -->

<@widget name="login" include="assets" />

<#-- 
        With release 1.6, the home page no longer uses the "browse by" class group/classes display. 
        If you prefer to use the "browse by" display, replace the import statement below with the
        following include statement:
        
            <#include "browse-classgroups.ftl">
            
        Also ensure that the homePage.geoFocusMaps flag in the runtime.properties file is commented
        out.
-->
<#import "lib-home-page.ftl" as lh>

<!DOCTYPE html>
<html lang="en">
    <head>
        <#include "head.ftl">
        <#if geoFocusMapsEnabled >
            <#include "geoFocusMapScripts.ftl">
        </#if>
        <script type="text/javascript" src="${urls.base}/js/homePageUtils.js?version=x"></script>
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.2/jquery.min.js"></script>
        <script>
            function setClassCount(queryUrl, selector){
                $.getJSON({
                    url: queryUrl,
                    success: function(data) {
                        var count = data["results"]["bindings"][0]["count"]["value"];
                        $(selector).html(count);
                    }
                });
            }

            var queryUrl = "https://info.deepcarbon.net/vivo/admin/sparqlquery?query=PREFIX+rdf%3A+++%3Chttp%3A%2F%2Fwww.w3.org%2F1999%2F02%2F22-rdf-syntax-ns%23%3E%0D%0APREFIX+rdfs%3A++%3Chttp%3A%2F%2Fwww.w3.org%2F2000%2F01%2Frdf-schema%23%3E%0D%0APREFIX+xsd%3A+++%3Chttp%3A%2F%2Fwww.w3.org%2F2001%2FXMLSchema%23%3E%0D%0APREFIX+owl%3A+++%3Chttp%3A%2F%2Fwww.w3.org%2F2002%2F07%2Fowl%23%3E%0D%0APREFIX+swrl%3A++%3Chttp%3A%2F%2Fwww.w3.org%2F2003%2F11%2Fswrl%23%3E%0D%0APREFIX+swrlb%3A+%3Chttp%3A%2F%2Fwww.w3.org%2F2003%2F11%2Fswrlb%23%3E%0D%0APREFIX+vitro%3A+%3Chttp%3A%2F%2Fvitro.mannlib.cornell.edu%2Fns%2Fvitro%2F0.7%23%3E%0D%0APREFIX+bibo%3A+%3Chttp%3A%2F%2Fpurl.org%2Fontology%2Fbibo%2F%3E%0D%0APREFIX+c4o%3A+%3Chttp%3A%2F%2Fpurl.org%2Fspar%2Fc4o%2F%3E%0D%0APREFIX+cito%3A+%3Chttp%3A%2F%2Fpurl.org%2Fspar%2Fcito%2F%3E%0D%0APREFIX+dcat%3A+%3Chttp%3A%2F%2Fwww.w3.org%2Fns%2Fdcat%23%3E%0D%0APREFIX+dcosample%3A+%3Chttp%3A%2F%2Finfo.deepcarbon.net%2Fsample%2Fschema%23%3E%0D%0APREFIX+dco%3A+%3Chttp%3A%2F%2Finfo.deepcarbon.net%2Fschema%23%3E%0D%0APREFIX+dc%3A+%3Chttp%3A%2F%2Fpurl.org%2Fdc%2Felements%2F1.1%2F%3E%0D%0APREFIX+dct%3A+%3Chttp%3A%2F%2Fpurl.org%2Fdc%2Fterms%2F%3E%0D%0APREFIX+event%3A+%3Chttp%3A%2F%2Fpurl.org%2FNET%2Fc4dm%2Fevent.owl%23%3E%0D%0APREFIX+fabio%3A+%3Chttp%3A%2F%2Fpurl.org%2Fspar%2Ffabio%2F%3E%0D%0APREFIX+foaf%3A+%3Chttp%3A%2F%2Fxmlns.com%2Ffoaf%2F0.1%2F%3E%0D%0APREFIX+geo%3A+%3Chttp%3A%2F%2Faims.fao.org%2Faos%2Fgeopolitical.owl%23%3E%0D%0APREFIX+obo%3A+%3Chttp%3A%2F%2Fpurl.obolibrary.org%2Fobo%2F%3E%0D%0APREFIX+ocrer%3A+%3Chttp%3A%2F%2Fpurl.org%2Fnet%2FOCRe%2Fresearch.owl%23%3E%0D%0APREFIX+ocresd%3A+%3Chttp%3A%2F%2Fpurl.org%2Fnet%2FOCRe%2Fstudy_design.owl%23%3E%0D%0APREFIX+p.1%3A+%3Chttp%3A%2F%2Fvivoweb.org%2Fontology%2Fprovenance-support%23%3E%0D%0APREFIX+prov%3A+%3Chttp%3A%2F%2Fwww.w3.org%2Fns%2Fprov%23%3E%0D%0APREFIX+samfl%3A+%3Chttp%3A%2F%2Fdef.seegrid.csiro.au%2Fontology%2Fom%2Fsam-lite%23%3E%0D%0APREFIX+skos%3A+%3Chttp%3A%2F%2Fwww.w3.org%2F2004%2F02%2Fskos%2Fcore%23%3E%0D%0APREFIX+vcard%3A+%3Chttp%3A%2F%2Fwww.w3.org%2F2006%2Fvcard%2Fns%23%3E%0D%0APREFIX+vitro-public%3A+%3Chttp%3A%2F%2Fvitro.mannlib.cornell.edu%2Fns%2Fvitro%2Fpublic%23%3E%0D%0APREFIX+vivo%3A+%3Chttp%3A%2F%2Fvivoweb.org%2Fontology%2Fcore%23%3E%0D%0APREFIX+scires%3A+%3Chttp%3A%2F%2Fvivoweb.org%2Fontology%2Fscientific-research%23%3E%0D%0A%0D%0A%23%0D%0A%23+This+example+query+gets+20+geographic+locations%0D%0A%23+and+%28if+available%29+their+labels%0D%0A%23%0D%0ASELECT+%28COUNT%28DISTINCT+%3Fs%29+AS+%3Fcount%29%0D%0A++++++++WHERE%0D%0A++++++++%7B%0D%0A++++++++++++%3Fs+a+foaf%3APerson+.%0D%0A++++++++++++%3Fs+%3Chttp%3A%2F%2Fvivo.mydomain.edu%2Fns%23networkId%3E+%3Fid+.%0D%0A++++++++%7D&resultFormat=RS_JSON&rdfResultFormat=JSON-LD";
            var selector = "p.stats-count#members";
            setClassCount(queryUrl, selector);
            var queryUrl = "https://info.deepcarbon.net/vivo/admin/sparqlquery?query=PREFIX+rdf%3A+++%3Chttp%3A%2F%2Fwww.w3.org%2F1999%2F02%2F22-rdf-syntax-ns%23%3E%0D%0APREFIX+rdfs%3A++%3Chttp%3A%2F%2Fwww.w3.org%2F2000%2F01%2Frdf-schema%23%3E%0D%0APREFIX+xsd%3A+++%3Chttp%3A%2F%2Fwww.w3.org%2F2001%2FXMLSchema%23%3E%0D%0APREFIX+owl%3A+++%3Chttp%3A%2F%2Fwww.w3.org%2F2002%2F07%2Fowl%23%3E%0D%0APREFIX+swrl%3A++%3Chttp%3A%2F%2Fwww.w3.org%2F2003%2F11%2Fswrl%23%3E%0D%0APREFIX+swrlb%3A+%3Chttp%3A%2F%2Fwww.w3.org%2F2003%2F11%2Fswrlb%23%3E%0D%0APREFIX+vitro%3A+%3Chttp%3A%2F%2Fvitro.mannlib.cornell.edu%2Fns%2Fvitro%2F0.7%23%3E%0D%0APREFIX+bibo%3A+%3Chttp%3A%2F%2Fpurl.org%2Fontology%2Fbibo%2F%3E%0D%0APREFIX+c4o%3A+%3Chttp%3A%2F%2Fpurl.org%2Fspar%2Fc4o%2F%3E%0D%0APREFIX+cito%3A+%3Chttp%3A%2F%2Fpurl.org%2Fspar%2Fcito%2F%3E%0D%0APREFIX+dcat%3A+%3Chttp%3A%2F%2Fwww.w3.org%2Fns%2Fdcat%23%3E%0D%0APREFIX+dcosample%3A+%3Chttp%3A%2F%2Finfo.deepcarbon.net%2Fsample%2Fschema%23%3E%0D%0APREFIX+dco%3A+%3Chttp%3A%2F%2Finfo.deepcarbon.net%2Fschema%23%3E%0D%0APREFIX+dc%3A+%3Chttp%3A%2F%2Fpurl.org%2Fdc%2Felements%2F1.1%2F%3E%0D%0APREFIX+dct%3A+%3Chttp%3A%2F%2Fpurl.org%2Fdc%2Fterms%2F%3E%0D%0APREFIX+event%3A+%3Chttp%3A%2F%2Fpurl.org%2FNET%2Fc4dm%2Fevent.owl%23%3E%0D%0APREFIX+fabio%3A+%3Chttp%3A%2F%2Fpurl.org%2Fspar%2Ffabio%2F%3E%0D%0APREFIX+foaf%3A+%3Chttp%3A%2F%2Fxmlns.com%2Ffoaf%2F0.1%2F%3E%0D%0APREFIX+geo%3A+%3Chttp%3A%2F%2Faims.fao.org%2Faos%2Fgeopolitical.owl%23%3E%0D%0APREFIX+obo%3A+%3Chttp%3A%2F%2Fpurl.obolibrary.org%2Fobo%2F%3E%0D%0APREFIX+ocrer%3A+%3Chttp%3A%2F%2Fpurl.org%2Fnet%2FOCRe%2Fresearch.owl%23%3E%0D%0APREFIX+ocresd%3A+%3Chttp%3A%2F%2Fpurl.org%2Fnet%2FOCRe%2Fstudy_design.owl%23%3E%0D%0APREFIX+p.1%3A+%3Chttp%3A%2F%2Fvivoweb.org%2Fontology%2Fprovenance-support%23%3E%0D%0APREFIX+prov%3A+%3Chttp%3A%2F%2Fwww.w3.org%2Fns%2Fprov%23%3E%0D%0APREFIX+samfl%3A+%3Chttp%3A%2F%2Fdef.seegrid.csiro.au%2Fontology%2Fom%2Fsam-lite%23%3E%0D%0APREFIX+skos%3A+%3Chttp%3A%2F%2Fwww.w3.org%2F2004%2F02%2Fskos%2Fcore%23%3E%0D%0APREFIX+vcard%3A+%3Chttp%3A%2F%2Fwww.w3.org%2F2006%2Fvcard%2Fns%23%3E%0D%0APREFIX+vitro-public%3A+%3Chttp%3A%2F%2Fvitro.mannlib.cornell.edu%2Fns%2Fvitro%2Fpublic%23%3E%0D%0APREFIX+vivo%3A+%3Chttp%3A%2F%2Fvivoweb.org%2Fontology%2Fcore%23%3E%0D%0APREFIX+scires%3A+%3Chttp%3A%2F%2Fvivoweb.org%2Fontology%2Fscientific-research%23%3E%0D%0A%0D%0A%23%0D%0A%23+This+example+query+gets+20+geographic+locations%0D%0A%23+and+%28if+available%29+their+labels%0D%0A%23%0D%0ASELECT+%28COUNT%28DISTINCT+%3Fs%29+AS+%3Fcount%29%0D%0A++++++++WHERE%0D%0A++++++++%7B%0D%0A++++++++%3Fs+a+vivo%3ADataset+.%0D%0A++++++++%3Fs+vitro%3AmostSpecificType+vivo%3ADataset+.%0D%0A++++++++%7D&resultFormat=RS_JSON&rdfResultFormat=JSON-LD";
            var selector = "p.stats-count#datasets";
            setClassCount(queryUrl, selector);
            var queryUrl = "https://info.deepcarbon.net/vivo/admin/sparqlquery?query=PREFIX+rdf%3A+++%3Chttp%3A%2F%2Fwww.w3.org%2F1999%2F02%2F22-rdf-syntax-ns%23%3E%0D%0APREFIX+rdfs%3A++%3Chttp%3A%2F%2Fwww.w3.org%2F2000%2F01%2Frdf-schema%23%3E%0D%0APREFIX+xsd%3A+++%3Chttp%3A%2F%2Fwww.w3.org%2F2001%2FXMLSchema%23%3E%0D%0APREFIX+owl%3A+++%3Chttp%3A%2F%2Fwww.w3.org%2F2002%2F07%2Fowl%23%3E%0D%0APREFIX+swrl%3A++%3Chttp%3A%2F%2Fwww.w3.org%2F2003%2F11%2Fswrl%23%3E%0D%0APREFIX+swrlb%3A+%3Chttp%3A%2F%2Fwww.w3.org%2F2003%2F11%2Fswrlb%23%3E%0D%0APREFIX+vitro%3A+%3Chttp%3A%2F%2Fvitro.mannlib.cornell.edu%2Fns%2Fvitro%2F0.7%23%3E%0D%0APREFIX+bibo%3A+%3Chttp%3A%2F%2Fpurl.org%2Fontology%2Fbibo%2F%3E%0D%0APREFIX+c4o%3A+%3Chttp%3A%2F%2Fpurl.org%2Fspar%2Fc4o%2F%3E%0D%0APREFIX+cito%3A+%3Chttp%3A%2F%2Fpurl.org%2Fspar%2Fcito%2F%3E%0D%0APREFIX+dcat%3A+%3Chttp%3A%2F%2Fwww.w3.org%2Fns%2Fdcat%23%3E%0D%0APREFIX+dcosample%3A+%3Chttp%3A%2F%2Finfo.deepcarbon.net%2Fsample%2Fschema%23%3E%0D%0APREFIX+dco%3A+%3Chttp%3A%2F%2Finfo.deepcarbon.net%2Fschema%23%3E%0D%0APREFIX+dc%3A+%3Chttp%3A%2F%2Fpurl.org%2Fdc%2Felements%2F1.1%2F%3E%0D%0APREFIX+dct%3A+%3Chttp%3A%2F%2Fpurl.org%2Fdc%2Fterms%2F%3E%0D%0APREFIX+event%3A+%3Chttp%3A%2F%2Fpurl.org%2FNET%2Fc4dm%2Fevent.owl%23%3E%0D%0APREFIX+fabio%3A+%3Chttp%3A%2F%2Fpurl.org%2Fspar%2Ffabio%2F%3E%0D%0APREFIX+foaf%3A+%3Chttp%3A%2F%2Fxmlns.com%2Ffoaf%2F0.1%2F%3E%0D%0APREFIX+geo%3A+%3Chttp%3A%2F%2Faims.fao.org%2Faos%2Fgeopolitical.owl%23%3E%0D%0APREFIX+obo%3A+%3Chttp%3A%2F%2Fpurl.obolibrary.org%2Fobo%2F%3E%0D%0APREFIX+ocrer%3A+%3Chttp%3A%2F%2Fpurl.org%2Fnet%2FOCRe%2Fresearch.owl%23%3E%0D%0APREFIX+ocresd%3A+%3Chttp%3A%2F%2Fpurl.org%2Fnet%2FOCRe%2Fstudy_design.owl%23%3E%0D%0APREFIX+p.1%3A+%3Chttp%3A%2F%2Fvivoweb.org%2Fontology%2Fprovenance-support%23%3E%0D%0APREFIX+prov%3A+%3Chttp%3A%2F%2Fwww.w3.org%2Fns%2Fprov%23%3E%0D%0APREFIX+samfl%3A+%3Chttp%3A%2F%2Fdef.seegrid.csiro.au%2Fontology%2Fom%2Fsam-lite%23%3E%0D%0APREFIX+skos%3A+%3Chttp%3A%2F%2Fwww.w3.org%2F2004%2F02%2Fskos%2Fcore%23%3E%0D%0APREFIX+vcard%3A+%3Chttp%3A%2F%2Fwww.w3.org%2F2006%2Fvcard%2Fns%23%3E%0D%0APREFIX+vitro-public%3A+%3Chttp%3A%2F%2Fvitro.mannlib.cornell.edu%2Fns%2Fvitro%2Fpublic%23%3E%0D%0APREFIX+vivo%3A+%3Chttp%3A%2F%2Fvivoweb.org%2Fontology%2Fcore%23%3E%0D%0APREFIX+scires%3A+%3Chttp%3A%2F%2Fvivoweb.org%2Fontology%2Fscientific-research%23%3E%0D%0A%0D%0A%23%0D%0A%23+This+example+query+gets+20+geographic+locations%0D%0A%23+and+%28if+available%29+their+labels%0D%0A%23%0D%0A+SELECT+%28COUNT%28DISTINCT+%3Fs%29+AS+%3Fcount%29%0D%0A++++++++WHERE%0D%0A++++++++%7B%0D%0A++++++++%3Fs+a+vivo%3AProject+.%0D%0A++++++++%3Fs+vitro%3AmostSpecificType+vivo%3AProject+.%0D%0A++++++++%7D&resultFormat=RS_JSON&rdfResultFormat=JSON-LD";
            var selector = "p.stats-count#projects";
            setClassCount(queryUrl, selector);
            var queryUrl = "https://info.deepcarbon.net/vivo/admin/sparqlquery?query=PREFIX+rdf%3A+++%3Chttp%3A%2F%2Fwww.w3.org%2F1999%2F02%2F22-rdf-syntax-ns%23%3E%0D%0APREFIX+rdfs%3A++%3Chttp%3A%2F%2Fwww.w3.org%2F2000%2F01%2Frdf-schema%23%3E%0D%0APREFIX+xsd%3A+++%3Chttp%3A%2F%2Fwww.w3.org%2F2001%2FXMLSchema%23%3E%0D%0APREFIX+owl%3A+++%3Chttp%3A%2F%2Fwww.w3.org%2F2002%2F07%2Fowl%23%3E%0D%0APREFIX+swrl%3A++%3Chttp%3A%2F%2Fwww.w3.org%2F2003%2F11%2Fswrl%23%3E%0D%0APREFIX+swrlb%3A+%3Chttp%3A%2F%2Fwww.w3.org%2F2003%2F11%2Fswrlb%23%3E%0D%0APREFIX+vitro%3A+%3Chttp%3A%2F%2Fvitro.mannlib.cornell.edu%2Fns%2Fvitro%2F0.7%23%3E%0D%0APREFIX+bibo%3A+%3Chttp%3A%2F%2Fpurl.org%2Fontology%2Fbibo%2F%3E%0D%0APREFIX+c4o%3A+%3Chttp%3A%2F%2Fpurl.org%2Fspar%2Fc4o%2F%3E%0D%0APREFIX+cito%3A+%3Chttp%3A%2F%2Fpurl.org%2Fspar%2Fcito%2F%3E%0D%0APREFIX+dcat%3A+%3Chttp%3A%2F%2Fwww.w3.org%2Fns%2Fdcat%23%3E%0D%0APREFIX+dcosample%3A+%3Chttp%3A%2F%2Finfo.deepcarbon.net%2Fsample%2Fschema%23%3E%0D%0APREFIX+dco%3A+%3Chttp%3A%2F%2Finfo.deepcarbon.net%2Fschema%23%3E%0D%0APREFIX+dc%3A+%3Chttp%3A%2F%2Fpurl.org%2Fdc%2Felements%2F1.1%2F%3E%0D%0APREFIX+dct%3A+%3Chttp%3A%2F%2Fpurl.org%2Fdc%2Fterms%2F%3E%0D%0APREFIX+event%3A+%3Chttp%3A%2F%2Fpurl.org%2FNET%2Fc4dm%2Fevent.owl%23%3E%0D%0APREFIX+fabio%3A+%3Chttp%3A%2F%2Fpurl.org%2Fspar%2Ffabio%2F%3E%0D%0APREFIX+foaf%3A+%3Chttp%3A%2F%2Fxmlns.com%2Ffoaf%2F0.1%2F%3E%0D%0APREFIX+geo%3A+%3Chttp%3A%2F%2Faims.fao.org%2Faos%2Fgeopolitical.owl%23%3E%0D%0APREFIX+obo%3A+%3Chttp%3A%2F%2Fpurl.obolibrary.org%2Fobo%2F%3E%0D%0APREFIX+ocrer%3A+%3Chttp%3A%2F%2Fpurl.org%2Fnet%2FOCRe%2Fresearch.owl%23%3E%0D%0APREFIX+ocresd%3A+%3Chttp%3A%2F%2Fpurl.org%2Fnet%2FOCRe%2Fstudy_design.owl%23%3E%0D%0APREFIX+p.1%3A+%3Chttp%3A%2F%2Fvivoweb.org%2Fontology%2Fprovenance-support%23%3E%0D%0APREFIX+prov%3A+%3Chttp%3A%2F%2Fwww.w3.org%2Fns%2Fprov%23%3E%0D%0APREFIX+samfl%3A+%3Chttp%3A%2F%2Fdef.seegrid.csiro.au%2Fontology%2Fom%2Fsam-lite%23%3E%0D%0APREFIX+skos%3A+%3Chttp%3A%2F%2Fwww.w3.org%2F2004%2F02%2Fskos%2Fcore%23%3E%0D%0APREFIX+vcard%3A+%3Chttp%3A%2F%2Fwww.w3.org%2F2006%2Fvcard%2Fns%23%3E%0D%0APREFIX+vitro-public%3A+%3Chttp%3A%2F%2Fvitro.mannlib.cornell.edu%2Fns%2Fvitro%2Fpublic%23%3E%0D%0APREFIX+vivo%3A+%3Chttp%3A%2F%2Fvivoweb.org%2Fontology%2Fcore%23%3E%0D%0APREFIX+scires%3A+%3Chttp%3A%2F%2Fvivoweb.org%2Fontology%2Fscientific-research%23%3E%0D%0A%0D%0A%23%0D%0A%23+This+example+query+gets+20+geographic+locations%0D%0A%23+and+%28if+available%29+their+labels%0D%0A%23%0D%0ASELECT+%28COUNT%28DISTINCT+%3Fs%29+AS+%3Fcount%29%0D%0A++++++++WHERE%0D%0A++++++++%7B%0D%0A++++++++%3Fs+a+dco%3AFieldStudy+.%0D%0A++++++++%3Fs+vitro%3AmostSpecificType+dco%3AFieldStudy+.%0D%0A++++++++%7D&resultFormat=RS_JSON&rdfResultFormat=JSON-LD";
            var selector = "p.stats-count#field-studies";
            setClassCount(queryUrl, selector);
            var queryUrl = "https://info.deepcarbon.net/vivo/admin/sparqlquery?query=PREFIX+rdf%3A+++%3Chttp%3A%2F%2Fwww.w3.org%2F1999%2F02%2F22-rdf-syntax-ns%23%3E%0D%0APREFIX+rdfs%3A++%3Chttp%3A%2F%2Fwww.w3.org%2F2000%2F01%2Frdf-schema%23%3E%0D%0APREFIX+xsd%3A+++%3Chttp%3A%2F%2Fwww.w3.org%2F2001%2FXMLSchema%23%3E%0D%0APREFIX+owl%3A+++%3Chttp%3A%2F%2Fwww.w3.org%2F2002%2F07%2Fowl%23%3E%0D%0APREFIX+swrl%3A++%3Chttp%3A%2F%2Fwww.w3.org%2F2003%2F11%2Fswrl%23%3E%0D%0APREFIX+swrlb%3A+%3Chttp%3A%2F%2Fwww.w3.org%2F2003%2F11%2Fswrlb%23%3E%0D%0APREFIX+vitro%3A+%3Chttp%3A%2F%2Fvitro.mannlib.cornell.edu%2Fns%2Fvitro%2F0.7%23%3E%0D%0APREFIX+bibo%3A+%3Chttp%3A%2F%2Fpurl.org%2Fontology%2Fbibo%2F%3E%0D%0APREFIX+c4o%3A+%3Chttp%3A%2F%2Fpurl.org%2Fspar%2Fc4o%2F%3E%0D%0APREFIX+cito%3A+%3Chttp%3A%2F%2Fpurl.org%2Fspar%2Fcito%2F%3E%0D%0APREFIX+dcat%3A+%3Chttp%3A%2F%2Fwww.w3.org%2Fns%2Fdcat%23%3E%0D%0APREFIX+dcosample%3A+%3Chttp%3A%2F%2Finfo.deepcarbon.net%2Fsample%2Fschema%23%3E%0D%0APREFIX+dco%3A+%3Chttp%3A%2F%2Finfo.deepcarbon.net%2Fschema%23%3E%0D%0APREFIX+dc%3A+%3Chttp%3A%2F%2Fpurl.org%2Fdc%2Felements%2F1.1%2F%3E%0D%0APREFIX+dct%3A+%3Chttp%3A%2F%2Fpurl.org%2Fdc%2Fterms%2F%3E%0D%0APREFIX+event%3A+%3Chttp%3A%2F%2Fpurl.org%2FNET%2Fc4dm%2Fevent.owl%23%3E%0D%0APREFIX+fabio%3A+%3Chttp%3A%2F%2Fpurl.org%2Fspar%2Ffabio%2F%3E%0D%0APREFIX+foaf%3A+%3Chttp%3A%2F%2Fxmlns.com%2Ffoaf%2F0.1%2F%3E%0D%0APREFIX+geo%3A+%3Chttp%3A%2F%2Faims.fao.org%2Faos%2Fgeopolitical.owl%23%3E%0D%0APREFIX+obo%3A+%3Chttp%3A%2F%2Fpurl.obolibrary.org%2Fobo%2F%3E%0D%0APREFIX+ocrer%3A+%3Chttp%3A%2F%2Fpurl.org%2Fnet%2FOCRe%2Fresearch.owl%23%3E%0D%0APREFIX+ocresd%3A+%3Chttp%3A%2F%2Fpurl.org%2Fnet%2FOCRe%2Fstudy_design.owl%23%3E%0D%0APREFIX+p.1%3A+%3Chttp%3A%2F%2Fvivoweb.org%2Fontology%2Fprovenance-support%23%3E%0D%0APREFIX+prov%3A+%3Chttp%3A%2F%2Fwww.w3.org%2Fns%2Fprov%23%3E%0D%0APREFIX+samfl%3A+%3Chttp%3A%2F%2Fdef.seegrid.csiro.au%2Fontology%2Fom%2Fsam-lite%23%3E%0D%0APREFIX+skos%3A+%3Chttp%3A%2F%2Fwww.w3.org%2F2004%2F02%2Fskos%2Fcore%23%3E%0D%0APREFIX+vcard%3A+%3Chttp%3A%2F%2Fwww.w3.org%2F2006%2Fvcard%2Fns%23%3E%0D%0APREFIX+vitro-public%3A+%3Chttp%3A%2F%2Fvitro.mannlib.cornell.edu%2Fns%2Fvitro%2Fpublic%23%3E%0D%0APREFIX+vivo%3A+%3Chttp%3A%2F%2Fvivoweb.org%2Fontology%2Fcore%23%3E%0D%0APREFIX+scires%3A+%3Chttp%3A%2F%2Fvivoweb.org%2Fontology%2Fscientific-research%23%3E%0D%0A%0D%0A%23%0D%0A%23+This+example+query+gets+20+geographic+locations%0D%0A%23+and+%28if+available%29+their+labels%0D%0A%23%0D%0ASELECT+%28COUNT%28DISTINCT+%3Fpublication%29+AS+%3Fcount%29%0D%0AWHERE+%7B%0D%0A++++%7B+%3Fpublication+a+bibo%3AArticle+.+%7D%0D%0A++++UNION+%7B+%3Fpublication+a+bibo%3ABook+.+%7D%0D%0A++++UNION+%7B+%3Fpublication+a+bibo%3ADocumentPart+.+%7D%0D%0A++++UNION+%7B+%3Fpublication+a+dco%3APoster+.+%7D%0D%0A++++UNION+%7B+%3Fpublication+a+bibo%3AThesis+.+%7D%0D%0A++++%3Fpublication+dco%3AisContributionToDCO+%3FisDcoPublication+.%0D%0A++++FILTER+%28lcase%28str%28%3FisDcoPublication%29%29+%3D+%22yes%22%29%0D%0A%7D&resultFormat=RS_JSON&rdfResultFormat=JSON-LD";
            var selector = "p.stats-count#dco-publications";
            setClassCount(queryUrl, selector);

        </script>
    </head>
    
    <body class="${bodyClasses!}" onload="${bodyOnload!}">
    <#-- supplies the faculty count to the js function that generates a random row number for the solr query -->
        <@lh.facultyMemberCount  vClassGroups! />
        <#include "identity.ftl">
       
		<#-- added by Josh 10/9/2015 -->
        <#include "dcomenu.ftl">

        <section id="intro" role="region">
            <h2>${i18n().intro_title}</h2>

            <p><div class="image"><a href="${urls.base}/field-studies"><img src="${urls.theme}/images/dco-images/DCO-Field-Study-Map-Slide-copy.jpg" /></a><span class="caption">This map depicts the locations of Deep Carbon Observatory field studies. Visit <a href="${urls.base}/field-studies">the DCO Field Study page</a> for the interactive version.</span></div>${i18n().intro_para1}</span></p>
            <p>${i18n().intro_para2}</p>

        
        </section> <!-- #intro -->
       
       

        <#if geoFocusMapsEnabled >
            <!-- Map display of researchers' areas of geographic focus. Must be enabled in runtime.properties -->
            <@lh.geographicFocusHtml />
        </#if>
        
        <!-- Statistical information relating to property groups and their classes; displayed horizontally, not vertically-->
        <#--<@lh.allClassGroups vClassGroups! />-->

        <#-- Statistical information relating of entities of interest of DCO-->
        <section id="home-stats" class="home-sections" >
            <h4>${i18n().statistics}</h4>
            <ul id="stats">
                <li>
                    <a href="${urls.base}/browse">
                        <p class="stats-count" id="members">...</p>
                        <p class="stats-type" id="members">DCO Members</p>
                    </a>
                </li>
                <li>
                    <a href="${urls.base}/browse">
                        <p class="stats-count" id="dco-publications">...</p>
                        <p class="stats-type" id="dco-publications">Publications</p>
                    </a>
                </li>
                <li>
                    <a href="${urls.base}/browse">
                        <p class="stats-count" id="datasets">...</p>
                        <p class="stats-type" id="datasets">Datasets</p>
                    </a>
                </li>
                <li>
                    <a href="${urls.base}/browse">
                        <p class="stats-count" id="projects">...</p>
                        <p class="stats-type" id="projects">Projects</p>
                    </a>
                </li>
                <li>
                    <a href="${urls.base}/browse">
                        <p class="stats-count" id="field-studies">...</p>
                        <p class="stats-type" id="field-studies">Field Studies</p>
                    </a>
                </li>
            </ul>
        </section>

        <#include "footer.ftl">
        <#-- builds a json object that is used by js to render the academic departments section -->
        <@lh.listAcademicDepartments />
    <script>       
        var i18nStrings = {
            researcherString: '${i18n().researcher}',
            researchersString: '${i18n().researchers}',
            currentlyNoResearchers: '${i18n().currently_no_researchers}',
            countriesAndRegions: '${i18n().countries_and_regions}',
            countriesString: '${i18n().countries}',
            regionsString: '${i18n().regions}',
            statesString: '${i18n().map_states_string}',
            stateString: '${i18n().map_state_string}',
            statewideLocations: '${i18n().statewide_locations}',
            researchersInString: '${i18n().researchers_in}',
            inString: '${i18n().in}',
            noFacultyFound: '${i18n().no_faculty_found}',
            placeholderImage: '${i18n().placeholder_image}',
            viewAllFaculty: '${i18n().view_all_faculty}',
            viewAllString: '${i18n().view_all}',
            viewAllDepartments: '${i18n().view_all_departments}',
            noDepartmentsFound: '${i18n().no_departments_found}'
        };
        // set the 'limmit search' text and alignment
        if  ( $('input.search-homepage').css('text-align') == "right" ) {       
             $('input.search-homepage').attr("value","${i18n().limit_search} \u2192");
        }  
    </script>
    </body>
</html>