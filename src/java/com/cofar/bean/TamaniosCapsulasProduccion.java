/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.cofar.bean;

/**
 *
 * @author DASISAQ-
 */
public class TamaniosCapsulasProduccion  extends AbstractBean{
    private int codTamanioCapsulaProduccion=0;
    private String nombreTamanioCapsulaProduccion="";
    private String descripcionTamanioCapsulaProduccion="";
    //cantidad de productos que utilizan el tamanio de capsula;
    private int cantidadProductos=0;
    public TamaniosCapsulasProduccion() {
    }

    public int getCodTamanioCapsulaProduccion() {
        return codTamanioCapsulaProduccion;
    }

    public void setCodTamanioCapsulaProduccion(int codTamanioCapsulaProduccion) {
        this.codTamanioCapsulaProduccion = codTamanioCapsulaProduccion;
    }

    public String getNombreTamanioCapsulaProduccion() {
        return nombreTamanioCapsulaProduccion;
    }

    public void setNombreTamanioCapsulaProduccion(String nombreTamanioCapsulaProduccion) {
        this.nombreTamanioCapsulaProduccion = nombreTamanioCapsulaProduccion;
    }

    public String getDescripcionTamanioCapsulaProduccion() {
        return descripcionTamanioCapsulaProduccion;
    }

    public void setDescripcionTamanioCapsulaProduccion(String descripcionTamanioCapsulaProduccion) {
        this.descripcionTamanioCapsulaProduccion = descripcionTamanioCapsulaProduccion;
    }

    public int getCantidadProductos() {
        return cantidadProductos;
    }

    public void setCantidadProductos(int cantidadProductos) {
        this.cantidadProductos = cantidadProductos;
    }

    

}
