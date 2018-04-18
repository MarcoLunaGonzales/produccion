/*
 * EstadoReferencialMateriales.java
 *
 * Created on 7 de septiembre de 2010, 09:06 AM
 *
 * To change this template, choose Tools | Template Manager
 * and open the template in the editor.
 */

package com.cofar.bean;

/**
 *
 * @author WILSON
 */
public class EstadoReferencialMateriales {
    private String codSolicitudCompra="1";
    private String nombreEstadoMaterial="";
    /** Creates a new instance of EstadoReferencialMateriales */
    public EstadoReferencialMateriales() {
    }

    public String getCodSolicitudCompra() {
        return codSolicitudCompra;
    }

    public void setCodSolicitudCompra(String codSolicitudCompra) {
        this.codSolicitudCompra = codSolicitudCompra;
    }

    public String getNombreEstadoMaterial() {
        return nombreEstadoMaterial;
    }

    public void setNombreEstadoMaterial(String nombreEstadoMaterial) {
        this.nombreEstadoMaterial = nombreEstadoMaterial;
    }
    
}
