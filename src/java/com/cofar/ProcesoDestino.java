/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.cofar;

/**
 *
 * @author DASISAQ
 */
public class ProcesoDestino
{
    private int codProcesoDestino;
    private String descripcionEnlace;

    public ProcesoDestino(int codProcesoDestino, String descripcionEnlace) {
        this.codProcesoDestino = codProcesoDestino;
        this.descripcionEnlace = descripcionEnlace;
    }

    
    
    
    public int getCodProcesoDestino() {
        return codProcesoDestino;
    }

    public void setCodProcesoDestino(int codProcesoDestino) {
        this.codProcesoDestino = codProcesoDestino;
    }

    public String getDescripcionEnlace() {
        return descripcionEnlace;
    }

    public void setDescripcionEnlace(String descripcionEnlace) {
        this.descripcionEnlace = descripcionEnlace;
    }

}
