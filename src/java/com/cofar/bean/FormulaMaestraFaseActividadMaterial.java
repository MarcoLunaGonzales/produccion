/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.cofar.bean;

/**
 *
 * @author hvaldivia
 */
public class FormulaMaestraFaseActividadMaterial {
    int codFaseMaterial = 0;
    FormulaMaestraDetalleFPActividad formulaMaestraFaseActividad = new FormulaMaestraDetalleFPActividad();
    Materiales materiales = new Materiales();
    UnidadesMedida unidadesMedida = new UnidadesMedida();
    float cantidad = 0;

    public float getCantidad() {
        return cantidad;
    }

    public void setCantidad(float cantidad) {
        this.cantidad = cantidad;
    }

    public int getCodFaseMaterial() {
        return codFaseMaterial;
    }

    public void setCodFaseMaterial(int codFaseMaterial) {
        this.codFaseMaterial = codFaseMaterial;
    }

    public FormulaMaestraDetalleFPActividad getFormulaMaestraFaseActividad() {
        return formulaMaestraFaseActividad;
    }

    public void setFormulaMaestraFaseActividad(FormulaMaestraDetalleFPActividad formulaMaestraFaseActividad) {
        this.formulaMaestraFaseActividad = formulaMaestraFaseActividad;
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

    

}
