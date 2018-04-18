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
public class CampaniaProgramaProduccion extends AbstractBean{
    private int codCampaniaProgramaProduccion=0;
    private String nombreCampaniaProgramaProduccion="";
    private ProgramaProduccionPeriodo programaProduccionPeriodo=new ProgramaProduccionPeriodo();
    private TiposCampaniaProgramaProduccion tiposCampaniaProgramaProduccion=new TiposCampaniaProgramaProduccion();
    private ComponentesProd componentesProd=new ComponentesProd();
    private List<CampaniaProgramaProduccionDetalle> campaniaProgramaProduccionDetalleList=null;
    public CampaniaProgramaProduccion() {
    }

    public int getCodCampaniaProgramaProduccion() {
        return codCampaniaProgramaProduccion;
    }

    public void setCodCampaniaProgramaProduccion(int codCampaniaProgramaProduccion) {
        this.codCampaniaProgramaProduccion = codCampaniaProgramaProduccion;
    }

    public String getNombreCampaniaProgramaProduccion() {
        return nombreCampaniaProgramaProduccion;
    }

    public void setNombreCampaniaProgramaProduccion(String nombreCampaniaProgramaProduccion) {
        this.nombreCampaniaProgramaProduccion = nombreCampaniaProgramaProduccion;
    }

    

    public ProgramaProduccionPeriodo getProgramaProduccionPeriodo() {
        return programaProduccionPeriodo;
    }

    public void setProgramaProduccionPeriodo(ProgramaProduccionPeriodo programaProduccionPeriodo) {
        this.programaProduccionPeriodo = programaProduccionPeriodo;
    }

    public TiposCampaniaProgramaProduccion getTiposCampaniaProgramaProduccion() {
        return tiposCampaniaProgramaProduccion;
    }

    public void setTiposCampaniaProgramaProduccion(TiposCampaniaProgramaProduccion tiposCampaniaProgramaProduccion) {
        this.tiposCampaniaProgramaProduccion = tiposCampaniaProgramaProduccion;
    }

    public ComponentesProd getComponentesProd() {
        return componentesProd;
    }

    public void setComponentesProd(ComponentesProd componentesProd) {
        this.componentesProd = componentesProd;
    }

    public List<CampaniaProgramaProduccionDetalle> getCampaniaProgramaProduccionDetalleList() {
        return campaniaProgramaProduccionDetalleList;
    }

    public void setCampaniaProgramaProduccionDetalleList(List<CampaniaProgramaProduccionDetalle> campaniaProgramaProduccionDetalleList) {
        this.campaniaProgramaProduccionDetalleList = campaniaProgramaProduccionDetalleList;
    }
    public int getCampaniaProgramaProduccionDetalleListLength()
    {
        return (this.campaniaProgramaProduccionDetalleList!=null?this.campaniaProgramaProduccionDetalleList.size():0);
    }

    

}
