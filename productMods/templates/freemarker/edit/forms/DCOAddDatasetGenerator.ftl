<#-- $This file is distributed under the terms of the license in /doc/license.txt$ -->

<form class="editForm" action="${urls.base}/DCOAddDatasetController" method="post" enctype="multipart/form-data">
    <input type="hidden" name="editKey" id="editKey" value="${editConfiguration.editKey}" role="input" />
    <input type="hidden" name="subjectUri" id="subjectUri" value="${editConfiguration.subjectUri}">
    <p>Dataset Name
    <input type="text" name="dataset-name" id="dataset-name" label="dataset name" size="30" role="input" />
    </p>
    <p>Enter URL for the file
    <input type="text" name="remote_url" id="remote_url" label="remote URL" size="30" role="input" />
    </p>
    <p>
    Or upload the file:
    <input type="file" name="file" id="file" role="input" multiple=""/>
    </p>
    <p class="submit">
        <input type="submit" id="submit" value="create" role="submit" />
        <span class="or"> or </span>
        <a title="Cancel" href="${editConfiguration.urlToReturnTo}">Cancel</a>
    </p>     
</form>
