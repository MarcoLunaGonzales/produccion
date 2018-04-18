/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.cofar.bean;

/**
 *
 * @author DASISAQ
 */
public class TiposCompra extends AbstractBean 
{
    private int codTipoCompra=0;
    private String nombreTipoCompra="";

    public TiposCompra() {
    }

    public int getCodTipoCompra() {
        return codTipoCompra;
    }

    public void setCodTipoCompra(int codTipoCompra) {
        this.codTipoCompra = codTipoCompra;
    }

    public String getNombreTipoCompra() {
        return nombreTipoCompra;
    }

    public void setNombreTipoCompra(String nombreTipoCompra) {
        this.nombreTipoCompra = nombreTipoCompra;
    }
    
    
}
