/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.cofar.bean;

import java.util.Date;

/**
 *
 * @author DASISAQ
 */
public class RegistroOOS extends AbstractBean{
    private int codRegistroOOS=0;
    private String correlativoOOS="";
    private Personal personalDetectaOOS=new Personal();
    private Date fechaDeteccion=new Date();
    private Date fechaEnvioAsc=new Date();
    private String proveedor="";
    public RegistroOOS() {
    }

    public int getCodRegistroOOS() {
        return codRegistroOOS;
    }

    public void setCodRegistroOOS(int codRegistroOOS) {
        this.codRegistroOOS = codRegistroOOS;
    }

    public String getCorrelativoOOS() {
        return correlativoOOS;
    }

    public void setCorrelativoOOS(String correlativoOOS) {
        this.correlativoOOS = correlativoOOS;
    }

    public Date getFechaDeteccion() {
        return fechaDeteccion;
    }

    public void setFechaDeteccion(Date fechaDeteccion) {
        this.fechaDeteccion = fechaDeteccion;
    }

    public Date getFechaEnvioAsc() {
        return fechaEnvioAsc;
    }

    public void setFechaEnvioAsc(Date fechaEnvioAsc) {
        this.fechaEnvioAsc = fechaEnvioAsc;
    }

    public Personal getPersonalDetectaOOS() {
        return personalDetectaOOS;
    }

    public void setPersonalDetectaOOS(Personal personalDetectaOOS) {
        this.personalDetectaOOS = personalDetectaOOS;
    }

    public String getProveedor() {
        return proveedor;
    }

    public void setProveedor(String proveedor) {
        this.proveedor = proveedor;
    }

    
    

}
