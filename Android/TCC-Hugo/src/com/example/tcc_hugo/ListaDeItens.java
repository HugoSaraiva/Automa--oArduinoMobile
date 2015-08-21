package com.example.tcc_hugo;

import java.net.URL;
import java.util.ArrayList;
import android.os.AsyncTask;
import android.os.Bundle;
import android.app.Activity;
import android.view.Menu;
import android.widget.ListView;

public class ListaDeItens extends Activity {
    ListView listView ;
    LeitorXML api = null;
    ArrayList<Dispositivo> lista;
    DispositivoAdapter adapter;
    
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_lista_de_itens);
        
        // Get ListView object from xml
        listView = (ListView) findViewById(R.id.lista);
        
        // Defined Array values to show in ListView
        lista = new ArrayList<Dispositivo>();


        // Define a new Adapter
        // First parameter - Context
        // Second parameter - Layout for the row
        // Third parameter - ID of the TextView to which the data is written
        // Forth - the Array of data


        // Assign adapter to ListView
        adapter = new DispositivoAdapter(this, lista);
        listView.setAdapter(adapter); 
        
        api = new LeitorXML();
        
    	new CarregarDados().execute(null, null, null);
        
    }
    
    private class CarregarDados extends AsyncTask<URL, Integer, Long> {

    	protected Long doInBackground(URL... urls) {

    		lista = api.executarConsulta("");

    		return null;
    	}

    	protected void onProgressUpdate(Integer... progress) {
    	}

    	protected void onPostExecute(Long result) {
    	    // update data in our adapter
    	    adapter.getData().clear();
    	    adapter.getData().addAll(lista);
    	    // fire the event
    	    adapter.notifyDataSetChanged();
    	}

    }
    
    
	@Override
	public boolean onCreateOptionsMenu(Menu menu) {
		// Inflate the menu; this adds items to the action bar if it is present.
		getMenuInflater().inflate(R.menu.lista_de_itens, menu);
		return true;
	}

}
