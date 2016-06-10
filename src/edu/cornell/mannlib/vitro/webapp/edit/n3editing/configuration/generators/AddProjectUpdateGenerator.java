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
import edu.cornell.mannlib.vitro.webapp.controller.VitroRequest;
import edu.cornell.mannlib.vitro.webapp.edit.n3editing.VTwo.EditConfigurationUtils;
import edu.cornell.mannlib.vitro.webapp.edit.n3editing.VTwo.EditConfigurationVTwo;
import edu.cornell.mannlib.vitro.webapp.edit.n3editing.VTwo.fields.IndividualsViaVClassOptions;
import edu.cornell.mannlib.vitro.webapp.edit.n3editing.VTwo.fields.FieldVTwo;
import edu.cornell.mannlib.vitro.webapp.edit.n3editing.configuration.preprocessors.AddProjectUpdatePreprocessor;
import edu.cornell.mannlib.vitro.webapp.edit.n3editing.configuration.validators.AntiXssValidation;
import edu.cornell.mannlib.vitro.webapp.utils.FrontEndEditingUtils;
import edu.cornell.mannlib.vitro.webapp.utils.FrontEndEditingUtils.EditMode;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

public class AddProjectUpdateGenerator extends VivoBaseGenerator implements EditConfigurationGenerator {

    private static final Log log = LogFactory.getLog(AddProjectUpdatePreprocessor.class);

    final static String dco ="http://info.deepcarbon.net/schema#";
    final static String rdfs ="http://www.w3.org/2000/01/rdf-schema#";
    final static String bibo ="http://purl.org/ontology/bibo/";
    final static String assocPub = dco + "associatedPublication";
    final static String assocInstr = dco + "updateRefersTo";
    final static String dateTimeValueType = vivoCore + "DateTimeValue";
    final static String dateTimeValue = vivoCore + "dateTime";
    final static String dateTimePrecision = vivoCore + "dateTimePrecision";
    final static String reportingYearClass = dco + "ReportingYear";

    public AddProjectUpdateGenerator() {}

    @Override
    public EditConfigurationVTwo getEditConfiguration(VitroRequest vreq, HttpSession session) throws Exception
    {
        log.debug("in editConfiguration::constructor");
        EditConfigurationVTwo editConfiguration = new EditConfigurationVTwo();
        initBasics(editConfiguration, vreq);
        initPropertyParameters(vreq, session, editConfiguration);
        initObjectPropForm(editConfiguration, vreq);
        setVarNames(editConfiguration);

        // Required N3
        editConfiguration.setN3Required(generateN3Required());

        // Optional N3
        editConfiguration.setN3Optional(generateN3Optional());

        editConfiguration.setNewResources(generateNewResources(vreq));

        // In scope
        setUrisAndLiteralsInScope(editConfiguration, vreq);

        // on Form
        setUrisAndLiteralsOnForm(editConfiguration, vreq);

        // Sparql queries
        setSparqlQueries(editConfiguration, vreq);

        // set fields
        setFields(editConfiguration, vreq);

        // template file
        editConfiguration.setTemplate("addProjectUpdate.ftl");


        editConfiguration.addValidator(new AntiXssValidation());
//        editConfiguration.addValidator(new AutocompleteRequiredInputValidator("publicationUri", "publicationUri"));
//        editConfiguration.addValidator(new PersonHasPublicationValidator());
//
        // Adding additional data, specifically edit mode
        addFormSpecificData(editConfiguration, vreq);

        editConfiguration.addEditSubmissionPreprocessor(
                new AddProjectUpdatePreprocessor(editConfiguration));

        prepare(vreq, editConfiguration);
        return editConfiguration;
    }

    private void setVarNames(EditConfigurationVTwo editConfiguration) {
        editConfiguration.setVarNameForSubject("project");
        editConfiguration.setVarNameForPredicate("predicate");
        editConfiguration.setVarNameForObject("projectUpdateUri");

    }

