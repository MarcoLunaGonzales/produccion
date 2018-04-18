/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.cofar.bean;

/**
 *
 * @author aquispe
 */
public class Grupos extends AbstractBean{

    private int codGrupo=0;
    private String nombreGrupo="";
    private String obsGrupo="";
    private EstadoReferencial estadoRegistro=new EstadoReferencial();
    private Capitulos capitulo=new Capitulos();

    public Grupos() {
    }

    public Capitulos getCapitulo() {
        return capitulo;
    }

    public void setCapitulo(Capitulos capitulo) {
        this.capitulo = capitulo;
    }

    public int getCodGrupo() {
        return codGrupo;
    }

    public void setCodGrupo(int codGrupo) {
        this.codGrupo = codGrupo;
    }

    public EstadoReferencial getEstadoRegistro() {
        return estadoRegistro;
    }

    public void setEstadoRegistro(EstadoReferencial estadoRegistro) {
        this.estadoRegistro = estadoRegistro;
    }

    public String getNombreGrupo() {
        return nombreGrupo;
    }

    public void setNombreGrupo(String nombreGrupo) {
        this.nombreGrupo = nombreGrupo;
    }

    public String getObsGrupo() {
        return obsGrupo;
    }

    public void setObsGrupo(String obsGrupo) {
        this.obsGrupo = obsGrupo;
    }
    
}
