<div id="container" style="position:relative;float:left;">
    <div id="nav" style="clear:both;">
        <button id="back"><<</button>
        <button id="pause">ll</button>
        <button id="forward">>></button>
    </div>
    <div id="slideshow">
        <div class="slide">
            <div id="image">
                <div class="image">
                    <a href="${urls.base}/field-studies"><img src="${urls.theme}/images/dco-images/DCO-Field-Study-Map-Slide-copy.jpg" /></a>
                    <span class="caption">This map depicts the locations of Deep Carbon Observatory field studies. Visit <a href="${urls.base}/field-studies">the DCO Field Study page</a> for the interactive version.</span>
                </div>
            </div>
        </div>
        <div class="slide">
            <div id="expertiseWordCloud">
            </div>
            <span class="caption">This word cloud represents areas of expertise of the various members of the DCO community. Pause the slide show to examine further by clicking on one of the words. <a href="${urls.base}/expertise-cloud">Click to enlarge Cloud</a>.</span>
        </div>
        <div class="slide">
            <div id="commMemberCounts">
            </div>
            <span class="caption">This chart represents the number of members of the DCO per science community. Pause the slide show to examine further by click on a part of the chart and then clicking more information. <a href="${urls.base}/members-pie">Click to enlarge Chart</a>.</span>
        </div>
        <div class="slide" id="barchart">
            <iframe src="/dco-viz/NewMemberBarChart.php" scrolling="no"></iframe>
            <span class="caption">This chart represents the number of new members of the DCO over a given period of time. Pause the slide show to examine further. <a href="${urls.base}/new-members-bar">Click to enlarge Chart</a>.</span>
        </div>
        <div class="slide">
            <div id="pubWordCloud">
            </div>
            <span class="caption">This word cloud represents keywords found in publications contributed to the DCO. Pause the slide show to examine further by clicking on one of the words. <a href="${urls.base}/pub-cloud">Click to enlarge Cloud</a>.</span>
        </div>
        <div class="slide">
            <div id="commPubCounts">
            </div>
            <span class="caption">This chart represents the number of publications per science community. Pause the slide show to examine further by click on a part of the chart and then clicking more information. <a href="${urls.base}/pubs-pie">Click to enlarge Chart</a>.</span>
        </div>
        <div class="slide" id="timeseries">
            <iframe src="/dco-viz/TotalMemberTimeSeries.php" scrolling="no"></iframe>
            <span class="caption">This chart represents the number of new members of the DCO over the life of the project. Pause the slide show to examine further. <a href="${urls.base}/new-members-series">Click to enlarge Chart</a>.</span>
        </div>
    </div> <!--slideshow-->
</div> <!--container-->
