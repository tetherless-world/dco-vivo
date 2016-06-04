package edu.cornell.mannlib.vitro.webapp.edit.n3editing.configuration.preprocessors;

import edu.cornell.mannlib.vitro.webapp.controller.VitroRequest;
import edu.cornell.mannlib.vitro.webapp.edit.n3editing.VTwo.BaseEditSubmissionPreprocessorVTwo;
import edu.cornell.mannlib.vitro.webapp.edit.n3editing.VTwo.EditConfigurationVTwo;
import edu.cornell.mannlib.vitro.webapp.edit.n3editing.VTwo.MultiValueEditSubmission;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;


public class AddProjectUpdatePreprocessor extends BaseEditSubmissionPreprocessorVTwo {

    private static final Log log = LogFactory.getLog(AddProjectUpdatePreprocessor.class);

    public AddProjectUpdatePreprocessor(EditConfigurationVTwo editConfig) {
        super(editConfig);
    }

/* FIXME: This doesn't seem to be called
*/
    @Override
    public void preprocess(MultiValueEditSubmission inputSubmission, VitroRequest vreq) {
        log.debug("in AddProjectUpdatePreprocessor::preprocess");
        addURIsFromForm(inputSubmission, "publicationUri");
        addURIsFromForm(inputSubmission, "instrumentUri");
        log.debug("Input submission: " + inputSubmission.toString());
    }

    // Q: Why are we getting URIs from the form and then setting them in the form?  What are we actually doing here?
    private void addURIsFromForm(MultiValueEditSubmission inputSubmission, String uriVariable) {
        if (inputSubmission.hasUriValue(uriVariable)) {
            Map<String, List<String>> urisFromForm = inputSubmission.getUrisFromForm();
            List<String> newURIs = new ArrayList<>();
            for (String uri : urisFromForm.get(uriVariable)) {
                if (uri != null && uri.length() != 0 && !uri.equals(">SUBMITTED VALUE WAS BLANK<")) {
                    newURIs.add(uri);
                }
            }
            urisFromForm.put(uriVariable, newURIs);
            inputSubmission.setUrisFromForm(urisFromForm);
        }
    }
}
