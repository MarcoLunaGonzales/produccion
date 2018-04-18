/*
 * ComponentesProd.java
 *
 * Created on 25 de mayo de 2008, 19:26
 */

package com.cofar.bean;

import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author Wilson Choquehuanca Gonzales
 * @company COFAR
 */
public class FormulaMaestraDetalleMP extends AbstractBean {
    
    /** Creates a new instance of ComponentesProd */
    //<editor-fold desc="variables producto" defaultstate="collapsed">
        private FormulaMaestra formulaMaestra=new FormulaMaestra();
        private Materiales materiales=new Materiales();
        private double cantidad=0;
        private UnidadesMedida unidadesMedida=new UnidadesMedida();
        private int nroPreparaciones=1;
        private Double cantidadUnitariaGramos=0d;
        private Double cantidadTotalGramos=0d;
        private Double cantidadMaximaMaterialPorFraccion=0d;
        private Double densidadMaterial=0d;
        private TiposMaterialProduccion tiposMaterialProduccion=new TiposMaterialProduccion();
        private int codFormulaMastraDetalleMpVersion=0;
        
    //</editor-fold>
    private boolean aplicaCantidadMaximaPorFraccion=false;
    
    private List<FormulaMaestraDetalleMPfracciones> formulaMaestraDetalleMPfraccionesList;
    private boolean materialExcepcionSumaTotal=false;
    private boolean swSi=false;
    private boolean swNo=false;
    private List fraccionesDetalleList = new ArrayList();
    private double cantidadRef = 0;
    private TiposMaterialReactivo tiposMaterialReactivo = new TiposMaterialReactivo();
    private List tiposMaterialReactivoList = new ArrayList();
    private TiposAnalisisMaterialReactivo tiposAnalisisMaterialReactivo = new TiposAnalisisMaterialReactivo();
    private List tiposAnalisisMaterialReactivoList = new ArrayList();
    private List tiposAnalisisMaterialReactivoList1 = new ArrayList();
    private int cambioVersion=0;
    private Materiales materialAnterior = new Materiales();
    private Double equivalenciaAGramos=0d;
    private Double equivalenciaAMiliLitros=0d;
    private int nroDecimalesAlmacen=0;
    
    public FormulaMaestra getFormulaMaestra() {
        return formulaMaestra;
    }
    
    public void setFormulaMaestra(FormulaMaestra formulaMaestra) {
        this.formulaMaestra = formulaMaestra;
    }
    
    public Materiales getMateriales() {
        return materiales;
    }
    
    public void setMateriales(Materiales materiales) {
        this.materiales = materiales;
    }

    public double getCantidad() {
        return cantidad;
    }

    public void setCantidad(double cantidad) {
        this.cantidad = cantidad;
    }

    
    public UnidadesMedida getUnidadesMedida() {
        return unidadesMedida;
    }
    
    public void setUnidadesMedida(UnidadesMedida unidadesMedida) {
        this.unidadesMedida = unidadesMedida;
    }
    
    public int getNroPreparaciones() {
        return nroPreparaciones;
    }
    
    public void setNroPreparaciones(int nroPreparaciones) {
        this.nroPreparaciones = nroPreparaciones;
    }

    public boolean isSwSi() {
        return swSi;
    }

    public void setSwSi(boolean swSi) {
        this.swSi = swSi;
    }

    public boolean isSwNo() {
        return swNo;
    }

    public void setSwNo(boolean swNo) {
        this.swNo = swNo;
    }

    /**
     * @return the fraccionesDetalleList
     */
    public List getFraccionesDetalleList() {
        return fraccionesDetalleList;
    }

    /**
     * @param fraccionesDetalleList the fraccionesDetalleList to set
     */
    public void setFraccionesDetalleList(List fraccionesDetalleList) {
        this.fraccionesDetalleList = fraccionesDetalleList;
    }

    public double getCantidadRef() {
        return cantidadRef;
    }

    public void setCantidadRef(double cantidadRef) {
        this.cantidadRef = cantidadRef;
    }

    public TiposMaterialReactivo getTiposMaterialReactivo() {
        return tiposMaterialReactivo;
    }

    public void setTiposMaterialReactivo(TiposMaterialReactivo tiposMaterialReactivo) {
        this.tiposMaterialReactivo = tiposMaterialReactivo;
    }

    public List getTiposMaterialReactivoList() {
        return tiposMaterialReactivoList;
    }

    public void setTiposMaterialReactivoList(List tiposMaterialReactivoList) {
        this.tiposMaterialReactivoList = tiposMaterialReactivoList;
    }

    public TiposAnalisisMaterialReactivo getTiposAnalisisMaterialReactivo() {
        return tiposAnalisisMaterialReactivo;
    }

    public void setTiposAnalisisMaterialReactivo(TiposAnalisisMaterialReactivo tiposAnalisisMaterialReactivo) {
        this.tiposAnalisisMaterialReactivo = tiposAnalisisMaterialReactivo;
    }

