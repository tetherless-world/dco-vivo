/* $This file is distributed under the terms of the license in /doc/license.txt$ */

package edu.cornell.mannlib.vitro.webapp.edit.n3editing.configuration.generators;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;

import javax.servlet.http.HttpSession;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.hp.hpl.jena.query.QuerySolution;
import com.hp.hpl.jena.query.ResultSet;
import com.hp.hpl.jena.rdf.model.RDFNode;
import com.hp.hpl.jena.rdf.model.Literal;
import com.hp.hpl.jena.vocabulary.RDFS;
import com.hp.hpl.jena.vocabulary.XSD;

import edu.cornell.mannlib.vitro.webapp.beans.DataPropertyComparator;
import edu.cornell.mannlib.vitro.webapp.beans.DataPropertyStatement;
import edu.cornell.mannlib.vitro.webapp.beans.Individual;
import edu.cornell.mannlib.vitro.webapp.controller.VitroRequest;
import edu.cornell.mannlib.vitro.webapp.dao.jena.QueryUtils;
import edu.cornell.mannlib.vitro.webapp.edit.n3editing.DatasetHasContributorValidator;
import edu.cornell.mannlib.vitro.webapp.edit.n3editing.VTwo.DateTimeIntervalValidationVTwo;
import edu.cornell.mannlib.vitro.webapp.edit.n3editing.VTwo.EditConfigurationUtils;
import edu.cornell.mannlib.vitro.webapp.edit.n3editing.VTwo.EditConfigurationVTwo;
import edu.cornell.mannlib.vitro.webapp.edit.n3editing.VTwo.fields.FieldVTwo;
import edu.cornell.mannlib.vitro.webapp.edit.n3editing.configuration.validators.AntiXssValidation;

/**
 * This is a slightly unusual generator that is used by Manage Contributors on
 * information resources. 
 *
 * It is intended to always be an add, and never an update. 
 */
public class AddContributorsToDatasetGenerator extends VivoBaseGenerator implements EditConfigurationGenerator {
    public static Log log = LogFactory.getLog(AddContributorsToDatasetGenerator.class);

    @Override
    public EditConfigurationVTwo getEditConfiguration(VitroRequest vreq,
            HttpSession session) {
        EditConfigurationVTwo editConfiguration = new EditConfigurationVTwo();    	    	
        initBasics(editConfiguration, vreq);
        initPropertyParameters(vreq, session, editConfiguration);

        //Overriding URL to return to
        setUrlToReturnTo(editConfiguration, vreq);

        //set variable names
        editConfiguration.setVarNameForSubject("dataset");               
        editConfiguration.setVarNameForPredicate("predicate");      
        editConfiguration.setVarNameForObject("contributorshipUri");                          

        // Required N3
        editConfiguration.setN3Required( list( getN3NewContributorship() ) );    

        // Optional N3 
        editConfiguration.setN3Optional( generateN3Optional());	

        editConfiguration.addNewResource("contributorshipUri", DEFAULT_NS_TOKEN);
        editConfiguration.addNewResource("newPerson", DEFAULT_NS_TOKEN);
        editConfiguration.addNewResource("newOrg", DEFAULT_NS_TOKEN);
        editConfiguration.addNewResource("vcardPerson", DEFAULT_NS_TOKEN);
        editConfiguration.addNewResource("vcardName", DEFAULT_NS_TOKEN);
        
        //In scope
        setUrisAndLiteralsInScope(editConfiguration, vreq);

        //on Form
        setUrisAndLiteralsOnForm(editConfiguration, vreq);

        //Sparql queries
        setSparqlQueries(editConfiguration, vreq);

        //set fields
        setFields(editConfiguration, vreq, EditConfigurationUtils.getPredicateUri(vreq));

        //template file
        editConfiguration.setTemplate("addContributorsToDataset.ftl");
        //add validators
        editConfiguration.addValidator(new DatasetHasContributorValidator());

        //Adding additional data, specifically edit mode
        addFormSpecificData(editConfiguration, vreq);
        
        editConfiguration.addValidator(new AntiXssValidation());
        
        //NOITCE this generator does not run prepare() since it 
        //is never an update and has no SPARQL for existing
        
        return editConfiguration;
    }
		
	private void setUrlToReturnTo(EditConfigurationVTwo editConfiguration, VitroRequest vreq) {
		editConfiguration.setUrlPatternToReturnTo(EditConfigurationUtils.getFormUrlWithoutContext(vreq));		
	}
	
