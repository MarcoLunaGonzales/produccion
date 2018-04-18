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
public class ActividadesPreparado extends AbstractBean
{
    private int codActividadPreparado=0;
    private String nombreActividadPreparado="";
    private String descripcion="";

    public ActividadesPreparado() {
    }

    public int getCodActividadPreparado() {
        return codActividadPreparado;
    }

    public void setCodActividadPreparado(int codActividadPreparado) {
        this.codActividadPreparado = codActividadPreparado;
    }

    public String getDescripcion() {
        return descripcion;
    }

    public void setDescripcion(String descripcion) {
        this.descripcion = descripcion;
    }

    public String getNombreActividadPreparado() {
        return nombreActividadPreparado;
    }

    public void setNombreActividadPreparado(String nombreActividadPreparado) {
        this.nombreActividadPreparado = nombreActividadPreparado;
    }
}
