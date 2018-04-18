/*
 * Cargos.java
 *
 * Created on 7 de marzo de 2008, 16:26
 */

package com.cofar.bean;

/**
 *
 * @author Wilmer Manzaneda chavez
 * @company COFAR
 */
public class Cargos {
    
    /** Creates a new instance of Cargos */
    private String codigoCargo="";
    private String descripcionCargo="";
    public Cargos() {
    }

    public String getCodigoCargo() {
        return codigoCargo;
    }

    public void setCodigoCargo(String codigoCargo) {
        this.codigoCargo = codigoCargo;
    }

    public String getDescripcionCargo() {
        return descripcionCargo;
    }

    public void setDescripcionCargo(String descripcionCargo) {
        this.descripcionCargo = descripcionCargo;
    }
    
}
