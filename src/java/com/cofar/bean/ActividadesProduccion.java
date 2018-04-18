/*
 * LineaMKT.java
 *
 * Created on 21 de abril de 2008, 10:14 AM
 *
 * To change this template, choose Tools | Template Manager
 * and open the template in the editor.
 */

package com.cofar.bean;

/**
 *
 * @author rodrigo
 */
public class ActividadesProduccion extends AbstractBean{
    
    /** Creates a new instance of LineaMKT */
    
    private int codActividad=0;
    private String nombreActividad="";
    private String obsActividad="";
    private Boolean checked=new Boolean(false);    
    private EstadoReferencial estadoReferencial=new EstadoReferencial();
    private TiposActividadProduccion tiposActividadProduccion = new TiposActividadProduccion();
    private TiposActividad tipoActividad= new TiposActividad();
    private UnidadesMedida unidadesMedida=new UnidadesMedida();
    private ProcesosOrdenManufactura procesosOrdenManufactura=new ProcesosOrdenManufactura();

    public int getCodActividad() {
        return codActividad;
    }

    public void setCodActividad(int codActividad) {
        this.codActividad = codActividad;
    }

    
    

    public String getNombreActividad() {
        return nombreActividad;
    }

    public void setNombreActividad(String nombreActividad) {
        this.nombreActividad = nombreActividad;
    }

    public String getObsActividad() {
        return obsActividad;
    }

    public void setObsActividad(String obsActividad) {
        this.obsActividad = obsActividad;
    }

    public Boolean getChecked() {
        return checked;
    }

    public void setChecked(Boolean checked) {
        this.checked = checked;
    }

    public EstadoReferencial getEstadoReferencial() {
        return estadoReferencial;
    }

    public void setEstadoReferencial(EstadoReferencial estadoReferencial) {
        this.estadoReferencial = estadoReferencial;
    }

    public TiposActividadProduccion getTiposActividadProduccion() {
        return tiposActividadProduccion;
    }

    public void setTiposActividadProduccion(TiposActividadProduccion tiposActividadProduccion) {
        this.tiposActividadProduccion = tiposActividadProduccion;
    }

    public TiposActividad getTipoActividad() {
        return tipoActividad;
    }

    public void setTipoActividad(TiposActividad tipoActividad) {
        this.tipoActividad = tipoActividad;
    }

    public UnidadesMedida getUnidadesMedida() {
        return unidadesMedida;
    }

    public void setUnidadesMedida(UnidadesMedida unidadesMedida) {
        this.unidadesMedida = unidadesMedida;
    }

    public ProcesosOrdenManufactura getProcesosOrdenManufactura() {
        return procesosOrdenManufactura;
    }

    public void setProcesosOrdenManufactura(ProcesosOrdenManufactura procesosOrdenManufactura) {
        this.procesosOrdenManufactura = procesosOrdenManufactura;
    }

    
}
