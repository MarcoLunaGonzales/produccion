/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.cofar.bean;

/**
 *
 * @author aquispe
 */
public class DefectosEnvasePersonal extends AbstractBean{

    private Personal personal=new Personal();
    private double cantidadDefectosEncontrados=0d;

    public DefectosEnvasePersonal() {
    }

    public double getCantidadDefectosEncontrados() {
        return cantidadDefectosEncontrados;
    }

    public void setCantidadDefectosEncontrados(double cantidadDefectosEncontrados) {
        this.cantidadDefectosEncontrados = cantidadDefectosEncontrados;
    }

    public Personal getPersonal() {
        return personal;
    }

    public void setPersonal(Personal personal) {
        this.personal = personal;
    }
    


}
