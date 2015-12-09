package edu.cornell.mannlib.vitro.webapp.edit.n3editing.configuration.preprocessors;

import java.util.*;

import javax.servlet.http.HttpServletRequest;

import com.hp.hpl.jena.ontology.OntModel;
import com.hp.hpl.jena.rdf.model.Literal;
import com.hp.hpl.jena.rdf.model.Model;
import com.hp.hpl.jena.rdf.model.Property;
import com.hp.hpl.jena.rdf.model.ResIterator;
import com.hp.hpl.jena.rdf.model.Resource;
import com.hp.hpl.jena.rdf.model.Statement;

import edu.cornell.mannlib.vitro.webapp.controller.VitroRequest;
import edu.cornell.mannlib.vitro.webapp.dao.VitroVocabulary;

import edu.cornell.mannlib.vitro.webapp.controller.VitroRequest;
import edu.cornell.mannlib.vitro.webapp.edit.n3editing.VTwo.BaseEditSubmissionPreprocessorVTwo;
import edu.cornell.mannlib.vitro.webapp.edit.n3editing.VTwo.EditConfigurationVTwo;
import edu.cornell.mannlib.vitro.webapp.edit.n3editing.VTwo.MultiValueEditSubmission;


public class AddPublicationToProjectUpdatePreprocessor extends BaseEditSubmissionPreprocessorVTwo {

    public AddPublicationToProjectUpdatePreprocessor(EditConfigurationVTwo editConfig) {
        super(editConfig);

    }

    @Override
    public void preprocess(MultiValueEditSubmission inputSubmission, VitroRequest vreq) {
        if(inputSubmission.hasUriValue("publicationUri")) {
            Map<String, List<String>> urisFromForm = inputSubmission.getUrisFromForm();
            List<String> pubUris = urisFromForm.get("publicationUri");
            List<String> newPubUris = new ArrayList<String>();
            for (String pubUri : pubUris) {
                if (pubUri != null && pubUri.length() != 0 && !pubUri.equals(">SUBMITTED VALUE WAS BLANK<")) {
                    newPubUris.add(pubUri);
                }
            }
            urisFromForm.put("publicationUri", newPubUris);
            inputSubmission.setUrisFromForm(urisFromForm);
        }

//        System.out.println("Input submission: " + inputSubmission.toString());
    }

}
