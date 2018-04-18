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
public class MaterialesGenericos extends AbstractBean
{
    private int codMaterialGenerico=0;
    private String nombreMaterialGenerico="";
    private EstadoReferencial estadoRegistro=new EstadoReferencial();

    public MaterialesGenericos() {
    }

    public int getCodMaterialGenerico() {
        return codMaterialGenerico;
    }

    public void setCodMaterialGenerico(int codMaterialGenerico) {
        this.codMaterialGenerico = codMaterialGenerico;
    }

    public String getNombreMaterialGenerico() {
        return nombreMaterialGenerico;
    }

    public void setNombreMaterialGenerico(String nombreMaterialGenerico) {
        this.nombreMaterialGenerico = nombreMaterialGenerico;
    }

    public EstadoReferencial getEstadoRegistro() {
        return estadoRegistro;
    }

    public void setEstadoRegistro(EstadoReferencial estadoRegistro) {
        this.estadoRegistro = estadoRegistro;
    }
    
    
}
