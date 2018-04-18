/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.cofar.bean;

/**
 *
 * @author hvaldivia
 */
public class FormulaMaestraPreparado extends AbstractBean{
    FormulaMaestra formulaMaestra = new FormulaMaestra();
    int codPreparado = 0;
    String descripcionPrecaucion = "";
    String observacion = "";
    Maquinaria maquinaria = new Maquinaria();
    PartesMaquinaria partesMaquinaria = new PartesMaquinaria();
    float temperaturaMaxima = 0;
    float humedadRelativaMaxima = 0;

    public int getCodPreparado() {
        return codPreparado;
    }

    public void setCodPreparado(int codPreparado) {
        this.codPreparado = codPreparado;
    }

    public String getDescripcionPrecaucion() {
        return descripcionPrecaucion;
    }

    public void setDescripcionPrecaucion(String descripcionPrecaucion) {
        this.descripcionPrecaucion = descripcionPrecaucion;
    }

    public FormulaMaestra getFormulaMaestra() {
        return formulaMaestra;
    }

    public void setFormulaMaestra(FormulaMaestra formulaMaestra) {
        this.formulaMaestra = formulaMaestra;
    }

    public float getHumedadRelativaMaxima() {
        return humedadRelativaMaxima;
    }

    public void setHumedadRelativaMaxima(float humedadRelativaMaxima) {
        this.humedadRelativaMaxima = humedadRelativaMaxima;
    }

    public Maquinaria getMaquinaria() {
        return maquinaria;
    }

    public void setMaquinaria(Maquinaria maquinaria) {
        this.maquinaria = maquinaria;
    }

    public String getObservacion() {
        return observacion;
    }

    public void setObservacion(String observacion) {
        this.observacion = observacion;
    }

    public float getTemperaturaMaxima() {
        return temperaturaMaxima;
    }

    public void setTemperaturaMaxima(float temperaturaMaxima) {
        this.temperaturaMaxima = temperaturaMaxima;
    }

    public PartesMaquinaria getPartesMaquinaria() {
        return partesMaquinaria;
    }

    public void setPartesMaquinaria(PartesMaquinaria partesMaquinaria) {
        this.partesMaquinaria = partesMaquinaria;
    }

   


}
