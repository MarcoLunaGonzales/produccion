/*
 * Gestiones.java
 *
 * Created on 19 de marzo de 2008, 11:06
 */

package com.cofar.bean;

/**
 *
 * @author Wilmer Manzaneda chavez
 * @company COFAR
 */
public class Gestiones {
    
    /** Creates a new instance of Gestiones */
    private String codGestion="";
    private String nombreGestion="";
    private String gestionEstado="";
    
    
    public Gestiones() {
    }

    public String getCodGestion() {
        return codGestion;
    }

    public void setCodGestion(String codGestion) {
        this.codGestion = codGestion;
    }

    public String getNombreGestion() {
        return nombreGestion;
    }

    public void setNombreGestion(String nombreGestion) {
        this.nombreGestion = nombreGestion;
    }

    public String getGestionEstado() {
        return gestionEstado;
    }

    public void setGestionEstado(String gestionEstado) {
        this.gestionEstado = gestionEstado;
    }
    
}
