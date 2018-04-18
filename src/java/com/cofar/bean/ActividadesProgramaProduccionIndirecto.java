/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.cofar.bean;

/**
 *
 * @author hvaldivia
 */
public class ActividadesProgramaProduccionIndirecto extends AbstractBean{
    ActividadesProduccion actividadesProduccion = new ActividadesProduccion();
    int orden = 0;
    float horasHombre = 0;
    AreasEmpresa areasEmpresa = new AreasEmpresa();
    EstadoReferencial estadoReferencial = new EstadoReferencial();

    public AreasEmpresa getAreasEmpresa() {
        return areasEmpresa;
    }

    public void setAreasEmpresa(AreasEmpresa areasEmpresa) {
        this.areasEmpresa = areasEmpresa;
    }

    public ActividadesProduccion getActividadesProduccion() {
        return actividadesProduccion;
    }

    public void setActividadesProduccion(ActividadesProduccion actividadesProduccion) {
        this.actividadesProduccion = actividadesProduccion;
    }

    

    public float getHorasHombre() {
        return horasHombre;
    }

    public void setHorasHombre(float horasHombre) {
        this.horasHombre = horasHombre;
    }

    public int getOrden() {
        return orden;
    }

    public void setOrden(int orden) {
        this.orden = orden;
    }

    public EstadoReferencial getEstadoReferencial() {
        return estadoReferencial;
    }

    public void setEstadoReferencial(EstadoReferencial estadoReferencial) {
        this.estadoReferencial = estadoReferencial;
    }
    
    
}
