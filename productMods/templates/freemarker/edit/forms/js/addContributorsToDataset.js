/* $This file is distributed under the terms of the license in /doc/license.txt$ */

var addContributorForm = {

    /* *** Initial page setup *** */
   
    onLoad: function() {
        
        if (this.disableFormInUnsupportedBrowsers()) {
            return;
        }        
        this.mixIn();
        this.initObjects();                 
        this.initPage();       
    },

    disableFormInUnsupportedBrowsers: function() {       
        var disableWrapper = $('#ie67DisableWrapper');
        
        // Check for unsupported browsers only if the element exists on the page
        if (disableWrapper.length) {
            if (vitro.browserUtils.isIELessThan8()) {
                disableWrapper.show();
                $('.noIE67').hide();
                return true;
            }
        }            
        return false;      
    },
        
    mixIn: function() {
        // Mix in the custom form utility methods
        $.extend(this, vitro.customFormUtils);
        
        // Get the custom form data from the page
        $.extend(this, customFormData);

        // Get the i18n variables from the page
        $.extend(this, i18nStrings);
    },
    
    // On page load, create references for easy access to form elements.
    // NB These must be assigned after the elements have been loaded onto the page.
    initObjects: function() {
        
        this.form = $('#addContributorForm');
        this.showFormButtonWrapper = $('#showAddForm');
        this.showFormButton = $('#showAddFormButton');
        this.removeContributorshipLinks = $('a.remove');
        //this.undoLinks = $('a.undo');
        this.submit = this.form.find(':submit');
        this.cancel = this.form.find('.cancel'); 
        this.acSelector = this.form.find('.acSelector');
        this.labelField = $('#label');
        this.firstNameField = $('#firstName');
        this.middleNameField = $('#middleName');
        this.lastNameField = $('#lastName');
        this.lastNameLabel = $('label[for=lastName]');
        this.personUriField = $('#personUri');
        this.firstNameWrapper = this.firstNameField.parent();
        this.middleNameWrapper = this.middleNameField.parent();
        this.lastNameWrapper = this.lastNameField.parent();
        this.selectedContributor = $('#selectedContributor');
        this.selectedContributorName = $('#selectedContributorName');
        this.acHelpTextClass = 'acSelectorWithHelpText';
        this.verifyMatch = this.form.find('.verifyMatch');  
        this.personRadio = $('input.person-radio');  
        this.orgRadio = $('input.org-radio');
        this.personSection = $('section#personFields');  
        this.orgSection = $('section#organizationFields');  
        this.orgName = $('input#orgName');
        this.orgNameWrapper = this.orgName.parent();
        this.orgUriField = $('input#orgUri');
        this.selectedOrg = $('div#selectedOrg');
        this.selectedOrgName = $('span#selectedOrgName');
        this.orgLink = $('a#orgLink');
        this.personLink = $('a#personLink');
        this.returnLink = $('a#returnLink');
        
        this.orgSection.hide();
    },
    
    // Initial page setup. Called only at page load.
    initPage: function() {

        this.initContributorshipData();
            
        // Show elements hidden by CSS for the non-JavaScript-enabled version.
        // NB The non-JavaScript version of this form is currently not functional.
        this.removeContributorshipLinks.show();
        
        //this.undoLinks.hide();
        
        this.bindEventListeners();
        
        this.initAutocomplete();
        
        this.initElementData();

        this.initContributorDD();
        
        if (this.findValidationErrors()) {
            this.initFormAfterInvalidSubmission();
        } else {
            this.initContributorListOnlyView();
        }
    },
    
    
    /* *** Set up the various page views *** */
   
   // This initialization is done only on page load, not when returning to contributor list only view 
   // after hitting 'cancel.'
   initContributorListOnlyView: function() {
       
        if ($('.contributorship').length) {  // make sure we have at least one contributor
            // Reorder contributors on page load so that previously unranked contributors get a rank. Otherwise,
            // when we add a new contributor, it will get put ahead of any previously unranked contributors, instead
            // of at the end of the list. (It is also helpful to normalize the data before we get started.)            
            this.reorderContributors();
        }        
        this.showContributorListOnlyView();       
   },
    
    // This view shows the list of existing contributors and hides the form.
    // There is a button to show the form. We do this on page load, and after
    // hitting 'cancel' from full view.
    showContributorListOnlyView: function() {
        this.hideForm();
        this.showFormButtonWrapper.show();
    },

    // View of form after returning from an invalid submission. On this form,
    // validation errors entail that we were entering a new person, so we show
    // all the fields straightaway.
    initFormAfterInvalidSubmission: function() {
        this.initForm();
        this.showFieldsForNewPerson();
    },

    // Initial view of add contributor form. We get here by clicking the show form button,
    // or by cancelling out of an autocomplete selection.
    initFormView: function() {
        
        this.initForm();
        
        // There's a conflict bewteen the last name fields .blur event and the cancel
        // button's click. So display the middle and first names along with the last name tlw72
        //this.hideFieldsForNewPerson();

        // This shouldn't be needed, because calling this.hideFormFields(this.lastNameWrapper)
        // from showSelectedContributor should do it. However, it doesn't work from there,
        // or in the cancel action, or if referring to this.lastNameField. None of those work,
        // however.
        $('#lastName').val(''); 
        // Set the initial autocomplete help text in the acSelector field.
        this.addAcHelpText(this.acSelector);
        
        return false; 
        
    },
    
    // Form initialization common to both a 'clean' form view and when
    // returning from an invalid submission.
    initForm: function() {
        
        // Hide the button that shows the form
        this.showFormButtonWrapper.hide(); 

        this.hideSelectedPerson();
        this.hideSelectedOrg();

        this.cancel.unbind('click');
        this.cancel.bind('click', function() {
            addContributorForm.showContributorListOnlyView();
            addContributorForm.setContributorType("person");
            return false;
        });
        
        // Reset the last name field. It had been hidden if we selected an contributor from
        // the autocomplete field.
        this.lastNameWrapper.show(); 
        this.showFieldsForNewPerson();        

        // Show the form
        this.form.show();                 
        //this.lastNameField.focus();
    },   
    
    hideSelectedPerson: function() {
        this.selectedContributor.hide();
        this.selectedContributorName.html('');
        this.personUriField.val('');
    },

    hideSelectedOrg: function() {
        this.selectedOrg.hide();
        this.selectedOrgName.html('');
        this.orgUriField.val('');
    },

    showFieldsForNewPerson: function() {    
        this.firstNameWrapper.show();
        this.middleNameWrapper.show();
    },

    hideFieldsForNewPerson: function() {   
        this.hideFields(this.firstNameWrapper); 
        this.hideFields(this.middleNameWrapper); 
    },
        
    /* *** Ajax initializations *** */

    /* Autocomplete */
    initAutocomplete: function() {

        // Make cache a property of this so we can access it after removing 
        // an contributor.
        this.acCache = {};  
        this.setAcFilter();
        var $acField;
        var urlString;
        var contributorType;
        
        if  ( this.personRadio.attr("checked") ) {
            $acField = this.lastNameField;
            urlString = addContributorForm.acUrl + addContributorForm.personUrl + addContributorForm.tokenize;
            contributorType = "person";
        }
        else {
            $acField = this.orgName;
            urlString = addContributorForm.acUrl + addContributorForm.orgUrl + addContributorForm.tokenize;
            contributorType = "org";
        }  
        $acField.autocomplete({
            minLength: 2,
            source: function(request, response) {
                if (request.term in addContributorForm.acCache) {
                    // console.log('found term in cache');
                    response(addContributorForm.acCache[request.term]);
                    return;
                }
                // console.log('not getting term from cache');
                
                // If the url query params are too long, we could do a post
                // here instead of a get. Add the exclude uris to the data
                // rather than to the url.
                $.ajax({
                    url: urlString,
                    dataType: 'json',
                    data: {
                        term: request.term
                    }, 
                    complete: function(xhr, status) {
                        // Not sure why, but we need an explicit json parse here. jQuery
                        // should parse the response text and return a json object.
                        var results = jQuery.parseJSON(xhr.responseText),
                            filteredResults = addContributorForm.filterAcResults(results);
                        addContributorForm.acCache[request.term] = filteredResults;  
                        response(filteredResults);
                    }

                });
            },
            // Select event not triggered in IE6/7 when selecting with enter key rather
            // than mouse. Thus form is disabled in these browsers.
            // jQuery UI bug: when scrolling through the ac suggestions with up/down arrow
            // keys, the input element gets filled with the highlighted text, even though no
            // select event has been triggered. To trigger a select, the user must hit enter
            // or click on the selection with the mouse. This appears to confuse some users.
            select: function(event, ui) {
                addContributorForm.showSelectedContributor(ui,contributorType); 
            }
        });

    },

    initElementData: function() {   
        this.verifyMatch.data('baseHref', this.verifyMatch.attr('href'));
    },

    setAcFilter: function() {
        this.acFilter = [];
        
        $('.contributorship').each(function() {
            var uri = $(this).data('ContributorUri');
            addContributorForm.acFilter.push(uri);
         });
    },
    
    removeContributorFromAcFilter: function(contributor) {
        var index = $.inArray(contributor, this.acFilter);
        if (index > -1) { // this should always be true
            this.acFilter.splice(index, 1);
        }   
    },
    
    filterAcResults: function(results) {
        var filteredResults = [];
        if (!this.acFilter.length) {
            return results;
        }
        $.each(results, function() {
            if ($.inArray(this.uri, addContributorForm.acFilter) == -1) {
                // console.log("adding " + this.label + " to filtered results");
                filteredResults.push(this);
            }
            else {
                // console.log("filtering out " + this.label);
            }
        });
        return filteredResults;
    },
    
    // After removing an contributorship, selectively clear matching autocomplete
    // cache entries, else the associated contributor will not be included in 
    // subsequent autocomplete suggestions.
    clearAcCacheEntries: function(name) {
        name = name.toLowerCase();
        $.each(this.acCache, function(key, value) {
            if (name.indexOf(key) == 0) {
                delete addContributorForm.acCache[key];
            }
        });
    },
    
    // Action taken after selecting an contributor from the autocomplete list
    showSelectedContributor: function(ui,contributorType) {

        if ( contributorType == "person" ) {
            this.personUriField.val(ui.item.uri);
            this.selectedContributor.show();

            // Transfer the name from the autocomplete to the selected contributor
            // name display, and hide the last name field.
            this.selectedContributorName.html(ui.item.label);
            // NB For some reason this doesn't delete the value from the last name
            // field when the form is redisplayed. Thus it's done explicitly in initFormView.
            this.hideFields(this.lastNameWrapper);
            // These get displayed if the selection was made through an enter keystroke,
            // since the keydown event on the last name field is also triggered (and
            // executes first). So re-hide them here.
            this.hideFieldsForNewPerson(); 
            this.personLink.attr('href', this.verifyMatch.data('baseHref') + ui.item.uri);
        }
        else {
            // do the same as above but for the organization fields
            this.orgUriField.val(ui.item.uri); 
            this.selectedOrg.show();

            this.selectedOrgName.html(ui.item.label);

            this.hideFields(this.orgNameWrapper); 

            this.orgLink.attr('href', this.verifyMatch.data('baseHref') + ui.item.uri);
        }

        // Cancel restores initial form view
        this.cancel.unbind('click');
        this.cancel.bind('click', function() {
            addContributorForm.initFormView();
            addContributorForm.setContributorType(contributorType);
            return false;
        });
    },
        
    /* Drag-and-drop */
    initContributorDD: function() {
        
        var contributorshipList = $('#contributorships'),
            contributorships = contributorshipList.children('li');
        
        if (contributorships.length < 2) {
            return;
        }
        
        $('.contributorNameWrapper').each(function() {
            $(this).attr('title', addContributorForm.contributorNameWrapperTitle);
        });
        
        contributorshipList.sortable({
            cursor: 'move',
            update: function(event, ui) {
                addContributorForm.reorderContributors(event, ui);
            }
        });     
    },
    
    // Reorder contributors. Called on page load and after contributor drag-and-drop and remove.
    // Event and ui parameters are defined only in the case of drag-and-drop.
    reorderContributors: function(event, ui) {
        var contributorships = $('li.contributorship').map(function(index, el) {
            return $(this).data('contributorshipUri');
        }).get();

        $.ajax({
            url: addContributorForm.reorderUrl,
            data: {
                predicate: addContributorForm.rankPredicate,
                individuals: contributorships
            },
            traditional: true, // serialize the array of individuals for the server
            dataType: 'json',
            type: 'POST',
            success: function(data, status, request) {
                var pos;
                $('.contributorship').each(function(index){
                    pos = index + 1;
                    // Set the new position for this element. The only function of this value 
                    // is so we can reset an element to its original position in case reordering fails.
                    addContributorForm.setPosition(this, pos);                
                });
                // Set the form rank field value.
                $('#rank').val(pos + 1);        
            },
            error: function(request, status, error) {
                // ui is undefined on page load and after an contributorship removal.
                if (ui) {
                    // Put the moved item back to its original position.
                    // Seems we need to do this by hand. Can't see any way to do it with jQuery UI. ??
                    var pos = addContributorForm.getPosition(ui.item),                       
                        nextpos = pos + 1, 
                        contributorships = $('#contributorships'), 
                        next = addContributorForm.findContributorship('position', nextpos);
                    
                    if (next.length) {
                        ui.item.insertBefore(next);
                    }
                    else {
                        ui.item.appendTo(contributorships);
                    }
                    
                    alert(addContributorForm.reorderContributorsAlert);                                 
                }      
            }
        });           
    },
    
    // On page load, associate data with each contributorship element. Then we don't
    // have to keep retrieving data from or modifying the DOM as we manipulate the
    // contributorships.
    initContributorshipData: function() {
        $('.contributorship').each(function(index) {
            $(this).data(contributorshipData[index]);    
            
            // RY We might still need position to put back an element after reordering
            // failure. Rank might already have been reset? Check.
            // We also may need position to implement undo links: we want the removed contributorship
            // to show up in the list, but it has no rank.
            $(this).data('position', index+1);      
        });
    },

    getPosition: function(contributorship) {
        return $(contributorship).data('position');
    },
    
    setPosition: function(contributorship, pos) {
        $(contributorship).data('position', pos);
    },
    
    findContributorship: function(key, value) {
        var matchingContributorship = $(); // if we don't find one, return an empty jQuery set
        
        $('.contributorship').each(function() {
            var contributorship = $(this);
            if ( contributorship.data(key) === value ) {
                matchingContributorship = contributorship; 
                return false; // stop the loop
            }
        });
         
        return matchingContributorship;       
    },
    
               
    /* *** Event listeners *** */ 
   
    bindEventListeners: function() {
        
        this.showFormButton.click(function() {
            addContributorForm.initFormView();
            return false;
        });
        
        this.orgRadio.click(function() {
            addContributorForm.setContributorType("org");
        });

        this.personRadio.click(function() {
            addContributorForm.setContributorType("person");
        });

        this.form.submit(function() {
            // NB Important JavaScript scope issue: if we call it this way, this = addContributorForm 
            // in prepareSubmit. If we do this.form.submit(this.prepareSubmit); then
            // this != addContributorForm in prepareSubmit.
            $selectedObj = addContributorForm.form.find('input.acSelector');
            addContributorForm.deleteAcHelpText($selectedObj);
			addContributorForm.prepareSubmit(); 
        });     

        this.lastNameField.blur(function() {
            // Cases where this event should be ignored:
            // 1. personUri field has a value: the autocomplete select event has already fired.
            // 2. The last name field is empty (especially since the field has focus when the form is displayed).
            // 3. Autocomplete suggestions are showing.
            if ( addContributorForm.personUriField.val() || !$(this).val() || $('ul.ui-autocomplete li.ui-menu-item').length ) {
                return;
            }
            addContributorForm.onLastNameChange();
        });

        this.personLink.click(function() {
            window.open($(this).attr('href'), 'verifyMatchWindow', 'width=640,height=640,scrollbars=yes,resizable=yes,status=yes,toolbar=no,menubar=no,location=no');
            return false;
        });   

        this.orgLink.click(function() {
            window.open($(this).attr('href'), 'verifyMatchWindow', 'width=640,height=640,scrollbars=yes,resizable=yes,status=yes,toolbar=no,menubar=no,location=no');
            return false;
        });   

    	this.acSelector.focus(function() {
        	addContributorForm.deleteAcHelpText(this);
    	});   

    	this.acSelector.blur(function() {
        	addContributorForm.addAcHelpText(this);
    	}); 
                
    	this.orgName.focus(function() {
        	addContributorForm.deleteAcHelpText(this);
    	});   

    	this.orgName.blur(function() {
        	addContributorForm.addAcHelpText(this);
    	}); 
                
        // When hitting enter in last name field, show first and middle name fields.
        // NB This event fires when selecting an autocomplete suggestion with the enter
        // key. Since it fires first, we undo its effects in the ac select event listener.
        this.lastNameField.keydown(function(event) {
            if (event.which === 13) {
                addContributorForm.onLastNameChange();
                return false; // don't submit form
            }
        });
        
        this.removeContributorshipLinks.click(function() {
            addContributorForm.removeContributorship(this);
            return false;
        });
        
    },

    prepareSubmit: function() {
        var firstName,
            middleName,
            lastName,
            name;
        
        // If selecting an existing person, don't submit name fields
        if (this.personUriField.val() != '' || this.orgUriField.val() != '' || this.orgName.val() != '' ) {
            this.firstNameField.attr('disabled', 'disabled');
            this.middleNameField.attr('disabled', 'disabled');
            this.lastNameField.attr('disabled', 'disabled');
        } 
        else {
            firstName = this.firstNameField.val();
            middleName = this.middleNameField.val();
            lastName = this.lastNameField.val();
            
            name = lastName;
            if (firstName) {
                name += ', ' + firstName;
            }
            if (middleName) {
                name += ' ' + middleName;
            }
            
            this.labelField.val(name);
        }
		// If user selected org via autocomplete, clear the org name field
		if ( this.orgUriField.val() != '' ) {
			this.orgName.val("");
		}

    },    
    
    onLastNameChange: function() {
        this.showFieldsForNewPerson();
        this.firstNameField.focus();
        // this.fixNames();
    },
    
    // User may have typed first name as well as last name into last name field.
    // If so, when showing first and middle name fields, move anything after a comma
    // or space into the first name field.
    // RY Space is problematic because they may be entering "<firstname> <lastname>", but
    // comma is a clear case. 
//    fixNames: function() {
//        var lastNameInput = this.lastNameField.val(),
//            names = lastNameInput.split(/[, ]+/), 
//            lastName = names[0];
// 
//        this.lastNameField.val(lastName);
//        
//        if (names.length > 1) {
//            //firstName = names[1].replace(/^[, ]+/, '');
//            this.firstNameField.val(names[1]);
//        } 
//    },
     
    removeContributorship: function(link) {
        // RY Upgrade this to a modal window

        contributorName = $(link).prev().children().text();

        var removeLast = false,
            message = addContributorForm.removeContributorshipMessage + '\n\n' + contributorName + ' ?\n\n';
        if (!confirm(message)) {
            return false;
        }

        if ( addContributorForm.showFormButtonWrapper.is(':visible') ) {
            addContributorForm.returnLink.hide();
            $('img#indicatorOne').removeClass('hidden');
            addContributorForm.showFormButton.addClass('disabledSubmit');
            addContributorForm.showFormButton.attr('disabled','disabled');
        }
        else {
            addContributorForm.cancel.hide();
            $('img#indicatorTwo').removeClass('hidden');            
            addContributorForm.submit.addClass('disabledSubmit');
            addContributorForm.submit.attr('disabled','disabled');
        }
              
        if ($(link)[0] === $('.remove:last')[0]) {
            removeLast = true;
        } 
        
        $.ajax({
            url: $(link).attr('href'),
            type: 'POST', 
            data: {
                deletion: $(link).parents('.contributorship').data('contributorshipUri')
            },
            dataType: 'json',
            context: link, // context for callback
            complete: function(request, status) {
                var contributorship,
                    contributorUri;
            
                if (status === 'success') {
                    
                    contributorship = $(this).parents('.contributorship');
                
                    // Clear autocomplete cache entries matching this contributor's name, else
                    // autocomplete will be retrieved from the cache, which excludes the removed contributor.
                    addContributorForm.clearAcCacheEntries(contributorship.data('contributorName'));
                    
                    // Remove this contributor from the acFilter so it is included in autocomplete
                    // results again.
                    addContributorForm.removeContributorFromAcFilter(contributorship.data('contributorUri'));
                    
                    contributorship.fadeOut(400, function() {
                        var numContributors;
 
                        // For undo link: add to a deletedContributorships array
                        
                        // Remove from the DOM                       
                        $(this).remove();
                        
                        // Actions that depend on the contributor having been removed from the DOM:
                        numContributors = $('.contributorship').length; // retrieve the length after removing contributorship from the DOM
                        
                        // If removed item not last, reorder to remove any gaps
                        if (numContributors > 0 && ! removeLast) {
                            addContributorForm.reorderContributors();
                        }
                            
                        // If fewer than two contributors remaining, disable drag-drop
                        if (numContributors < 2) {
                            addContributorForm.disableContributorDD();
                        }                           

                        if ( $('img#indicatorOne').is(':visible') ) {
                            $('img#indicatorOne').fadeOut(100, function() {
                                $(this).addClass('hidden');
                            });

                            addContributorForm.returnLink.fadeIn(100, function() {
                                $(this).show();
                            });
                            addContributorForm.showFormButton.removeClass('disabledSubmit');
                            addContributorForm.showFormButton.attr('disabled','');
                        }
                        else {
                            $('img#indicatorTwo').fadeOut(100, function() {
                                 $(this).addClass('hidden');
                             });

                             addContributorForm.cancel.fadeIn(100, function() {
                                 $(this).show();
                             });
                             addContributorForm.submit.removeClass('disabledSubmit');
                             addContributorForm.submit.attr('disabled','');
                        }
                    });

                } else {
                    alert(addContributorForm.removeContributorshipAlert);
                    
                }
            }
        });        
    },
    
    // Disable DD and associated cues if only one contributor remains
    disableContributorDD: function() {
        var contributorships = $('#contributorships'),
            contributorNameWrapper = $('.contributorNameWrapper');
            
        contributorships.sortable({ disable: true } );
        
        // Use class dd rather than jQuery UI's class ui-sortable, so that we can remove
        // the class if there's fewer than one contributor. We don't want to remove the ui-sortable
        // class, in case we want to re-enable DD without a page reload (e.g., if implementing
        // adding an contributor via Ajax request). 
        contributorships.removeClass('dd');
              
        contributorNameWrapper.removeAttr('title');
    },

    // RY To be implemented later.
    toggleRemoveLink: function() {
        // when clicking remove: remove the contributor, and change link text to 'undo'
        // when clicking undo: add the contributor back, and change link text to 'remove'
    },

	// Set the initial help text in the lastName field and change the class name.
	addAcHelpText: function(selectedObj) {
        var typeText;
        if ( $(selectedObj).attr('id') == "lastName" ) {
            typeText = addContributorForm.contributorTypeText;
        }
        else {
            typeText = addContributorForm.organizationTypeText;
        }
        
        if (!$(selectedObj).val()) {
			$(selectedObj).val(addContributorForm.helpTextSelect + " " + typeText + " " + addContributorForm.helpTextAdd)
						   .addClass(this.acHelpTextClass);
		}
	},
	
	deleteAcHelpText: function(selectedObj) {
	    if ($(selectedObj).hasClass(this.acHelpTextClass)) {
	            $(selectedObj).val('')
	                          .removeClass(this.acHelpTextClass);
	    }
	},

    // Depending on whether the contributor is a person or an organization,
    // we need to set the correct class names for fields like the acSelector, acSelection, etc.
    // as well as clear and disable fields, call other functions ...
	setContributorType: function(contributorType) {
	    if ( contributorType == "org" ) {
	        this.personSection.hide();
	        this.orgSection.show();
			this.orgNameWrapper.show();
	        // person fields
            this.personRadio.attr('checked', false);  // needed for reset when cancel button is clicked
	        this.acSelector.removeClass("acSelector");
	        this.acSelector.removeClass(this.acHelpTextClass);
	        this.selectedContributor.removeClass("acSelection");
	        this.selectedContributorName.removeClass("acSelectionInfo");
	        this.personLink.removeClass("verifyMatch");
	        this.acSelector.attr('disabled', 'disabled');
	        this.firstNameField.attr('disabled', 'disabled');
	        this.middleNameField.attr('disabled', 'disabled');
	        this.lastNameField.attr('disabled', 'disabled');
	        this.acSelector.val('');
	        this.firstNameField.val('');
	        this.middleNameField.val('');
	        this.lastNameField.val('');
	        // org fields
	        this.orgRadio.attr('checked', true); // needed for reset when cancel button is clicked
	        this.orgName.addClass("acSelector");
	        this.selectedOrg.addClass("acSelection");
	        this.selectedOrgName.addClass("acSelectionInfo");
	        this.orgLink.addClass("verifyMatch");
	        this.orgName.attr('disabled', '');
	        this.orgUriField.attr('disabled', '');

	        addContributorForm.addAcHelpText(this.orgName);
	        addContributorForm.initAutocomplete();
	        addContributorForm.hideSelectedPerson();
	    }
	    else if ( contributorType == "person" ) {
	        this.orgSection.hide();
	        this.personSection.show();
	        // org fields
	        this.orgRadio.attr('checked', false);  // needed for reset when cancel button is clicked
	        this.orgName.removeClass("acSelector");
	        this.orgName.removeClass(this.acHelpTextClass);
	        this.selectedOrg.removeClass("acSelection");
	        this.selectedOrgName.removeClass("acSelectionInfo");
	        this.orgLink.removeClass("verifyMatch");
	        this.orgName.attr('disabled', 'disabled');
	        this.orgUriField.attr('disabled', 'disabled');
	        this.orgName.val('');
	        this.orgUriField.val('');
            // person fields
            this.acSelector.addClass("acSelector");
            this.personRadio.attr('checked', true);  // needed for reset when cancel button is clicked
	        this.selectedContributor.addClass("acSelection");
	        this.selectedContributorName.addClass("acSelectionInfo");
	        this.personLink.addClass("verifyMatch");
	        this.acSelector.attr('disabled', '');
	        this.firstNameField.attr('disabled', '');
	        this.middleNameField.attr('disabled', '');
	        this.lastNameField.attr('disabled', '');

	        addContributorForm.addAcHelpText(this.acSelector);
	        addContributorForm.initAutocomplete();
	        addContributorForm.hideSelectedOrg();
	        
	    }
    }
};

$(document).ready(function() {   
    addContributorForm.onLoad();
}); 