    private List<String> generateN3Required() {
        return list(getProjectUpdateN3());
    }

    private String getProjectUpdateN3() {
        return "@prefix dco: <" + dco + "> . " +
                "?projectUpdateUri a dco:ProjectUpdate ." +
                "?projectUpdateUri <" + label + "> ?title . " +
                "?projectUpdateUri dco:forProject ?project ." +
                "?project dco:hasProjectUpdate ?projectUpdateUri .";
    }

    private List<String> generateN3Optional() {
        return list(getN3ForExistingReportingYear(),
                    getN3ForExistingPublication(),
                    getN3ForExistingInstrument(),
                    getN3ForNewModificationNote(),
                    getN3ForModifiedByAssertion(),
                    getN3ForModifiedOnAssertion(),
                    getN3ForUpdateTextAssertion()
        );
    }

    private String getN3ForExistingReportingYear() {
        return "@prefix dco: <" + dco + "> . " +
                "?projectUpdateUri dco:forReportingYear ?reportingYearUri . ";
    }

    private String getN3ForExistingPublication() {
        return "@prefix dco: <" + dco + "> . " +
                "?projectUpdateUri dco:associatedPublication ?publicationUri . ";
    }

    private String getN3ForExistingInstrument() {
        return "@prefix dco: <" + dco + "> . " +
                "?projectUpdateUri dco:updateRefersTo ?instrumentUri . ";
    }

    private String getN3ForNewModificationNote() {
        return "@prefix dco: <" + dco + "> . " +
                "?newModificationNoteUri a dco:ProjectUpdateModificationNote . " +
                "?newModificationNoteUri <" + label + "> ?modificationNoteText . " +
                "?projectUpdateUri dco:modificationNote ?newModificationNoteUri . ";
    }

    private String getN3ForModifiedByAssertion() {
        return "@prefix dco: <" + dco + "> . " +
                "?newModificationNoteUri dco:modifiedBy ?modifiedByUri . ";
    }

    private String getN3ForModifiedOnAssertion() {
        return "@prefix dco: <" + dco + "> . " +
                "?newModificationNoteUri dco:modifiedOn ?modifiedOn . ";
    }

    private String getN3ForUpdateTextAssertion() {
        return "@prefix dco: <" + dco + "> . " +
                "?projectUpdateUri dco:updateText ?updateText . ";
    }

    /**  Get new resources	 */
    private Map<String, String> generateNewResources(VitroRequest vreq) {
        log.debug("in editConfiguration::generateNewResources");
        String DEFAULT_NS_TOKEN=null; //null forces the default NS

        HashMap<String, String> newResources = new HashMap<String, String>();
        newResources.put("projectUpdateUri", DEFAULT_NS_TOKEN);
        newResources.put("newModificationNoteUri", DEFAULT_NS_TOKEN);
        return newResources;
    }

    /** Set URIS and Literals In Scope and on form and supporting methods	 */
    private void setUrisAndLiteralsInScope(EditConfigurationVTwo editConfiguration, VitroRequest vreq) {
        log.debug("in editConfiguration::getEditConfiguration");
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
        log.debug("in editConfiguration::setUrisAndLiteralsOnForm");
        List<String> urisOnForm = new ArrayList<String>();
        urisOnForm.add("reportingYearUri");
        urisOnForm.add("publicationUri");
        urisOnForm.add("instrumentUri");
        urisOnForm.add("modifiedByUri");
        editConfiguration.setUrisOnform(urisOnForm);

        List<String> literalsOnForm = new ArrayList<String>();
        literalsOnForm.add("title");
        literalsOnForm.add("modifiedOn");
        literalsOnForm.add("modificationNoteText");
        literalsOnForm.add("updateText");
        editConfiguration.setLiteralsOnForm(literalsOnForm);
    }