	/***N3 strings both required and optional***/
	
	public String getN3PrefixString() {
		return "@prefix dco: <http://info.deepcarbon.net/schema#> .\n" + 
         "@prefix core:  <http://vivoweb.org/ontology/core#> .\n" +
		 "@prefix dcodata: <http://info.deepcarbon.net/data/schema#> .\n" +
		 "@prefix foaf: <" + foaf + "> .  \n"   ;
	}
	
	private String getN3NewContributorship() {
		return getN3PrefixString() + 
		"?contributorshipUri a dcodata:Contributor ;\n" + 
        "  core:relates ?dataset .\n" + 
        "?dataset core:relatedBy ?contributorshipUri .";
	}
	
	private String getN3ContributorshipRank() {
		return getN3PrefixString() +   
        "?contributorshipUri core:rank ?rank .";
	}
	
	//first name, middle name, last name, and new perseon for new contributor being created, and n3 for existing person
	//if existing person selected as contributor
	public List<String> generateN3Optional() {
		return list(
		        getN3NewPersonFirstName() ,
                getN3NewPersonMiddleName(),
                getN3NewPersonLastName(),                
                getN3NewPerson(),
                getN3ContributorshipRank(),
                getN3ForExistingPerson(),
                getN3NewOrg(),
                getN3ForExistingOrg());
		
	}
	
	
	private String getN3NewPersonFirstName() {
		return getN3PrefixString() + 
            "@prefix vcard: <http://www.w3.org/2006/vcard/ns#> .  \n" +
            "?newPerson <http://purl.obolibrary.org/obo/ARG_2000028>  ?vcardPerson . \n" +
            "?vcardPerson <http://purl.obolibrary.org/obo/ARG_2000029>  ?newPerson . \n" +
            "?vcardPerson a <http://www.w3.org/2006/vcard/ns#Individual> . \n" + 
            "?vcardPerson vcard:hasName  ?vcardName . \n" +
            "?vcardName a <http://www.w3.org/2006/vcard/ns#Name> . \n" +   
            "?vcardName vcard:givenName ?firstName .";
	}
	
	private String getN3NewPersonMiddleName() {
		return getN3PrefixString() +  
            "@prefix vcard: <http://www.w3.org/2006/vcard/ns#> .  \n" +
            "?newPerson <http://purl.obolibrary.org/obo/ARG_2000028>  ?vcardPerson . \n" +
            "?vcardPerson <http://purl.obolibrary.org/obo/ARG_2000029>  ?newPerson . \n" +
            "?vcardPerson a vcard:Individual . \n" + 
            "?vcardPerson vcard:hasName  ?vcardName . \n" +
            "?vcardName a vcard:Name . \n" +   
            "?vcardName <http://vivoweb.org/ontology/core#middleName> ?middleName .";
	}
	
	private String getN3NewPersonLastName() {
		return getN3PrefixString() + 
            "@prefix vcard: <http://www.w3.org/2006/vcard/ns#> .  \n" +
            "?newPerson <http://purl.obolibrary.org/obo/ARG_2000028>  ?vcardPerson . \n" +
            "?vcardPerson <http://purl.obolibrary.org/obo/ARG_2000029>  ?newPerson . \n" +
            "?vcardPerson a <http://www.w3.org/2006/vcard/ns#Individual> . \n" + 
            "?vcardPerson vcard:hasName  ?vcardName . \n" +
            "?vcardName a <http://www.w3.org/2006/vcard/ns#Name> . \n" +   
            "?vcardName vcard:familyName ?lastName .";
	}
	
	private String getN3NewPerson() {
		return  getN3PrefixString() + 
        "?newPerson a foaf:Person ;\n" + 
        "<" + RDFS.label.getURI() + "> ?label .\n" + 
        "?contributorshipUri core:relates ?newPerson .\n" + 
        "?newPerson core:relatedBy ?contributorshipUri . ";
	}
	
	private String getN3ForExistingPerson() {
		return getN3PrefixString() + 
		"?contributorshipUri core:relates ?personUri .\n" + 
		"?personUri core:relatedBy ?contributorshipUri .";
	}
	
