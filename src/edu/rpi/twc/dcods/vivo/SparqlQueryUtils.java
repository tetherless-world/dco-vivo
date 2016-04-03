package edu.rpi.twc.dcods.vivo;

import java.io.BufferedReader;
import java.io.DataOutputStream;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import javax.servlet.ServletContext;

import org.apache.commons.httpclient.URIException;
import org.apache.commons.httpclient.util.URIUtil;
import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.impl.client.DefaultHttpClient;
import org.json.JSONArray;
import org.json.JSONObject;

public class SparqlQueryUtils {
    
    public static JSONArray vivoSparqlSelect(String sparqlQuery, ServletContext ctx) {
        System.out.println("SparqlQueryUtils:vivoSparqlSelect");
        String endpoint = ServerInfo.getInstance().getEndpoint( ctx );
        System.out.println("  endpoint = " + endpoint);
        String namespace = ServerInfo.getInstance().getDCOURI( ctx );
        System.out.println("  namespace = " + namespace);
        String queryStr = 
                "PREFIX dco: <" + namespace + "> " +
                "PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#> " +
                "PREFIX xsd: <http://www.w3.org/2001/XMLSchema#> " +
                "PREFIX vivo: <http://vivoweb.org/ontology/core#> " +
                "PREFIX foaf: <http://xmlns.com/foaf/0.1/> " +
                "PREFIX vcard: <http://www.w3.org/2006/vcard/ns#> " +
                "PREFIX obo: <http://purl.obolibrary.org/obo/> " +
                sparqlQuery;
        System.out.println("  query = " + queryStr);
        String encodedQuery = new String();
        try {
            encodedQuery = URIUtil.encodeWithinQuery(queryStr);
        } catch (URIException e1) {
            e1.printStackTrace();
        }
        System.out.println("  encodedQuery = " + encodedQuery);
        String outputFormat = "&output=json";
        String url = endpoint + "/sparql?query=" + encodedQuery + outputFormat;
        HttpClient client = new DefaultHttpClient();
        HttpGet request = new HttpGet(url);
        HttpResponse response;
        BufferedReader bufferedReader;
        JSONArray results = new JSONArray();
        try {
            response = client.execute(request);
            HttpEntity entity = response.getEntity();
            if (entity != null) {
                InputStream inputStream = entity.getContent();
                        bufferedReader = new BufferedReader(new InputStreamReader(inputStream));
                       StringBuilder builder = new StringBuilder();
                        for (String line = null; (line = bufferedReader.readLine()) != null;) {
                            builder.append(line).append("\n");
                        }
                        JSONObject jsonObject = new JSONObject(builder.toString());
                        results = jsonObject.getJSONObject("results").getJSONArray("bindings");
                        System.out.println("  results = " + results);
                        bufferedReader.close();
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
                client.getConnectionManager().shutdown();
            }
        return results;
    }
    
    public static boolean vivoSparqlAsk(String queryStr, ServletContext ctx) {
        System.out.println("SparqlQueryUtils:vivoSparqlAsk");
        String endpoint = ServerInfo.getInstance().getEndpoint( ctx );
        System.out.println("  endpoint = " + endpoint);
        System.out.println("  ask query = " + queryStr);
        String encodedQuery = new String();
        try {
            encodedQuery = URIUtil.encodeWithinQuery(queryStr);
        } catch (URIException e1) {
            e1.printStackTrace();
            return false;
        }
        String outputFormat = "&output=json";
        String url = endpoint + "/sparql?query=" + encodedQuery + outputFormat;
        HttpClient client = new DefaultHttpClient();
        HttpGet request = new HttpGet(url);
        HttpResponse response;
        BufferedReader bufferedReader;
        boolean result = Boolean.FALSE;
        try {
            response = client.execute(request);
            HttpEntity entity = response.getEntity();
            if (entity != null) {
                InputStream inputStream = entity.getContent();
                        bufferedReader = new BufferedReader(new InputStreamReader(inputStream));
                       StringBuilder builder = new StringBuilder();
                        for (String line = null; (line = bufferedReader.readLine()) != null;) {
                            builder.append(line).append("\n");
                        }
                        JSONObject jsonObject = new JSONObject(builder.toString());
                        result = Boolean.parseBoolean(jsonObject.getString("boolean"));
                        System.out.println("  ask result = " + result);
                        bufferedReader.close();
            }
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        } finally {
            client.getConnectionManager().shutdown();
        }

        return result;
    }
    
    public static int vivoSparqlInsert(String data, ServletContext ctx ) throws Exception {
        System.out.println("SparqlQueryUtils:vivoSparqlInsert");
        String email = ServerInfo.getInstance().getRootName( ctx );
        System.out.println("  email = " + email);
        String password = ServerInfo.getInstance().getRootPassword( ctx );
        String updateAPI = ServerInfo.getInstance().getSparqlUpdateAPI( ctx );
        System.out.println("  update API = " + updateAPI);
        System.out.println("  data = " + data);
        URL obj = new URL(updateAPI);
        HttpURLConnection con = (HttpURLConnection) obj.openConnection();
 
        //add reuqest header
        con.setRequestMethod("POST");
        con.setRequestProperty("User-Agent", "Mozilla/5.0");
        con.setRequestProperty("Accept-Language", "en-US,en;q=0.5");
 
        try {
            data = URIUtil.encodeWithinQuery(data);
        } catch (URIException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }

        String payload = "password=" + password + "&email=" + email + "&update=";
        try {
            payload = URIUtil.encodeQuery(payload);
        } catch (URIException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }

        String urlParameters = payload+data;
 
        // Send post request
        con.setDoOutput(true);
        DataOutputStream wr = new DataOutputStream(con.getOutputStream());
        wr.writeBytes(urlParameters);
        wr.flush();
        wr.close();
 
        int responseCode = con.getResponseCode();
 
        BufferedReader in = new BufferedReader(new InputStreamReader(con.getInputStream()));
        String inputLine;
        StringBuffer response = new StringBuffer();
 
        while ((inputLine = in.readLine()) != null) {
            response.append(inputLine);
        }
        in.close();
 
        System.out.println("  response = " + response);
        System.out.println("  responseCode = " + responseCode);
        return responseCode;
    }

}
