/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.cofar.bean;

/**
 *
 * @author wchoquehuanca
 */
public class TipoResultadoDescriptivo extends AbstractBean{

    private String codTipoResultadoDescriptivo="0";
    private String nombreTipoResultadoDescriptivo="";

    public TipoResultadoDescriptivo() {
    }

    public String getCodTipoResultadoDescriptivo() {
        return codTipoResultadoDescriptivo;
    }

    public void setCodTipoResultadoDescriptivo(String codTipoResultadoDescriptivo) {
        this.codTipoResultadoDescriptivo = codTipoResultadoDescriptivo;
    }

    public String getNombreTipoResultadoDescriptivo() {
        return nombreTipoResultadoDescriptivo;
    }

    public void setNombreTipoResultadoDescriptivo(String nombreTipoResultadoDescriptivo) {
        this.nombreTipoResultadoDescriptivo = nombreTipoResultadoDescriptivo;
    }


}
