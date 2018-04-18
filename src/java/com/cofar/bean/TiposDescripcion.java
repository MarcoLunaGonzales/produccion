/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.cofar.bean;

/**
 *
 * @author DASISAQ-
 */
public class TiposDescripcion extends  AbstractBean
{
    private int codTipoDescripcion=0;
    private String nombreTipoDescripcion="";
    private String especificacion="";

    public int getCodTipoDescripcion() {
        return codTipoDescripcion;
    }

    public void setCodTipoDescripcion(int codTipoDescripcion) {
        this.codTipoDescripcion = codTipoDescripcion;
    }

    public String getNombreTipoDescripcion() {
        return nombreTipoDescripcion;
    }

    public void setNombreTipoDescripcion(String nombreTipoDescripcion) {
        this.nombreTipoDescripcion = nombreTipoDescripcion;
    }

    

    public String getEspecificacion() {
        return especificacion;
    }

    public void setEspecificacion(String especificacion) {
        this.especificacion = especificacion;
    }
    
    
}
