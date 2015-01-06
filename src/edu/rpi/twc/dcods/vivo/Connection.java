package edu.rpi.twc.dcods.vivo;

import java.net.URL;

import java.net.MalformedURLException;
import java.io.IOException;
import java.io.BufferedReader;
import java.io.InputStreamReader;

import org.apache.http.HttpResponse;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.entity.StringEntity;

/**
 * Connection holds the connection details for this session
 *
 * @author      Ross Jones <ross.jones@okfn.org>
 * @version     1.7
 * @since       2012-05-01
 */
public final class Connection {

    private String m_host;
    private int m_port;
    private String _apikey = null;
    private URL u;
    
    public Connection(  ) {
        this("http://datahub.io", 80);
    }

    public Connection(String hostName,String apiKey,boolean customizedConn){
    	try {
			this.u = new URL( hostName );
			this._apikey = apiKey;
			
		} catch (MalformedURLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
    	
    }
    public Connection( String host  ) {
        this( host, 80 );
    }

    public Connection( String host, int port ) {
        this.m_host = host;
        this.m_port = port;

        try {
            URL u = new URL( this.m_host + ":" + this.m_port + "/api");
        } catch ( MalformedURLException mue ) {
            System.out.println(mue);
        }

    }

    public void setApiKey( String key ) {
        this._apikey = key;
    }


    
    /**
     * Makes a POST request
     *
     * Submits a POST HTTP request to the CKAN instance configured within
     * the constructor, returning tne entire contents of the response.
     *
     * @param  path The URL path to make the POST request to
     * @param  data The data to be posted to the URL
     * @returns The String contents of the response
     * @throws A CKANException if the request fails
     */
     protected String Post(String data)
         throws CKANException {
         URL url = this.u;

         String body = "";

         HttpClient httpclient = new DefaultHttpClient();
         try {
             HttpPost postRequest = new HttpPost(url.toString());
             postRequest.setHeader( "X-CKAN-API-Key", this._apikey );

 		    StringEntity input = new StringEntity(data);
 		    input.setContentType("application/json");
 		    postRequest.setEntity(input);

             HttpResponse response = httpclient.execute(postRequest);
             int statusCode = response.getStatusLine().getStatusCode();

             BufferedReader br = new BufferedReader(
                         new InputStreamReader((response.getEntity().getContent())));

             String line = "";
 		    while ((line = br.readLine()) != null) {
                 body += line;
 		    }
         } catch( IOException ioe ) {
             System.out.println( ioe );
         } finally {
             httpclient.getConnectionManager().shutdown();
         }

         return body;
     }
     
     
    /**
    * Makes a POST request
    *
    * Submits a POST HTTP request to the CKAN instance configured within
    * the constructor, returning tne entire contents of the response.
    *
    * @param  path The URL path to make the POST request to
    * @param  data The data to be posted to the URL
    * @returns The String contents of the response
    * @throws A CKANException if the request fails
    */
    protected String Post(String path, String data)
        throws CKANException {
        URL url = null;

       
        try {
            url = new URL(  u.toString() + path);
        } catch ( MalformedURLException mue ) {
            System.err.println(mue);
            return null;
        }

        String body = "";

        HttpClient httpclient = new DefaultHttpClient();
        try {
            HttpPost postRequest = new HttpPost(url.toString());
            postRequest.setHeader( "X-CKAN-API-Key", this._apikey );

		    StringEntity input = new StringEntity(data);
		    input.setContentType("application/json");
		    postRequest.setEntity(input);

            HttpResponse response = httpclient.execute(postRequest);
            int statusCode = response.getStatusLine().getStatusCode();

            BufferedReader br = new BufferedReader(
                        new InputStreamReader((response.getEntity().getContent())));

            String line = "";
		    while ((line = br.readLine()) != null) {
                body += line;
		    }
        } catch( IOException ioe ) {
            System.out.println( ioe );
        } finally {
            httpclient.getConnectionManager().shutdown();
        }

        return body;
    }

}