	private String getN3NewOrg() {
		return  getN3PrefixString() + 
        "?newOrg a foaf:Organization ;\n" + 
        "<" + RDFS.label.getURI() + "> ?orgName .\n" + 
        "?contributorshipUri core:relates ?newOrg .\n" + 
        "?newOrg core:relatedBy ?contributorshipUri . ";
	}
	
	private String getN3ForExistingOrg() {
		return getN3PrefixString() + 
		"?contributorshipUri core:relates ?orgUri .\n" + 
		"?orgUri core:relatedBy ?contributorshipUri .";
	}
	/**  Get new resources	 */
	//A new contributorship uri will always be created when an contributor is added
	//A new person may be added if a person not in the system will be added as contributor
	 private Map<String, String> generateNewResources(VitroRequest vreq) {					
			
			
			HashMap<String, String> newResources = new HashMap<String, String>();			
			newResources.put("contributorshipUri", DEFAULT_NS_TOKEN);
			newResources.put("newPerson", DEFAULT_NS_TOKEN);
			newResources.put("vcardPerson", DEFAULT_NS_TOKEN);
			newResources.put("vcardName", DEFAULT_NS_TOKEN);
			newResources.put("newOrg", DEFAULT_NS_TOKEN);
			return newResources;
		}
	
	/** Set URIS and Literals In Scope and on form and supporting methods	 */   
    private void setUrisAndLiteralsInScope(EditConfigurationVTwo editConfiguration, VitroRequest vreq) {
    	//Uris in scope always contain subject and predicate
    	HashMap<String, List<String>> urisInScope = new HashMap<String, List<String>>();
    	urisInScope.put(editConfiguration.getVarNameForSubject(), 
    			Arrays.asList(new String[]{editConfiguration.getSubjectUri()}));
    	urisInScope.put(editConfiguration.getVarNameForPredicate(), 
    			Arrays.asList(new String[]{editConfiguration.getPredicateUri()}));
    	editConfiguration.setUrisInScope(urisInScope);
    	//no literals in scope    	    
    }
	
    public void setUrisAndLiteralsOnForm(EditConfigurationVTwo editConfiguration, VitroRequest vreq) {
    	List<String> urisOnForm = new ArrayList<String>();    	
    	//If an existing person is being used as an contributor, need to get the person uri
    	urisOnForm.add("personUri");
    	urisOnForm.add("orgUri");
    	editConfiguration.setUrisOnform(urisOnForm);
    	
    	//for person who is not in system, need to add first name, last name and middle name
    	//Also need to store contributorship rank and label of contributor
    	List<String> literalsOnForm = list("firstName",
    			"middleName",
    			"lastName",
    			"rank",
    			"orgName",
    			"label");
    	editConfiguration.setLiteralsOnForm(literalsOnForm);
    }   
    
    /** Set SPARQL Queries and supporting methods. */        
    private void setSparqlQueries(EditConfigurationVTwo editConfiguration, VitroRequest vreq) {        
        //Sparql queries are all empty for existing values
    	//This form is different from the others that it gets multiple contributors on the same page
    	//and that information will be queried and stored in the additional form specific data
        HashMap<String, String> map = new HashMap<String, String>();
    	editConfiguration.setSparqlForExistingUris(new HashMap<String, String>());
    	editConfiguration.setSparqlForExistingLiterals(new HashMap<String, String>());
    	editConfiguration.setSparqlForAdditionalUrisInScope(new HashMap<String, String>());
    	editConfiguration.setSparqlForAdditionalLiteralsInScope(new HashMap<String, String>());
    }
    
    /**
	 * 
	 * Set Fields and supporting methods
	 */
	
	public void setFields(EditConfigurationVTwo editConfiguration, VitroRequest vreq, String predicateUri) {
    	setLabelField(editConfiguration);
    	setFirstNameField(editConfiguration);
    	setMiddleNameField(editConfiguration);
    	setLastNameField(editConfiguration);
    	setRankField(editConfiguration);
    	setPersonUriField(editConfiguration);
    	setOrgUriField(editConfiguration);
    	setOrgNameField(editConfiguration);
    }
	
	private void setLabelField(EditConfigurationVTwo editConfiguration) {
		editConfiguration.addField(new FieldVTwo().
				setName("label").
				setValidators(list("datatype:" + XSD.xstring.toString())).
				setRangeDatatypeUri(XSD.xstring.toString())
				);
	}


