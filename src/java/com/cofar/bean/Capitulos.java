/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.cofar.bean;

/**
 *
 * @author aquispe
 */
public class Capitulos extends AbstractBean{
    private int codCapitulo=0;
    private String nombreCapitulo="";
    private String obsCapitulo="";
    private EstadoReferencial estadoRegistro=new EstadoReferencial();

    public Capitulos() {
    }

    public int getCodCapitulo() {
        return codCapitulo;
    }

    public void setCodCapitulo(int codCapitulo) {
        this.codCapitulo = codCapitulo;
    }

    public EstadoReferencial getEstadoRegistro() {
        return estadoRegistro;
    }

    public void setEstadoRegistro(EstadoReferencial estadoRegistro) {
        this.estadoRegistro = estadoRegistro;
    }

    public String getNombreCapitulo() {
        return nombreCapitulo;
    }

    public void setNombreCapitulo(String nombreCapitulo) {
        this.nombreCapitulo = nombreCapitulo;
    }

    public String getObsCapitulo() {
        return obsCapitulo;
    }

    public void setObsCapitulo(String obsCapitulo) {
        this.obsCapitulo = obsCapitulo;
    }



}
