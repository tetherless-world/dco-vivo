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

    final static String dco ="http://info.deepcarbon.net/schema#";

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
        initBasics(editConfiguration, vreq);
        initPropertyParameters(vreq, session, editConfiguration);
        initObjectPropForm(editConfiguration, vreq);
        setVarNames(editConfiguration);

        // Required N3
        editConfiguration.setN3Required(generateN3Required());
//
        // Optional N3
        editConfiguration.setN3Optional(generateN3Optional());
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

    private void setVarNames(EditConfigurationVTwo editConfiguration) {
        editConfiguration.setVarNameForSubject("project");
        editConfiguration.setVarNameForPredicate("predicate");
        editConfiguration.setVarNameForObject("projectUpdateUri");

    }

    private List<String> generateN3Required() {
        return list(getProjectUpdateN3(),
                    getN3ForExistingReportingYear()
        );
    }

    private String getProjectUpdateN3() {
        return "@prefix dco: <" + dco + "> . " +
                "?projectUpdateUri a dco:ProjectUpdate ;" +
                "dco:forProject ?project ." +
                "?project dco:hasProjectUpdate ?projectUpdateUri .";
    }

    private List<String> generateN3Optional() {
        return list(getN3ForNewReportingYear()
        );
    }

    private String getN3ForNewReportingYear() {
        return "@prefix dco: <" + dco + "> . " +
                "?newReportingYear a dco:ReportingYear . " +
                "?newReportingYear <" + label + "> ?title . " +
                "projectUpdateUri dco:forReportingYear ?newReportingYear . ";
    }

    private String getN3ForExistingReportingYear() {
        return "@prefix dco: <" + dco + "> . " +
                "projectUpdateUri dco:forReportingYear ?reportingYearUri . ";
    }

    private String getN3ForExistingPublication() {
        return "@prefix dco: <" + dco + "> . " +
                "projectUpdateUri dco:associatedPublications ?publicationUri . ";
    }

    private String getN3ForNewModificationNote() {
        return "@prefix dco: <" + dco + "> . " +
                "?newModificationNote a dco:ProjectUpdateModificationNote . " +
                "?newModificationNote dco:modifiedBy ?personUri . " +
                "?newModificationNote dco:modifiedOn ?date . " +
                "projectUpdateUri dco:modificationNote ?modificationNoteUri . ";
    }

    /**  Get new resources	 */
    private Map<String, String> generateNewResources(VitroRequest vreq) {
        String DEFAULT_NS_TOKEN=null; //null forces the default NS

        HashMap<String, String> newResources = new HashMap<String, String>();
        newResources.put("ProjectUpdate", DEFAULT_NS_TOKEN);
        newResources.put("newModificationNote", DEFAULT_NS_TOKEN);
        //newResources.put("dateTimeNode", DEFAULT_NS_TOKEN);
        return newResources;
    }

    /** Set URIS and Literals In Scope and on form and supporting methods	 */
    private void setUrisAndLiteralsInScope(EditConfigurationVTwo editConfiguration, VitroRequest vreq) {
        HashMap<String, List<String>> urisInScope = new HashMap<String, List<String>>();
        urisInScope.put(editConfiguration.getVarNameForSubject(),
                Arrays.asList(new String[]{editConfiguration.getSubjectUri()}));
        urisInScope.put(editConfiguration.getVarNameForPredicate(),
                Arrays.asList(new String[]{editConfiguration.getPredicateUri()}));
        editConfiguration.setUrisInScope(urisInScope);
        HashMap<String, List<Literal>> literalsInScope = new HashMap<String, List<Literal>>();
        editConfiguration.setLiteralsInScope(literalsInScope);

    }

    private void setUrisAndLiteralsOnForm(EditConfigurationVTwo editConfiguration, VitroRequest vreq) {
        List<String> urisOnForm = new ArrayList<String>();
        urisOnForm.add("reportingYearUri");
        urisOnForm.add("publisherUri");
        urisOnForm.add("personUri");
        editConfiguration.setUrisOnform(urisOnForm);

        List<String> literalsOnForm = new ArrayList<String>();
        literalsOnForm.add("date");
        editConfiguration.setLiteralsOnForm(literalsOnForm);
    }

    /** Set SPARQL Queries and supporting methods. */
    //In this case no queries for existing
    private void setSparqlQueries(EditConfigurationVTwo editConfiguration, VitroRequest vreq) {
        editConfiguration.setSparqlForExistingUris(new HashMap<String, String>());
        editConfiguration.setSparqlForAdditionalLiteralsInScope(new HashMap<String, String>());
        editConfiguration.setSparqlForAdditionalUrisInScope(new HashMap<String, String>());
        editConfiguration.setSparqlForExistingLiterals(new HashMap<String, String>());
    }

    /**
     *
     * Set Fields and supporting methods
     * @throws Exception
     */

    private void setFields(EditConfigurationVTwo editConfiguration, VitroRequest vreq) throws Exception {
        setTitleField(editConfiguration);
        setReportingYearUriField(editConfiguration);
        setPublicationUriField(editConfiguration);
    }

    private void setTitleField(EditConfigurationVTwo editConfiguration) {
        String stringDatatypeUri = XSD.xstring.toString();
        editConfiguration.addField(new FieldVTwo().
                setName("title").
                setValidators(list("datatype:" + stringDatatypeUri)).
                setRangeDatatypeUri(stringDatatypeUri));
    }

    private void setReportingYearUriField(EditConfigurationVTwo editConfiguration) {
        editConfiguration.addField(new FieldVTwo().
                setName("reportingYearUri"));
    }

    private void setPublicationUriField(EditConfigurationVTwo editConfiguration) {
        editConfiguration.addField(new FieldVTwo().
                setName("publicationUri"));
    }

}