	private void setFirstNameField(EditConfigurationVTwo editConfiguration) {
		editConfiguration.addField(new FieldVTwo().
				setName("firstName").
				setValidators(list("datatype:" + XSD.xstring.toString())).
				setRangeDatatypeUri(XSD.xstring.toString())
				);
	}


	private void setMiddleNameField(EditConfigurationVTwo editConfiguration) {
		editConfiguration.addField(new FieldVTwo().
				setName("middleName").
				setValidators(list("datatype:" + XSD.xstring.toString())).
				setRangeDatatypeUri(XSD.xstring.toString())
				);
	}

	private void setLastNameField(EditConfigurationVTwo editConfiguration) {
		editConfiguration.addField(new FieldVTwo().
				setName("lastName").
				setValidators(list("datatype:" + XSD.xstring.toString())).
				setRangeDatatypeUri(XSD.xstring.toString())
				);
	}

	private void setRankField(EditConfigurationVTwo editConfiguration) {
		editConfiguration.addField(new FieldVTwo().
				setName("rank").
				setValidators(list("nonempty")).
				setRangeDatatypeUri(XSD.xint.toString())
				);
	}


	private void setPersonUriField(EditConfigurationVTwo editConfiguration) {
		editConfiguration.addField(new FieldVTwo().
				setName("personUri")
				//.setObjectClassUri(personClass)
				);
	}

	private void setOrgUriField(EditConfigurationVTwo editConfiguration) {
		editConfiguration.addField(new FieldVTwo().
				setName("orgUri")
				//.setObjectClassUri(personClass)
				);
	}

	private void setOrgNameField(EditConfigurationVTwo editConfiguration) {
		editConfiguration.addField(new FieldVTwo().
				setName("orgName").
				setValidators(list("datatype:" + XSD.xstring.toString())).
				setRangeDatatypeUri(XSD.xstring.toString())
				);
	}
	
	//Form specific data
	public void addFormSpecificData(EditConfigurationVTwo editConfiguration, VitroRequest vreq) {
		HashMap<String, Object> formSpecificData = new HashMap<String, Object>();
		//Get the existing contributorships
		formSpecificData.put("existingContributorInfo", getExistingContributorships(editConfiguration.getSubjectUri(), vreq));
		formSpecificData.put("newRank", getMaxRank(editConfiguration.getSubjectUri(), vreq) + 1);
		formSpecificData.put("rankPredicate", "http://vivoweb.org/ontology/core#rank");
		editConfiguration.setFormSpecificData(formSpecificData);
	}

    private static String CONTRIBUTORSHIPS_QUERY = ""
        + "PREFIX core: <http://vivoweb.org/ontology/core#> \n"
        + "PREFIX afn:  <http://jena.hpl.hp.com/ARQ/function#> \n"
        + "PREFIX dco:  <http://info.deepcarbon.net/schema#> \n"
        + "PREFIX dcodata:  <http://info.deepcarbon.net/data/schema#> \n"
        + "PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#> \n"
        + "PREFIX foaf: <http://xmlns.com/foaf/0.1/> \n"
        + "SELECT ?contributorshipURI (afn:localname(?contributorshipURI) AS ?contributorshipName) ?contributorURI ?contributorName ?rank \n"
        + "WHERE { \n"
        + "?subject core:relatedBy ?contributorshipURI . \n"
        + "?contributorshipURI a dcodata:Contributor . \n"
        + "?contributorshipURI core:relates ?contributorURI . \n" 
        + "?contributorURI a foaf:Agent . \n"
        + "OPTIONAL { ?contributorURI rdfs:label ?contributorName } \n"
        + "OPTIONAL { ?contributorshipURI core:rank ?rank } \n" 
        + "} ORDER BY ?rank";
    
       
    private List<ContributorshipInfo> getExistingContributorships(String subjectUri, VitroRequest vreq) {
          
        String queryStr = QueryUtils.subUriForQueryVar(this.getContributorshipsQuery(), "subject", subjectUri);
        log.debug("Query string is: " + queryStr);
        List<Map<String, String>> contributorships = new ArrayList<Map<String, String>>();
        try {
            ResultSet results = QueryUtils.getQueryResults(queryStr, vreq);
            while (results.hasNext()) {
                QuerySolution soln = results.nextSolution();
                RDFNode node = soln.get("contributorshipURI");
                if (node.isURIResource()) {
                    contributorships.add(QueryUtils.querySolutionToStringValueMap(soln));        
                }
            }
        } catch (Exception e) {
            log.error(e, e);
        }    
        contributorships = QueryUtils.removeDuplicatesMapsFromList(contributorships, "contributorshipURI", "contributorURI");
        log.debug("contributorships = " + contributorships);
        return getContributorshipInfo(contributorships);
    }

