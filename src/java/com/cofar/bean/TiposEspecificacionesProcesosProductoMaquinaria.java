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
public class TiposEspecificacionesProcesosProductoMaquinaria extends AbstractBean
{
    private int codTipoEspecificacionProcesoProductoMaquinaria=0;
    private String nombreTipoEspecificacionProcesoProductoMaquinaria="";

    public int getCodTipoEspecificacionProcesoProductoMaquinaria() {
        return codTipoEspecificacionProcesoProductoMaquinaria;
    }

    public void setCodTipoEspecificacionProcesoProductoMaquinaria(int codTipoEspecificacionProcesoProductoMaquinaria) {
        this.codTipoEspecificacionProcesoProductoMaquinaria = codTipoEspecificacionProcesoProductoMaquinaria;
    }

    public String getNombreTipoEspecificacionProcesoProductoMaquinaria() {
        return nombreTipoEspecificacionProcesoProductoMaquinaria;
    }

    public void setNombreTipoEspecificacionProcesoProductoMaquinaria(String nombreTipoEspecificacionProcesoProductoMaquinaria) {
        this.nombreTipoEspecificacionProcesoProductoMaquinaria = nombreTipoEspecificacionProcesoProductoMaquinaria;
    }
    
    
}
