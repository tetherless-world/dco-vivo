package edu.cornell.mannlib.vitro.webapp.edit.n3editing.configuration.generators;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import com.hp.hpl.jena.rdf.model.Literal;
import com.hp.hpl.jena.vocabulary.XSD;
import com.hp.hpl.jena.query.Query;
import com.hp.hpl.jena.query.QueryFactory;
import com.hp.hpl.jena.query.QueryExecution;
import com.hp.hpl.jena.query.QueryExecutionFactory;
import com.hp.hpl.jena.query.ResultSet;
import com.hp.hpl.jena.rdf.model.RDFNode;
import com.hp.hpl.jena.rdf.model.Resource;
import com.hp.hpl.jena.sparql.resultset.ResultSetMem;

import edu.cornell.mannlib.vitro.webapp.beans.Individual;
import edu.cornell.mannlib.vitro.webapp.beans.ObjectPropertyStatement;
import edu.cornell.mannlib.vitro.webapp.controller.VitroRequest;
import edu.cornell.mannlib.vitro.webapp.controller.freemarker.UrlBuilder;
import edu.cornell.mannlib.vitro.webapp.dao.ModelAccess;
import edu.cornell.mannlib.vitro.webapp.dao.VitroVocabulary;
import edu.cornell.mannlib.vitro.webapp.edit.n3editing.AutocompleteRequiredInputValidator;
import edu.cornell.mannlib.vitro.webapp.edit.n3editing.PersonHasPublicationValidator;
import edu.cornell.mannlib.vitro.webapp.edit.n3editing.VTwo.DateTimeWithPrecisionVTwo;
import edu.cornell.mannlib.vitro.webapp.edit.n3editing.VTwo.EditConfigurationUtils;
import edu.cornell.mannlib.vitro.webapp.edit.n3editing.VTwo.EditConfigurationVTwo;
import edu.cornell.mannlib.vitro.webapp.edit.n3editing.VTwo.fields.ConstantFieldOptions;
import edu.cornell.mannlib.vitro.webapp.edit.n3editing.VTwo.fields.FieldVTwo;
import edu.cornell.mannlib.vitro.webapp.edit.n3editing.configuration.validators.AntiXssValidation;
import edu.cornell.mannlib.vitro.webapp.utils.FrontEndEditingUtils.EditMode;
import edu.cornell.mannlib.vitro.webapp.utils.generators.EditModeUtils;


public class AddProjectUpdateGenerator extends VivoBaseGenerator implements EditConfigurationGenerator {

    public AddProjectUpdateGenerator() {}

    @Override
    public EditConfigurationVTwo getEditConfiguration(VitroRequest vreq, HttpSession session) throws Exception {

        if( EditConfigurationUtils.getObjectUri(vreq) == null ){
            return doAddNew(vreq,session);
        } else {
            // TODO: need to decide what to do here
            return null;
        }
    }


    // We need to implement all the methods within this method.
    protected EditConfigurationVTwo doAddNew(VitroRequest vreq,
                                             HttpSession session) throws Exception {
        EditConfigurationVTwo editConfiguration = new EditConfigurationVTwo();
//        initBasics(editConfiguration, vreq);
//        initPropertyParameters(vreq, session, editConfiguration);
//        initObjectPropForm(editConfiguration, vreq);
//        setVarNames(editConfiguration);
//
//        // Required N3
//        editConfiguration.setN3Required(generateN3Required());
//
//        // Optional N3
//        editConfiguration.setN3Optional(generateN3Optional());
//
//        editConfiguration.setNewResources(generateNewResources(vreq));
//
//        // In scope
//        setUrisAndLiteralsInScope(editConfiguration, vreq);
//
//        // on Form
//        setUrisAndLiteralsOnForm(editConfiguration, vreq);
//
//        // Sparql queries
//        setSparqlQueries(editConfiguration, vreq);
//
//        // set fields
//        setFields(editConfiguration, vreq);
//
//        // template file
//        editConfiguration.setTemplate("addProjectUpdate.ftl"); // need to create this ftl file
//        // adding person has publication validator
//        editConfiguration.addValidator(new AntiXssValidation());
//        editConfiguration.addValidator(new AutocompleteRequiredInputValidator("pubUri", "title"));
//        editConfiguration.addValidator(new PersonHasPublicationValidator());
//
//        // Adding additional data, specifically edit mode
//        addFormSpecificData(editConfiguration, vreq);
//        prepare(vreq, editConfiguration);
        return editConfiguration;
    }

}
