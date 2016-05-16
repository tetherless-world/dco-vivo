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

import edu.cornell.mannlib.vitro.webapp.controller.VitroRequest;
import edu.cornell.mannlib.vitro.webapp.edit.n3editing.VTwo.EditConfigurationUtils;
import edu.cornell.mannlib.vitro.webapp.edit.n3editing.VTwo.EditConfigurationVTwo;
import edu.cornell.mannlib.vitro.webapp.edit.n3editing.VTwo.fields.IndividualsViaVClassOptions;
import edu.cornell.mannlib.vitro.webapp.edit.n3editing.VTwo.fields.FieldVTwo;
//import edu.cornell.mannlib.vitro.webapp.edit.n3editing.configuration.preprocessors.AddLandingPagePreprocessor;
import edu.cornell.mannlib.vitro.webapp.edit.n3editing.configuration.validators.AntiXssValidation;
import edu.cornell.mannlib.vitro.webapp.utils.FrontEndEditingUtils;
import edu.cornell.mannlib.vitro.webapp.utils.FrontEndEditingUtils.EditMode;


public class DatasetLandingPageGenerator extends VivoBaseGenerator implements EditConfigurationGenerator {

    // set up some prefixes as strings so we don't replicate when building the RDF
    final static String dco ="http://info.deepcarbon.net/schema#";
    final static String dcat ="http://www.w3.org/ns/dcat#";
    final static String foaf ="http://xmlns.com/foaf/0.1/";
    final static String rdfs ="http://www.w3.org/2000/01/rdf-schema#";

    public DatasetLandingPageGenerator() {}

    /** Retrieve the configuration that represents the information in the form.
     *
     * This method returns the configuration that represents the information in the form, what freemarker template to use and how to build the rdf that is
     * used to create the new information.
     *
     * This method and everything that it does happens before the form is actually displayed. Nothing happens afterwards.
     */
    @Override
    public EditConfigurationVTwo getEditConfiguration(VitroRequest vreq, HttpSession session) throws Exception {

        EditConfigurationVTwo editConfiguration = new EditConfigurationVTwo();
        initBasics(editConfiguration, vreq);
        initPropertyParameters(vreq, session, editConfiguration);
        initObjectPropForm(editConfiguration, vreq);

        // This sets the variable names for subject, predicate and object in the generated N3
        setVarNames(editConfiguration);

        // This is the N3 for required fields in the form. Any fields in the form replace the corresponding variables in the SPARQL. For example, in this
        // form we use the form field "uri" and in the N3 we use "?uri" wherever we want the value to be replaced.
        editConfiguration.setN3Required(generateN3Required());

        // In scope
        setUrisAndLiteralsInScope(editConfiguration, vreq);

        // This tells VIVO which fields in the form are literals and which ones are URIs. This informs the processing code how to render the replacement for
        // the variable in the N3. For example, in this form the URI field is of type uri so it is replaced in the N3 as <uri>. If it were a literal it
        // would be replaced with the type of literal (as defined in setVarNames
        setUrisAndLiteralsOnForm(editConfiguration, vreq);

        // These are the queries that get used to pre-populate the fields in the form. Using the subject, predicate and object from above build the queries
        // so that they return the appropriate value using the appropriate variable name in the query. For this form we do not pre-populate the form because
        // we do not allow editing.
        setSparqlQueries(editConfiguration, vreq);

        // set the field names that are used in the form. This tells VIVO the form names, whether they are required or not, and if a Literal you can
        // tell it what type of literal
        setFields(editConfiguration, vreq);

        // This tells the configuration which freemarker template file to use to generate the form. In our form we have only one text box for the landingPage.
        editConfiguration.setTemplate("addLandingPage.ftl");


        // This does basic validation on all of the fields, if they are required. This is a default validator provided by VIVO
        editConfiguration.addValidator(new AntiXssValidation());

        // Adding additional data, specifically edit mode, to be used by the freemarker template (ftl)
        addFormSpecificData(editConfiguration, vreq);

        // if we had any pre-processing to do on any of the fields in the form we would use the AddLandingPagePreprocessor object. Right now it does nothing.
        /*
        editConfiguration.addEditSubmissionPreprocessor(
                new AddLandingPagePreprocessor(editConfiguration));
        */

        prepare(vreq, editConfiguration);
        return editConfiguration;
    }

    // sets the variable names for the subject, predicate and object use in the generation of the N3
    private void setVarNames(EditConfigurationVTwo editConfiguration) {
        editConfiguration.setVarNameForSubject("dataset");
        editConfiguration.setVarNameForPredicate("landingPage");
        editConfiguration.setVarNameForObject("uri");
    }

    // Generate the N3 that will be used to create the new triples. ?uri is replaced with <uri> from the form as it is a uri. We make that entity a
    // foaf:Document so that it appears properly in the dataset display
    private List<String> generateN3Required() {
        return list(getLandingPageN3());
    }

    // what we do is we have the user specify a URL that is used to access datasets, not a download link). We then use that URL as the URI of a
    // foaf:Document. In the custom display we use the URI of the foaf:Document in the display that links to that URI. We do not set any
    // properties for the foaf:Document itself.
    private String getLandingPageN3() {
        String ret = "@prefix foaf: <" + foaf + "> . " +
                "@prefix dcat: <" + dcat + "> ." +
                "?dataset dcat:landingPage ?uri ." +
                "?uri a foaf:Document ." ;
        return ret ;
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

    // set the form fields that we have in the form. We have only one field in the form, a uri with name uri.
    private void setUrisAndLiteralsOnForm(EditConfigurationVTwo editConfiguration, VitroRequest vreq) {
        List<String> urisOnForm = new ArrayList<String>();
        urisOnForm.add("uri");
        editConfiguration.setUrisOnform(urisOnForm);

        List<String> literalsOnForm = new ArrayList<String>();
        editConfiguration.setLiteralsOnForm(literalsOnForm);
    }

    //In this case no queries for existing values of the foaf:Document.
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

    // set the field names that are used in the form. This tells VIVO the form names, whether they are required or not, and if a Literal you can
    // tell it what type of literal
    private void setFields(EditConfigurationVTwo editConfiguration, VitroRequest vreq) throws Exception {
        setURIField(editConfiguration);
    }

    private void setURIField(EditConfigurationVTwo editConfiguration) {
        String stringDatatypeUri = XSD.xstring.toString();
        editConfiguration.addField(new FieldVTwo().
                setName("uri").
                setValidators(list("nonempty")));
    }

    // Adding additional data, specifically edit mode, to be used by the freemarker template (ftl)
    public void addFormSpecificData(EditConfigurationVTwo editConfiguration, VitroRequest vreq) {
        HashMap<String, Object> formSpecificData = new HashMap<String, Object>();
        formSpecificData.put("editMode", getEditMode(vreq).name().toLowerCase());
        editConfiguration.setFormSpecificData(formSpecificData);
    }

    // returns the mode, whether adding a new entity or editing an existing one. This could be used in the ftl to determine how to display the fields of the form,
    // what text to use for labels, etc...
    public EditMode getEditMode(VitroRequest vreq) {
        String objectUri = EditConfigurationUtils.getObjectUri(vreq);
        EditMode editMode = FrontEndEditingUtils.EditMode.ADD;
        if(objectUri != null && !objectUri.isEmpty()) {
            editMode = FrontEndEditingUtils.EditMode.EDIT;
        }
        return editMode;
    }
}
