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
import edu.cornell.mannlib.vitro.webapp.edit.n3editing.DatasetHasCreatorValidator;
import edu.cornell.mannlib.vitro.webapp.edit.n3editing.VTwo.DateTimeIntervalValidationVTwo;
import edu.cornell.mannlib.vitro.webapp.edit.n3editing.VTwo.EditConfigurationUtils;
import edu.cornell.mannlib.vitro.webapp.edit.n3editing.VTwo.EditConfigurationVTwo;
import edu.cornell.mannlib.vitro.webapp.edit.n3editing.VTwo.fields.FieldVTwo;
import edu.cornell.mannlib.vitro.webapp.edit.n3editing.configuration.validators.AntiXssValidation;

/**
 * This is a slightly unusual generator that is used by Manage Creators on
 * information resources. 
 *
 * It is intended to always be an add, and never an update. 
 */
public class AddCreatorsToDatasetGenerator extends VivoBaseGenerator implements EditConfigurationGenerator {
    public static Log log = LogFactory.getLog(AddCreatorsToDatasetGenerator.class);

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
        editConfiguration.setVarNameForObject("creatorshipUri");                          

        // Required N3
        editConfiguration.setN3Required( list( getN3NewCreatorship() ) );    

        // Optional N3 
        editConfiguration.setN3Optional( generateN3Optional());	

        editConfiguration.addNewResource("creatorshipUri", DEFAULT_NS_TOKEN);
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
        editConfiguration.setTemplate("addCreatorsToDataset.ftl");
        //add validators
        editConfiguration.addValidator(new DatasetHasCreatorValidator());

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
	
	private String getN3NewCreatorship() {
		return getN3PrefixString() + 
		"?creatorshipUri a dcodata:Creator ;\n" + 
        "  core:relates ?dataset .\n" + 
        "?dataset core:relatedBy ?creatorshipUri .";
	}
	
	private String getN3CreatorshipRank() {
		return getN3PrefixString() +   
        "?creatorshipUri core:rank ?rank .";
	}
	
