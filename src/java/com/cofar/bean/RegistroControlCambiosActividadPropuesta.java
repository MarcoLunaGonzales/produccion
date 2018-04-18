/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.cofar.bean;

/**
 *
 * @author DASISAQ-
 */
public class RegistroControlCambiosActividadPropuesta extends AbstractBean{
    private Personal personal=new Personal();
    private String actividadSugerida="";

    public RegistroControlCambiosActividadPropuesta() {
    }
    
    
    

    public String getActividadSugerida() {
        return actividadSugerida;
    }

    public void setActividadSugerida(String actividadSugerida) {
        this.actividadSugerida = actividadSugerida;
    }

    public Personal getPersonal() {
        return personal;
    }

    public void setPersonal(Personal personal) {
        this.personal = personal;
    }


}
