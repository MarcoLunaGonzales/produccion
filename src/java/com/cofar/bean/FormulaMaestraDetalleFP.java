/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.cofar.bean;

/**
 *
 * @author hvaldivia
 */
public class FormulaMaestraDetalleFP extends  AbstractBean{

    int codFasePreparado = 0;
    FormulaMaestraPreparado formulaMaestraPreparado = new FormulaMaestraPreparado();
    String descripcionFase = "";
    int ordenFasePreparado = 0;

    public int getCodFasePreparado() {
        return codFasePreparado;
    }

    public void setCodFasePreparado(int codFasePreparado) {
        this.codFasePreparado = codFasePreparado;
    }

    public String getDescripcionFase() {
        return descripcionFase;
    }

    public void setDescripcionFase(String descripcionFase) {
        this.descripcionFase = descripcionFase;
    }
    

    public int getOrdenFasePreparado() {
        return ordenFasePreparado;
    }

    public void setOrdenFasePreparado(int ordenFasePreparado) {
        this.ordenFasePreparado = ordenFasePreparado;
    }

    public FormulaMaestraPreparado getFormulaMaestraPreparado() {
        return formulaMaestraPreparado;
    }

    public void setFormulaMaestraPreparado(FormulaMaestraPreparado formulaMaestraPreparado) {
        this.formulaMaestraPreparado = formulaMaestraPreparado;
    }

    
    
}
