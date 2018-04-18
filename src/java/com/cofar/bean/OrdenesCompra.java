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
public class OrdenesCompra extends AbstractBean
{
    private int codOrdenCompra=0;
    private int nroOrdenCompra=0;
    private TiposTransporte tiposTransporte=new TiposTransporte();

    public OrdenesCompra() {
    }

    public int getCodOrdenCompra() {
        return codOrdenCompra;
    }

    public void setCodOrdenCompra(int codOrdenCompra) {
        this.codOrdenCompra = codOrdenCompra;
    }

    public int getNroOrdenCompra() {
        return nroOrdenCompra;
    }

    public void setNroOrdenCompra(int nroOrdenCompra) {
        this.nroOrdenCompra = nroOrdenCompra;
    }

    public TiposTransporte getTiposTransporte() {
        return tiposTransporte;
    }

    public void setTiposTransporte(TiposTransporte tiposTransporte) {
        this.tiposTransporte = tiposTransporte;
    }
    
    
}
