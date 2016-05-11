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
<script src="/dco-viz/js/jquery-2.1.4.js"></script>
<script src="//cdnjs.cloudflare.com/ajax/libs/d3/3.5.6/d3.min.js" charset="utf-8"></script>
<script src="/dco-viz/js/d3.layout.cloud.js"></script>
<script src="/dco-viz/js/d3pie.min.js"></script>
<script src="/dco-viz/js/visualizations.js"></script>

<style>

  text[id$=_title] {
    transform: translateY(10px);
  }

  svg {
    padding-top:10px;
    padding-bottom:10px;
    padding-right:10px;
    padding-left:0px;
  }

  #container {
    width: 500px;
    height: 320px;
  }

  #slideshow {
    position: relative;
    width: 500px;
    height: 320px;
    padding: 10px;
    box-shadow: 0 0 20px rgba(0,0,0,0.4);
  }

  .slide {
    margin: 1%;
    /*position: absolute;*/
    top: 10px;
    left: 10px;
    right: 10px;
    bottom: 10px;
  }


  #slideshow > div > iframe {
    width:500px;
    height:320px
  }

  #slideshow > div > a {
      margin: 1%;
    float: right;
  }

  #nav {
    margin: 1%;
    width: 100%;
  }

</style>
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
            <div id="container" style="position:relative;float:left;">
                <div id="nav" style="clear:both;">
                    <button id="back"><<</button>
                    <button id="pause">ll</button>
                    <button id="forward">>></button>
                </div>
                <div id="slideshow">
                    <div class="slide">
                        <div id="slide1">
                            <div class="image">
                                <a href="${urls.base}/field-studies"><img src="${urls.theme}/images/dco-images/DCO-Field-Study-Map-Slide-copy.jpg" /></a>
                                <span class="caption">This map depicts the locations of Deep Carbon Observatory field studies. Visit <a href="${urls.base}/field-studies">the DCO Field Study page</a> for the interactive version.</span>
                            </div>
                        </div>
                    </div>
                    <div class="slide">
                        <div id="slide2">
                            <script type="text/javascript">
                                expertiseWordCloud("#slide2",500,300);
                            </script>
                        </div>
                        <span class="caption">This word cloud represents keywords found in publications contributed to the DCO. Pause the slide show to examine further by clicking on one of the words. <a target="_blank" href="/dco-viz/PubWordCloud.html">Click to enlarge Cloud</a>.</span>
                    </div>
                    <div class="slide">
                        <div id="slide3">
                            <script type="text/javascript">
                                $(document).ready(function() { pubWordCloud("#slide3",500,300); })
                            </script>
                        </div>
                        <span class="caption">This word cloud represents areas of expertise of the various members of the DCO community. Pause the slide show to examine further by clicking on one of the words. <a target="_blank" href="/dco-viz/AreasWordCloud.html">Click to enlarge Cloud</a>.</span>
                    </div>
                    <div class="slide">
                        <div id="slide4">
                            <script type="text/javascript">
                                $(document).ready(function() { commPubCounts("#slide4",500,280); })
                            </script>
                        </div>
                        <span class="caption">This chart represents the number of publications per science community. Pause the slide show to examine further by click on a part of the chart and then clicking more information. <a target="_blank" href="/dco-viz/PieChartPublications.html">Click to enlarge Chart</a>.</span>
                    </div>
                    <div class="slide">
                        <div id="slide5">
                            <script type="text/javascript">
                                $(document).ready(function() { commMemberCounts("#slide5",500,280); })
                            </script>
                        </div>
                        <span class="caption">This chart represents the number of members of the DCO per science community. Pause the slide show to examine further by click on a part of the chart and then clicking more information. <a target="_blank" href="/dco-viz/PieChart.html">Click to enlarge Chart</a>.</span>
                    </div>
                    <div class="slide" id="slide6">
                        <iframe src="/dco-viz/NewMemberBarChart.php" scrolling="no"></iframe>
                        <span class="caption">This chart represents the number of new members of the DCO over a given period of time. Pause the slide show to examine further. <a target="_blank" href="/dco-viz/NewMemberBarChart.php">Click to enlarge Chart</a>.</span>
                    </div>
                    <div class="slide" id="slide7">
                        <iframe src="/dco-viz/TotalMemberTimeSeries.php" scrolling="no"></iframe>
                        <span class="caption">This chart represents the number of new members of the DCO over the life of the project. Pause the slide show to examine further. <a target="_blank" href="/dco-viz/TotalMemberTimeSeries.php">Click to enlarge Chart</a>.</span>
                    </div>
                </div> <!--slideshow-->
            </div> <!--container-->
            <div style="position:relative;float:right;width:40%;">
            <br/><br/>
            ${i18n().intro_para1}
            <br/>
            ${i18n().intro_para2}
            </div>
            </div>
        </section> <!-- #intro -->
        
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

    function slideShow() {
        var timer,obj;

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
            $('#slideshow > div:first')
                .fadeOut(100)
                .next()
                .fadeIn(100)
                .end()
                .appendTo('#slideshow');
        };
        obj.resume();
        return obj;

    }

    $("#slideshow > div:gt(0)").hide();

    var slideShow = slideShow();

    $("#forward").click(function() {

        $('#slideshow > div:first')
            .fadeOut(100)
            .next()
            .fadeIn(100)
            .end()
            .appendTo('#slideshow');

    });

    $("#back").click(function() {

        $('#slideshow > div').filter(":last")
            .fadeOut(100)
            .next()
            .fadeIn(100)
            .end()
            .prependTo('#slideshow');

        $("#slideshow > div").filter(":eq(0)").show();

        $("#slideshow > div").filter(":gt(0)").hide();

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
