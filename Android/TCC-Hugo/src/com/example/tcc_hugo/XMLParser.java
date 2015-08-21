package com.example.tcc_hugo;

import java.io.IOException;
import java.io.StringReader;
import java.io.UnsupportedEncodingException;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;

import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.HttpStatus;
import org.apache.http.client.ClientProtocolException;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.util.EntityUtils;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.InputSource;
import org.xml.sax.SAXException;

import android.util.Log;

public class XMLParser {

	public String getXmlFromUrl(String url) {
		String xml = null;
		try {
			
			DefaultHttpClient httpClient = new DefaultHttpClient();
			HttpGet httpGet = new HttpGet(url);
			httpGet.addHeader("Accept", "text/xml");
			httpGet.addHeader("Content-Type", "text/xml");
			HttpResponse httpResponse = httpClient.execute(httpGet);
			final int statusCode = httpResponse.getStatusLine().getStatusCode();
			
			if (statusCode != HttpStatus.SC_OK) {
	            Log.w(getClass().getSimpleName(), "Error " + statusCode + " for URL " + url);
	            return null;
	         }

			HttpEntity httpEntity = httpResponse.getEntity();
			if (httpEntity != null) {
				xml = EntityUtils.toString(httpEntity);
			}
			
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		} catch (ClientProtocolException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
		return xml;
	}

	public Document getDomElement(String xml) {
		Document doc = null;
		DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
		try {
			DocumentBuilder db = dbf.newDocumentBuilder();
			InputSource is = new InputSource();
			is.setCharacterStream(new StringReader(xml));
			doc = (Document) db.parse(is);
		} catch (ParserConfigurationException e) {
			Log.e("CL", e.getMessage());
			return null;
		} catch (SAXException e) {
			Log.e("CL", e.getMessage());
			return null;
		} catch (IOException e) {
			Log.e("CL", e.getMessage());
			return null;
		}
		return doc;
	}

	public String getValue(Element item, String str) {
		NodeList n = item.getElementsByTagName(str);
		return this.getElementValue(n.item(0));
	}

	public final String getElementValue(Node elem) {
		Node child;
		if (elem != null) {
			if (elem.hasChildNodes()) {
				for (child = elem.getFirstChild(); child != null; child = child
						.getNextSibling()) {
					if (child.getNodeType() == Node.TEXT_NODE) {
						return child.getNodeValue();
					}
				}
			}
		}
		return "";
	}
}