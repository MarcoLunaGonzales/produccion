/*
 * LineaMKT.java
 *
 * Created on 21 de abril de 2008, 10:14 AM
 *
 * To change this template, choose Tools | Template Manager
 * and open the template in the editor.
 */

package com.cofar.bean;

import java.util.List;

/**
 *
 * @author rodrigo
 */
public class ActividadesFormulaMaestra extends AbstractBean
{
    private int codActividadFormula=0;
    private int ordenActividad=0;
    private FormulaMaestra formulaMaestra=new FormulaMaestra();
    private ActividadesProduccion actividadesProduccion=new ActividadesProduccion();
    private EstadoReferencial estadoReferencial=new EstadoReferencial();
    private List<MaquinariaActividadesFormula> maquinariaActividadesFormulaList=null;
    private PresentacionesProducto presentacionesProducto=new PresentacionesProducto();
    private AreasEmpresa areasEmpresa=new AreasEmpresa();
    private TiposProgramaProduccion tiposProgramaProduccion=new TiposProgramaProduccion();
    private ActividadFormulaMaestraBloque actividadFormulaMaestraBloque=new ActividadFormulaMaestraBloque();
    private List<ActividadesFormulaMaestraHorasEstandarMaquinaria> actividadesFormulaMaestraHorasEstandarMaquinariaList;

    public int getCodActividadFormula() {
        return codActividadFormula;
    }

    public void setCodActividadFormula(int codActividadFormula) {
        this.codActividadFormula = codActividadFormula;
    }
    
    public int getOrdenActividad() {
        return ordenActividad;
    }

    public void setOrdenActividad(int ordenActividad) {
        this.ordenActividad = ordenActividad;
    }

    public FormulaMaestra getFormulaMaestra() {
        return formulaMaestra;
    }

    public void setFormulaMaestra(FormulaMaestra formulaMaestra) {
        this.formulaMaestra = formulaMaestra;
    }

    public ActividadesProduccion getActividadesProduccion() {
        return actividadesProduccion;
    }

    public void setActividadesProduccion(ActividadesProduccion actividadesProduccion) {
        this.actividadesProduccion = actividadesProduccion;
    }

    public EstadoReferencial getEstadoReferencial() {
        return estadoReferencial;
    }

    public void setEstadoReferencial(EstadoReferencial estadoReferencial) {
        this.estadoReferencial = estadoReferencial;
    }

    public int getCantidadMaquinarias()
    {
        return this.maquinariaActividadesFormulaList.size();
    }

    public List<MaquinariaActividadesFormula> getMaquinariaActividadesFormulaList() {
        return maquinariaActividadesFormulaList;
    }

    public void setMaquinariaActividadesFormulaList(List<MaquinariaActividadesFormula> maquinariaActividadesFormulaList) {
        this.maquinariaActividadesFormulaList = maquinariaActividadesFormulaList;
    }

    public PresentacionesProducto getPresentacionesProducto() {
        return presentacionesProducto;
    }

    public void setPresentacionesProducto(PresentacionesProducto presentacionesProducto) {
        this.presentacionesProducto = presentacionesProducto;
    }

    public AreasEmpresa getAreasEmpresa() {
        return areasEmpresa;
    }

    public void setAreasEmpresa(AreasEmpresa areasEmpresa) {
        this.areasEmpresa = areasEmpresa;
    }

    public TiposProgramaProduccion getTiposProgramaProduccion() {
        return tiposProgramaProduccion;
    }

    public void setTiposProgramaProduccion(TiposProgramaProduccion tiposProgramaProduccion) {
        this.tiposProgramaProduccion = tiposProgramaProduccion;
    }

    public List<ActividadesFormulaMaestraHorasEstandarMaquinaria> getActividadesFormulaMaestraHorasEstandarMaquinariaList() {
        return actividadesFormulaMaestraHorasEstandarMaquinariaList;
    }

    public void setActividadesFormulaMaestraHorasEstandarMaquinariaList(List<ActividadesFormulaMaestraHorasEstandarMaquinaria> actividadesFormulaMaestraHorasEstandarMaquinariaList) {
        this.actividadesFormulaMaestraHorasEstandarMaquinariaList = actividadesFormulaMaestraHorasEstandarMaquinariaList;
    }
    
    public int getActividadesFormulaMaestraHorasEstandarMaquinariaListSize() {
        return (actividadesFormulaMaestraHorasEstandarMaquinariaList!=null?actividadesFormulaMaestraHorasEstandarMaquinariaList.size():0);
    }

    public ActividadFormulaMaestraBloque getActividadFormulaMaestraBloque() {
        return actividadFormulaMaestraBloque;
    }

    public void setActividadFormulaMaestraBloque(ActividadFormulaMaestraBloque actividadFormulaMaestraBloque) {
        this.actividadFormulaMaestraBloque = actividadFormulaMaestraBloque;
    }
    
    

    
}
