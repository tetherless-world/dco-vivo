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
          <link rel="stylesheet" href="/vivo/themes/dco/css/slideshow.css" />
          <script type="text/javascript" src="${urls.base}/js/homePageUtils.js?version=x"></script>
          <script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.2/jquery.min.js"></script>
          <!--<script src="/vivo/themes/dco/js/jquery-2.1.4.js"></script>-->
          <script src="//cdnjs.cloudflare.com/ajax/libs/d3/3.5.6/d3.min.js" charset="utf-8"></script>
          <script src="/vivo/themes/dco/js/d3.layout.cloud.js"></script>
          <script src="/vivo/themes/dco/js/d3pie.min.js"></script>
          <script src="/vivo/themes/dco/js/visualizations.js"></script>
          <script src="/vivo/themes/dco/js/stats.js"></script>

              </head>
              <body class="${bodyClasses!}" onload="${bodyOnload!}">
                 <#-- supplies the faculty count to the js function that generates a random row number for the solr query -->
                     <@lh.facultyMemberCount  vClassGroups! />
                     <#include "identity.ftl">

                             <#-- added by Josh 10/9/2015 -->
                     <#include "dcomenu.ftl">

                     <section id="intro" role="region">
                         <h2>${i18n().intro_title}</h2>

                         <div style="display:block;">
                         <#include "page-home-slideshow.ftl">
                         <div style="position:relative;float:right;width:40%;">
                         <br/><br/>
                         ${i18n().intro_para1}
                         <br/>
                         ${i18n().intro_para2}
                         </div>
                         </div>
                     </section> <!-- #intro -->


                     <#if geoFocusMapsEnabled >
                         <!-- Map display of researchers' areas of geographic focus. Must be enabled in runtime.properties -->
                         <@lh.geographicFocusHtml />
                     </#if>

                     <!-- Statistical information relating to property groups and their classes; displayed horizontally, not vertically-->
                     <#--<@lh.allClassGroups vClassGroups! />-->

                     <#-- Statistical information relating of entities of interest of DCO-->
                     <#include "page-home-stats.ftl">

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
                        <script type="text/javascript">
                            interval=1;
                            function drawChart(chartType) {
                                switch (chartType) {
                                    case "expertiseWordCloud":
                                        expertiseWordCloud("#expertiseWordCloud",500,270);
                                        break;
                                    case "pubWordCloud":
                                        pubWordCloud("#pubWordCloud",500,270);
                                        break;
                                    case "commPubCounts":
                                        commPubCounts("#commPubCounts",500,270);
                                        break;
                                    case "commMemberCounts":
                                        commMemberCounts("#commMemberCounts",500,270);
                                        break;

                                    default:

                                }
                            }

                            function slideShow() {
                                var timer,obj;

                                var elementId = $('#slideshow > div:first > div').attr('id');
                                if ( elementId != 'iframe' ) {

                                    drawChart(elementId);
                                }

                                $("#slideshow > div").filter(":gt(0)").hide();

                                $("#slideshow > div").filter(":eq(0)").show();

                                obj = {}
                                obj.resume = function() {
                                    timerOn = true;
                                    timer =
                                        setInterval(obj.step, 7000);
                                };

                                obj.pause = function() {
                                    clearInterval(timer);
                                };

                                obj.step = function() {
                                    interval++;

                                    $('#slideshow > div:first')
                                        .hide()
                                        .next()
                                        .fadeIn(100)
                                        .end()
                                        .appendTo('#slideshow');

                                    var elementId = $('#slideshow > div:first > div').attr('id');

                                    if ( elementId != 'iframe' && interval < 7 ) {

                                        drawChart(elementId);
                                    }
                                };

                                obj.resume();

                                return obj;

                            }

                            var slideShow = slideShow();

                            $("#forward").click(function() {
                                slideShow.pause();
                                slideShow.step();
                                slideShow.resume();
                            });


                            $("#back").click(function() {
                                slideShow.pause();
                                $('#slideshow > div').filter(":last")
                                    .hide()
                                    .next()
                                    .fadeIn(100)
                                    .end()
                                    .prependTo('#slideshow');

                                $("#slideshow > div").filter(":eq(0)").show();
                                $("#slideshow > div").filter(":gt(0)").hide();

                                slideShow.resume();
                            });

                            $("#pause").click(function() {

                                if ($("#pause").text() == "ll") {

                                    console.log('ll');
                                    slideShow.pause();
                                    $("#pause").html(">");
                                } else {
                                    console.log('>');
                                    slideShow.resume();
                                    $("#pause").html("ll");
                                }
                            });
                    </script>

                    </html>

