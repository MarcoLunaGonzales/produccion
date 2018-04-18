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
public class ProtocoloMantenimientoVersionDetalleMateriales extends AbstractBean
{
    private int codProtocoloMantenimientoVersionDetalleMaterial=0;
    private Materiales materiales=new Materiales();
    private UnidadesMedida unidadesMedida=new UnidadesMedida();
    private Double cantidadMaterial=0d;

    public ProtocoloMantenimientoVersionDetalleMateriales()
    {
    }

    public Materiales getMateriales() {
        return materiales;
    }

    public void setMateriales(Materiales materiales) {
        this.materiales = materiales;
    }

    public UnidadesMedida getUnidadesMedida() {
        return unidadesMedida;
    }

    public void setUnidadesMedida(UnidadesMedida unidadesMedida) {
        this.unidadesMedida = unidadesMedida;
    }

    public Double getCantidadMaterial() {
        return cantidadMaterial;
    }

    public void setCantidadMaterial(Double cantidadMaterial) {
        this.cantidadMaterial = cantidadMaterial;
    }

    public int getCodProtocoloMantenimientoVersionDetalleMaterial() {
        return codProtocoloMantenimientoVersionDetalleMaterial;
    }

    public void setCodProtocoloMantenimientoVersionDetalleMaterial(int codProtocoloMantenimientoVersionDetalleMaterial) {
        this.codProtocoloMantenimientoVersionDetalleMaterial = codProtocoloMantenimientoVersionDetalleMaterial;
    }
    
    
}
