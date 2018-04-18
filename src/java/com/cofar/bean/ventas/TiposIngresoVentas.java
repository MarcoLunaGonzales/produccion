/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.cofar.bean.ventas;

import com.cofar.bean.AbstractBean;

/**
 *
 * @author DASISAQ
 */
public class TiposIngresoVentas extends AbstractBean 
{
    private int codTipoIngresoVentas=0;
    private String nombreTipoIngresoVentas="";

    public TiposIngresoVentas() {
    }

    public int getCodTipoIngresoVentas() {
        return codTipoIngresoVentas;
    }

    public void setCodTipoIngresoVentas(int codTipoIngresoVentas) {
        this.codTipoIngresoVentas = codTipoIngresoVentas;
    }

    public String getNombreTipoIngresoVentas() {
        return nombreTipoIngresoVentas;
    }

    public void setNombreTipoIngresoVentas(String nombreTipoIngresoVentas) {
        this.nombreTipoIngresoVentas = nombreTipoIngresoVentas;
    }
    
    
}
