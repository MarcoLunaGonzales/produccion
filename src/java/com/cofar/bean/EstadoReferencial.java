/*
 * EstadoCivilPersona.java
 *
 * Created on 7 de marzo de 2008, 16:28
 */

package com.cofar.bean;

/**
 *
 * @author Wilmer Manzaneda chavez
 * @company COFAR
 */
public class EstadoReferencial {
    
    /** Creates a new instance of EstadoCivilPersona */
    private String codEstadoRegistro="1";
    private String nombreEstadoRegistro="";
    public EstadoReferencial() {
    }

    public String getCodEstadoRegistro() {
        return codEstadoRegistro;
    }

    public void setCodEstadoRegistro(String codEstadoRegistro) {
        this.codEstadoRegistro = codEstadoRegistro;
    }

    public String getNombreEstadoRegistro() {
        return nombreEstadoRegistro;
    }

    public void setNombreEstadoRegistro(String nombreEstadoRegistro) {
        this.nombreEstadoRegistro = nombreEstadoRegistro;
    }

 
}
