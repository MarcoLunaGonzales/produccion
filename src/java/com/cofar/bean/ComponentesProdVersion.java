/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.cofar.bean;

import java.util.Date;
import java.util.List;

/**
 *
 * @author DASISAQ-
 */
public class ComponentesProdVersion extends ComponentesProd
{
    private EstadosVersionComponentesProd estadosVersionComponentesProd=new EstadosVersionComponentesProd();
    private int codVersion=0;
    private int nroVersion=0;
    private Date fechaModificacion = new Date();
    private Personal personaCreacion = new Personal();
    private Date fechaInicioVigencia = new Date();
    private List<ComponentesProdVersionModificacion> componentesProdVersionModificacionList=null;
    private List<ComponentesProdConcentracion> componentesProdConcentracionList=null;
    private TiposModificacionProducto tiposModificacionProducto=new TiposModificacionProducto();
    
    //listado de lotes asociados
    private List<ProgramaProduccion> programaProduccionList;
    
    //cantidad de desviaciones de la version
    private int cantidadLotesConDesviacion = 0;
    
    //para navegador setear estado
    private ComponentesProdVersionModificacion componentesProdVersionModificacionPersonal;
    
    
    public ComponentesProdVersion() {
    }

    public int getCodVersion() {
        return codVersion;
    }

    public void setCodVersion(int codVersion) {
        this.codVersion = codVersion;
    }

    public EstadosVersionComponentesProd getEstadosVersionComponentesProd() {
        return estadosVersionComponentesProd;
    }

    public void setEstadosVersionComponentesProd(EstadosVersionComponentesProd estadosVersionComponentesProd) {
        this.estadosVersionComponentesProd = estadosVersionComponentesProd;
    }

    public Date getFechaInicioVigencia() {
        return fechaInicioVigencia;
    }

    public void setFechaInicioVigencia(Date fechaInicioVigencia) {
        this.fechaInicioVigencia = fechaInicioVigencia;
    }

    public Date getFechaModificacion() {
        return fechaModificacion;
    }

    public void setFechaModificacion(Date fechaModificacion) {
        this.fechaModificacion = fechaModificacion;
    }

    public Personal getPersonaCreacion() {
        return personaCreacion;
    }

    public void setPersonaCreacion(Personal personaCreacion) {
        this.personaCreacion = personaCreacion;
    }

    public int getNroVersion() {
        return nroVersion;
    }

    public void setNroVersion(int nroVersion) {
        this.nroVersion = nroVersion;
    }

    public List<ComponentesProdVersionModificacion> getComponentesProdVersionModificacionList() {
        return componentesProdVersionModificacionList;
    }

    public void setComponentesProdVersionModificacionList(List<ComponentesProdVersionModificacion> componentesProdVersionModificacionList) {
        this.componentesProdVersionModificacionList = componentesProdVersionModificacionList;
    }
    
    public int getComponentesProdVersionModificacionListSize()
    {
        return (this.componentesProdVersionModificacionList!=null?this.componentesProdVersionModificacionList.size():0);
    }

    public List<ComponentesProdConcentracion> getComponentesProdConcentracionList() {
        return componentesProdConcentracionList;
    }

    public void setComponentesProdConcentracionList(List<ComponentesProdConcentracion> componentesProdConcentracionList) {
        this.componentesProdConcentracionList = componentesProdConcentracionList;
    }

    public TiposModificacionProducto getTiposModificacionProducto() {
        return tiposModificacionProducto;
    }

    public void setTiposModificacionProducto(TiposModificacionProducto tiposModificacionProducto) {
        this.tiposModificacionProducto = tiposModificacionProducto;
    }

    public ComponentesProdVersionModificacion getComponentesProdVersionModificacionPersonal() {
        return componentesProdVersionModificacionPersonal;
    }

    public void setComponentesProdVersionModificacionPersonal(ComponentesProdVersionModificacion componentesProdVersionModificacionPersonal) {
        this.componentesProdVersionModificacionPersonal = componentesProdVersionModificacionPersonal;
    }

    public List<ProgramaProduccion> getProgramaProduccionList() {
        return programaProduccionList;
    }

    public void setProgramaProduccionList(List<ProgramaProduccion> programaProduccionList) {
        this.programaProduccionList = programaProduccionList;
    }

    public int getCantidadLotesConDesviacion() {
        return cantidadLotesConDesviacion;
    }

    public void setCantidadLotesConDesviacion(int cantidadLotesConDesviacion) {
        this.cantidadLotesConDesviacion = cantidadLotesConDesviacion;
    }

    
    
    
    
}
