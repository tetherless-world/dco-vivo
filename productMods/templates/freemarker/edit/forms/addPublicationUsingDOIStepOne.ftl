<#-- $This file is distributed under the terms of the license in /doc/license.txt$ -->

<#import "lib-vivo-form.ftl" as lvf>

<#assign metadata = metadata>

<h2>Imported Metadata for Publication DOI: ${doi}</h2>
<br/>
<span style="font-size:9pt;border:1px solid;margin:10px 0px;padding:15px 10px 15px 10px;background-color:#FEEFB3;"><span style="color:red;">NOTE ON AUTHORS</span>: Please use the dropdowns to select an existing author if available. Creating a new one might introduce duplication.</span>
<br/><br/>
<section id="addPublicationToPerson" role="region">

<form id="addpublicationToPersonUsingDOIStageTwo" class="customForm noIE67" action="${urls.base}/addPublicationUsingDOIStepTwo" role="add publication">
	<p>
		<label for="typeSelector">Publication Type (required)</label>
		<select id="typeSelector" name="pubType" acGroupName="publication">
             <option value="" selected="selected">Select one</option>
             <#list pubTypes?keys as key>
                 <option value="${key}">${pubTypes[key]}</option>
             </#list>
        </select>
    </p>
	<p>
		<label for="title">Title</label>
		<#if metadata.titles?has_content>
			<select id="titleSelector" name="title" acGroup="publication">
				<#list metadata.titles as title>
					<option value="${title}">${title}</option>
				</#list>
			</select>
		<#else>
			<input class="acSelector" size="100"  type="text" id="title" name="title" acGroupName="publication" value="" />
		</#if>
	</p>
	<p>
		<label for="pubYear">Publication Year</label>
		<#if metadata.publicationYears?has_content>
			<select id="pubYearSelector" name="pubYear" acGroup="publication">
				<#list metadata.publicationYears as year>
					<option value="${year?c}">${year?c}</option>
				</#list>
			</select>
		<#else>
			<input class="acSelector" size="4"  type="text" id="pubYear" name="pubYear" acGroupName="publication" value="" />
		</#if>
	</p>
	<#if metadata.authors?has_content>
		<p>
			<label for="author">Authors</label>
			<#list metadata.authors as author>
				<select id="authorSelector" name="author-${author_index+1}" order=${author_index+1} acGroupName="publication">
					<#if author.uri?has_content>
						<option value="${author.uri}">${author.family}, ${author.given}</option>
					<#else>
						<option value="${author.family}, ${author.given}">${author.family}, ${author.given} (create this entry in VIVO)</option>
					</#if>
					<#if author.matching?has_content>
						<#list author.matching as matching>
							<option value="${matching.uri}">${matching.label}</option>
						</#list>
					</#if>
				</select>
				<#if author_has_next><br/></#if>
			</#list>
		</p>
	</#if>
	<#if metadata.venue?has_content>
		<p>
			<label for="venue">Venue</label>
			<select id="venueSelector" name="venue" acGroup="publication">
				<#if metadata.venue.uri?has_content>
					<option value="${metadata.venue.uri}">${metadata.venue.label}</option>
				<#else>
					<option value="${metadata.venue.label}">${metadata.venue.label} (create this entry in VIVO)</option>
				</#if>
				<#if metadata.venue.matching?has_content>
					<#list metadata.venue.matching as matching>
						<option value="${matching.uri}">${matching.label}</option>
					</#list>
				</#if>
			</select>
		</p>
		<p>
		<label for="typeSelector">Venue Type (required if "Venue" is filled)</label>
		<select id="typeSelector" name="venueType" acGroupName="publication">
             <option value="" selected="selected">Select one</option>
             <#list venueTypes?keys as key>
                 <option value="${key}">${venueTypes[key]}</option>
             </#list>
        </select>
    </p>
	</#if>
    <p>
		<label for="volume">Volume</label>
		<#if metadata.volume?has_content>
			<input class="doitext" size="100"  type="text" id="volume" name="volume" acGroupName="publication" value="${volume}" />
		<#else>
			<input class="doitext" size="100"  type="text" id="volume" name="volume" acGroupName="publication" value="" />
		</#if>
	</p>
    <p>
		<label for="issue">Issue</label>
		<#if metadata.issue?has_content>
			<input class="doitext" size="100"  type="text" id="issue" name="issue" acGroupName="publication" value="${issue}" />
		<#else>
			<input class="doitext" size="100"  type="text" id="issue" name="issue" acGroupName="publication" value="" />
		</#if>
	</p>
	<p>
		<input type="hidden" name="doi" value="${doi}"/>
		<input type="submit" id="submit" value="Create an entry with these metadata"/>
	</p>
</form>
