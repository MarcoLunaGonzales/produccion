/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.cofar.bean;

/**
 *
 * @author DASISAQ-
 */
public class RegistroControlCambiosProposito extends AbstractBean{
    private String propositoCambio="";
    private Personal personal=new Personal();

    public Personal getPersonal() {
        return personal;
    }

    public void setPersonal(Personal personal) {
        this.personal = personal;
    }

    public String getPropositoCambio() {
        return propositoCambio;
    }

    public void setPropositoCambio(String propositoCambio) {
        this.propositoCambio = propositoCambio;
    }

    public RegistroControlCambiosProposito() {
    }
    

}
