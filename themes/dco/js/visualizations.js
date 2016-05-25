// Areas of Expertise Word Cloud
function expertiseWordCloud(elementId,width,height) {
    // var expertiseAreas = "/dco-viz/statsJSON/expertiseAreas.json";
    var expertiseAreas = "/dco-viz/statsJSON/expertiseAreas.json";
    var theQueryResult;
    var leaders = [];

    jQuery.ajax(
        {
            type: 'GET',
            url: expertiseAreas,
            dataType: 'json',
            success: function(data) {
                // console.log("Success in getting query result! Now continue to parse the result...");
                theQueryResult=data;
                // theQueryResult=data.expertiseAreas;
                // console.log(theQueryResult);

                for (var i=0; i<theQueryResult.results.bindings.length; i++){
                    var item = {text: theQueryResult.results.bindings[i].expertiseName.value,
                        link: theQueryResult.results.bindings[i].expertiseUri.value,
                        size: Number(theQueryResult.results.bindings[i].count.value),};
                    leaders.push(item);
                }

                var fill = d3.scale.category20();
                var layout =
                        d3.layout.cloud()
                                .size([width,height])
                                .words(leaders)
                                .padding(2)
                                // .rotate(function() { return ~~(Math.random() * 2) * 45; })
                                .rotate(function() { return 0; })
                                .font("Impact")
                                .fontSize(function(d) { return d.size; })
                                .on("end", draw);
                layout.start();
                function draw(words) {
                    d3.select(elementId).append("svg")
                        .attr("width", layout.size()[0])
                        .attr("height", layout.size()[1])
                        .attr("xmlns/:xlink", "http://www.w3.org/1999/xlink")
                        .append("g")
                        .attr("transform", "translate(" + layout.size()[0] / 2 + "," + layout.size()[1] / 2 + ")")
                        .selectAll("text")
                        .data(words)
                        .enter()
                        .append("a")
                        .attr("xlink:href", function(d) { return d.link; })
                        .attr("target", "_blank")
                        .append("text")
                        .style("font-size", function(d) { return d.size + "px"; })
                        .style("font-family", "Impact")
                        .style("fill", function(d, i) { return fill(i); })
                        .attr("text-anchor", "middle")
                        .attr("transform", function(d) {
                            return "translate(" + [d.x, d.y] + ")rotate(" + d.rotate + ")";
                        })
                        .text(function(d) { return d.text; });
                }
            }
        }
    );
}

// Publications Subject Areas Word Cloud
function pubWordCloud(elementId,width,height) {

    var subjectAreasUrl = "/dco-viz/statsJSON/subjectAreas.json";
    var theQueryResult;
    var subjectAreas = [];

    jQuery.ajax(
        {
            type: 'GET',
            url: subjectAreasUrl,
            dataType: 'json',
            success: function(data) {
                // console.log("Success in getting query result! Now continue to parse the result...");
                theQueryResult=data;
                // theQueryResult=data.subjectAreas;
                // console.log(theQueryResult);

                for (var i=0; i<theQueryResult.results.bindings.length; i++){
                    var item = {text: theQueryResult.results.bindings[i].subjectArea.value,
                        link: theQueryResult.results.bindings[i].subjectAreaUri.value,
                        size: Number(theQueryResult.results.bindings[i].count.value),};
                    subjectAreas.push(item);

                  }

                var fill = d3.scale.category20();

                var layout =
                         d3.layout.cloud()
                             .size([width,height])
                             .words(subjectAreas)
                             .padding(2)
                             .rotate(function() { return 0; })
                             .font("Impact")
                             //.fontSize(function(d) { return Math.pow(d.size,1.7); })
                             //subject area counts low so set to *10 for now
                             .fontSize(function(d) { return d.size*12 })
                             .on("end", draw);
                layout.start();

                function draw(words) {
                    d3.select(elementId).append("svg")
                        .attr("width", layout.size()[0])
                        .attr("height", layout.size()[1])
                        .attr("xmlns/:xlink", "http://www.w3.org/1999/xlink")
                        .append("g")
                        .attr("transform", "translate(" + layout.size()[0] / 2 + "," + layout.size()[1] / 2 + ")")
                        .selectAll("text")
                        .data(words)
                        .enter()
                        .append("a")
                        .attr("xlink:href", function(d) { return d.link; })
                        .attr("target", "_blank")
                        .append("text")
                        .style("font-size", function(d) { return d.size + "px"; })
                        .style("font-family", "Impact")
                        .style("fill", function(d, i) { return fill(i); })
                        .attr("text-anchor", "middle")
                        .attr("transform", function(d) {
                            return "translate(" + [d.x, d.y] + ")rotate(" + d.rotate + ")";
                        })
                        .text(function(d) { return d.text; })
                }
            }
        }
    );

}

