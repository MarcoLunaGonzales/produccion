/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.cofar.bean;

/**
 *
 * @author aquispe
 */
public class TiposCotizacionesVentas extends AbstractBean{
    private int codTipoCotizacion=0;
    private String nombreTipoCotizacion="";
    private EstadoReferencial estadoRegistro=new EstadoReferencial();

    public TiposCotizacionesVentas() {
    }

    public int getCodTipoCotizacion() {
        return codTipoCotizacion;
    }

    public void setCodTipoCotizacion(int codTipoCotizacion) {
        this.codTipoCotizacion = codTipoCotizacion;
    }

    public EstadoReferencial getEstadoRegistro() {
        return estadoRegistro;
    }

    public void setEstadoRegistro(EstadoReferencial estadoRegistro) {
        this.estadoRegistro = estadoRegistro;
    }

    public String getNombreTipoCotizacion() {
        return nombreTipoCotizacion;
    }

    public void setNombreTipoCotizacion(String nombreTipoCotizacion) {
        this.nombreTipoCotizacion = nombreTipoCotizacion;
    }
    

}
