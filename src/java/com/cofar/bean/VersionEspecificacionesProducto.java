/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.cofar.bean;

import java.util.Date;



/**
 *
 * @author DASISAQ
 */
public class VersionEspecificacionesProducto extends AbstractBean{
    private int codVersionEspecificacionProducto=0;
    private int nroVersionEspecificacionProducto=0;
    private Date fechaCreacion=new Date();
    private boolean versionActiva=false;
    private TipoAnalisis tipoAnalisis=new TipoAnalisis();
    private String observacion="";
    private Personal personalRegistra=new Personal();
    private Personal personalModifica=new Personal();

    public VersionEspecificacionesProducto() {
    }

    public int getCodVersionEspecificacionProducto() {
        return codVersionEspecificacionProducto;
    }

    public void setCodVersionEspecificacionProducto(int codVersionEspecificacionProducto) {
        this.codVersionEspecificacionProducto = codVersionEspecificacionProducto;
    }

    public Date getFechaCreacion() {
        return fechaCreacion;
    }

    public void setFechaCreacion(Date fechaCreacion) {
        this.fechaCreacion = fechaCreacion;
    }

    public int getNroVersionEspecificacionProducto() {
        return nroVersionEspecificacionProducto;
    }

    public void setNroVersionEspecificacionProducto(int nroVersionEspecificacionProducto) {
        this.nroVersionEspecificacionProducto = nroVersionEspecificacionProducto;
    }

    public TipoAnalisis getTipoAnalisis() {
        return tipoAnalisis;
    }

    public void setTipoAnalisis(TipoAnalisis tipoAnalisis) {
        this.tipoAnalisis = tipoAnalisis;
    }

    public boolean isVersionActiva() {
        return versionActiva;
    }

    public void setVersionActiva(boolean versionActiva) {
        this.versionActiva = versionActiva;
    }

    public String getObservacion() {
        return observacion;
    }

    public void setObservacion(String observacion) {
        this.observacion = observacion;
    }

    public Personal getPersonalModifica() {
        return personalModifica;
    }

    public void setPersonalModifica(Personal personalModifica) {
        this.personalModifica = personalModifica;
    }

    public Personal getPersonalRegistra() {
        return personalRegistra;
    }

    public void setPersonalRegistra(Personal personalRegistra) {
        this.personalRegistra = personalRegistra;
    }

    

}
