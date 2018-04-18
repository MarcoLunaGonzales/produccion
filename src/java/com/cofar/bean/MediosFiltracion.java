/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.cofar.bean;

/**
 *
 * @author DASISAQ-
 */
public class MediosFiltracion extends AbstractBean
{
    private int codMedioFiltracion=0;
    private String nombreMedioFiltracion="";
    private EstadoReferencial estadoRegistro=new EstadoReferencial();

    public MediosFiltracion() {
    }

    public int getCodMedioFiltracion() {
        return codMedioFiltracion;
    }

    public void setCodMedioFiltracion(int codMedioFiltracion) {
        this.codMedioFiltracion = codMedioFiltracion;
    }

    public String getNombreMedioFiltracion() {
        return nombreMedioFiltracion;
    }

    public void setNombreMedioFiltracion(String nombreMedioFiltracion) {
        this.nombreMedioFiltracion = nombreMedioFiltracion;
    }

    public EstadoReferencial getEstadoRegistro() {
        return estadoRegistro;
    }

    public void setEstadoRegistro(EstadoReferencial estadoRegistro) {
        this.estadoRegistro = estadoRegistro;
    }
    
    
}
