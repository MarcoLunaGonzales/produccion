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
public class TiposMantenimientoMaquinaria extends AbstractBean 
{
    private int codTipoMantenimientoMaquinaria=0;
    private String nombreTipoMantenimientoMaquinaria="";
    private EstadoReferencial estadoRegistro=new EstadoReferencial();

    public TiposMantenimientoMaquinaria() {
    }

    public int getCodTipoMantenimientoMaquinaria() {
        return codTipoMantenimientoMaquinaria;
    }

    public void setCodTipoMantenimientoMaquinaria(int codTipoMantenimientoMaquinaria) {
        this.codTipoMantenimientoMaquinaria = codTipoMantenimientoMaquinaria;
    }

    public String getNombreTipoMantenimientoMaquinaria() {
        return nombreTipoMantenimientoMaquinaria;
    }

    public void setNombreTipoMantenimientoMaquinaria(String nombreTipoMantenimientoMaquinaria) {
        this.nombreTipoMantenimientoMaquinaria = nombreTipoMantenimientoMaquinaria;
    }

    public EstadoReferencial getEstadoRegistro() {
        return estadoRegistro;
    }

    public void setEstadoRegistro(EstadoReferencial estadoRegistro) {
        this.estadoRegistro = estadoRegistro;
    }
    
    
}
