<#-- $This file is distributed under the terms of the license in /doc/license.txt$ -->

<#--Breaking this out so this can be utilized by other pages such as the jsp advanced tools pages-->

<section id="searchbox" role="region">
    <fieldset>
        <legend>${i18n().search_form}</legend>

        <form id="search-form" action="${urls.search}" name="search" role="search" accept-charset="UTF-8" method="POST"> 
            <div id="search-field">
                <input type="text" name="querytext" value="Search" title="Enter the terms you wish to search for." class="form-text" onfocus="if (this.value == 'Search') {this.value = '';}" onblur="if (this.value == '') {this.value = 'Search';}" value="value" id="edit-search-theme-form-1" class="search-vivo"  autocapitalize="off"  />
                <input type="submit" class="form-submit" value="&#187;" class="search">
            </div>
        </form>
    </fieldset>
</section>
        