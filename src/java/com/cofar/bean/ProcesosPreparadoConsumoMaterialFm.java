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
public class ProcesosPreparadoConsumoMaterialFm extends AbstractBean {
    
    private FormulaMaestraDetalleMPfracciones formulaMaestraDetalleMPfracciones=new FormulaMaestraDetalleMPfracciones();

    public ProcesosPreparadoConsumoMaterialFm() {
    }

    public FormulaMaestraDetalleMPfracciones getFormulaMaestraDetalleMPfracciones() {
        return formulaMaestraDetalleMPfracciones;
    }

    public void setFormulaMaestraDetalleMPfracciones(FormulaMaestraDetalleMPfracciones formulaMaestraDetalleMPfracciones) {
        this.formulaMaestraDetalleMPfracciones = formulaMaestraDetalleMPfracciones;
    }
    
    
}
