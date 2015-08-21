package com.example.tcc_hugo;

import java.io.Serializable;

public class Dispositivo implements Serializable  {
	private static final long serialVersionUID = 1L;
	public int codigo;
	public String descricao;
	public String status;
	
	public Dispositivo() {
		this.codigo = 0;
		this.descricao = "";
		this.status = "";
	}
	
	public Dispositivo(int codigo, String descricao, String status) {
		this.codigo = codigo;
		this.descricao = descricao;
		this.status = status;
	}

	public int getCodigo() {
		return codigo;
	}

	public void setCodigo(int codigo) {
		this.codigo = codigo;
	}

	public String getDescricao() {
		return descricao;
	}

	public void setDescricao(String descricao) {
		this.descricao = descricao;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}
	
}
