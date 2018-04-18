/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.cofar.bean;

/**
 *
 * @author DASISAQ-
 */
public class FormulaMaestraVersionModificacion extends AbstractBean{
    private Personal personal=new Personal();
    private EstadosVersionFormulaMaestra estadosVersionFormulaMaestra=new EstadosVersionFormulaMaestra();

    public FormulaMaestraVersionModificacion() {
    }

    public EstadosVersionFormulaMaestra getEstadosVersionFormulaMaestra() {
        return estadosVersionFormulaMaestra;
    }

    public void setEstadosVersionFormulaMaestra(EstadosVersionFormulaMaestra estadosVersionFormulaMaestra) {
        this.estadosVersionFormulaMaestra = estadosVersionFormulaMaestra;
    }

    public Personal getPersonal() {
        return personal;
    }

    public void setPersonal(Personal personal) {
        this.personal = personal;
    }
    

}
