<#-- $This file is distributed under the terms of the license in /doc/license.txt$ -->

<#-- Custom form for adding creators to datasets -->

<#import "lib-vivo-form.ftl" as lvf>

<#--Retrieve certain page specific information information-->
<#assign newRank = editConfiguration.pageData.newRank />
<#assign existingCreatorInfo = editConfiguration.pageData.existingCreatorInfo />
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



<#--UL class based on size of existing creators-->
<#assign ulClass = ""/>
<#if (existingCreatorInfo?size > 0)>
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

<h3>${i18n().manage_creators}</h3>

<ul id="creatorships" ${ulClass}>

<script type="text/javascript">
    var creatorshipData = [];
</script>


<#assign creatorHref="/individual?uri=" />
<#--This should be a list of java objects where URI and name can be retrieved-->
<#list existingCreatorInfo as creatorship>
	<#assign creatorUri = creatorship.creatorUri/>
	<#assign creatorName = creatorship.creatorName/>

	<li class="creatorship">
			<#-- span.creator will be used in the next phase, when we display a message that the creator has been
			removed. That text will replace the a.creatorName, which will be removed. -->    
			<span class="creator">
					<#-- This span is here to assign a width to. We can't assign directly to the a.creatorName,
					for the case when it's followed by an em tag - we want the width to apply to the whole thing. -->
					<span class="creatorNameWrapper">
							<#if (creatorUri?length > 0)>
									<span class="creatorName">${creatorName}</span>
								<#else>      
									<span class="creatorName">${creatorship.creatorshipName}</span><em> (${i18n().no_linked_creator})</em>
							</#if>
					</span>

					<a href="${urls.base}/edit/primitiveDelete" class="remove" title="${i18n().remove_creator_link}">${i18n().remove_capitalized}</a>
			</span>
	</li>

	<script type="text/javascript">
			creatorshipData.push({
					"creatorshipUri": "${creatorship.creatorshipUri}",
					"creatorUri": "${creatorUri}",
					"creatorName": "${creatorName}"                
			});
	</script>
</#list>

   

</ul>

<section id="showAddForm" role="region">
    <input type="hidden" name = "editKey" value="${editKey}" />
    <input type="submit" id="showAddFormButton" value="${i18n().add_creator}" role="button" />

    <span class="or"> ${i18n().or} </span>
    <a id="returnLink" class="cancel" href="${cancelUrl}&url=/individual" title="${i18n().cancel_title}">${i18n().return_to_dataset}</a>
    <img id="indicatorOne" class="indicator hidden" alt="${i18n().processing_indicator}" src="${urls.base}/images/indicatorWhite.gif" />
</section> 

<form id="addCreatorForm" action ="${submitUrl}" class="customForm noIE67">
    <h3>${i18n().add_a_creator}</h3>

    <div style="display:inline">
        <input type="radio" name="creatorType" class="person-radio" value="" role="radio" checked style="display:inline;margin-top:20px" />
        <label class="inline" for="Person" >${i18n().person_capitalized}</label>
        <input type="radio" name="creatorType" class="org-radio" value="http://xmlns.com/foaf/0.1/Organization" role="radio" style="display:inline;margin-left:18px" />
        <label class="inline" for="Organization">${i18n().organization_capitalized}</label>
    </div>

    <section id="personFields" role="personContainer">
    		<#--These wrapper paragraph elements are important because javascript hides parent of these fields, since last name
    		should be visible even when first name/middle name are not, the parents should be separate for each field-->
    		<p class="inline">
        <label for="lastName">${i18n().last_name} <span class='requiredHint'> *</span></label>
        <input class="acSelector" size="35"  type="text" id="lastName" name="lastName" value="${lastNameValue}" role="input" />
        </p>
				
				<p class="inline">
        <label for="firstName">${i18n().first_name} ${requiredHint} ${initialHint}</label>
        <input  size="20"  type="text" id="firstName" name="firstName" value="${firstNameValue}"  role="input" />
        </p>
        
				<p class="inline">
				<label for="middleName">${i18n().middle_name} <span class='hint'>(${i18n().initial_okay})</span></label>
        <input  size="20"  type="text" id="middleName" name="middleName" value="${middleNameValue}"  role="input" />
        </p>
      
        <div id="selectedCreator" class="acSelection">
            <p class="inline">
                <label>${i18n().selected_creator}:&nbsp;</label>
                <span class="acSelectionInfo" id="selectedCreatorName"></span>
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
            <input type="submit" id="submit" value="${i18n().add_creator}" role="button" role="input" />
            
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
    creatorNameWrapperTitle: '${i18n().drag_drop_reorder_creators}',
    reorderCreatorsAlert: '${i18n().reordering_creators_failed}',
    removeCreatorshipMessage: '${i18n().confirm_creator_removal}',
    removeCreatorshipAlert: '${i18n().error_processing_creator_request}',
    creatorTypeText: '${i18n().creator_capitalized}',
    organizationTypeText: '${i18n().organization_capitalized}',
    helpTextSelect: '${i18n().select_an_existing}',
    helpTextAdd: '${i18n().or_add_new_one}'
};
</script>

${stylesheets.add('<link rel="stylesheet" href="${urls.base}/js/jquery-ui/css/smoothness/jquery-ui-1.8.9.custom.css" />',
					'<link rel="stylesheet" href="${urls.base}/templates/freemarker/edit/forms/css/customForm.css" />',
					'<link rel="stylesheet" href="${urls.base}/templates/freemarker/edit/forms/css/autocomplete.css" />',
					'<link rel="stylesheet" href="${urls.base}/templates/freemarker/edit/forms/css/addCreatorsToDataset.css" />')}


${scripts.add('<script type="text/javascript" src="${urls.base}/js/jquery-ui/js/jquery-ui-1.8.9.custom.min.js"></script>')}
${scripts.add('<script type="text/javascript" src="${urls.base}/js/customFormUtils.js"></script>')}
${scripts.add('<script type="text/javascript" src="${urls.base}/js/browserUtils.js"></script>')}
${scripts.add('<script type="text/javascript" src="${urls.base}/templates/freemarker/edit/forms/js/addCreatorsToDataset.js"></script>')}
