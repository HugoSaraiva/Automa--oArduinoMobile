package com.example.tcc_hugo;

import java.util.ArrayList;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.NodeList;

public class LeitorXML {

	static final String URL_PADRAO = "http://192.168.0.177/mobile";

	public ArrayList<Dispositivo> executarConsulta(String complementoURL) {

		String URL = URL_PADRAO;

		ArrayList<Dispositivo> resposta = new ArrayList<Dispositivo>();
		XMLParser parser = new XMLParser();

		String xml = parser.getXmlFromUrl(URL + complementoURL);
		if (xml != null) {
			Document doc = parser.getDomElement(xml);
			NodeList nl = doc.getElementsByTagName("Dispositivo");

			for (int i = 0; i < nl.getLength(); i++) {
				Element e = (Element) nl.item(i);
				resposta.add(montarDispositivoComElemento(e, parser));
			}
		}
		return resposta;
	}

	private Dispositivo montarDispositivoComElemento(Element element, XMLParser parser) {
		Dispositivo dispositivo = new Dispositivo();

		dispositivo.codigo = Integer.parseInt(parser.getValue(element, "Codigo"));  
		dispositivo.descricao = parser.getValue(element, "Descricao"); 
		dispositivo.status = parser.getValue(element, "Status"); 

		return dispositivo;
	}
}
