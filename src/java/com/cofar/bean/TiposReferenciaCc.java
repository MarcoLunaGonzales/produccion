/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.cofar.bean;

/**
 *
 * @author hvaldivia
 */
public class TiposReferenciaCc extends AbstractBean{
    int codReferenciaCc = 0;
    String nombreReferenciaCc = "";
    String observacion="";

    public TiposReferenciaCc() {
    }
    

    public int getCodReferenciaCc() {
        return codReferenciaCc;
    }

    public void setCodReferenciaCc(int codReferenciaCc) {
        this.codReferenciaCc = codReferenciaCc;
    }

    public String getNombreReferenciaCc() {
        return nombreReferenciaCc;
    }

    public void setNombreReferenciaCc(String nombreReferenciaCc) {
        this.nombreReferenciaCc = nombreReferenciaCc;
    }

    public String getObservacion() {
        return observacion;
    }

    public void setObservacion(String observacion) {
        this.observacion = observacion;
    }
    
    
}
