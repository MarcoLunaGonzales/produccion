/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.cofar.bean;

/**
 *
 * @author aquispe
 */
public class AlmacenesMuestra extends AbstractBean{
    private int codAlmacenMuestra=0;
    private String nombreAlmacenMuestra="";
    private EstadoReferencial estadoRegistro=new EstadoReferencial();

    public AlmacenesMuestra() {
    }

    public int getCodAlmacenMuestra() {
        return codAlmacenMuestra;
    }

    public void setCodAlmacenMuestra(int codAlmacenMuestra) {
        this.codAlmacenMuestra = codAlmacenMuestra;
    }

    public EstadoReferencial getEstadoRegistro() {
        return estadoRegistro;
    }

    public void setEstadoRegistro(EstadoReferencial estadoRegistro) {
        this.estadoRegistro = estadoRegistro;
    }

    public String getNombreAlmacenMuestra() {
        return nombreAlmacenMuestra;
    }

    public void setNombreAlmacenMuestra(String nombreAlmacenMuestra) {
        this.nombreAlmacenMuestra = nombreAlmacenMuestra;
    }

    

}

