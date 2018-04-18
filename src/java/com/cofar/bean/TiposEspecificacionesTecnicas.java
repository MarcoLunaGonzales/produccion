/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.cofar.bean;

import java.util.List;

/**
 *
 * @author aquispe
 */
public class TiposEspecificacionesTecnicas extends AbstractBean {
    private int codTipoEspecificacionTecnica=0;
    private String nombreTipoEspecificacionTecnica="";
    private EstadoReferencial estadoRegistro=new EstadoReferencial();
    private List<EspecificacionesTecnicasPresentacion> especificacionesTecnicasPresentacionesList=null;
    public TiposEspecificacionesTecnicas() {
    }

    public int getCodTipoEspecificacionTecnica() {
        return codTipoEspecificacionTecnica;
    }

    public void setCodTipoEspecificacionTecnica(int codTipoEspecificacionTecnica) {
        this.codTipoEspecificacionTecnica = codTipoEspecificacionTecnica;
    }

    public EstadoReferencial getEstadoRegistro() {
        return estadoRegistro;
    }

    public void setEstadoRegistro(EstadoReferencial estadoRegistro) {
        this.estadoRegistro = estadoRegistro;
    }

    public String getNombreTipoEspecificacionTecnica() {
        return nombreTipoEspecificacionTecnica;
    }

    public void setNombreTipoEspecificacionTecnica(String nombreTipoEspecificacionTecnica) {
        this.nombreTipoEspecificacionTecnica = nombreTipoEspecificacionTecnica;
    }

    public List<EspecificacionesTecnicasPresentacion> getEspecificacionesTecnicasPresentacionesList() {
        return especificacionesTecnicasPresentacionesList;
    }

    public void setEspecificacionesTecnicasPresentacionesList(List<EspecificacionesTecnicasPresentacion> especificacionesTecnicasPresentacionesList) {
        this.especificacionesTecnicasPresentacionesList = especificacionesTecnicasPresentacionesList;
    }
    public int getCantidadEspecificacionesPresentacion()
    {
        return this.especificacionesTecnicasPresentacionesList.size();
    }

    

}
