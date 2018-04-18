/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.cofar.bean;

/**
 *
 * @author DASISAQ-
 */
public class PermisosVersionCp extends AbstractBean {
    private Personal personal=new Personal();
    private int codTipoModificacion=0;

    public int getCodTipoModificacion() {
        return codTipoModificacion;
    }

    public void setCodTipoModificacion(int codTipoModificacion) {
        this.codTipoModificacion = codTipoModificacion;
    }

    public Personal getPersonal() {
        return personal;
    }

    public void setPersonal(Personal personal) {
        this.personal = personal;
    }
    

}
