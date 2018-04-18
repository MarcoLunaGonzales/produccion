/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.cofar.bean;

/**
 *
 * @author hvaldivia
 */
public class FormulaMaestraDetalleFPActividadMaterial extends AbstractBean {
    int codFaseMaterial = 0;
    FormulaMaestraDetalleFPActividad formulaMaestraDetalleFPActividad = new FormulaMaestraDetalleFPActividad();
    FormulaMaestraDetalleFP formulaMaestraDetalleFP = new FormulaMaestraDetalleFP();
    Materiales materiales = new Materiales();
    float cantidad = 0;
    float temperatura1 = 0;
    float temperatura2 = 0;
    

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

    public FormulaMaestraDetalleFPActividad getFormulaMaestraDetalleFPActividad() {
        return formulaMaestraDetalleFPActividad;
    }

    public void setFormulaMaestraDetalleFPActividad(FormulaMaestraDetalleFPActividad formulaMaestraDetalleFPActividad) {
        this.formulaMaestraDetalleFPActividad = formulaMaestraDetalleFPActividad;
    }

    public Materiales getMateriales() {
        return materiales;
    }

    public void setMateriales(Materiales materiales) {
        this.materiales = materiales;
    }

    public FormulaMaestraDetalleFP getFormulaMaestraDetalleFP() {
        return formulaMaestraDetalleFP;
    }

    public void setFormulaMaestraDetalleFP(FormulaMaestraDetalleFP formulaMaestraDetalleFP) {
        this.formulaMaestraDetalleFP = formulaMaestraDetalleFP;
    }

    public float getTemperatura1() {
        return temperatura1;
    }

    public void setTemperatura1(float temperatura1) {
        this.temperatura1 = temperatura1;
    }

    public float getTemperatura2() {
        return temperatura2;
    }

    public void setTemperatura2(float temperatura2) {
        this.temperatura2 = temperatura2;
    }

}
