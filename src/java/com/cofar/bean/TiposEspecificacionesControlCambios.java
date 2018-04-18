/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.cofar.bean;

import java.util.List;

/**
 *
 * @author DASISAQ-
 */
public class TiposEspecificacionesControlCambios extends AbstractBean{
    private int codTipoEspecificacionControlCambios=0;
    private String nombreTipoEspecificacionControlCambios="";
    private List<EspecificacionesControlCambios> especificacionesControlCambiosList=null;

    public TiposEspecificacionesControlCambios() {
    }

    public int getCodTipoEspecificacionControlCambios() {
        return codTipoEspecificacionControlCambios;
    }

    public void setCodTipoEspecificacionControlCambios(int codTipoEspecificacionControlCambios) {
        this.codTipoEspecificacionControlCambios = codTipoEspecificacionControlCambios;
    }

    public List<EspecificacionesControlCambios> getEspecificacionesControlCambiosList() {
        return especificacionesControlCambiosList;
    }

    public void setEspecificacionesControlCambiosList(List<EspecificacionesControlCambios> especificacionesControlCambiosList) {
        this.especificacionesControlCambiosList = especificacionesControlCambiosList;
    }

    public String getNombreTipoEspecificacionControlCambios() {
        return nombreTipoEspecificacionControlCambios;
    }

    public void setNombreTipoEspecificacionControlCambios(String nombreTipoEspecificacionControlCambios) {
        this.nombreTipoEspecificacionControlCambios = nombreTipoEspecificacionControlCambios;
    }
    

}
