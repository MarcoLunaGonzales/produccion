/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.cofar.bean;

/**
 *
 * @author hvaldivia
 */
public class FormulaMaestraDetalleFPActividad extends AbstractBean {
    int codFaseActividad = 0;
    FormulaMaestraDetalleFP formulaMaestraFasePreparado  = new FormulaMaestraDetalleFP();
    String descripcionActividad = "";
    float tiempoActividad = 0;
    int nroRepeticiones = 0;
    String observacion = "";
    float temperaturaFinal1 = 0;
    float temperaturaFinal2 = 0;

    public int getCodFaseActividad() {
        return codFaseActividad;
    }

    public void setCodFaseActividad(int codFaseActividad) {
        this.codFaseActividad = codFaseActividad;
    }


    public String getDescripcionActividad() {
        return descripcionActividad;
    }

    public void setDescripcionActividad(String descripcionActividad) {
        this.descripcionActividad = descripcionActividad;
    }

    public int getNroRepeticiones() {
        return nroRepeticiones;
    }

    public void setNroRepeticiones(int nroRepeticiones) {
        this.nroRepeticiones = nroRepeticiones;
    }

    public String getObservacion() {
        return observacion;
    }

    public void setObservacion(String observacion) {
        this.observacion = observacion;
    }

    public float getTemperaturaFinal1() {
        return temperaturaFinal1;
    }

    public void setTemperaturaFinal1(float temperaturaFinal1) {
        this.temperaturaFinal1 = temperaturaFinal1;
    }

    public float getTemperaturaFinal2() {
        return temperaturaFinal2;
    }

    public void setTemperaturaFinal2(float temperaturaFinal2) {
        this.temperaturaFinal2 = temperaturaFinal2;
    }

    public float getTiempoActividad() {
        return tiempoActividad;
    }

    public void setTiempoActividad(float tiempoActividad) {
        this.tiempoActividad = tiempoActividad;
    }

    public FormulaMaestraDetalleFP getFormulaMaestraFasePreparado() {
        return formulaMaestraFasePreparado;
    }

    public void setFormulaMaestraFasePreparado(FormulaMaestraDetalleFP formulaMaestraFasePreparado) {
        this.formulaMaestraFasePreparado = formulaMaestraFasePreparado;
    }

}
