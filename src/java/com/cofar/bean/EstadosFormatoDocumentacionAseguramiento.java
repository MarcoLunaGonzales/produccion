/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.cofar.bean;

/**
 *
 * @author DASISAQ
 */
public class EstadosFormatoDocumentacionAseguramiento extends AbstractBean
{
    private int codEstadoFormatoDocumentacionAseguramiento=0;
    private String nombreEstadosFormatoDocumentacionAseguramiento="";

    public EstadosFormatoDocumentacionAseguramiento() {
    }

    public int getCodEstadoFormatoDocumentacionAseguramiento() {
        return codEstadoFormatoDocumentacionAseguramiento;
    }

    public void setCodEstadoFormatoDocumentacionAseguramiento(int codEstadoFormatoDocumentacionAseguramiento) {
        this.codEstadoFormatoDocumentacionAseguramiento = codEstadoFormatoDocumentacionAseguramiento;
    }

    public String getNombreEstadosFormatoDocumentacionAseguramiento() {
        return nombreEstadosFormatoDocumentacionAseguramiento;
    }

    public void setNombreEstadosFormatoDocumentacionAseguramiento(String nombreEstadosFormatoDocumentacionAseguramiento) {
        this.nombreEstadosFormatoDocumentacionAseguramiento = nombreEstadosFormatoDocumentacionAseguramiento;
    }
    
    
}