	//first name, middle name, last name, and new perseon for new creator being created, and n3 for existing person
	//if existing person selected as creator
	public List<String> generateN3Optional() {
		return list(
		        getN3NewPersonFirstName() ,
                getN3NewPersonMiddleName(),
                getN3NewPersonLastName(),                
                getN3NewPerson(),
                getN3CreatorshipRank(),
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
        "?creatorshipUri core:relates ?newPerson .\n" + 
        "?newPerson core:relatedBy ?creatorshipUri . ";
	}
	
	private String getN3ForExistingPerson() {
		return getN3PrefixString() + 
		"?creatorshipUri core:relates ?personUri .\n" + 
		"?personUri core:relatedBy ?creatorshipUri .";
	}
	
	private String getN3NewOrg() {
		return  getN3PrefixString() + 
        "?newOrg a foaf:Organization ;\n" + 
        "<" + RDFS.label.getURI() + "> ?orgName .\n" + 
        "?creatorshipUri core:relates ?newOrg .\n" + 
        "?newOrg core:relatedBy ?creatorshipUri . ";
	}
	
	private String getN3ForExistingOrg() {
		return getN3PrefixString() + 
		"?creatorshipUri core:relates ?orgUri .\n" + 
		"?orgUri core:relatedBy ?creatorshipUri .";
	}
	/**  Get new resources	 */
	//A new creatorship uri will always be created when an creator is added
	//A new person may be added if a person not in the system will be added as creator
	 private Map<String, String> generateNewResources(VitroRequest vreq) {					
			
			
			HashMap<String, String> newResources = new HashMap<String, String>();			
			newResources.put("creatorshipUri", DEFAULT_NS_TOKEN);
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
    	//If an existing person is being used as an creator, need to get the person uri
    	urisOnForm.add("personUri");
    	urisOnForm.add("orgUri");
    	editConfiguration.setUrisOnform(urisOnForm);
    	
    	//for person who is not in system, need to add first name, last name and middle name
    	//Also need to store creatorship rank and label of creator
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
    	//This form is different from the others that it gets multiple creators on the same page
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
		//Get the existing creatorships
		formSpecificData.put("existingCreatorInfo", getExistingCreatorships(editConfiguration.getSubjectUri(), vreq));
		formSpecificData.put("newRank", getMaxRank(editConfiguration.getSubjectUri(), vreq) + 1);
		formSpecificData.put("rankPredicate", "http://vivoweb.org/ontology/core#rank");
		editConfiguration.setFormSpecificData(formSpecificData);
	}

    private static String CREATORSHIPS_QUERY = ""
        + "PREFIX core: <http://vivoweb.org/ontology/core#> \n"
        + "PREFIX afn:  <http://jena.hpl.hp.com/ARQ/function#> \n"
        + "PREFIX dco:  <http://info.deepcarbon.net/schema#> \n"
        + "PREFIX dcodata:  <http://info.deepcarbon.net/data/schema#> \n"
        + "PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#> \n"
        + "PREFIX foaf: <http://xmlns.com/foaf/0.1/> \n"
        + "SELECT ?creatorshipURI (afn:localname(?creatorshipURI) AS ?creatorshipName) ?creatorURI ?creatorName ?rank \n"
        + "WHERE { \n"
        + "?subject core:relatedBy ?creatorshipURI . \n"
        + "?creatorshipURI a dcodata:Creator . \n"
        + "?creatorshipURI core:relates ?creatorURI . \n" 
        + "?creatorURI a foaf:Agent . \n"
        + "OPTIONAL { ?creatorURI rdfs:label ?creatorName } \n"
        + "OPTIONAL { ?creatorshipURI core:rank ?rank } \n" 
        + "} ORDER BY ?rank";
    
       
    private List<CreatorshipInfo> getExistingCreatorships(String subjectUri, VitroRequest vreq) {
          
        String queryStr = QueryUtils.subUriForQueryVar(this.getCreatorshipsQuery(), "subject", subjectUri);
        log.debug("Query string is: " + queryStr);
        List<Map<String, String>> creatorships = new ArrayList<Map<String, String>>();
        try {
            ResultSet results = QueryUtils.getQueryResults(queryStr, vreq);
            while (results.hasNext()) {
                QuerySolution soln = results.nextSolution();
                RDFNode node = soln.get("creatorshipURI");
                if (node.isURIResource()) {
                    creatorships.add(QueryUtils.querySolutionToStringValueMap(soln));        
                }
            }
        } catch (Exception e) {
            log.error(e, e);
        }    
        creatorships = QueryUtils.removeDuplicatesMapsFromList(creatorships, "creatorShipURI", "creatorURI");
        log.debug("creatorships = " + creatorships);
        return getCreatorshipInfo(creatorships);
    }

    private static String MAX_RANK_QUERY = ""
        + "PREFIX core: <http://vivoweb.org/ontology/core#> \n"
        + "PREFIX dcodata: <http://info.deepcarbon.net/data/schema#> \n"
        + "SELECT DISTINCT ?rank WHERE { \n"
        + "    ?subject core:relatedBy ?creatorship . \n"
        + "    ?creatorship a dcodata:Creator . \n"
        + "    ?creatorship core:rank ?rank .\n"
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

	private List<CreatorshipInfo> getCreatorshipInfo(
			List<Map<String, String>> creatorships) {
		List<CreatorshipInfo> info = new ArrayList<CreatorshipInfo>();
	 	String creatorshipUri =  "";
	 	String creatorshipName = "";
	 	String creatorUri = "";
	 	String creatorName = "";

		for ( Map<String, String> creatorship : creatorships ) {
		    for (Entry<String, String> entry : creatorship.entrySet() ) {
		            if ( entry.getKey().equals("creatorshipURI") ) {
		                creatorshipUri = entry.getValue();
		            }
		            else if ( entry.getKey().equals("creatorshipName") ) {
		                creatorshipName = entry.getValue();
		            }
		            else if ( entry.getKey().equals("creatorURI") ) {
		                creatorUri = entry.getValue();
		            }
		            else if ( entry.getKey().equals("creatorName") ) {
		                creatorName = entry.getValue();
		            }
			 }

			 CreatorshipInfo aaInfo = new CreatorshipInfo(creatorshipUri, creatorshipName, creatorUri, creatorName);
		    info.add(aaInfo);
		 }
		 log.debug("info = " + info);
		 return info;
	}

	//This is the information about creators the form will require
	public class CreatorshipInfo {
		//This is the creatorship node information
		private String creatorshipUri;
		private String creatorshipName;
		//Creator information for creatorship node
		private String creatorUri;
		private String creatorName;
		
		public CreatorshipInfo(String inputCreatorshipUri, 
				String inputCreatorshipName,
				String inputCreatorUri,
				String inputCreatorName) {
			creatorshipUri = inputCreatorshipUri;
			creatorshipName = inputCreatorshipName;
			creatorUri = inputCreatorUri;
			creatorName = inputCreatorName;

		}
		
		//Getters - specifically required for Freemarker template's access to POJO
		public String getCreatorshipUri() {
			return creatorshipUri;
		}
		
		public String getCreatorshipName() {
			return creatorshipName;
		}
		
		public String getCreatorUri() {
			return creatorUri;
		}
		
		public String getCreatorName() {
			return creatorName;
		}
	}
	
	static final String DEFAULT_NS_TOKEN=null; //null forces the default NS

    protected String getMaxRankQueryStr() {
    	return MAX_RANK_QUERY;
    }

    protected String getCreatorshipsQuery() {
    	return CREATORSHIPS_QUERY;
    }

}