    /** Set SPARQL Queries and supporting methods. */
    private void setSparqlQueries(EditConfigurationVTwo editConfiguration, VitroRequest vreq) {
        log.debug("in editConfiguration::setSparqlQueries");
        editConfiguration.addSparqlForExistingLiteral("title", existingTitleQuery);
        editConfiguration.addSparqlForExistingLiteral("modifiedOn", existingModifiedOn);
        editConfiguration.addSparqlForExistingLiteral("modificationNoteText", existingModificationNoteText);
        editConfiguration.addSparqlForExistingLiteral("updateText", existingUpdateText);

        editConfiguration.addSparqlForExistingUris("reportingYearUri", existingReportingYears);
        editConfiguration.addSparqlForExistingUris("modifiedByUri", existingModifiedByUris);
        editConfiguration.addSparqlForExistingUris("publicationUri", existingPublicationUris);
        editConfiguration.addSparqlForExistingUris("instrumentUri", existingInstrumentUris);
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
        setExistingInstrumentUriField(editConfiguration);
        setUpdateTextField(editConfiguration);
        setModifiedByField(editConfiguration);
        setModifiedOnField(editConfiguration);
        setModificationNoteTextField(editConfiguration);
    }

    private void setTitleField(EditConfigurationVTwo editConfiguration) {
        String stringDatatypeUri = XSD.xstring.toString();
        editConfiguration.addField(new FieldVTwo().
                setName("title").
                setValidators(list("datatype:" + stringDatatypeUri,"nonempty")).
                setRangeDatatypeUri(stringDatatypeUri));
    }

    private void setUpdateTextField(EditConfigurationVTwo editConfiguration) {
        String stringDatatypeUri = XSD.xstring.toString();
        editConfiguration.addField(new FieldVTwo().
                setName("updateText").
                setValidators(list("datatype:" + stringDatatypeUri,"nonempty")).
                setRangeDatatypeUri(stringDatatypeUri));
    }

    private void setReportingYearUriField(EditConfigurationVTwo editConfiguration) throws Exception {
        editConfiguration.addField(new FieldVTwo().
                setName("reportingYearUri").
                setValidators(list("nonempty")).
                setOptions(new IndividualsViaVClassOptions(reportingYearClass)));
    }

    private void setPublicationUriField(EditConfigurationVTwo editConfiguration) throws Exception {
        editConfiguration.addField(new FieldVTwo().
                setName("publicationUri"));
    }

    private void setExistingInstrumentUriField(EditConfigurationVTwo editConfiguration) throws Exception {
        editConfiguration.addField(new FieldVTwo().
                setName("instrumentUri"));
    }

    private void setModifiedByField(EditConfigurationVTwo editConfiguration) throws Exception {
        editConfiguration.addField(new FieldVTwo().
                setName("modifiedBy").
                setValidators(list("nonempty")));
    }

    private void setModifiedOnField(EditConfigurationVTwo editConfiguration) {
        String dateDatatypeUri = XSD.date.toString();
        editConfiguration.addField(new FieldVTwo().
                setName("modifiedOn").
                setValidators(list("datatype:" + dateDatatypeUri)).
                setRangeDatatypeUri(dateDatatypeUri));
    }

    private void setModificationNoteTextField(EditConfigurationVTwo editConfiguration) {
        String stringDatatypeUri = XSD.xstring.toString();
        editConfiguration.addField(new FieldVTwo().
                setName("modificationNoteText").
                setValidators(list("datatype:" + stringDatatypeUri,"nonempty")).
                setRangeDatatypeUri(stringDatatypeUri));
    }

    public void addFormSpecificData(EditConfigurationVTwo editConfiguration, VitroRequest vreq) {
        log.debug("in editConfiguration::addFormSpecificData");
        HashMap<String, Object> formSpecificData = new HashMap<String, Object>();
        formSpecificData.put("editMode", getEditMode(vreq).name().toLowerCase());
        formSpecificData.put("publications", getIndividuals(vreq, assocPub));
        formSpecificData.put("instruments", getIndividuals(vreq, assocInstr));
        //formSpecificData.put("sparqlForPublicationAcFilter", getSparqlForPublicationAcFilter(vreq));
        editConfiguration.setFormSpecificData(formSpecificData);
        log.debug("formSpecificData: " + formSpecificData.toString());
    }

