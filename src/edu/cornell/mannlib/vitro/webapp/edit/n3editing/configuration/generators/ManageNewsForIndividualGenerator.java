/* $This file is distributed under the terms of the license in /doc/license.txt$ */
package edu.cornell.mannlib.vitro.webapp.edit.n3editing.configuration.generators;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.hp.hpl.jena.query.QuerySolution;
import com.hp.hpl.jena.query.ResultSet;
import com.hp.hpl.jena.rdf.model.RDFNode;

import edu.cornell.mannlib.vitro.webapp.beans.Individual;
import edu.cornell.mannlib.vitro.webapp.controller.VitroRequest;
import edu.cornell.mannlib.vitro.webapp.controller.freemarker.UrlBuilder;
import edu.cornell.mannlib.vitro.webapp.controller.freemarker.UrlBuilder.ParamMap;
import edu.cornell.mannlib.vitro.webapp.dao.jena.QueryUtils;
import edu.cornell.mannlib.vitro.webapp.edit.n3editing.VTwo.EditConfigurationUtils;
import edu.cornell.mannlib.vitro.webapp.edit.n3editing.VTwo.EditConfigurationVTwo;

/**
 * This is an odd controller that is just drawing a page with links on it.
 * It is not an example of the normal use of the RDF editing system and
 * was just migrated over from an odd use of the JSP RDF editing system
 * during the 1.4 release. 
 * 
 * This mainly sets up pageData for the template to use.
 */
public class ManageNewsForIndividualGenerator extends BaseEditConfigurationGenerator implements EditConfigurationGenerator {
    public static Log log = LogFactory.getLog(ManageNewsForIndividualGenerator.class);
    
    @Override
    public EditConfigurationVTwo getEditConfiguration(VitroRequest vreq, HttpSession session) {

        EditConfigurationVTwo config = new EditConfigurationVTwo();
        config.setTemplate(this.getTemplate());

        initBasics(config, vreq);
        initPropertyParameters(vreq, session, config);
        initObjectPropForm(config, vreq);

        config.setSubjectUri(EditConfigurationUtils.getSubjectUri(vreq));
        config.setEntityToReturnTo( EditConfigurationUtils.getSubjectUri(vreq));

        List<Map<String,String>> newsLinks = getNewsLinks(config.getSubjectUri(), vreq);
        config.addFormSpecificData("newsLinks",newsLinks);

        config.addFormSpecificData("rankPredicate", "http://vivoweb.org/ontology/core#rank" );
        config.addFormSpecificData("reorderUrl", "/edit/reorder" );       
        config.addFormSpecificData("deleteNewsLinkUrl", "/edit/primitiveDelete");              

        ParamMap paramMap = new ParamMap();
        paramMap.put("subjectUri", config.getSubjectUri());
        paramMap.put("editForm", this.getEditForm());
        paramMap.put("view", "form");
        String path = UrlBuilder.getUrl( UrlBuilder.Route.EDIT_REQUEST_DISPATCH ,paramMap);

        config.addFormSpecificData("baseEditNewsLinkUrl", path);                 

        //Also add domainUri and rangeUri if they exist, adding here instead of template
        String domainUri = (String) vreq.getParameter("domainUri");
        String rangeUri = (String) vreq.getParameter("rangeUri");
        paramMap = new ParamMap();
        paramMap.put("subjectUri", config.getSubjectUri());
        paramMap.put("predicateUri", config.getPredicateUri());
        paramMap.put("editForm" , this.getEditForm() );
        paramMap.put("cancelTo", "manage");
        if(domainUri != null && !domainUri.isEmpty()) {
        	paramMap.put("domainUri", domainUri);
        }
        if(rangeUri != null && !rangeUri.isEmpty()) {
        	paramMap.put("rangeUri", rangeUri);
        }
        path = UrlBuilder.getUrl( UrlBuilder.Route.EDIT_REQUEST_DISPATCH ,paramMap);

        config.addFormSpecificData("showAddFormUrl", path);          

        Individual subject = vreq.getWebappDaoFactory().getIndividualDao().getIndividualByURI(config.getSubjectUri());
        if( subject != null && subject.getName() != null ){
            config.addFormSpecificData("subjectName", subject.getName());
        }else{
            config.addFormSpecificData("subjectName", null);
        }
        prepare(vreq, config);
        return config;
    }
  
    
    private static String NEWS_QUERY = ""
        + "PREFIX core: <http://vivoweb.org/ontology/core#> \n"
        + "PREFIX vcard: <http://www.w3.org/2006/vcard/ns#> \n"
        + "PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#> \n"
        + "PREFIX dco: <http://info.deepcarbon.net/schema#> \n"
        + "SELECT DISTINCT ?vcard ?link ?url ?label ?rank WHERE { \n"
        + "    ?subject dco:instrInitiativeNews ?vcard . \n"
        + "    ?vcard vcard:hasURL ?link . \n"
        + "    ?link a vcard:URL \n"
        + "    OPTIONAL { ?link vcard:url ?url } \n"
        + "    OPTIONAL { ?link rdfs:label ?label } \n"
        + "    OPTIONAL { ?link core:rank ?rank } \n"
        + "} ORDER BY ?rank";
    
       
    private List<Map<String, String>> getNewsLinks(String subjectUri, VitroRequest vreq) {
          
        String queryStr = QueryUtils.subUriForQueryVar(this.getQuery(), "subject", subjectUri);
        log.debug("Query string is: " + queryStr);
        List<Map<String, String>> newsLinks = new ArrayList<Map<String, String>>();
        try {
            ResultSet results = QueryUtils.getQueryResults(queryStr, vreq);
            while (results.hasNext()) {
                QuerySolution soln = results.nextSolution();
                RDFNode node = soln.get("link");
                if (node.isURIResource()) {
                    newsLinks.add(QueryUtils.querySolutionToStringValueMap(soln));        
                }
            }
        } catch (Exception e) {
            log.error(e, e);
        }    
        log.debug("newsLinks = " + newsLinks);
        return newsLinks;
    }
    
    //Putting this into a method allows overriding it in subclasses
    protected String getEditForm() {
    	return AddEditNewsFormGenerator.class.getName();
    }
    
    protected String getQuery() {
    	return NEWS_QUERY;
    }
    
    protected String getTemplate() {
    	return "manageNewsForIndividual.ftl";
    }
}
