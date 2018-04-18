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
public class MarcaMaquinaria extends AbstractBean
{
    private int codMarcaMaquinaria=0;
    private String nombreMarcaMaquinaria="";

    public MarcaMaquinaria() {
    }

    public int getCodMarcaMaquinaria() {
        return codMarcaMaquinaria;
    }

    public void setCodMarcaMaquinaria(int codMarcaMaquinaria) {
        this.codMarcaMaquinaria = codMarcaMaquinaria;
    }

    public String getNombreMarcaMaquinaria() {
        return nombreMarcaMaquinaria;
    }

    public void setNombreMarcaMaquinaria(String nombreMarcaMaquinaria) {
        this.nombreMarcaMaquinaria = nombreMarcaMaquinaria;
    }
    
    
}
