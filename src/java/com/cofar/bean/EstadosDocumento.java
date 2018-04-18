/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.cofar.bean;

/**
 *
 * @author aquispe
 */
public class EstadosDocumento extends AbstractBean{
    private int codEstadoDocumento=0;
    private String nombreEstadoDocumento="";
    private EstadoReferencial estadoRegistro=new EstadoReferencial();

    public EstadosDocumento() {
    }

    public int getCodEstadoDocumento() {
        return codEstadoDocumento;
    }

    public void setCodEstadoDocumento(int codEstadoDocumento) {
        this.codEstadoDocumento = codEstadoDocumento;
    }

    public EstadoReferencial getEstadoRegistro() {
        return estadoRegistro;
    }

    public void setEstadoRegistro(EstadoReferencial estadoRegistro) {
        this.estadoRegistro = estadoRegistro;
    }

    public String getNombreEstadoDocumento() {
        return nombreEstadoDocumento;
    }

    public void setNombreEstadoDocumento(String nombreEstadoDocumento) {
        this.nombreEstadoDocumento = nombreEstadoDocumento;
    }

    

}
