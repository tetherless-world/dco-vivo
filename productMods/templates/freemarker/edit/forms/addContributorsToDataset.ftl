<#-- $This file is distributed under the terms of the license in /doc/license.txt$ -->

<#-- Custom form for adding contributors to datasets -->

<#import "lib-vivo-form.ftl" as lvf>

<#--Retrieve certain page specific information information-->
<#assign newRank = editConfiguration.pageData.newRank />
<#assign existingContributorInfo = editConfiguration.pageData.existingContributorInfo />
<#assign rankPredicate = editConfiguration.pageData.rankPredicate />

<#--If edit submission exists, then retrieve validation errors if they exist-->
<#if editSubmission?has_content && editSubmission.submissionExists = true && editSubmission.validationErrors?has_content>
	<#assign submissionErrors = editSubmission.validationErrors/>
</#if>

<#--Submission values for these fields may be returned if user did not fill out fields for new person-->
<#assign lastNameValue = lvf.getFormFieldValue(editSubmission, editConfiguration, "lastName") />
<#assign firstNameValue = lvf.getFormFieldValue(editSubmission, editConfiguration, "firstName") />
<#assign middleNameValue = lvf.getFormFieldValue(editSubmission, editConfiguration, "middleName") />
<#assign orgNameValue = lvf.getFormFieldValue(editSubmission, editConfiguration, "orgName") />



<#--UL class based on size of existing contributors-->
<#assign ulClass = ""/>
<#if (existingContributorInfo?size > 0)>
	<#assign ulClass = "class='dd'"/>
</#if>

<#assign title="<em>${editConfiguration.subjectName}</em>" />
<#assign requiredHint="<span class='requiredHint'> *</span>" />
<#assign initialHint="<span class='hint'>(${i18n().initial_okay})</span>" />

<@lvf.unsupportedBrowser urls.base/>

<h2>${title}</h2>

<#if submissionErrors?has_content>
    <section id="error-alert" role="alert" class="validationError">
        <img src="${urls.images}/iconAlert.png" width="24" height="24" alert="${i18n().error_alert_icon}" />
        <p>
        <#--below shows examples of both printing out all error messages and checking the error message for a specific field-->
        <#list submissionErrors?keys as errorFieldName>
        		  ${submissionErrors[errorFieldName]} <br/>
        </#list>
        
        </p>
    </section>
</#if>

<h3>${i18n().manage_contributors}</h3>

<ul id="contributorships" ${ulClass}>

<script type="text/javascript">
    var contributorshipData = [];
</script>


<#assign contributorHref="/individual?uri=" />
<#--This should be a list of java objects where URI and name can be retrieved-->
<#list existingContributorInfo as contributorship>
	<#assign contributorUri = contributorship.contributorUri/>
	<#assign contributorName = contributorship.contributorName/>

	<li class="contributorship">
			<#-- span.contributor will be used in the next phase, when we display a message that the contributor has been
			removed. That text will replace the a.contributorName, which will be removed. -->    
			<span class="contributor">
					<#-- This span is here to assign a width to. We can't assign directly to the a.contributorName,
					for the case when it's followed by an em tag - we want the width to apply to the whole thing. -->
					<span class="contributorNameWrapper">
							<#if (contributorUri?length > 0)>
									<span class="contributorName">${contributorName}</span>
								<#else>      
									<span class="contributorName">${contributorship.contributorshipName}</span><em> (${i18n().no_linked_contributor})</em>
							</#if>
					</span>

					<a href="${urls.base}/edit/primitiveDelete" class="remove" title="${i18n().remove_contributor_link}">${i18n().remove_capitalized}</a>
			</span>
	</li>

	<script type="text/javascript">
			contributorshipData.push({
					"contributorshipUri": "${contributorship.contributorshipUri}",
					"contributorUri": "${contributorUri}",
					"contributorName": "${contributorName}"                
			});
	</script>
</#list>

   

</ul>

<section id="showAddForm" role="region">
    <input type="hidden" name = "editKey" value="${editKey}" />
    <input type="submit" id="showAddFormButton" value="${i18n().add_contributor}" role="button" />

    <span class="or"> ${i18n().or} </span>
    <a id="returnLink" class="cancel" href="${cancelUrl}&url=/individual" title="${i18n().cancel_title}">${i18n().return_to_dataset}</a>
    <img id="indicatorOne" class="indicator hidden" alt="${i18n().processing_indicator}" src="${urls.base}/images/indicatorWhite.gif" />
</section> 

