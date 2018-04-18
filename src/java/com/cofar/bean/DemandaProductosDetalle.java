/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.cofar.bean;

/**
 *
 * @author hvaldivia
 */
public class DemandaProductosDetalle {
    FormulaMaestra formulaMaestra = new FormulaMaestra();
    double cantProdMC = 0.0;
    double cantProdMM = 0.0;
    double cantProdMI = 0.0;
    double cantLotesMC = 0.0;
    double cantLotesMM = 0.0;
    double cantLotesMI = 0.0;

    int nroLotes = 0;

    public double getCantProdMC() {
        return cantProdMC;
    }

    public void setCantProdMC(double cantProdMC) {
        this.cantProdMC = cantProdMC;
    }

    public double getCantProdMI() {
        return cantProdMI;
    }

    public void setCantProdMI(double cantProdMI) {
        this.cantProdMI = cantProdMI;
    }

    public double getCantProdMM() {
        return cantProdMM;
    }

    public void setCantProdMM(double cantProdMM) {
        this.cantProdMM = cantProdMM;
    }

    public FormulaMaestra getFormulaMaestra() {
        return formulaMaestra;
    }

    public void setFormulaMaestra(FormulaMaestra formulaMaestra) {
        this.formulaMaestra = formulaMaestra;
    }

    public int getNroLotes() {
        return nroLotes;
    }

    public void setNroLotes(int nroLotes) {
        this.nroLotes = nroLotes;
    }

    public double getCantLotesMC() {
        return cantLotesMC;
    }

    public void setCantLotesMC(double cantLotesMC) {
        this.cantLotesMC = cantLotesMC;
    }

    public double getCantLotesMI() {
        return cantLotesMI;
    }

    public void setCantLotesMI(double cantLotesMI) {
        this.cantLotesMI = cantLotesMI;
    }

    public double getCantLotesMM() {
        return cantLotesMM;
    }

    public void setCantLotesMM(double cantLotesMM) {
        this.cantLotesMM = cantLotesMM;
    }



    

    

}