    public List getTiposAnalisisMaterialReactivoList() {
        return tiposAnalisisMaterialReactivoList;
    }

    public void setTiposAnalisisMaterialReactivoList(List tiposAnalisisMaterialReactivoList) {
        this.tiposAnalisisMaterialReactivoList = tiposAnalisisMaterialReactivoList;
    }

    public List getTiposAnalisisMaterialReactivoList1() {
        return tiposAnalisisMaterialReactivoList1;
    }

    public void setTiposAnalisisMaterialReactivoList1(List tiposAnalisisMaterialReactivoList1) {
        this.tiposAnalisisMaterialReactivoList1 = tiposAnalisisMaterialReactivoList1;
    }
    public int getCantidadDetalle(){
        return this.tiposAnalisisMaterialReactivoList1.size();
    }

    public int getCambioVersion() {
        return cambioVersion;
    }

    public void setCambioVersion(int cambioVersion) {
        this.cambioVersion = cambioVersion;
    }

    public Materiales getMaterialAnterior() {
        return materialAnterior;
    }

    public void setMaterialAnterior(Materiales materialAnterior) {
        this.materialAnterior = materialAnterior;
    }

    public Double getCantidadUnitariaGramos() {
        return cantidadUnitariaGramos;
    }

    public void setCantidadUnitariaGramos(Double cantidadUnitariaGramos) {
        this.cantidadUnitariaGramos = cantidadUnitariaGramos;
    }

    public Double getCantidadTotalGramos() {
        return cantidadTotalGramos;
    }

    public void setCantidadTotalGramos(Double cantidadTotalGramos) {
        this.cantidadTotalGramos = cantidadTotalGramos;
    }

    public Double getCantidadMaximaMaterialPorFraccion() {
        return cantidadMaximaMaterialPorFraccion;
    }

    public void setCantidadMaximaMaterialPorFraccion(Double cantidadMaximaMaterialPorFraccion) {
        this.cantidadMaximaMaterialPorFraccion = cantidadMaximaMaterialPorFraccion;
    }

    public Double getDensidadMaterial() {
        return densidadMaterial;
    }

    public void setDensidadMaterial(Double densidadMaterial) {
        this.densidadMaterial = densidadMaterial;
    }

    

    public int getNroDecimalesAlmacen() {
        return nroDecimalesAlmacen;
    }

    public void setNroDecimalesAlmacen(int nroDecimalesAlmacen) {
        this.nroDecimalesAlmacen = nroDecimalesAlmacen;
    }

    public TiposMaterialProduccion getTiposMaterialProduccion() {
        return tiposMaterialProduccion;
    }

    public void setTiposMaterialProduccion(TiposMaterialProduccion tiposMaterialProduccion) {
        this.tiposMaterialProduccion = tiposMaterialProduccion;
    }

    

    public Double getEquivalenciaAGramos() {
        return equivalenciaAGramos;
    }

    public void setEquivalenciaAGramos(Double equivalenciaAGramos) {
        this.equivalenciaAGramos = equivalenciaAGramos;
    }

    public Double getEquivalenciaAMiliLitros() {
        return equivalenciaAMiliLitros;
    }

    public void setEquivalenciaAMiliLitros(Double equivalenciaAMiliLitros) {
        this.equivalenciaAMiliLitros = equivalenciaAMiliLitros;
    }
    
    public int getFormulaMaestraDetalleMPfraccionesListSize() {
        return (this.formulaMaestraDetalleMPfraccionesList!=null?this.formulaMaestraDetalleMPfraccionesList.size():0);
    }

    public List<FormulaMaestraDetalleMPfracciones> getFormulaMaestraDetalleMPfraccionesList() {
        return formulaMaestraDetalleMPfraccionesList;
    }

    public void setFormulaMaestraDetalleMPfraccionesList(List<FormulaMaestraDetalleMPfracciones> formulaMaestraDetalleMPfraccionesList) {
        this.formulaMaestraDetalleMPfraccionesList = formulaMaestraDetalleMPfraccionesList;
    }

    public int getCodFormulaMastraDetalleMpVersion() {
        return codFormulaMastraDetalleMpVersion;
    }

    public void setCodFormulaMastraDetalleMpVersion(int codFormulaMastraDetalleMpVersion) {
        this.codFormulaMastraDetalleMpVersion = codFormulaMastraDetalleMpVersion;
    }

    public boolean isMaterialExcepcionSumaTotal() {
        return materialExcepcionSumaTotal;
    }

    public void setMaterialExcepcionSumaTotal(boolean materialExcepcionSumaTotal) {
        this.materialExcepcionSumaTotal = materialExcepcionSumaTotal;
    }

    public boolean isAplicaCantidadMaximaPorFraccion() {
        return aplicaCantidadMaximaPorFraccion;
    }

    public void setAplicaCantidadMaximaPorFraccion(boolean aplicaCantidadMaximaPorFraccion) {
        this.aplicaCantidadMaximaPorFraccion = aplicaCantidadMaximaPorFraccion;
    }

    
    
    
    

}
