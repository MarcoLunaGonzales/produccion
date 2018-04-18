/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.cofar.bean;

/**
 *
 * @author hvaldivia
 */
public class DocumentacionArgumentosProducto extends AbstractBean {
    PresentacionesProducto presentacionesProducto = new PresentacionesProducto();
    int codArgumento = 0;
    String nombreArgumento = "";
    String descripcionArgumento = "";
    EstadoReferencial estadoReferencial =   new EstadoReferencial();
    String descripcionPregunta = "";

    public int getCodArgumento() {
        return codArgumento;
    }

    public void setCodArgumento(int codArgumento) {
        this.codArgumento = codArgumento;
    }

    public PresentacionesProducto getPresentacionesProducto() {
        return presentacionesProducto;
    }

    public void setPresentacionesProducto(PresentacionesProducto presentacionesProducto) {
        this.presentacionesProducto = presentacionesProducto;
    }

    public String getDescripcionArgumento() {
        return descripcionArgumento;
    }

    public void setDescripcionArgumento(String descripcionArgumento) {
        this.descripcionArgumento = descripcionArgumento;
    }

    public EstadoReferencial getEstadoReferencial() {
        return estadoReferencial;
    }

    public void setEstadoReferencial(EstadoReferencial estadoReferencial) {
        this.estadoReferencial = estadoReferencial;
    }

    public String getNombreArgumento() {
        return nombreArgumento;
    }

    public void setNombreArgumento(String nombreArgumento) {
        this.nombreArgumento = nombreArgumento;
    }

    public String getDescripcionPregunta() {
        return descripcionPregunta;
    }

    public void setDescripcionPregunta(String descripcionPregunta) {
        this.descripcionPregunta = descripcionPregunta;
    }
    
    

}
