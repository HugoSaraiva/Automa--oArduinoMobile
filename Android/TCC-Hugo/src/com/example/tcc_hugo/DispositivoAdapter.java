package com.example.tcc_hugo;

import java.net.URL;
import java.util.List;

import android.content.Context;
import android.os.AsyncTask;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.View.OnClickListener;
import android.widget.BaseAdapter;
import android.widget.Button;
import android.widget.TextView;

public class DispositivoAdapter extends BaseAdapter {
    private Context context;
    private List<Dispositivo> dispositivos;
    LeitorXML api = null;
    
    public DispositivoAdapter(Context context, List<Dispositivo> dispositivos){
        this.context = context;
        this.dispositivos = dispositivos;
        api = new LeitorXML();
    }

	@Override
	public int getCount() {
        return dispositivos.size();
	}

	@Override
	public Object getItem(int position) {
        return dispositivos.get(position);
	}

	@Override
	public long getItemId(int position) {
        return position;
	}

	@Override
	public View getView(int position, View convertView, ViewGroup parent) {
        // Recupera o estado da posição atual
        Dispositivo dispositivo = dispositivos.get(position);
        
        // Cria uma instância do layout XML para os objetos correspondentes
        // na View
        LayoutInflater inflater = (LayoutInflater)
            context.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
        View view = inflater.inflate(R.layout.activity_dispositivo, null);
        
        // Estado - Abreviação
        TextView txtDescricao = (TextView)view.findViewById(R.id.txtDescricao);
        txtDescricao.setText(dispositivo.getDescricao() + " - " + dispositivo.getStatus());
        
        // Capital
        Button btnAlterar = (Button)view.findViewById(R.id.btnAlterar);
        btnAlterar.setTag(dispositivo.getCodigo());
        
        final DispositivoAdapter adapter = this;

        btnAlterar.setOnClickListener(new OnClickListener() {
			@Override
			public void onClick(View v) {
		    	CarregarDados cd = new CarregarDados();
		    	cd.adapter = adapter;
		    	cd.complementoUrl = "Alterar" + v.getTag();
		    	cd.execute(null, null, null);
			}
		});
 
        return view;
	}
    
    private class CarregarDados extends AsyncTask<URL, Integer, Long> {
    	public DispositivoAdapter adapter;
        public String complementoUrl = "";

    	protected Long doInBackground(URL... urls) {

    		dispositivos = api.executarConsulta(complementoUrl);

    		return null;
    	}

    	protected void onProgressUpdate(Integer... progress) {
    	}

    	protected void onPostExecute(Long result) {
    	    // update data in our adapter
    	    adapter.getData().clear();
    	    adapter.getData().addAll(dispositivos);
    	    // fire the event
    	    adapter.notifyDataSetChanged();
    	}

    }

public List<Dispositivo> getData() {
    return dispositivos;
}

}
