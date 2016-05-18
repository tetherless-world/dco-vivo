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
        <script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.2/jquery.min.js"></script>

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
        <#--Added by Hao 05/18/2016-->
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
                        <p class="stats-count" id="dco_publications">...</p>
                        <p class="stats-type" id="dco_publications">Publications</p>
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
                        <p class="stats-count" id="field_studies">...</p>
                        <p class="stats-type" id="field_studies">Field Studies</p>
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