// Publication counts by community
function commPubCounts(elementId,width,height) {

    var pubCountUrl = "/dco-viz/statsJSON/communityPubCounts.json";
    var commNumbers = [];
    var commNames = [];
    var peopleCounts = [];
    // FIXME: we need to add more colors in case there's more communities.
    var colors = [ "#0c6197", "#248838", "#e98125", "#923e99", "#00fbe4", "#eb0ddc", "#f3f10b", "#990000", "#000000", "#515151"  ];

    var button = $('<button id="moreInfoPubs">More Information</button>');

    $(elementId).append(button);

    moreInfoPubs.onclick = function()
    {
        var segment = pubsPie.getOpenSegment();
        if(segment === null)
        {
            alert("Please click on a piece of the pie, then re-click the button.");
        }
        else
        {
            var i = segment.data.num;
            var name = commNames[i];
            var publications = segment.data.value;
            // alert("The " + name + " has " + publications + " publications and " + peopleCounts[commNames[i]] + " members." );
            alert("The " + name + " has " + publications + " publications.");
        }
    };

    function openURL(link)
    {
    $.ajax({
        dataType: "json",
        url: link,
        success: function(data) {
        for(var i = 0; i < data.results.bindings.length; i++)
        {
            peopleCounts[data.results.bindings[i].dcocommname.value] = parseInt(data.results.bindings[i].number.value);
        }
        }
        });
    }


    $.ajax({
        dataType: "json",
        url: pubCountUrl,
        success: function(data) {
            // theQueryResult = data.communityPubCounts;
            theQueryResult = data;
            for(var i = 0; i < theQueryResult.results.bindings.length; i++)
            {
                updateNumbers(parseInt(theQueryResult.results.bindings[i].number.value));
                updateNames(theQueryResult.results.bindings[i].dcocommname.value);
            }

            pubsPie = generateChart(commNames, commNumbers, width);
            //Opens the people count and stores results in peopleCounts
            // openURL(pplCount)
        }
    });

    function updateNumbers(number) {
        commNumbers.push(number);
    };

    function updateNames(name) {
        commNames.push(name);
    };

    //Right now, the full names stored in commNames are not used because some are too big
    //to fit onscreen. However, they are still stored for use in other queries.
    function generateChart(commNames, commNumbers, width) {
        var json = {
            "header": {
                "title": {
                    "text": "Publications Sorted by Affiliated Community",
                    "fontSize": 24,
                    "font": "open sans"
                },
                "titleSubtitlePadding": 9
            },
            "size": {
                "canvasWidth": width,
                "canvasHeight": height,
                "pieInnerRadius": "35%",
                "pieOuterRadius": "100%"
            },
            "data": {
                "content": [
                ]
            },
            "labels": {
                "outer": {
                    "pieDistance": 32
                },
                "inner": {
                    "hideWhenLessThanPercentage": 3
                },
                "mainLabel": {
                    "fontSize": 11
                },
                "percentage": {
                    "color": "#ffffff",
                    "decimalPlaces": 1
                },
                "value": {
                    "color": "#adadad",
                    "fontSize": 11
                },
                "lines": {
                    "enabled": true
                },
                "truncation": {
                    "enabled": true
                }
            },
            "effects": {
                "pullOutSegmentOnClick": {
                    "effect": "linear",
                    "speed": 400,
                    "size": 16
                }
            },
            "misc": {
                "gradient": {
                    "enabled": true,
                    "percentage": 100
                }
            }
        };

        // we now have the basic structure and can add the data returned from the first query
        for( var i = 0; i < commNames.length; i++ )
        {
            json.data.content.push( {
                "label": commNames[i],
                "value": commNumbers[i],
                "color": colors[i],
                "num": i
            } );
        }

        return new d3pie(elementId,json);
    };
}

