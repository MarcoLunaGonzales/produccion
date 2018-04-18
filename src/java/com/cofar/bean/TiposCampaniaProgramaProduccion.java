/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.cofar.bean;

/**
 *
 * @author DASISAQ-
 */
public class TiposCampaniaProgramaProduccion extends AbstractBean {
    private int codTipoCampaniaProgramaProduccion=0;
    private String nombreTipoCampaniaProgramaProduccion="";

    public TiposCampaniaProgramaProduccion() {
    }

    public int getCodTipoCampaniaProgramaProduccion() {
        return codTipoCampaniaProgramaProduccion;
    }

    public void setCodTipoCampaniaProgramaProduccion(int codTipoCampaniaProgramaProduccion) {
        this.codTipoCampaniaProgramaProduccion = codTipoCampaniaProgramaProduccion;
    }

    public String getNombreTipoCampaniaProgramaProduccion() {
        return nombreTipoCampaniaProgramaProduccion;
    }

    public void setNombreTipoCampaniaProgramaProduccion(String nombreTipoCampaniaProgramaProduccion) {
        this.nombreTipoCampaniaProgramaProduccion = nombreTipoCampaniaProgramaProduccion;
    }
    

}
