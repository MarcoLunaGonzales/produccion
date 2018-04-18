/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.cofar.bean;

/**
 *
 * @author DASISAQ-
 */
public class TiposModificacionFormula extends AbstractBean {
    private int codTipoModificacionFormula=0;
    private String nombreTipoModificacionFormula="";
    private EstadoReferencial estadoRegistro=new EstadoReferencial();

    public TiposModificacionFormula() {
    }

    public int getCodTipoModificacionFormula() {
        return codTipoModificacionFormula;
    }

    public void setCodTipoModificacionFormula(int codTipoModificacionFormula) {
        this.codTipoModificacionFormula = codTipoModificacionFormula;
    }

    public EstadoReferencial getEstadoRegistro() {
        return estadoRegistro;
    }

    public void setEstadoRegistro(EstadoReferencial estadoRegistro) {
        this.estadoRegistro = estadoRegistro;
    }

    public String getNombreTipoModificacionFormula() {
        return nombreTipoModificacionFormula;
    }

    public void setNombreTipoModificacionFormula(String nombreTipoModificacionFormula) {
        this.nombreTipoModificacionFormula = nombreTipoModificacionFormula;
    }
}
