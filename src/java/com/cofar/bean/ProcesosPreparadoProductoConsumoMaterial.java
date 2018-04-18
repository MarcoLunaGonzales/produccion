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
public class ProcesosPreparadoProductoConsumoMaterial extends AbstractBean
{
    private Materiales materiales=new Materiales();
    private FormulaMaestraDetalleMPfracciones formulaMaestraDetalleMPfracciones=new FormulaMaestraDetalleMPfracciones();
    private FormulaMaestraDetalleMP formulaMaestraDetalleMP=new FormulaMaestraDetalleMP();
    private boolean materialTransitorio=false;
    private ProcesosPreparadoProducto procesosPreparadoProducto=new ProcesosPreparadoProducto();
    

    public ProcesosPreparadoProductoConsumoMaterial() {
    }

    public Materiales getMateriales() {
        return materiales;
    }

    public void setMateriales(Materiales materiales) {
        this.materiales = materiales;
    }

    public FormulaMaestraDetalleMPfracciones getFormulaMaestraDetalleMPfracciones() {
        return formulaMaestraDetalleMPfracciones;
    }

    public void setFormulaMaestraDetalleMPfracciones(FormulaMaestraDetalleMPfracciones formulaMaestraDetalleMPfracciones) {
        this.formulaMaestraDetalleMPfracciones = formulaMaestraDetalleMPfracciones;
    }

    public boolean isMaterialTransitorio() {
        return materialTransitorio;
    }

    public void setMaterialTransitorio(boolean materialTransitorio) {
        this.materialTransitorio = materialTransitorio;
    }

    public ProcesosPreparadoProducto getProcesosPreparadoProducto() {
        return procesosPreparadoProducto;
    }

    public void setProcesosPreparadoProducto(ProcesosPreparadoProducto procesosPreparadoProducto) {
        this.procesosPreparadoProducto = procesosPreparadoProducto;
    }

    

    public FormulaMaestraDetalleMP getFormulaMaestraDetalleMP() {
        return formulaMaestraDetalleMP;
    }

    public void setFormulaMaestraDetalleMP(FormulaMaestraDetalleMP formulaMaestraDetalleMP) {
        this.formulaMaestraDetalleMP = formulaMaestraDetalleMP;
    }
    
    
    
}