    private static String MAX_RANK_QUERY = ""
        + "PREFIX core: <http://vivoweb.org/ontology/core#> \n"
        + "PREFIX dcodata: <http://info.deepcarbon.net/data/schema#> \n"
        + "SELECT DISTINCT ?rank WHERE { \n"
        + "    ?subject core:relatedBy ?contributorship . \n"
        + "    ?contributorship a dcodata:Contributor . \n"
        + "    ?contributorship core:rank ?rank .\n"
        + "} ORDER BY DESC(?rank) LIMIT 1";
        
    private int getMaxRank(String subjectUri, VitroRequest vreq) {

        int maxRank = 0; // default value 
        String queryStr = QueryUtils.subUriForQueryVar(this.getMaxRankQueryStr(), "subject", subjectUri);
        log.debug("maxRank query string is: " + queryStr);
        try {
            ResultSet results = QueryUtils.getQueryResults(queryStr, vreq);
            if (results != null && results.hasNext()) { // there is at most one result
                QuerySolution soln = results.next(); 
                RDFNode node = soln.get("rank");
                if (node != null && node.isLiteral()) {
                    // node.asLiteral().getInt() won't return an xsd:string that 
                    // can be parsed as an int.
                    int rank = Integer.parseInt(node.asLiteral().getLexicalForm());
                    if (rank > maxRank) {  
                        log.debug("setting maxRank to " + rank);
                        maxRank = rank;
                    }
                }
            }
        } catch (NumberFormatException e) {
            log.error("Invalid rank returned from query: not an integer value.");
        } catch (Exception e) {
            log.error(e, e);
        }
        log.debug("maxRank is: " + maxRank);
        return maxRank;
    }

	private List<ContributorshipInfo> getContributorshipInfo(
			List<Map<String, String>> contributorships) {
		List<ContributorshipInfo> info = new ArrayList<ContributorshipInfo>();
	 	String contributorshipUri =  "";
	 	String contributorshipName = "";
	 	String contributorUri = "";
	 	String contributorName = "";

		for ( Map<String, String> contributorship : contributorships ) {
		    for (Entry<String, String> entry : contributorship.entrySet() ) {
		            if ( entry.getKey().equals("contributorshipURI") ) {
		                contributorshipUri = entry.getValue();
		            }
		            else if ( entry.getKey().equals("contributorshipName") ) {
		                contributorshipName = entry.getValue();
		            }
		            else if ( entry.getKey().equals("contributorURI") ) {
		                contributorUri = entry.getValue();
		            }
		            else if ( entry.getKey().equals("contributorName") ) {
		                contributorName = entry.getValue();
		            }
			 }

			 ContributorshipInfo aaInfo = new ContributorshipInfo(contributorshipUri, contributorshipName, contributorUri, contributorName);
		    info.add(aaInfo);
		 }
		 log.debug("info = " + info);
		 return info;
	}

	//This is the information about contributors the form will require
	public class ContributorshipInfo {
		//This is the contributorship node information
		private String contributorshipUri;
		private String contributorshipName;
		//Contributor information for contributorship node
		private String contributorUri;
		private String contributorName;
		
		public ContributorshipInfo(String inputContributorshipUri, 
				String inputContributorshipName,
				String inputContributorUri,
				String inputContributorName) {
			contributorshipUri = inputContributorshipUri;
			contributorshipName = inputContributorshipName;
			contributorUri = inputContributorUri;
			contributorName = inputContributorName;

		}
		
		//Getters - specifically required for Freemarker template's access to POJO
		public String getContributorshipUri() {
			return contributorshipUri;
		}
		
		public String getContributorshipName() {
			return contributorshipName;
		}
		
		public String getContributorUri() {
			return contributorUri;
		}
		
		public String getContributorName() {
			return contributorName;
		}
	}
	
	static final String DEFAULT_NS_TOKEN=null; //null forces the default NS

    protected String getMaxRankQueryStr() {
    	return MAX_RANK_QUERY;
    }

    protected String getContributorshipsQuery() {
    	return CONTRIBUTORSHIPS_QUERY;
    }

}