<form id="addContributorForm" action ="${submitUrl}" class="customForm noIE67">
    <h3>${i18n().add_a_contributor}</h3>

    <div style="display:inline">
        <input type="radio" name="contributorType" class="person-radio" value="" role="radio" checked style="display:inline;margin-top:20px" />
        <label class="inline" for="Person" >${i18n().person_capitalized}</label>
        <input type="radio" name="contributorType" class="org-radio" value="http://xmlns.com/foaf/0.1/Organization" role="radio" style="display:inline;margin-left:18px" />
        <label class="inline" for="Organization">${i18n().organization_capitalized}</label>
    </div>

    <section id="personFields" role="personContainer">
    		<#--These wrapper paragraph elements are important because javascript hides parent of these fields, since last name
    		should be visible even when first name/middle name are not, the parents should be separate for each field-->
    		<p class="inline">
        <label for="lastName">${i18n().last_name} <span class='requiredHint'> *</span></label>
        <input class="acSelector" size="60"  type="text" id="lastName" name="lastName" value="${lastNameValue}" role="input" />
        </p>
				
				<p class="inline">
        <label for="firstName">${i18n().first_name} ${requiredHint} ${initialHint}</label>
        <input  size="60"  type="text" id="firstName" name="firstName" value="${firstNameValue}"  role="input" />
        </p>
        
				<p class="inline">
				<label for="middleName">${i18n().middle_name} <span class='hint'>(${i18n().initial_okay})</span></label>
        <input  size="60"  type="text" id="middleName" name="middleName" value="${middleNameValue}"  role="input" />
        </p>
      
        <div id="selectedContributor" class="acSelection">
            <p class="inline">
                <label>${i18n().selected_contributor}:&nbsp;</label>
                <span class="acSelectionInfo" id="selectedContributorName"></span>
                <a href="${urls.base}/individual?uri=" id="personLink" class="verifyMatch"  title="${i18n().verify_match_capitalized}">(${i18n().verify_match_capitalized})</a>
                <input type="hidden" id="personUri" name="personUri" value=""  role="input" /> <!-- Field value populated by JavaScript -->
            </p>
        </div>
    </section>
    <section id="organizationFields" role="organization">
    		<p class="inline">
        <label for="orgName">${i18n().organization_name_capitalized} <span class='requiredHint'> *</span></label>
        <input size="38"  type="text" id="orgName" name="orgName" value="${orgNameValue}" role="input" />
        </p>
				      
        <div id="selectedOrg" class="acSelection">
            <p class="inline">
                <label>${i18n().selected_organization}:&nbsp;</label>
                <span  id="selectedOrgName"></span>
                <a href="${urls.base}/individual?uri=" id="orgLink"  title="${i18n().verify_match_capitalized}">(${i18n().verify_match_capitalized})</a>
                <input type="hidden" id="orgUri" name="orgUri" value=""  role="input" /> <!-- Field value populated by JavaScript -->
            </p>
        </div>
    </section>

    <input type="hidden" id="label" name="label" value=""  role="input" />  <!-- Field value populated by JavaScript -->


        <input type="hidden" name="rank" id="rank" value="${newRank}" role="input" />
    
        <p class="submit">
            <input type="hidden" name = "editKey" value="${editKey}" role="input" />
            <input type="submit" id="submit" value="${i18n().add_contributor}" role="button" role="input" />
            
            <span class="or"> ${i18n().or} </span>
            
            <a id="returnLink" class="cancel" href="${cancelUrl}" title="${i18n().cancel_title}">${i18n().cancel_link}</a>
            <img id="indicatorTwo" alt="${i18n().processing_indicator}" class="indicator hidden" src="${urls.base}/images/indicatorWhite.gif" />
        </p>

        <p id="requiredLegend" class="requiredHint">* ${i18n().required_fields}</p>
</form>

<script type="text/javascript">
var customFormData = {
    rankPredicate: '${rankPredicate}',
    acUrl: '${urls.base}/autocomplete?type=',
    tokenize: '&tokenize=true',
    personUrl: 'http://xmlns.com/foaf/0.1/Person',
    orgUrl: 'http://xmlns.com/foaf/0.1/Organization',
    reorderUrl: '${urls.base}/edit/reorder'
};
var i18nStrings = {
    contributorNameWrapperTitle: '${i18n().drag_drop_reorder_contributors}',
    reorderContributorsAlert: '${i18n().reordering_contributors_failed}',
    removeContributorshipMessage: '${i18n().confirm_contributor_removal}',
    removeContributorshipAlert: '${i18n().error_processing_contributor_request}',
    contributorTypeText: '${i18n().contributor_capitalized}',
    organizationTypeText: '${i18n().organization_capitalized}',
    helpTextSelect: '${i18n().select_an_existing}',
    helpTextAdd: '${i18n().or_add_new_one}'
};
</script>

${stylesheets.add('<link rel="stylesheet" href="${urls.base}/js/jquery-ui/css/smoothness/jquery-ui-1.8.9.custom.css" />',
					'<link rel="stylesheet" href="${urls.base}/templates/freemarker/edit/forms/css/customForm.css" />',
					'<link rel="stylesheet" href="${urls.base}/templates/freemarker/edit/forms/css/autocomplete.css" />',
					'<link rel="stylesheet" href="${urls.base}/templates/freemarker/edit/forms/css/addContributorsToDataset.css" />')}


${scripts.add('<script type="text/javascript" src="${urls.base}/js/jquery-ui/js/jquery-ui-1.8.9.custom.min.js"></script>')}
${scripts.add('<script type="text/javascript" src="${urls.base}/js/customFormUtils.js"></script>')}
${scripts.add('<script type="text/javascript" src="${urls.base}/js/browserUtils.js"></script>')}
${scripts.add('<script type="text/javascript" src="${urls.base}/templates/freemarker/edit/forms/js/addContributorsToDataset.js"></script>')}