// Member counts by community
function commMemberCounts(elementId,width,height) {
    var commNumbers = [];
    var commNames = [];
    var publicationCounts = [];


    // FIXME: we need to add more colors in case there's more communities.
    var colors = [ "#0c6197", "#248838", "#e98125", "#923e99", "#00fbe4", "#eb0ddc", "#f3f10b", "#990000", "#000000", "#515151"  ];

    var button = $('<button id="moreInfoMembers">More Information</button>');
    $(elementId).append(button);

    moreInfoMembers.onclick = function()
    {
    	var segment = membersPie.getOpenSegment();
    	if(segment === null)
    	{
    		alert("Please click on a piece of the pie, then re-click the button.");
    	}
    	else
    	{
    		var i = segment.data.num;
    		var name = commNames[i];
    		var members = segment.data.value;
    		alert("The " + name + " has " + members + " members and " + publicationCounts[commNames[i]] + " publications." );
    	}
    };

    function openURL(link) {
    $.ajax({
    	dataType: "json",
    	url: link,
    	success: function(data) {
    	for(var i = 0; i < data.results.bindings.length; i++)
    	{
            // we know the dcocommname from the first query that grabs member counts for the communities
            // so we can use key/value paris in publicationCounts to store the number of publications
            // for that community. This is instead of relying on ordering of the second query results to be
            // the same as the first query results.
    		publicationCounts[data.results.bindings[i].dcocommname.value] = parseInt(data.results.bindings[i].number.value);
    	}
    	}
    	});
    }

    $.ajax({
    	dataType: "json",
        // url: "/dco-viz/statsJSON/dcoStats.json",
        url: "/dco-viz/statsJSON/communityMemberCounts1.json",
        //url: 'https://info.deepcarbon.net/vivo/admin/sparqlquery?query=PREFIX+rdfs%3A++%3Chttp%3A%2F%2Fwww.w3.org%2F2000%2F01%2Frdf-schema%23%3E%0D%0APREFIX+dco%3A+%3Chttp%3A%2F%2Finfo.deepcarbon.net%2Fschema%23%3E%0D%0APREFIX+foaf%3A+%3Chttp%3A%2F%2Fxmlns.com%2Ffoaf%2F0.1%2F%3E%0D%0APREFIX+obo%3A+%3Chttp%3A%2F%2Fpurl.obolibrary.org%2Fobo%2F%3E%0D%0APREFIX+vivo%3A+%3Chttp%3A%2F%2Fvivoweb.org%2Fontology%2Fcore%23%3E%0D%0A%0D%0A%23This+query+gets+the+names+of+each+DCO+community+and+counts+the+number+of+users+in+%0D%0A%23each+community%0D%0ASELECT+%3Fdcocommname+%28COUNT%28%3Fuser%29+as+%3Fnumber%29+WHERE%0D%0A%7B%0D%0A++++%3Fuser+a+foaf%3APerson+.%0D%0A+++++%3Fuser+%3Chttp%3A%2F%2Fvivo.mydomain.edu%2Fns%23networkId%3E+%3FnetID+.%0D%0A+++++%3Fuser+obo%3ARO_0000053+%3Fcommrole+.%0D%0A+++++%3Fcommrole+a+vivo%3AMemberRole+.%0D%0A++++OPTIONAL+%7B+%3Fcommrole+vivo%3AdateTimeINterval+%3Finterval+.%0D%0A+++++++++++++++++++++++++%3Finterval+vivo%3Aend+%3Fend+.+%7D%0D%0A++++FILTER%28%21BOUND%28%3Fend%29%29%0D%0A++++%3Fcommrole+vivo%3AroleContributesTo+%3Fdco_community+.%0D%0A++++%3Fdco_community+a+dco%3AResearchCommunity+.%0D%0A++++%3Fdco_community+rdfs%3Alabel+%3Fdcocommname+.%0D%0A%7D%0D%0AGROUP+BY+%3Fdcocommname%0D%0A&resultFormat=RS_JSON&rdfResultFormat=RDF%2FXML-ABBREV',
    	success: function(data) {
            // theQueryResult = data.communityMemberCounts1;
            theQueryResult = data;
            // console.log(theQueryResult);

    		for(var i = 0; i < theQueryResult.results.bindings.length; i++)
    		{
    			updateNumbers(parseInt(theQueryResult.results.bindings[i].number.value));
    			updateNames(theQueryResult.results.bindings[i].dcocommname.value);
    		}

    		membersPie = generateChart(commNames,commNumbers,width);
    		//Opens the publication count first and stores results in publicationCounts
            openURL("dco-viz/statsJSON/communityMemberCounts2.json");
            //openURL("https://info.deepcarbon.net/vivo/admin/sparqlquery?query=PREFIX+rdfs%3A++%3Chttp%3A%2F%2Fwww.w3.org%2F2000%2F01%2Frdf-schema%23%3E%0D%0APREFIX+dco%3A+%3Chttp%3A%2F%2Finfo.deepcarbon.net%2Fschema%23%3E%0D%0APREFIX+bibo%3A+%3Chttp%3A%2F%2Fpurl.org%2Fontology%2Fbibo%2F%3E%0D%0A%0D%0A%23%0D%0A%23Counts+the+number+of+publications+on+the+DCO+website%0D%0A%23Sorts+the+publications+by+DCO+community%0D%0A%23%0D%0ASELECT+%3Fdcocommname+%28COUNT%28%3Fpublication%29+as+%3Fnumber%29+WHERE%0D%0A%7B%0D%0A%7B+%3Fpublication+a+bibo%3AArticle+.+%7D+%0D%0AUNION+%7B+%3Fpublication+a+bibo%3ABook+.+%7D+%0D%0AUNION+%7B+%3Fpublication+a+bibo%3ADocumentPart+.+%7D+%0D%0AUNION+%7B+%3Fpublication+a+dco%3APoster+.+%7D+%0D%0AUNION+%7B+%3Fpublication+a+bibo%3AThesis+.+%7D%0D%0A%3Fpublication+dco%3AassociatedDCOCommunity+%3Fdcocomm.%0D%0A%3Fdcocomm+rdfs%3Alabel+%3Fdcocommname.%0D%0A%7D%0D%0AGROUP+BY+%3Fdcocommname&resultFormat=RS_JSON&rdfResultFormat=RDF%2FXML-ABBREV");
    	}
    });

    function updateNumbers(number) {
    	commNumbers.push(number);
    };

    function updateNames(name) {
    	commNames.push(name);
    };

    //Right now, the full names stored in commNames are not used because some are too big
    //to fit onscreen. However, they are still stored for use in other queries.
    function generateChart(commNames, commNumbers, width) {
        var json = {
    		"header": {
    			"title": {
    				"text": "Members Sorted by Affiliated Community",
    				"fontSize": 24,
    				"font": "open sans"
    			},
                "titleSubtitlePadding": 1
    		},
    		"size": {
    			"canvasWidth": width,
                "canvasHeight": height,
    			"pieInnerRadius": "35%",
    			"pieOuterRadius": "100%"
    		},
    		"data": {
    			"sortOrder": "label-desc",
    			"content": [
    			]
    		},
    		"labels": {
    			"outer": {
    				"pieDistance": 32
    			},
    			"inner": {
    				"hideWhenLessThanPercentage": 3
    			},
    			"mainLabel": {
    				"fontSize": 11
    			},
    			"percentage": {
    				"color": "#ffffff",
    				"decimalPlaces": 1
    			},
    			"value": {
    				"color": "#adadad",
    				"fontSize": 11
    			},
    			"lines": {
    				"enabled": true
    			},
    			"truncation": {
    				"enabled": false
    			}
    		},
    		"effects": {
    			"pullOutSegmentOnClick": {
    				"effect": "linear",
    				"speed": 400,
    				"size": 16
    			}
    		},
    		"misc": {
    			"gradient": {
    				"enabled": true,
    				"percentage": 100
    			}
    		}
        };

        // we now have the basic structure and can add the data returned from the first query
        for( var i = 0; i < commNames.length; i++ )
        {
            json.data.content.push( {
                "label": commNames[i],
                "value": commNumbers[i],
                "color": colors[i],
                "num": i
            } );
        }

        return new d3pie(elementId,json);
    };

}
