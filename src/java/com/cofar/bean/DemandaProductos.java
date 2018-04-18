/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.cofar.bean;

import java.util.Date;



/**
 *
 * @author hvaldivia
 */
public class DemandaProductos {
    int codDemanda = 0;
    Date fechaGenerado = new Date();
    String nombreDemanda = "";

    EstadoDemandaProductos estadoDemandaProductos = new EstadoDemandaProductos();

    public int getCodDemanda() {
        return codDemanda;
    }

    public void setCodDemanda(int codDemanda) {
        this.codDemanda = codDemanda;
    }

    public Date getFechaGenerado() {
        return fechaGenerado;
    }

    public void setFechaGenerado(Date fechaGenerado) {
        this.fechaGenerado = fechaGenerado;
    }

    public String getNombreDemanda() {
        return nombreDemanda;
    }

    public void setNombreDemanda(String nombreDemanda) {
        this.nombreDemanda = nombreDemanda;
    }

    public EstadoDemandaProductos getEstadoDemandaProductos() {
        return estadoDemandaProductos;
    }

    public void setEstadoDemandaProductos(EstadoDemandaProductos estadoDemandaProductos) {
        this.estadoDemandaProductos = estadoDemandaProductos;
    }

    
}