    public List<HashMap<String,String>> getIndividuals(VitroRequest vreq, String predicate) {
        Individual individual = EditConfigurationUtils.getObjectIndividual( vreq ) ;
        List<Individual> individuals = individual.getRelatedIndividuals( predicate );
        List<HashMap<String, String>> retlist= new ArrayList<HashMap<String, String>>() ;
        for( Individual i : individuals ) {
            HashMap<String, String> l = new HashMap<String, String>();
            l.put( "uri", i.getURI() ) ;
            l.put( "label", i.getName() ) ;
            retlist.add( l ) ;
        }
        return retlist ;
    }

    public String getSparqlForPublicationAcFilter(VitroRequest vreq) {
        String subject = EditConfigurationUtils.getSubjectUri(vreq);

        String query = "PREFIX core:<" + vivoCore + "> " +
                "PREFIX dco: <" + dco + "> " +
                "SELECT ?publicationUri WHERE { " +
                "<" + subject + "> dco:hasProjectUpdate ?projectUpdateUri . " +
                "?projectUpdateUri dco:associatedPublication ?publicationUri . }";
        return query;
    }

    public EditMode getEditMode(VitroRequest vreq) {
        String objectUri = EditConfigurationUtils.getObjectUri(vreq);
        EditMode editMode = FrontEndEditingUtils.EditMode.ADD;
        if(objectUri != null && !objectUri.isEmpty()) {
            editMode = FrontEndEditingUtils.EditMode.EDIT;
        }
        return editMode;
    }

    final static String existingTitleQuery  =
        "SELECT ?title WHERE {\n"+
        "?projectUpdateUri <"+ label +"> ?title . }";

    final static String existingUpdateText  =
        "PREFIX dco: <" + dco + ">\n"+
        "SELECT ?updateText WHERE {\n"+
        "?projectUpdateUri dco:updateText ?updateText .}";

    final static String existingModifiedOn =
        "PREFIX dco: <" + dco + ">\n"+
        "SELECT ?modfiedOn WHERE {\n"+
        "?projectUpdateUri dco:modificationNote ?newModificationNoteUri .\n"+
        "?newModificationNoteUri dco:modifiedOn ?modifiedOn .}";

    final static String existingModificationNoteText =
        "PREFIX dco: <" + dco + ">\n"+
        "SELECT ?modificationNoteText WHERE {\n"+
        "?projectUpdateUri dco:modificationNote ?newModificationNoteUri .\n"+
        "?newModificationNoteUri <" + label + "> ?modificationNoteText .}";

    final static String existingReportingYears =
        "PREFIX dco: <" + dco + ">\n"+
        "SELECT ?reportingYearUri WHERE {\n"+
        "?projectUpdateUri dco:forReportingYear ?reportingYearUri .}";

    final static String existingModifiedByUris =
        "PREFIX dco: <" + dco + ">\n"+
        "SELECT ?modifiedByUri WHERE {\n"+
        "?projectUpdateUri dco:modificationNote ?newModificationNoteUri .\n"+
        "?newModificationNoteUri dco:modifiedBy ?modifiedByUri .}";

    final static String existingPublicationUris =
        "PREFIX dco: <" + dco + ">\n"+
        "SELECT ?publicationUri WHERE {\n"+
        "?projectUpdateUri dco:associatedPublication ?publicationUri .}";

    final static String existingInstrumentUris =
        "PREFIX dco: <" + dco + ">\n"+
        "SELECT ?instrumentUri WHERE {\n"+
        "?projectUpdateUri dco:updateRefersTo ?instrumentUri .}";
}
